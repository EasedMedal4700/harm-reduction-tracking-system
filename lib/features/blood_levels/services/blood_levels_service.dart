// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Feature service.
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/core/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/logging/logger.dart';

import '../../../core/utils/dose_string_to_mg.dart';

import '../models/blood_levels_models.dart';

/// Service for calculating drug blood levels and metabolism
class BloodLevelsService {
  BloodLevelsService({SharedPreferences? prefs}) : _prefs = prefs;

  final SharedPreferences? _prefs;

  /// Calculate remaining drug levels from usage data
  Future<Map<String, DrugLevel>> calculateLevels({
    DateTime? referenceTime,
  }) async {
    final now = referenceTime ?? DateTime.now();
    final userId = UserService.getCurrentUserId();
    try {
      logger.debug('[BloodLevelsService] Fetching drug use data and profiles');
      // Fetch drug profiles to get duration and aftereffects data
      final profilesResponse = await Supabase.instance.client
          .from('drug_profiles')
          .select(
            'slug, name, pretty_name, formatted_duration, formatted_aftereffects, categories, formatted_dose, properties',
          );
      final profilesData = profilesResponse as List<dynamic>;
      final profilesMap = <String, Map<String, dynamic>>{};
      for (final profile in profilesData) {
        final slug = profile['slug'] as String?;
        final name = (profile['name'] as String?)?.toLowerCase();
        final prettyName = (profile['pretty_name'] as String?)?.toLowerCase();
        if (slug != null) {
          profilesMap[slug.toLowerCase()] = profile;
          if (name != null) profilesMap[name] = profile;
          if (prettyName != null) profilesMap[prettyName] = profile;
        }
      }
      // Filter by authenticated user's ID
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name, dose, start_time')
          .eq('uuid_user_id', userId)
          .order('start_time', ascending: false);
      final drugUseData = response as List<dynamic>;
      final levels = <String, DrugLevel>{};
      for (final entry in drugUseData) {
        final drugName = (entry['name'] as String?)?.toLowerCase() ?? '';
        if (drugName.isEmpty) continue;
        final doseString = entry['dose']?.toString() ?? '';
        final startTime = DateTime.tryParse(
          entry['start_time']?.toString() ?? '',
        );
        if (startTime == null || startTime.isAfter(now)) continue;
        final doseMg = _parseDoseMg(doseString, substance: drugName);
        if (doseMg <= 0) continue;
        final hoursSinceDose = now.difference(startTime).inMinutes / 60.0;
        // Get profile data for this drug
        final profile = profilesMap[drugName];
        final maxDuration = _parseMaxDuration(profile?['formatted_duration']);
        final maxAftereffects = _parseMaxDuration(
          profile?['formatted_aftereffects'],
        );
        final fullActiveWindow = maxDuration + maxAftereffects;
        final halfLife = _getHalfLife(drugName, profile: profile);
        final categories =
            (profile?['categories'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final formattedDose =
            profile?['formatted_dose'] as Map<String, dynamic>?;
        logger.debug(
          '[BloodLevelsService] Entry: $drugName, dose: ${doseMg}mg, hours: ${hoursSinceDose.toStringAsFixed(2)}h, '
          'duration: ${maxDuration}h, aftereffects: ${maxAftereffects}h, window: ${fullActiveWindow}h',
        );
        // Skip if outside active window
        if (hoursSinceDose > fullActiveWindow) {
          logger.debug(
            '[BloodLevelsService] Skipping $drugName - outside active window',
          );
          continue;
        }
        // Calculate remaining using half-life decay
        final remaining = doseMg * pow(0.5, hoursSinceDose / halfLife);
        final percentRemaining = (remaining / doseMg) * 100;
        // Determine if in aftereffects phase
        final inAftereffects = hoursSinceDose > maxDuration;
        // Keep doses with >10% remaining OR still in aftereffects window
        if (percentRemaining < 10.0 && !inAftereffects) {
          logger.debug(
            '[BloodLevelsService] Skipping $drugName - ${percentRemaining.toStringAsFixed(1)}% remaining, not in aftereffects',
          );
          continue;
        }
        if (!levels.containsKey(drugName)) {
          levels[drugName] = DrugLevel(
            drugName: drugName,
            totalDose: 0,
            totalRemaining: 0,
            lastDose: doseMg,
            lastUse: startTime,
            halfLife: halfLife,
            doses: const [],
            activeWindow: fullActiveWindow,
            maxDuration: maxDuration,
            categories: categories,
            formattedDose: formattedDose,
          );
        }
        final currentLevel = levels[drugName]!;
        final isMoreRecent = startTime.isAfter(currentLevel.lastUse);
        levels[drugName] = currentLevel.copyWith(
          totalDose: currentLevel.totalDose + doseMg,
          totalRemaining: currentLevel.totalRemaining + remaining,
          doses: [
            ...currentLevel.doses,
            DoseEntry(
              dose: doseMg,
              startTime: startTime,
              remaining: remaining,
              hoursElapsed: hoursSinceDose,
              percentRemaining: percentRemaining,
            ),
          ],
          // Update last dose if this is more recent
          lastDose: isMoreRecent ? doseMg : currentLevel.lastDose,
          lastUse: isMoreRecent ? startTime : currentLevel.lastUse,
        );
      }
      logger.info(
        '[BloodLevelsService] Found ${levels.length} active substances',
      );
      return levels;
    } catch (e, stackTrace) {
      logger.error(
        '[BloodLevelsService] calculateLevels failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Parse maximum duration from formatted_duration JSON
  /// Looks for the highest max value across all routes
  double _parseMaxDuration(dynamic formattedDuration) {
    if (formattedDuration == null) return 8.0; // Default 8 hours
    try {
      final data = formattedDuration as Map<String, dynamic>?;
      if (data == null) return 8.0;
      double maxHours = 0.0;
      // Iterate through all routes (oral, insufflated, etc.)
      for (final route in data.values) {
        if (route is! Map<String, dynamic>) continue;
        // Look for _unit fields that might contain duration info
        for (final entry in route.entries) {
          if (entry.key.endsWith('_unit') &&
              entry.value is Map<String, dynamic>) {
            final unitData = entry.value as Map<String, dynamic>;
            final max = unitData['max'];
            final units = unitData['units'] as String?;
            if (max != null && units != null) {
              final hours = _convertToHours(max, units);
              if (hours > maxHours) maxHours = hours;
            }
          }
        }
      }
      return maxHours > 0 ? maxHours : 8.0;
    } catch (e) {
      logger.debug('[BloodLevelsService] Error parsing duration: $e');
      return 8.0;
    }
  }

  /// Convert duration to hours based on units
  double _convertToHours(dynamic value, String units) {
    final numValue = value is num
        ? value.toDouble()
        : double.tryParse(value.toString()) ?? 0.0;
    switch (units.toLowerCase()) {
      case 'minutes':
        return numValue / 60.0;
      case 'hours':
        return numValue;
      case 'days':
        return numValue * 24.0;
      default:
        return numValue; // Assume hours
    }
  }

  /// Parse dose from string like "10mg" or "5-10 mg"
  double _parseDoseMg(String doseString, {required String substance}) {
    final prefs = _prefs;
    if (prefs == null) {
      // Fallback to legacy behavior when prefs aren't available.
      final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(doseString);
      return match != null ? double.tryParse(match.group(1)!) ?? 0.0 : 0.0;
    }

    return DoseStringToMg.parse(
      prefs: prefs,
      substance: substance,
      dose: doseString,
    );
  }

  /// Get all doses for a drug within a time window (for timeline visualization)
  ///
  /// Unlike calculateLevels(), this does NOT filter based on:
  /// - Active window (duration + aftereffects)
  /// - Remaining percentage
  ///
  /// Instead, it includes ANY dose whose timestamp falls within the time range.
  /// This allows the timeline to show historical peaks even if the dose has
  /// fully decayed by the reference time.
  Future<List<DoseEntry>> getDosesForTimeline({
    required String drugName,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
  }) async {
    try {
      final userId = UserService.getCurrentUserId();
      final startTime = referenceTime.subtract(Duration(hours: hoursBack));
      final endTime = referenceTime.add(Duration(hours: hoursForward));
      logger.debug(
        '[BloodLevelsService] Fetching timeline doses for $drugName between $startTime and $endTime',
      );
      // Fetch all doses within the time window (case-insensitive)
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name, dose, start_time')
          .eq('uuid_user_id', userId)
          .ilike('name', drugName)
          .gte('start_time', startTime.toIso8601String())
          .lte('start_time', endTime.toIso8601String())
          .order('start_time', ascending: true);
      final drugUseData = response as List<dynamic>;
      final doses = <DoseEntry>[];
      for (final entry in drugUseData) {
        final doseString = entry['dose']?.toString() ?? '';
        final startTime = DateTime.tryParse(
          entry['start_time']?.toString() ?? '',
        );
        if (startTime == null) continue;
        final doseMg = _parseDoseMg(doseString, substance: drugName);
        if (doseMg <= 0) continue;
        final hoursSinceDose =
            referenceTime.difference(startTime).inMinutes / 60.0;
        // Get profile for this drug to determine half-life
        final profileResponse = await Supabase.instance.client
            .from('drug_profiles')
            .select(
              'properties, formatted_duration, formatted_aftereffects, categories',
            )
            .ilike('slug', drugName)
            .maybeSingle();
        final halfLife = _getHalfLife(drugName, profile: profileResponse);
        // Calculate remaining at reference time (may be 0 if fully decayed)
        final remaining = doseMg * pow(0.5, hoursSinceDose / halfLife);
        final percentRemaining = (remaining / doseMg) * 100;
        doses.add(
          DoseEntry(
            dose: doseMg,
            startTime: startTime,
            remaining: remaining,
            hoursElapsed: hoursSinceDose,
            percentRemaining: percentRemaining,
          ),
        );
      }
      logger.info(
        '[BloodLevelsService] Found ${doses.length} doses for $drugName in timeline window',
      );
      return doses;
    } catch (e, stackTrace) {
      logger.error(
        '[BloodLevelsService] getDosesForTimeline failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get all unique drug names that have doses within the timeline window
  /// This includes both past and future doses relative to the reference time
  Future<Set<String>> getDrugsInTimelineWindow({
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
  }) async {
    try {
      final userId = UserService.getCurrentUserId();
      final startTime = referenceTime.subtract(Duration(hours: hoursBack));
      final endTime = referenceTime.add(Duration(hours: hoursForward));
      logger.debug(
        '[BloodLevelsService] Fetching all drugs in timeline window: $startTime to $endTime',
      );
      // Fetch all drugs with doses in the window
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name')
          .eq('uuid_user_id', userId)
          .gte('start_time', startTime.toIso8601String())
          .lte('start_time', endTime.toIso8601String());
      final drugUseData = response as List<dynamic>;
      final drugNames = <String>{};
      for (final entry in drugUseData) {
        final name = (entry['name'] as String?)?.toLowerCase();
        if (name != null && name.isNotEmpty) {
          drugNames.add(name);
        }
      }
      logger.info(
        '[BloodLevelsService] Found ${drugNames.length} unique drugs in timeline window: ${drugNames.join(", ")}',
      );
      return drugNames;
    } catch (e, stackTrace) {
      logger.error(
        '[BloodLevelsService] getDrugsInTimelineWindow failed',
        error: e,
        stackTrace: stackTrace,
      );
      return {};
    }
  }

  /// Determine half-life for a drug using database properties or intelligent estimation
  ///
  /// Priority:
  /// 1. Read from drug_profiles.properties.half_life_hours
  /// 2. Estimate from duration, onset, after-effects, and categories
  /// 3. Apply category-specific adjustments
  /// 4. Clamp to reasonable range (0.5 - 120 hours)
  double _getHalfLife(String drugName, {Map<String, dynamic>? profile}) {
    // Step 1: Try to get half-life from properties JSON
    if (profile != null) {
      final properties = profile['properties'] as Map<String, dynamic>?;
      if (properties != null) {
        final halfLife = properties['half_life_hours'];
        if (halfLife != null && halfLife is num && halfLife > 0) {
          return halfLife.toDouble().clamp(0.5, 120.0);
        }
      }
    }
    // Step 2: Estimate from duration, onset, and after-effects
    double estimatedHalfLife = 8.0; // Default fallback
    if (profile != null) {
      // Parse duration to get effective duration in hours
      final duration = _parseMaxDuration(profile['formatted_duration']);
      final afterEffects = _parseMaxDuration(profile['formatted_aftereffects']);
      final categories =
          (profile['categories'] as List<dynamic>?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
          [];
      // Base estimation: half-life = (duration / 4) + (after_effects / 8)
      if (duration > 0) {
        estimatedHalfLife = (duration / 4) + (afterEffects / 8);
      }
      // Step 3: Apply category-specific adjustments
      final categoryLower = categories.join(' ').toLowerCase();
      if (categoryLower.contains('benzo')) {
        // Benzodiazepines: classify by duration
        if (duration < 4) {
          estimatedHalfLife = 9.0; // Short-acting: 6-12h
        } else if (duration < 8) {
          estimatedHalfLife = 18.0; // Medium: 12-24h
        } else if (duration < 16) {
          estimatedHalfLife = 37.0; // Long: 24-50h
        } else {
          estimatedHalfLife = 85.0; // Ultra-long: 50-120h
        }
      } else if (categoryLower.contains('opioid')) {
        // Opioids: classify by duration
        if (duration < 5) {
          estimatedHalfLife = 3.5; // Short-acting: 2-5h
        } else if (duration < 12) {
          estimatedHalfLife = 9.0; // Medium: 6-12h
        } else {
          estimatedHalfLife = 24.0; // Long: 12-36h
        }
      } else if (categoryLower.contains('stimulant')) {
        // Stimulants: 20-30% of duration
        estimatedHalfLife = duration * 0.25;
      } else if (categoryLower.contains('psychedelic')) {
        // Psychedelics: 25-40% of duration
        estimatedHalfLife = duration * 0.33;
      } else if (categoryLower.contains('dissociative')) {
        // Dissociatives: 30-60% of duration
        estimatedHalfLife = duration * 0.45;
      } else if (categoryLower.contains('alcohol') ||
          categoryLower.contains('depressant') &&
              categoryLower.contains('gaba')) {
        // Alcohol/GABAergic depressants: short relative to effects
        estimatedHalfLife = duration * 0.15;
      } else if (duration > 0) {
        // Default category: 30% of duration
        estimatedHalfLife = duration * 0.3;
      }
      // Step 4: Adjust for extremely long after-effects (24h+)
      if (afterEffects >= 24) {
        estimatedHalfLife *= 1.15; // Add 15% for long after-effects
      }
    }
    // Step 5: Clamp to reasonable range
    return estimatedHalfLife.clamp(0.5, 120.0);
  }
}

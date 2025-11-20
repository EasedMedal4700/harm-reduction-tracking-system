import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

/// Service for calculating drug blood levels and metabolism
class BloodLevelsService {
  /// Calculate remaining drug levels from usage data
  Future<Map<String, DrugLevel>> calculateLevels({
    DateTime? referenceTime,
  }) async {
    final now = referenceTime ?? DateTime.now();
    
    try {
      ErrorHandler.logDebug('BloodLevelsService', 'Fetching drug use data and profiles');
      
      // Fetch drug profiles to get duration and aftereffects data
      final profilesResponse = await Supabase.instance.client
          .from('drug_profiles')
          .select('slug, name, pretty_name, formatted_duration, formatted_aftereffects');
      
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
      
      // RLS handles user filtering
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('name, dose, start_time')
          .order('start_time', ascending: false);
      
      final drugUseData = response as List<dynamic>;
      final levels = <String, DrugLevel>{};
      
      for (final entry in drugUseData) {
        final drugName = (entry['name'] as String?)?.toLowerCase() ?? '';
        if (drugName.isEmpty) continue;
        
        final doseString = entry['dose']?.toString() ?? '';
        final startTime = DateTime.tryParse(entry['start_time']?.toString() ?? '');
        if (startTime == null || startTime.isAfter(now)) continue;
        
        final doseMg = _parseDose(doseString);
        if (doseMg <= 0) continue;
        
        final hoursSinceDose = now.difference(startTime).inMinutes / 60.0;
        
        // Get profile data for this drug
        final profile = profilesMap[drugName];
        final maxDuration = _parseMaxDuration(profile?['formatted_duration']);
        final maxAftereffects = _parseMaxDuration(profile?['formatted_aftereffects']);
        final fullActiveWindow = maxDuration + maxAftereffects;
        final halfLife = _getHalfLife(drugName);
        
        ErrorHandler.logDebug('BloodLevelsService', 
          'Entry: $drugName, dose: ${doseMg}mg, hours: ${hoursSinceDose.toStringAsFixed(2)}h, '
          'duration: ${maxDuration}h, aftereffects: ${maxAftereffects}h, window: ${fullActiveWindow}h');
        
        // Skip if outside active window
        if (hoursSinceDose > fullActiveWindow) {
          ErrorHandler.logDebug('BloodLevelsService', 'Skipping $drugName - outside active window');
          continue;
        }
        
        // Calculate remaining using half-life decay
        final remaining = doseMg * pow(0.5, hoursSinceDose / halfLife);
        final percentRemaining = (remaining / doseMg) * 100;
        
        // Determine if in aftereffects phase
        final inAftereffects = hoursSinceDose > maxDuration;
        
        // Keep doses with >10% remaining OR still in aftereffects window
        if (percentRemaining < 10.0 && !inAftereffects) {
          ErrorHandler.logDebug('BloodLevelsService', 
            'Skipping $drugName - ${percentRemaining.toStringAsFixed(1)}% remaining, not in aftereffects');
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
            doses: [],
            activeWindow: fullActiveWindow,
            maxDuration: maxDuration,
          );
        }
        
        final currentLevel = levels[drugName]!;
        levels[drugName] = currentLevel.copyWith(
          totalDose: currentLevel.totalDose + doseMg,
          totalRemaining: currentLevel.totalRemaining + remaining,
          doses: [...currentLevel.doses, DoseEntry(
            dose: doseMg,
            startTime: startTime,
            remaining: remaining,
            hoursElapsed: hoursSinceDose,
            percentRemaining: percentRemaining,
          )],
          // Update last dose if this is more recent
          lastDose: startTime.isAfter(currentLevel.lastUse) ? doseMg : null,
          lastUse: startTime.isAfter(currentLevel.lastUse) ? startTime : null,
        );
      }
      
      ErrorHandler.logInfo('BloodLevelsService', 'Found ${levels.length} active substances');
      return levels;
    } catch (e, stackTrace) {
      ErrorHandler.logError('BloodLevelsService.calculateLevels', e, stackTrace);
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
          if (entry.key.endsWith('_unit') && entry.value is Map<String, dynamic>) {
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
      ErrorHandler.logDebug('BloodLevelsService', 'Error parsing duration: $e');
      return 8.0;
    }
  }
  
  /// Convert duration to hours based on units
  double _convertToHours(dynamic value, String units) {
    final numValue = value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0.0;
    
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
  double _parseDose(String doseString) {
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(doseString);
    return match != null ? double.tryParse(match.group(1)!) ?? 0.0 : 0.0;
  }
  
  /// Get estimated half-life for a drug (simplified version)
  double _getHalfLife(String drugName) {
    const halfLives = <String, double>{
      'methylphenidate': 3.5,
      'amphetamine': 10.0,
      'cocaine': 1.0,
      'mdma': 8.0,
      'lsd': 3.0,
      'psilocybin': 2.5,
      'cannabis': 24.0,
      'thc': 24.0,
      'caffeine': 5.0,
      'nicotine': 2.0,
      'alcohol': 5.0,
      'ketamine': 2.5,
      'dxm': 3.0,
      'bromazolam': 14.0,  // Benzodiazepine with ~14h half-life
      '2-fdck': 3.0,  // Similar to ketamine
    };
    
    return halfLives[drugName.toLowerCase()] ?? 8.0; // Default 8h
  }
}

/// Data class for drug level information
class DrugLevel {
  final String drugName;
  final double totalDose;
  final double totalRemaining;
  final double lastDose;
  final DateTime lastUse;
  final double halfLife;
  final List<DoseEntry> doses;
  final double activeWindow; // Full active window (duration + aftereffects)
  final double maxDuration; // Maximum duration before aftereffects
  
  const DrugLevel({
    required this.drugName,
    required this.totalDose,
    required this.totalRemaining,
    required this.lastDose,
    required this.lastUse,
    required this.halfLife,
    required this.doses,
    this.activeWindow = 8.0,
    this.maxDuration = 6.0,
  });
  
  /// Calculate overall percentage remaining (for all doses combined)
  double get percentage => totalDose > 0 ? (totalRemaining / totalDose) * 100 : 0.0;
  
  /// Get status based on remaining percentage
  String get status {
    final hoursSinceLastUse = DateTime.now().difference(lastUse).inMinutes / 60.0;
    final inAftereffects = hoursSinceLastUse > maxDuration;
    
    if (percentage > 40) return 'HIGH';
    if (percentage >= 10) return 'ACTIVE';
    if (inAftereffects && hoursSinceLastUse <= activeWindow) return 'TRACE';
    return 'LOW';
  }
  
  DrugLevel copyWith({
    double? totalDose,
    double? totalRemaining,
    double? lastDose,
    DateTime? lastUse,
    List<DoseEntry>? doses,
    double? activeWindow,
    double? maxDuration,
  }) {
    return DrugLevel(
      drugName: drugName,
      totalDose: totalDose ?? this.totalDose,
      totalRemaining: totalRemaining ?? this.totalRemaining,
      lastDose: lastDose ?? this.lastDose,
      lastUse: lastUse ?? this.lastUse,
      halfLife: halfLife,
      doses: doses ?? this.doses,
      activeWindow: activeWindow ?? this.activeWindow,
      maxDuration: maxDuration ?? this.maxDuration,
    );
  }
}

/// Individual dose entry
class DoseEntry {
  final double dose;
  final DateTime startTime;
  final double remaining;
  final double hoursElapsed;
  final double percentRemaining;
  
  const DoseEntry({
    required this.dose,
    required this.startTime,
    required this.remaining,
    required this.hoursElapsed,
    this.percentRemaining = 0.0,
  });
}

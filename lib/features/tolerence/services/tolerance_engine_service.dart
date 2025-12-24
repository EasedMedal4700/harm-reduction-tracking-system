import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/tolerance_model.dart';
import '../../../utils/tolerance_calculator.dart';
import 'dart:math' as math;
import '../../../utils/error_handler.dart';

/// Service for tolerance calculation engine
/// Handles fetching tolerance models and computing bucket tolerances
class ToleranceEngineService {
  static final _supabase = Supabase.instance.client;

  /// High-level API: compute full system tolerance for a user using the
  /// unified tolerance engine. This is the preferred entry point for all
  /// UI screens.
  static Future<ToleranceResult> computeSystemTolerance({
    required String userId,
    int daysBack = 30,
    bool debug = false,
  }) async {
    final results = await Future.wait([
      fetchAllToleranceModels(),
      fetchUseLogs(userId: userId, daysBack: daysBack),
    ]);
    final toleranceModels = results[0] as Map<String, ToleranceModel>;
    final useLogs = results[1] as List<UseLogEntry>;
    if (toleranceModels.isEmpty || useLogs.isEmpty) {
      // Return an empty result with all buckets at 0.
      final emptyPercents = <String, double>{
        for (final b in kToleranceBuckets) b: 0.0,
      };
      return ToleranceResult(
        bucketPercents: emptyPercents,
        bucketRawLoads: {for (final b in kToleranceBuckets) b: 0.0},
        toleranceScore: 0.0,
        daysUntilBaseline: {for (final b in kToleranceBuckets) b: 0.0},
        overallDaysUntilBaseline: 0.0,
      );
    }
    return ToleranceCalculatorFull.computeToleranceFull(
      useLogs: useLogs,
      toleranceModels: toleranceModels,
      debug: debug,
    );
  }

  /// Fetch all tolerance models from drug_profiles
  /// Returns Map<substanceSlug, ToleranceModel>
  static Future<Map<String, ToleranceModel>> fetchAllToleranceModels() async {
    try {
      final response = await _supabase
          .from('drug_profiles')
          .select('slug, tolerance_model')
          .not('tolerance_model', 'is', null);
      final models = <String, ToleranceModel>{};
      for (final row in response as List) {
        final slug = row['slug'] as String?;
        final toleranceJson = row['tolerance_model'] as Map<String, dynamic>?;
        if (slug != null && toleranceJson != null) {
          try {
            models[slug] = ToleranceModel.fromJson(toleranceJson);
          } catch (e) {
            ErrorHandler.logError(
              'ToleranceEngineService.fetchAllToleranceModels',
              'Failed to parse tolerance model for $slug: $e',
              StackTrace.current,
            );
          }
        }
      }
      ErrorHandler.logInfo(
        'ToleranceEngineService',
        'Loaded ${models.length} tolerance models',
      );
      return models;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceEngineService.fetchAllToleranceModels',
        e,
        stackTrace,
      );
      return {};
    }
  }

  /// Fetch use logs for a specific user
  /// Returns list of UseLogEntry objects
  static Future<List<UseLogEntry>> fetchUseLogs({
    required String userId,
    int daysBack = 30,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      final response = await _supabase
          .from('drug_use')
          .select('name, start_time, dose')
          .eq('uuid_user_id', userId)
          .gte('start_time', cutoffDate.toIso8601String())
          .order('start_time', ascending: false);
      final logs = <UseLogEntry>[];
      // Build mapping from profile name/pretty_name to slug once
      final profilesResp = await _supabase
          .from('drug_profiles')
          .select('slug, name, pretty_name');
      final nameToSlug = <String, String>{};
      for (final r in profilesResp as List) {
        final slugVal = (r['slug'] as String?)?.trim();
        final rawName = (r['name'] as String?)?.trim();
        final pretty = (r['pretty_name'] as String?)?.trim();
        if (slugVal == null) continue;
        if (rawName != null) nameToSlug[rawName.toLowerCase()] = slugVal;
        if (pretty != null) nameToSlug[pretty.toLowerCase()] = slugVal;
      }
      for (final row in response as List) {
        final name = (row['name'] as String?)?.trim();
        final timestampString = row['start_time'] as String?;
        final rawDose = row['dose'];
        if (name == null || timestampString == null) continue;
        final timestamp = DateTime.tryParse(timestampString);
        if (timestamp == null) continue;
        final doseUnits = _parseDose(rawDose);
        // Attempt to map the recorded name to a slug if we have a mapping.
        final mappedSlug = nameToSlug[name.toLowerCase()] ?? name;
        logs.add(
          UseLogEntry(
            substanceSlug: mappedSlug,
            timestamp: timestamp,
            doseUnits: doseUnits,
          ),
        );
      }
      ErrorHandler.logInfo(
        'ToleranceEngineService',
        'Loaded ${logs.length} use logs for user $userId',
      );
      return logs;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceEngineService.fetchUseLogs',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Compute all bucket tolerances for a user
  /// Returns Map<String, double> with tolerance percentages
  static Future<Map<String, double>> computeUserTolerances({
    required String userId,
    int daysBack = 30,
  }) async {
    try {
      // Fetch tolerance models and use logs in parallel
      final results = await Future.wait([
        fetchAllToleranceModels(),
        fetchUseLogs(userId: userId, daysBack: daysBack),
      ]);
      final toleranceModels = results[0] as Map<String, ToleranceModel>;
      final useLogs = results[1] as List<UseLogEntry>;
      if (toleranceModels.isEmpty) {
        ErrorHandler.logInfo(
          'ToleranceEngineService',
          'No tolerance models found',
        );
        return _emptyBuckets();
      }
      if (useLogs.isEmpty) {
        ErrorHandler.logInfo(
          'ToleranceEngineService',
          'No use logs found for user $userId',
        );
        return _emptyBuckets();
      }
      // Compute full tolerance and extract bucket percents. This ensures
      // all call sites stay consistent with the unified engine.
      final full = ToleranceCalculatorFull.computeToleranceFull(
        useLogs: useLogs,
        toleranceModels: toleranceModels,
      );
      final tolerances = full.bucketPercents;
      ErrorHandler.logInfo(
        'ToleranceEngineService',
        'Computed tolerances: $tolerances',
      );
      return tolerances;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceEngineService.computeUserTolerances',
        e,
        stackTrace,
      );
      return _emptyBuckets();
    }
  }

  /// Compute system states for all buckets
  static Future<Map<String, ToleranceSystemState>> computeUserSystemStates({
    required String userId,
    int daysBack = 30,
  }) async {
    final tolerances = await computeUserTolerances(
      userId: userId,
      daysBack: daysBack,
    );
    return ToleranceCalculator.computeAllBucketStates(tolerances: tolerances);
  }

  /// Compute a simple tolerance percentage per substance for debug.
  ///
  /// Now uses the same core parameters as the main tolerance model:
  ///   - standard_unit_mg
  ///   - potency_multiplier
  ///   - tolerance_gain_rate
  ///   - duration_multiplier
  ///   - half_life_hours / tolerance_decay_days
  static Future<Map<String, double>> computePerSubstanceTolerances({
    required String userId,
    int daysBack = 30,
  }) async {
    try {
      final results = await Future.wait([
        fetchAllToleranceModels(),
        fetchUseLogs(userId: userId, daysBack: daysBack),
      ]);
      final toleranceModels = results[0] as Map<String, ToleranceModel>;
      final useLogs = results[1] as List<UseLogEntry>;
      if (useLogs.isEmpty) return {};
      final now = DateTime.now();
      final map = <String, double>{};
      // Group logs by slug
      final grouped = <String, List<UseLogEntry>>{};
      for (final log in useLogs) {
        grouped.putIfAbsent(log.substanceSlug, () => []).add(log);
      }
      for (final entry in grouped.entries) {
        final slug = entry.key;
        final logs = entry.value;
        final model = toleranceModels[slug];
        if (model == null) {
          map[slug] = 0.0;
          continue;
        }
        // Sum of weights across neuro buckets
        final weightSum = model.neuroBuckets.values.fold<double>(
          0.0,
          (s, b) => s + b.weight,
        );
        if (weightSum <= 0 || model.standardUnitMg <= 0) {
          map[slug] = 0.0;
          continue;
        }
        final halfLife = model.halfLifeHours;
        final decayDays = model.toleranceDecayDays;
        final activeThreshold = model.activeThreshold;
        double rawLoad = 0.0;
        for (final logEntry in logs) {
          final hoursSince =
              now.difference(logEntry.timestamp).inMinutes / 60.0;
          if (hoursSince < 0) continue;
          // Active level (PK decay)
          final activeLevel = halfLife > 0
              ? math.exp(-hoursSince / halfLife)
              : 0.0;
          // Dose normalized to standard unit
          final doseNorm = logEntry.doseUnits / model.standardUnitMg;
          // Base contribution similar to main engine:
          // base = doseNorm * weightSum * potency * gainRate * 0.08 * durationMultiplier
          final baseContribution =
              doseNorm *
              weightSum *
              model.potencyMultiplier *
              model.toleranceGainRate *
              0.08 *
              model.durationMultiplier;
          double decayFactor;
          if (halfLife <= 0 || decayDays <= 0) {
            decayFactor = 0.0;
          } else {
            // If still in "active window" (above threshold), no long-term decay yet
            final activeWindowHours = -halfLife * math.log(activeThreshold);
            if (activeLevel >= activeThreshold) {
              decayFactor = 1.0;
            } else {
              final hoursPastActive = math.max(
                0.0,
                hoursSince - activeWindowHours,
              );
              final daysPastActive = hoursPastActive / 24.0;
              decayFactor = math.exp(-daysPastActive / decayDays);
            }
          }
          final eventLoad = baseContribution * decayFactor;
          rawLoad += eventLoad;
        }
        final percent = ToleranceCalculator.loadToPercent(rawLoad);
        map[slug] = percent;
      }
      // Sort map by percent desc
      final sorted = Map.fromEntries(
        map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
      );
      return sorted;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceEngineService.computePerSubstanceTolerances',
        e,
        stackTrace,
      );
      return {};
    }
  }

  /// Get detailed tolerance report
  static Future<ToleranceReport> getToleranceReport({
    required String userId,
    int daysBack = 30,
  }) async {
    final tolerances = await computeUserTolerances(
      userId: userId,
      daysBack: daysBack,
    );
    final states = ToleranceCalculator.computeAllBucketStates(
      tolerances: tolerances,
    );
    return ToleranceReport(
      tolerances: tolerances,
      states: states,
      timestamp: DateTime.now(),
    );
  }

  /// Parse dose from various formats
  static double _parseDose(dynamic rawDose) {
    if (rawDose == null) return 0.0;
    if (rawDose is num) return rawDose.toDouble();
    if (rawDose is String) {
      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(rawDose);
      if (match != null) {
        return double.tryParse(match.group(1)!) ?? 0.0;
      }
    }
    return 0.0;
  }

  /// Get breakdown of which substances are contributing to a specific bucket's load.
  ///
  /// Now uses the same core parameters as the main tolerance engine, so
  /// contribution percentages line up with the bucket totals.
  static Future<List<ToleranceContribution>> getBucketBreakdown({
    required String userId,
    required String bucketName,
    int daysBack = 30,
  }) async {
    try {
      final results = await Future.wait([
        fetchAllToleranceModels(),
        fetchUseLogs(userId: userId, daysBack: daysBack),
        _supabase.from('drug_profiles').select('slug, pretty_name, name'),
      ]);
      final toleranceModels = results[0] as Map<String, ToleranceModel>;
      final useLogs = results[1] as List<UseLogEntry>;
      final profilesData = results[2] as List<dynamic>;
      // Build slug -> pretty name map
      final slugToName = <String, String>{};
      for (final row in profilesData) {
        final slug = row['slug'] as String?;
        final pretty = row['pretty_name'] as String?;
        final name = row['name'] as String?;
        if (slug != null) {
          slugToName[slug] = pretty ?? name ?? slug;
        }
      }
      if (useLogs.isEmpty) return [];
      final now = DateTime.now();
      final contributions = <String, double>{};
      double totalRawLoad = 0.0;
      // Calculate raw load per substance for this bucket
      for (final log in useLogs) {
        final model = toleranceModels[log.substanceSlug];
        if (model == null) continue;
        final neuroBucket = model.neuroBuckets[bucketName];
        if (neuroBucket == null) continue;
        final halfLife = model.halfLifeHours;
        final decayDays = model.toleranceDecayDays;
        final activeThreshold = model.activeThreshold;
        if (halfLife <= 0 || model.standardUnitMg <= 0) continue;
        final hoursSince = now.difference(log.timestamp).inMinutes / 60.0;
        if (hoursSince < 0) continue;
        final activeLevel = math.exp(-hoursSince / halfLife); // PK active level
        // Normalize dose
        final doseNorm = log.doseUnits / model.standardUnitMg;
        // Base contribution as in main model
        final baseContribution =
            doseNorm *
            neuroBucket.weight *
            model.potencyMultiplier *
            model.toleranceGainRate *
            0.08 *
            model.durationMultiplier;
        double decayFactor;
        if (decayDays <= 0) {
          decayFactor = 0.0;
        } else {
          final activeWindowHours = -halfLife * math.log(activeThreshold);
          if (activeLevel >= activeThreshold) {
            decayFactor = 1.0;
          } else {
            final hoursPastActive = math.max(
              0.0,
              hoursSince - activeWindowHours,
            );
            final daysPastActive = hoursPastActive / 24.0;
            decayFactor = math.exp(-daysPastActive / decayDays);
          }
        }
        final load = baseContribution * decayFactor;
        contributions[log.substanceSlug] =
            (contributions[log.substanceSlug] ?? 0.0) + load;
        totalRawLoad += load;
      }
      if (totalRawLoad <= 0) return [];
      // Convert to list of contribution objects
      final result = <ToleranceContribution>[];
      for (final entry in contributions.entries) {
        final slug = entry.key;
        final rawLoad = entry.value;
        final percentContribution = (rawLoad / totalRawLoad) * 100;
        result.add(
          ToleranceContribution(
            substanceName: slugToName[slug] ?? slug,
            percentContribution: percentContribution,
            rawLoad: rawLoad,
          ),
        );
      }
      // Sort by contribution descending
      result.sort((a, b) => b.rawLoad.compareTo(a.rawLoad));
      return result;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceEngineService.getBucketBreakdown',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Return empty buckets map with all canonical buckets
  static Map<String, double> _emptyBuckets() {
    return {
      'gaba': 0.0,
      'stimulant': 0.0,
      'serotonin_release': 0.0,
      'serotonin_psychedelic': 0.0,
      'opioid': 0.0,
      'nmda': 0.0,
      'cannabinoid': 0.0,
    };
  }
}

/// Data class for tolerance breakdown
class ToleranceContribution {
  final String substanceName;
  final double percentContribution; // 0-100% of the total load
  final double rawLoad; // The actual load value
  const ToleranceContribution({
    required this.substanceName,
    required this.percentContribution,
    required this.rawLoad,
  });
}

/// Tolerance report containing percentages and states
class ToleranceReport {
  final Map<String, double> tolerances;
  final Map<String, ToleranceSystemState> states;
  final DateTime timestamp;
  const ToleranceReport({
    required this.tolerances,
    required this.states,
    required this.timestamp,
  });

  /// Get overall average tolerance
  double get averageTolerance {
    if (tolerances.isEmpty) return 0.0;
    final sum = tolerances.values.reduce((a, b) => a + b);
    return sum / tolerances.length;
  }

  /// Get highest tolerance bucket
  MapEntry<String, double>? get highestTolerance {
    if (tolerances.isEmpty) return null;
    return tolerances.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  /// Get count of buckets in each state
  Map<ToleranceSystemState, int> get stateCounts {
    final counts = <ToleranceSystemState, int>{
      ToleranceSystemState.recovered: 0,
      ToleranceSystemState.lightStress: 0,
      ToleranceSystemState.moderateStrain: 0,
      ToleranceSystemState.highStrain: 0,
      ToleranceSystemState.depleted: 0,
    };
    for (final state in states.values) {
      counts[state] = (counts[state] ?? 0) + 1;
    }
    return counts;
  }

  /// Check if any system is depleted
  bool get hasDepletedSystems {
    return states.values.contains(ToleranceSystemState.depleted);
  }

  /// Check if any system is high strain or worse
  bool get hasHighStrain {
    return states.values.any(
      (state) =>
          state == ToleranceSystemState.highStrain ||
          state == ToleranceSystemState.depleted,
    );
  }
}

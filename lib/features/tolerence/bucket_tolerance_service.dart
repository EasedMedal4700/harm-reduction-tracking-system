import '../../models/tolerance_bucket.dart';
import '../../utils/bucket_tolerance_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/logging/app_log.dart';

/// Service for fetching and managing bucket-based tolerance data.
class BucketToleranceService {
  static final _supabase = Supabase.instance.client;

  /// Fetches tolerance model with bucket data from drug_profiles.tolerance_model JSONB.
  static Future<BucketToleranceModel?> fetchToleranceModel(
    String substance,
  ) async {
    try {
      final response = await _supabase
          .from('drug_profiles')
          .select('tolerance_model')
          .eq('slug', substance.toLowerCase())
          .maybeSingle();
      if (response == null || response['tolerance_model'] == null) {
        AppLog.w('No tolerance model found for $substance in drug_profiles');
        return null;
      }
      // Extract tolerance_model JSONB and parse it
      final toleranceModelJson =
          response['tolerance_model'] as Map<String, dynamic>;
      return BucketToleranceModel.fromJson(substance, toleranceModelJson);
    } catch (e) {
      AppLog.e('Error fetching tolerance model for $substance: $e');
      return null;
    }
  }

  /// Fetches dose normalization - uses reasonable defaults per substance.
  /// TODO: Add standard_unit_mg field to drug_profiles.tolerance_model
  static Future<double> fetchStandardUnitMg(String substance) async {
    // Default standard doses for common substances (in mg)
    final defaults = {
      'alcohol': 10.0, // 10g = 1 standard drink
      'mdma': 100.0, // 100mg standard dose
      'lsd': 0.1, // 100μg = 0.1mg
      'amphetamine': 20.0, // 20mg therapeutic
      'dexedrine': 10.0, // 10mg standard
      'methylphenidate': 20.0, // 20mg standard
      'cannabis': 10.0, // 10mg THC
      'alprazolam': 1.0, // 1mg standard
      'bromazolam': 1.0, // 1mg standard
      'mdpv': 5.0, // 5mg common dose
    };
    return defaults[substance.toLowerCase()] ?? 10.0; // Default 10mg if unknown
  }

  /// Fetches use events for tolerance calculation.
  static Future<List<UseEvent>> fetchUseEvents({
    required int userId,
    required String substance,
    int daysBack = 90,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      final response = await _supabase
          .from('log_entries')
          .select('timestamp, dose_mg, substance')
          .eq('user_id', userId)
          .eq('substance', substance)
          .gte('timestamp', cutoffDate.toIso8601String())
          .order('timestamp', ascending: true);
      final events = <UseEvent>[];
      for (final row in response as List) {
        final timestamp = DateTime.parse(row['timestamp'] as String);
        final doseMg = (row['dose_mg'] as num?)?.toDouble() ?? 0.0;
        final substanceName = row['substance'] as String;
        events.add(
          UseEvent(
            timestamp: timestamp,
            doseMg: doseMg,
            substance: substanceName,
          ),
        );
      }
      return events;
    } catch (e) {
      AppLog.e('Error fetching use events: $e');
      return [];
    }
  }

  /// Calculates current tolerance for a substance using bucket model.
  static Future<Map<String, dynamic>> calculateSubstanceTolerance({
    required int userId,
    required String substance,
  }) async {
    try {
      // Fetch tolerance model
      final model = await fetchToleranceModel(substance);
      if (model == null) {
        return {
          'error': 'No tolerance model found for $substance',
          'tolerance': 0.0,
          'buckets': <String, BucketToleranceResult>{},
        };
      }
      // Fetch standard unit for dose normalization
      final standardUnitMg = await fetchStandardUnitMg(substance);
      // Fetch use events
      final useEvents = await fetchUseEvents(
        userId: userId,
        substance: substance,
        daysBack: 90,
      );
      if (useEvents.isEmpty) {
        return {
          'tolerance': 0.0,
          'buckets': <String, BucketToleranceResult>{},
          'model': model,
        };
      }
      // Calculate bucket tolerances
      final bucketResults =
          BucketToleranceCalculator.calculateSubstanceTolerance(
            model: model,
            useEvents: useEvents,
            standardUnitMg: standardUnitMg,
            currentTime: DateTime.now(),
          );
      // Calculate overall tolerance
      final overallTolerance =
          BucketToleranceCalculator.calculateOverallSubstanceTolerance(
            bucketResults: bucketResults,
          );
      return {
        'tolerance': overallTolerance,
        'buckets': bucketResults,
        'model': model,
        'standardUnitMg': standardUnitMg,
      };
    } catch (e) {
      AppLog.e('Error calculating substance tolerance: $e');
      return {
        'error': e.toString(),
        'tolerance': 0.0,
        'buckets': <String, BucketToleranceResult>{},
      };
    }
  }

  /// Calculates system-wide tolerance across all user substances.
  static Future<Map<String, dynamic>> calculateSystemTolerance({
    required int userId,
  }) async {
    try {
      // Fetch all substances user has logged
      final substancesResponse = await _supabase
          .from('log_entries')
          .select('substance')
          .eq('user_id', userId)
          .gte(
            'timestamp',
            DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
          );
      final uniqueSubstances = (substancesResponse as List)
          .map((row) => row['substance'] as String)
          .toSet()
          .toList();
      // Calculate tolerance for each substance
      final allSubstanceResults =
          <String, Map<String, BucketToleranceResult>>{};
      for (final substance in uniqueSubstances) {
        final result = await calculateSubstanceTolerance(
          userId: userId,
          substance: substance,
        );
        if (result['buckets'] != null) {
          allSubstanceResults[substance] =
              result['buckets'] as Map<String, BucketToleranceResult>;
        }
      }
      // Calculate system tolerance (cross-tolerance)
      final systemBucketTolerances =
          BucketToleranceCalculator.calculateSystemTolerance(
            allSubstanceResults: allSubstanceResults,
          );
      final overallSystemTolerance =
          BucketToleranceCalculator.calculateOverallSystemTolerance(
            systemBucketTolerances: systemBucketTolerances,
          );
      return {
        'overallTolerance': overallSystemTolerance,
        'bucketTolerances': systemBucketTolerances,
        'substanceCount': uniqueSubstances.length,
        'substances': uniqueSubstances,
      };
    } catch (e) {
      AppLog.e('Error calculating system tolerance: $e');
      return {
        'error': e.toString(),
        'overallTolerance': 0.0,
        'bucketTolerances': <String, double>{},
      };
    }
  }
}

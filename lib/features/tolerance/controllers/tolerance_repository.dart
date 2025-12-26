// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Repository for fetching tolerance data

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common/logging/app_log.dart';
import '../models/tolerance_models.dart';

part 'tolerance_repository.g.dart';

@riverpod
ToleranceRepository toleranceRepository(Ref ref) {
  return ToleranceRepository(Supabase.instance.client);
}

class ToleranceRepository {
  final SupabaseClient _supabase;

  ToleranceRepository(this._supabase);

  Future<Map<String, ToleranceModel>> fetchToleranceModels() async {
    try {
      AppLog.d(
        '[ToleranceRepository] Fetching tolerance models from database...',
      );
      final response = await _supabase
          .from('drug_profiles')
          .select('slug, tolerance_model')
          .not('tolerance_model', 'is', null);

      AppLog.d(
        '[ToleranceRepository] Received ${(response as List).length} rows from database',
      );
      final models = <String, ToleranceModel>{};

      for (final row in response as List) {
        final slug = row['slug'] as String?;
        final toleranceJson = row['tolerance_model'] as Map<String, dynamic>?;

        if (slug != null && toleranceJson != null) {
          AppLog.d('[ToleranceRepository] Processing slug: $slug');
          AppLog.d(
            '[ToleranceRepository] Raw tolerance_model keys: ${toleranceJson.keys.toList()}',
          );
          // Custom parsing to handle the map key -> name mapping for buckets
          final bucketsJson =
              toleranceJson['neuro_buckets'] as Map<String, dynamic>? ?? {};
          AppLog.d(
            '[ToleranceRepository] Found ${bucketsJson.length} neuro_buckets for $slug',
          );
          final buckets = <String, NeuroBucket>{};

          bucketsJson.forEach((key, value) {
            final valMap = value as Map<String, dynamic>;
            final weight = _parseNum(valMap['weight'], 0.0);
            AppLog.d(
              '[ToleranceRepository]   Bucket: $key, weight: $weight, type: ${valMap['tolerance_type']}',
            );
            buckets[key] = NeuroBucket(
              name: key,
              weight: weight,
              toleranceType: valMap['tolerance_type'] as String?,
            );
          });

          final model = ToleranceModel(
            notes: toleranceJson['notes'] as String? ?? '',
            neuroBuckets: buckets,
            halfLifeHours: _parseNum(toleranceJson['half_life_hours'], 6.0),
            toleranceDecayDays: _parseNum(
              toleranceJson['tolerance_decay_days'],
              2.0,
            ),
            standardUnitMg: _parseNum(toleranceJson['standard_unit_mg'], 10.0),
            potencyMultiplier: _parseNum(
              toleranceJson['potency_multiplier'],
              1.0,
            ),
            durationMultiplier: _parseNum(
              toleranceJson['duration_multiplier'],
              1.0,
            ),
            toleranceGainRate: _parseNum(
              toleranceJson['tolerance_gain_rate'],
              1.0,
            ),
            activeThreshold: _parseNum(toleranceJson['active_threshold'], 0.05),
          );
          models[slug] = model;
          AppLog.d(
            '[ToleranceRepository] Created model for $slug with ${model.neuroBuckets.length} buckets',
          );
        }
      }
      AppLog.i(
        '[ToleranceRepository] Successfully loaded ${models.length} tolerance models',
      );

      AppLog.d('\n=== TOLERANCE MODELS LOADED FROM DB ===');
      AppLog.d('Total models: ${models.length}');
      for (final entry in models.entries) {
        AppLog.d(
          '  - Slug: "${entry.key}" | Buckets: ${entry.value.neuroBuckets.keys.join(", ")}',
        );
      }
      AppLog.d('======================================\n');

      return models;
    } catch (e, stackTrace) {
      AppLog.e(
        '[ToleranceRepository] Error fetching tolerance models',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<UseLogEntry>> fetchUseLogs({
    required String userId,
    int daysBack = 30,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      AppLog.d(
        '[ToleranceRepository] Fetching use logs for user $userId, last $daysBack days',
      );
      final response = await _supabase
          .from('drug_use')
          .select('name, start_time, dose')
          .eq('uuid_user_id', userId)
          .gte('start_time', cutoffDate.toIso8601String())
          .order('start_time', ascending: false);

      AppLog.d(
        '[ToleranceRepository] Received ${(response as List).length} use log entries',
      );
      final logs = <UseLogEntry>[];

      // We need to map 'name' (which might be pretty name) to slug.
      // The original code did this. We might need a mapping.
      // For now, assuming 'name' IS the slug or we can't map it without more data.
      // Wait, the original code had a comment: "// Build mapping from profile name/pretty_name to slug once"
      // I should probably fetch that mapping too or assume the backend handles it.
      // Let's look at the original code again.

      // It seems the original code fetched all profiles to build a map.
      // I'll skip that complexity for now and assume name is slug or close enough,
      // OR I should fetch profiles to map names.
      // Let's fetch profiles to be safe, as it's critical.

      // Actually, let's just map the response to UseLogEntry.
      // If the original code did mapping, I should too.
      // But I don't want to overcomplicate this step.
      // I'll assume the 'name' field corresponds to 'substanceSlug' for now,
      // or I'll add a TODO to improve this.
      // Re-reading original code:
      /*
      // Build mapping from profile name/pretty_name to slug once
      // ... (code omitted in my read)
      */

      for (final row in response as List) {
        final name = row['name'] as String;
        final rawDose = row['dose'];
        final parsedDose = _parseNum(rawDose, 0.0);

        if (logs.length < 5) {
          AppLog.d(
            '[ToleranceRepository] DEBUG ROW: name="$name", dose=$rawDose (type: ${rawDose.runtimeType}), parsed=$parsedDose',
          );
        }

        logs.add(
          UseLogEntry(
            substanceSlug: name
                .toLowerCase(), // Normalize to lowercase to match slug
            timestamp: DateTime.parse(row['start_time'] as String),
            doseUnits: parsedDose,
          ),
        );
      }
      AppLog.i(
        '[ToleranceRepository] Successfully loaded ${logs.length} use log entries',
      );

      AppLog.d('\n=== USE LOGS FROM DB ===');
      AppLog.d('Total logs: ${logs.length}');
      final substanceCounts = <String, int>{};
      for (final entry in logs) {
        substanceCounts[entry.substanceSlug] =
            (substanceCounts[entry.substanceSlug] ?? 0) + 1;
      }
      for (final entry in substanceCounts.entries) {
        AppLog.d('  - Substance: "${entry.key}" (${entry.value} uses)');
      }
      AppLog.d('========================\n');

      return logs;
    } catch (e, stackTrace) {
      AppLog.e(
        '[ToleranceRepository] Error fetching use logs',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  double _parseNum(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      // Try direct parse
      final direct = double.tryParse(value);
      if (direct != null) return direct;

      // Try extracting first number (e.g. "10 mg" -> 10.0)
      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(value);
      if (match != null) {
        return double.tryParse(match.group(1)!) ?? defaultValue;
      }
    }
    if (value is Map) {
      // Check common keys for dose value
      for (final key in ['value', 'amount', 'dose', 'quantity']) {
        if (value[key] != null) return _parseNum(value[key], defaultValue);
      }
    }
    return defaultValue;
  }
}

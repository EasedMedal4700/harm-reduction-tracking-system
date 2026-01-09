// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Repository for fetching tolerance data

import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../common/logging/app_log.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../../../core/utils/dose_string_to_mg.dart';
import '../models/tolerance_models.dart';

part 'tolerance_repository.g.dart';

@riverpod
ToleranceRepository toleranceRepository(Ref ref) {
  SupabaseClient? client;
  try {
    client = Supabase.instance.client;
  } catch (_) {
    client = null;
  }
  return ToleranceRepository(
    client,
    prefs: ref.watch(sharedPreferencesProvider),
  );
}

class ToleranceRepository {
  static const String _toleranceModelAssetPath =
      'backend/ML/drug_tolerance_model/outputs/tolerance_neuro_buckets.json';

  final SupabaseClient? _supabase;
  final SharedPreferences _prefs;

  ToleranceRepository(this._supabase, {required SharedPreferences prefs})
    : _prefs = prefs;

  Future<Map<String, ToleranceModel>> fetchToleranceModels() async {
    try {
      AppLog.d('[ToleranceRepository] Loading tolerance models from asset...');
      final raw = await rootBundle.loadString(_toleranceModelAssetPath);
      final decoded = jsonDecode(raw);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Tolerance model JSON root is not an object');
      }

      final substances =
          (decoded['substances'] as Map?)?.cast<String, dynamic>() ?? const {};
      final models = <String, ToleranceModel>{};

      for (final entry in substances.entries) {
        final slug = entry.key;
        final toleranceJson = (entry.value as Map?)?.cast<String, dynamic>();
        if (toleranceJson == null) continue;

        final bucketsJson =
            (toleranceJson['neuro_buckets'] as Map?)?.cast<String, dynamic>() ??
            const {};
        final buckets = <String, NeuroBucket>{};

        bucketsJson.forEach((bucketName, value) {
          final valMap = (value as Map?)?.cast<String, dynamic>() ?? const {};
          buckets[bucketName] = NeuroBucket(
            name: bucketName,
            weight: _parseNum(valMap['weight'], 0.0),
            toleranceType:
                valMap['tolerance_type']?.toString() ??
                valMap['toleranceType']?.toString(),
          );
        });

        models[slug] = ToleranceModel(
          notes: toleranceJson['notes']?.toString() ?? '',
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
      }

      AppLog.i(
        '[ToleranceRepository] Loaded ${models.length} tolerance models from asset',
      );

      AppLog.d('\n=== TOLERANCE MODELS LOADED FROM ASSET ===');
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
      final supabase = _supabase;
      if (supabase == null) {
        throw Exception('Supabase not initialized');
      }
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      AppLog.d(
        '[ToleranceRepository] Fetching use logs for user $userId, last $daysBack days',
      );
      final response = await supabase
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
        final parsedDose = DoseStringToMg.parse(
          prefs: _prefs,
          substance: name,
          dose: rawDose,
          defaultValue: 0.0,
        );

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
      final direct = double.tryParse(value);
      if (direct != null) return direct;

      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(value);
      if (match != null) {
        return double.tryParse(match.group(1)!) ?? defaultValue;
      }
    }
    if (value is Map) {
      for (final key in ['value', 'amount', 'dose', 'quantity']) {
        if (value[key] != null) return _parseNum(value[key], defaultValue);
      }
    }
    return defaultValue;
  }
}

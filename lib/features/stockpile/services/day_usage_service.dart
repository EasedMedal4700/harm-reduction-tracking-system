// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';

abstract class DayUsageApi {
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String substanceName,
  });
}

class SupabaseDayUsageApi implements DayUsageApi {
  SupabaseDayUsageApi(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String substanceName,
  }) async {
    final response = await _client
        .from('drug_use')
        .select('start_time, dose, consumption, medical')
        .eq('name', substanceName)
        .order('start_time', ascending: false);

    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
        .toList();
  }
}

class DayUsageService {
  DayUsageService({DayUsageApi? api})
    : _api = api ?? SupabaseDayUsageApi(Supabase.instance.client);

  final DayUsageApi _api;

  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    final rows = await _api.fetchDrugUseRows(substanceName: substanceName);
    return _filterForWeekday(rows: rows, weekdayIndex: weekdayIndex);
  }

  List<DayUsageEntry> _filterForWeekday({
    required List<Map<String, dynamic>> rows,
    required int weekdayIndex,
  }) {
    final List<DayUsageEntry> result = [];

    for (final row in rows) {
      final startTime = DateTime.tryParse(row['start_time']?.toString() ?? '');
      if (startTime == null) continue;

      final isMedical = row['medical'] == true || row['medical'] == 1;
      var adjustedTime = startTime;
      if (!isMedical && startTime.hour < 5) {
        adjustedTime = startTime.subtract(const Duration(hours: 5));
      }

      if (adjustedTime.weekday % 7 != weekdayIndex) continue;

      result.add(
        DayUsageEntry(
          startTime: startTime,
          dose: row['dose']?.toString() ?? 'Unknown',
          route: row['consumption']?.toString() ?? 'Unknown',
          isMedical: isMedical,
        ),
      );
    }

    return result;
  }
}

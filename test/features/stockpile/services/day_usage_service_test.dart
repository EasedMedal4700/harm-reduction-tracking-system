import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/day_usage_service.dart';
import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';

class _FakeDayUsageApi implements DayUsageApi {
  _FakeDayUsageApi(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String substanceName,
  }) async {
    return rows;
  }
}

class _FakeSupabaseHttpClient extends http.BaseClient {
  _FakeSupabaseHttpClient({required this.jsonByPath});

  final Map<String, Object?> jsonByPath;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    final body = jsonEncode(
      jsonByPath.entries
              .firstWhere(
                (e) => path.contains(e.key),
                orElse: () => const MapEntry('', <Object?>[]),
              )
              .value ??
          <Object?>[],
    );

    return http.StreamedResponse(
      Stream<List<int>>.value(utf8.encode(body)),
      200,
      headers: const {'content-type': 'application/json'},
      request: request,
    );
  }
}

void main() {
  test('SupabaseDayUsageApi maps response rows', () async {
    final client = SupabaseClient(
      'https://example.com',
      'anon',
      httpClient: _FakeSupabaseHttpClient(
        jsonByPath: {
          '/rest/v1/drug_use': [
            {
              'start_time': DateTime(2025, 1, 6, 2).toIso8601String(),
              'dose': '5 mg',
              'consumption': 'oral',
              'medical': 0,
            },
          ],
        },
      ),
    );

    final api = SupabaseDayUsageApi(client);
    final rows = await api.fetchDrugUseRows(substanceName: 'X');

    expect(rows, hasLength(1));
    expect(rows.single['dose'], '5 mg');
  });

  test('filters by weekday and applies 5am cutoff for non-medical', () async {
    // Monday 02:00 non-medical should count as previous day (Sunday)
    final monday2am = DateTime(2025, 1, 6, 2); // Monday

    final service = DayUsageService(
      api: _FakeDayUsageApi([
        {
          'start_time': monday2am.toIso8601String(),
          'dose': '5 mg',
          'consumption': 'oral',
          'medical': false,
        },
      ]),
    );

    final sundayEntries = await service.fetchForWeekday(
      substanceName: 'X',
      weekdayIndex: 0, // 0 = Sunday (weekday % 7)
    );
    expect(sundayEntries, hasLength(1));

    final mondayEntries = await service.fetchForWeekday(
      substanceName: 'X',
      weekdayIndex: 1, // 1 = Monday
    );
    expect(mondayEntries, isEmpty);
  });

  test('medical entries are not shifted by 5am cutoff', () async {
    final monday2am = DateTime(2025, 1, 6, 2); // Monday

    final service = DayUsageService(
      api: _FakeDayUsageApi([
        {
          'start_time': monday2am.toIso8601String(),
          'dose': '5 mg',
          'consumption': 'oral',
          'medical': true,
        },
      ]),
    );

    final mondayEntries = await service.fetchForWeekday(
      substanceName: 'X',
      weekdayIndex: 1, // Monday
    );
    expect(mondayEntries, hasLength(1));
  });

  test('skips invalid rows and uses Unknown fallbacks', () async {
    final service = DayUsageService(
      api: _FakeDayUsageApi([
        {
          'start_time': 'not-a-date',
          'dose': '10 mg',
          'consumption': 'oral',
          'medical': 0,
        },
        {
          'start_time': DateTime(2025, 1, 5, 12).toIso8601String(), // Sunday
          // missing dose/route
        },
      ]),
    );

    final sundayEntries = await service.fetchForWeekday(
      substanceName: 'X',
      weekdayIndex: 0,
    );

    expect(sundayEntries, hasLength(1));
    expect(sundayEntries.single.dose, 'Unknown');
    expect(sundayEntries.single.route, 'Unknown');
  });
}

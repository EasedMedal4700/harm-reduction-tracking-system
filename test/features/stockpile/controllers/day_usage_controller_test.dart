import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/stockpile/controllers/day_usage_controller.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/day_usage_service.dart';

class _DummyDayUsageApi implements DayUsageApi {
  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String substanceName,
  }) async {
    return const <Map<String, dynamic>>[];
  }
}

class _FakeDayUsageService extends DayUsageService {
  _FakeDayUsageService() : super(api: _DummyDayUsageApi());

  @override
  Future<List<DayUsageEntry>> fetchForWeekday({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    return [
      DayUsageEntry(
        startTime: DateTime(2025, 1, 1, 12),
        dose: '$substanceName-$weekdayIndex',
        route: 'oral',
        isMedical: false,
      ),
    ];
  }
}

void main() {
  test('DayUsageController delegates to DayUsageService', () async {
    final container = ProviderContainer(
      overrides: [
        dayUsageServiceProvider.overrideWithValue(_FakeDayUsageService()),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      dayUsageControllerProvider(substanceName: 'X', weekdayIndex: 3).future,
    );

    expect(result.single.dose, 'X-3');
  });
}

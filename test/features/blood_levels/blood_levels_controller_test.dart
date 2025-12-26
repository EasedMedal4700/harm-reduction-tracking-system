import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/blood_levels/constants/blood_levels_constants.dart';
import 'package:mobile_drug_use_app/features/blood_levels/models/blood_levels_models.dart';
import 'package:mobile_drug_use_app/features/blood_levels/models/blood_levels_state.dart';
import 'package:mobile_drug_use_app/features/blood_levels/providers/blood_levels_providers.dart';
import 'package:mobile_drug_use_app/features/blood_levels/services/blood_levels_service.dart';

class FakeBloodLevelsService extends BloodLevelsService {
  DateTime? lastReferenceTime;
  int calculateCallCount = 0;

  Map<String, DrugLevel> levelsToReturn = const {};

  final Map<String, List<DoseEntry>> timelineDosesByDrug = {};

  @override
  Future<Map<String, DrugLevel>> calculateLevels({DateTime? referenceTime}) async {
    calculateCallCount += 1;
    lastReferenceTime = referenceTime;
    return levelsToReturn;
  }

  @override
  Future<List<DoseEntry>> getDosesForTimeline({
    required String drugName,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
  }) async {
    return timelineDosesByDrug[drugName] ?? const [];
  }
}

DrugLevel _exampleLevel({required DateTime now}) {
  return DrugLevel(
    drugName: 'caffeine',
    totalDose: 100,
    totalRemaining: 50,
    lastDose: 100,
    lastUse: now.subtract(const Duration(hours: 1)),
    halfLife: 5,
    doses: [
      DoseEntry(
        dose: 100,
        startTime: now.subtract(const Duration(hours: 1)),
        remaining: 50,
        hoursElapsed: 1,
        percentRemaining: 50,
      ),
    ],
    categories: const ['stimulant'],
  );
}

void main() {
  test('build loads levels via service', () async {
    final fake = FakeBloodLevelsService();
    final now = DateTime(2025, 1, 1, 12);

    fake.levelsToReturn = {
      'caffeine': _exampleLevel(now: now),
    };

    final container = ProviderContainer(
      overrides: [
        bloodLevelsServiceProvider.overrideWithValue(fake),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(bloodLevelsControllerProvider.future);

    expect(state.levels.keys, contains('caffeine'));
    expect(fake.calculateCallCount, 1);
    expect(fake.lastReferenceTime, isNotNull);
  });

  test('include/exclude and filteredLevels behave', () async {
    final fake = FakeBloodLevelsService();
    final now = DateTime(2025, 1, 1, 12);

    fake.levelsToReturn = {
      'caffeine': _exampleLevel(now: now),
      'nicotine': _exampleLevel(now: now).copyWith(drugName: 'nicotine'),
    };

    final container = ProviderContainer(
      overrides: [
        bloodLevelsServiceProvider.overrideWithValue(fake),
      ],
    );
    addTearDown(container.dispose);

    await container.read(bloodLevelsControllerProvider.future);

    final notifier = container.read(bloodLevelsControllerProvider.notifier);

    notifier.includeDrug('caffeine', true);
    var view = container.read(bloodLevelsControllerProvider).valueOrNull!;
    expect(view.includedDrugs, contains('caffeine'));
    expect(view.filteredLevels.keys, contains('caffeine'));
    expect(view.filteredLevels.keys, isNot(contains('nicotine')));

    notifier.excludeDrug('caffeine', true);
    view = container.read(bloodLevelsControllerProvider).valueOrNull!;
    expect(view.excludedDrugs, contains('caffeine'));
    expect(view.includedDrugs, isNot(contains('caffeine')));
    expect(view.filteredLevels.keys, isNot(contains('caffeine')));

    notifier.clearFilters();
    view = container.read(bloodLevelsControllerProvider).valueOrNull!;
    expect(view.includedDrugs, isEmpty);
    expect(view.excludedDrugs, isEmpty);
    expect(view.filteredLevels.keys, containsAll(['caffeine', 'nicotine']));
  });

  test('timeline hours clamp to bounds', () async {
    final fake = FakeBloodLevelsService();

    final container = ProviderContainer(
      overrides: [
        bloodLevelsServiceProvider.overrideWithValue(fake),
      ],
    );
    addTearDown(container.dispose);

    await container.read(bloodLevelsControllerProvider.future);

    final notifier = container.read(bloodLevelsControllerProvider.notifier);

    notifier.setHoursBack(0);
    var view = container.read(bloodLevelsControllerProvider).valueOrNull!;
    expect(view.chartHoursBack, 1);

    notifier.setHoursForward(9999);
    view = container.read(bloodLevelsControllerProvider).valueOrNull!;
    expect(view.chartHoursForward, BloodLevelsConstants.maxTimelineHours);
  });
}

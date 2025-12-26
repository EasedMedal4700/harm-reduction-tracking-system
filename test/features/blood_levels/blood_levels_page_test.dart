import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/blood_levels/blood_levels_page.dart';
import 'package:mobile_drug_use_app/features/blood_levels/models/blood_levels_models.dart';
import 'package:mobile_drug_use_app/features/blood_levels/providers/blood_levels_providers.dart';
import 'package:mobile_drug_use_app/features/blood_levels/services/blood_levels_service.dart';

class FakeBloodLevelsService extends BloodLevelsService {
  final Map<String, DrugLevel> levelsToReturn;
  FakeBloodLevelsService(this.levelsToReturn);

  @override
  Future<Map<String, DrugLevel>> calculateLevels({DateTime? referenceTime}) async {
    return levelsToReturn;
  }

  @override
  Future<List<DoseEntry>> getDosesForTimeline({
    required String drugName,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
  }) async {
    return const [];
  }
}

DrugLevel _exampleLevel(DateTime now) {
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
  testWidgets('shows loading then content', (tester) async {
    final now = DateTime(2025, 1, 1, 12);
    final fakeService = FakeBloodLevelsService({'caffeine': _exampleLevel(now)});

    final container = ProviderContainer(
      overrides: [
        bloodLevelsServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: AppThemeProvider(
          theme: AppTheme.light(fontSize: 1.0, compactMode: false),
          child: const MaterialApp(home: BloodLevelsPage()),
        ),
      ),
    );

    // Ensure the async controller has completed at least once.
    final state = await container.read(bloodLevelsControllerProvider.future);
    expect(state.levels.keys, contains('caffeine'));
    expect(state.showTimeline, isTrue);
    await tester.pumpAndSettle();

    expect(find.text('System Overview'), findsOneWidget);
    expect(find.text('Risk Assessment'), findsOneWidget);
    expect(find.text('No dose data to display'), findsOneWidget);
  });

  testWidgets('shows empty state when no levels', (tester) async {
    final fakeService = FakeBloodLevelsService(const {});

    final container = ProviderContainer(
      overrides: [
        bloodLevelsServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: AppThemeProvider(
          theme: AppTheme.light(fontSize: 1.0, compactMode: false),
          child: const MaterialApp(home: BloodLevelsPage()),
        ),
      ),
    );

    await container.read(bloodLevelsControllerProvider.future);
    await tester.pumpAndSettle();

    // Text comes from BloodLevelsEmptyState.
    expect(find.textContaining('No active substances'), findsOneWidget);
  });
}

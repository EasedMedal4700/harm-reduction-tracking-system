import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/analytics/providers/analytics_providers.dart';
import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/substance_repository.dart';

class _FakeAnalyticsService extends AnalyticsService {
  _FakeAnalyticsService({required this.entries, this.throwOnFetch = false});

  final List<LogEntry> entries;
  final bool throwOnFetch;

  Map<String, String>? lastSetSubstanceToCategory;

  @override
  Future<List<LogEntry>> fetchEntries() async {
    if (throwOnFetch) throw Exception('fetchEntries failed');
    return entries;
  }

  @override
  void setSubstanceToCategory(Map<String, String> map) {
    lastSetSubstanceToCategory = map;
    super.setSubstanceToCategory(map);
  }
}

class _FakeSubstanceRepository extends SubstanceRepository {
  _FakeSubstanceRepository(this.catalog);

  final List<Map<String, dynamic>> catalog;

  @override
  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async => catalog;
}

LogEntry _entry({
  required String substance,
  required DateTime datetime,
  String route = 'Oral',
  String location = 'Home',
  bool isMedicalPurpose = false,
  double craving = 0,
  List<String> feelings = const [],
}) {
  return LogEntry(
    substance: substance,
    dosage: 1,
    unit: 'mg',
    route: route,
    datetime: datetime,
    location: location,
    isMedicalPurpose: isMedicalPurpose,
    cravingIntensity: craving,
    feelings: feelings,
  );
}

void main() {
  test('refresh success populates entries and category map', () async {
    final fakeService = _FakeAnalyticsService(
      entries: [
        _entry(substance: 'Caffeine', datetime: DateTime(2025, 1, 10)),
        _entry(substance: 'THC', datetime: DateTime(2025, 1, 11)),
      ],
    );

    final fakeRepo = _FakeSubstanceRepository([
      {
        'name': 'Caffeine',
        'categories': ['Stimulant'],
      },
      {
        'name': 'THC',
        'categories': ['Cannabinoid'],
      },
    ]);

    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(fakeService),
        substanceRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(analyticsControllerProvider.notifier);
    await controller.refresh();

    final state = container.read(analyticsControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
    expect(state.entries, hasLength(2));

    expect(state.substanceToCategory['caffeine'], isNotNull);
    expect(state.substanceToCategory['thc'], isNotNull);
    expect(fakeService.lastSetSubstanceToCategory, isNotNull);
  });

  test('refresh failure sets error state', () async {
    final fakeService = _FakeAnalyticsService(
      entries: const [],
      throwOnFetch: true,
    );
    final fakeRepo = _FakeSubstanceRepository(const []);

    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(fakeService),
        substanceRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(analyticsControllerProvider.notifier);
    await controller.refresh();

    final state = container.read(analyticsControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isTrue);
    expect(state.entries, isEmpty);
    expect(state.errorMessage, isNotEmpty);
  });

  test('analyticsComputed returns derived metrics and insightText', () async {
    final fakeService = _FakeAnalyticsService(
      entries: [
        _entry(
          substance: 'Caffeine',
          datetime: DateTime(2025, 1, 10, 10),
          craving: 2,
        ),
        _entry(
          substance: 'Caffeine',
          datetime: DateTime(2025, 1, 11, 10),
          craving: 3,
        ),
      ],
    );

    final fakeRepo = _FakeSubstanceRepository([
      {
        'name': 'Caffeine',
        'categories': ['Stimulant'],
      },
    ]);

    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(fakeService),
        substanceRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(analyticsControllerProvider.notifier);
    await controller.refresh();

    final computed = container.read(analyticsComputedProvider);
    expect(computed, isNotNull);
    expect(computed!.totalEntries, 2);
    expect(computed.categoryCounts.values.fold<int>(0, (a, b) => a + b), 2);
    expect(computed.insightText, isNotEmpty);
  });

  test('toggleCategoryZoom selects all substances in category', () async {
    final fakeService = _FakeAnalyticsService(
      entries: [
        _entry(substance: 'A', datetime: DateTime(2025, 1, 10)),
        _entry(substance: 'B', datetime: DateTime(2025, 1, 11)),
      ],
    );

    final fakeRepo = _FakeSubstanceRepository([
      {
        'name': 'A',
        'categories': ['Stimulant'],
      },
      {
        'name': 'B',
        'categories': ['Stimulant'],
      },
    ]);

    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(fakeService),
        substanceRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(analyticsControllerProvider.notifier);
    await controller.refresh();

    controller.toggleCategoryZoom('Stimulant');
    final afterZoom = container.read(analyticsControllerProvider);
    expect(afterZoom.selectedSubstances.toSet(), {'A', 'B'});

    controller.toggleCategoryZoom('Stimulant');
    final afterClear = container.read(analyticsControllerProvider);
    expect(afterClear.selectedSubstances, isEmpty);
  });
}

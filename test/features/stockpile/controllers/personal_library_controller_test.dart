import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/stockpile/controllers/personal_library_controller.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/models/drug_catalog_entry.dart';

class _DummyPersonalLibraryApi implements PersonalLibraryApi {
  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async => const [];

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async => const [];
}

class _FakePersonalLibraryService extends PersonalLibraryService {
  _FakePersonalLibraryService(this._catalogByCall)
    : super(api: _DummyPersonalLibraryApi(), userIdGetter: () => 'u1');

  final List<List<DrugCatalogEntry>> _catalogByCall;
  int fetchCount = 0;
  int toggleFavCount = 0;
  int toggleArchiveCount = 0;

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() async {
    final idx = fetchCount.clamp(0, _catalogByCall.length - 1);
    fetchCount++;
    return _catalogByCall[idx];
  }

  @override
  Future<bool> toggleFavorite(DrugCatalogEntry entry) async {
    toggleFavCount++;
    return !entry.favorite;
  }

  @override
  Future<bool> toggleArchive(DrugCatalogEntry entry) async {
    toggleArchiveCount++;
    return !entry.archived;
  }
}

DrugCatalogEntry _entry({
  required String name,
  required List<String> categories,
  required int totalUses,
  bool archived = false,
  bool favorite = false,
}) {
  return DrugCatalogEntry(
    name: name,
    categories: categories,
    totalUses: totalUses,
    avgDose: 0,
    lastUsed: DateTime(2025, 1, 1),
    weekdayUsage: const WeekdayUsage(
      counts: [0, 0, 0, 0, 0, 0, 0],
      mostActive: 0,
      leastActive: 0,
    ),
    favorite: favorite,
    archived: archived,
    notes: '',
    quantity: 0,
  );
}

void main() {
  test('build computes filtered list and summary', () async {
    final catalog = [
      _entry(name: 'A', categories: const ['Stimulant'], totalUses: 2),
      _entry(
        name: 'B',
        categories: const ['Cannabinoid'],
        totalUses: 1,
        archived: true,
      ),
    ];

    final fakeService = _FakePersonalLibraryService([catalog]);
    final container = ProviderContainer(
      overrides: [
        personalLibraryServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(
      personalLibraryControllerProvider.future,
    );
    expect(state.catalog, hasLength(2));
    // showArchived defaults to false => archived filtered out
    expect(state.filtered.single.name, 'A');
    expect(state.summary.totalUses, 2);
    expect(state.summary.activeSubstances, 1);
    expect(state.summary.mostUsedCategory, 'Stimulant');
  });

  test('setQuery filters and toggleShowArchived includes archived', () async {
    final catalog = [
      _entry(
        name: 'Methylphenidate',
        categories: const ['Stimulant'],
        totalUses: 2,
      ),
      _entry(
        name: 'Cannabis',
        categories: const ['Cannabinoid'],
        totalUses: 1,
        archived: true,
      ),
    ];

    final fakeService = _FakePersonalLibraryService([catalog]);
    final container = ProviderContainer(
      overrides: [
        personalLibraryServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);

    await container.read(personalLibraryControllerProvider.future);

    final notifier = container.read(personalLibraryControllerProvider.notifier);
    notifier.setQuery('cann');

    var next = container.read(personalLibraryControllerProvider).requireValue;
    expect(next.filtered, isEmpty, reason: 'archived hidden by default');

    notifier.toggleShowArchived();
    next = container.read(personalLibraryControllerProvider).requireValue;
    expect(next.showArchived, isTrue);

    notifier.setQuery('cann');
    next = container.read(personalLibraryControllerProvider).requireValue;
    expect(next.filtered.single.name, 'Cannabis');
  });

  test('toggleFavorite and toggleArchive refresh state', () async {
    final catalog1 = [
      _entry(name: 'A', categories: const ['Stimulant'], totalUses: 1),
    ];
    final catalog2 = [
      _entry(name: 'A', categories: const ['Stimulant'], totalUses: 2),
    ];

    final fakeService = _FakePersonalLibraryService([catalog1, catalog2]);
    final container = ProviderContainer(
      overrides: [
        personalLibraryServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);

    final initial = await container.read(
      personalLibraryControllerProvider.future,
    );
    expect(initial.summary.totalUses, 1);

    final notifier = container.read(personalLibraryControllerProvider.notifier);
    await notifier.toggleFavorite(initial.catalog.single);

    final afterFav = container
        .read(personalLibraryControllerProvider)
        .requireValue;
    expect(fakeService.toggleFavCount, 1);
    expect(afterFav.summary.totalUses, 2);

    await notifier.toggleArchive(afterFav.catalog.single);
    expect(fakeService.toggleArchiveCount, 1);
  });
}

// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod controller for stockpile personal library

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/personal_library_state.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';

part 'personal_library_controller.g.dart';

@riverpod
class PersonalLibraryController extends _$PersonalLibraryController {
  @override
  Future<PersonalLibraryState> build() async {
    final service = ref.watch(personalLibraryServiceProvider);
    final catalog = await service.fetchCatalog();
    return _compute(catalog: catalog, query: '', showArchived: false);
  }

  Future<void> refresh() async {
    final previous = state.valueOrNull;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(personalLibraryServiceProvider);
      final catalog = await service.fetchCatalog();
      return _compute(
        catalog: catalog,
        query: previous?.query ?? '',
        showArchived: previous?.showArchived ?? false,
      );
    });
  }

  void setQuery(String query) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      _compute(
        catalog: current.catalog,
        query: query,
        showArchived: current.showArchived,
      ),
    );
  }

  void toggleShowArchived() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      _compute(
        catalog: current.catalog,
        query: current.query,
        showArchived: !current.showArchived,
      ),
    );
  }

  Future<void> toggleFavorite(DrugCatalogEntry entry) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final service = ref.read(personalLibraryServiceProvider);
    await service.toggleFavorite(entry);
    await refresh();
  }

  Future<void> toggleArchive(DrugCatalogEntry entry) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final service = ref.read(personalLibraryServiceProvider);
    await service.toggleArchive(entry);
    await refresh();
  }

  PersonalLibraryState _compute({
    required List<DrugCatalogEntry> catalog,
    required String query,
    required bool showArchived,
  }) {
    final service = ref.read(personalLibraryServiceProvider);
    var filtered = service.applySearch(query, catalog);
    if (!showArchived) {
      filtered = filtered.where((e) => !e.archived).toList();
    }

    final activeSubstances = catalog.where((e) => !e.archived).toList();
    final totalUses = activeSubstances.fold<int>(
      0,
      (sum, e) => sum + e.totalUses,
    );
    final avgUses = activeSubstances.isEmpty
        ? 0.0
        : totalUses / activeSubstances.length;

    final Map<String, int> categoryCount = {};
    for (final entry in activeSubstances) {
      for (final cat in entry.categories) {
        categoryCount[cat] = (categoryCount[cat] ?? 0) + entry.totalUses;
      }
    }

    final mostUsedCategory = categoryCount.isEmpty
        ? 'None'
        : categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return PersonalLibraryState(
      catalog: catalog,
      filtered: filtered,
      query: query,
      showArchived: showArchived,
      summary: PersonalLibrarySummary(
        totalUses: totalUses,
        activeSubstances: activeSubstances.length,
        avgUses: avgUses,
        mostUsedCategory: mostUsedCategory,
      ),
    );
  }
}

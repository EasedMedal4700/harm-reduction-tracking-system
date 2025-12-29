// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod controller + computed snapshot; UI reads derived values.
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';
import 'package:mobile_drug_use_app/features/analytics/models/analytics_computed.dart';
import 'package:mobile_drug_use_app/features/analytics/models/analytics_state.dart';
import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/repo/substance_repository.dart';
import 'package:mobile_drug_use_app/features/analytics/utils/time_period_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/common/logging/app_log.dart';

part 'analytics_providers.g.dart';

@riverpod
AnalyticsService analyticsService(Ref ref) => AnalyticsService();

@riverpod
SubstanceRepository substanceRepository(Ref ref) => SubstanceRepository();

@Riverpod(dependencies: [analyticsService, substanceRepository])
class AnalyticsController extends _$AnalyticsController {
  @override
  AnalyticsState build() {
    // Trigger initial load exactly once per provider lifetime.
    Future.microtask(refresh);
    return const AnalyticsState();
  }

  Future<void> refresh() async {
    if (state.isLoading) {
      // allow refresh even if currently loading? keep simple and coalesce
    }
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorDetails: null,
    );

    final service = ref.read(analyticsServiceProvider);
    final repo = ref.read(substanceRepositoryProvider);

    try {
      AppLog.i('[DATA] AnalyticsController.refresh starting');
      final entries = await service.fetchEntries();
      final catalog = await repo.fetchSubstancesCatalog();

      final substanceToCategory = <String, String>{};
      for (final item in catalog) {
        final name = (item['name'] as String?)?.toLowerCase();
        if (name == null || name.isEmpty) continue;

        final categories =
            (item['categories'] as List<dynamic>?)
                ?.whereType<String>()
                .toList() ??
            <String>[];

        final validCategories = categories
            .where((c) => DrugCategories.categoryPriority.contains(c))
            .toList();

        final chosen = validCategories.isNotEmpty
            ? validCategories.reduce(
                (a, b) =>
                    DrugCategories.categoryPriority.indexOf(a) <
                        DrugCategories.categoryPriority.indexOf(b)
                    ? a
                    : b,
              )
            : 'Placeholder';

        substanceToCategory[name] = chosen;
      }

      // Keep service in sync for any legacy consumers.
      service.setSubstanceToCategory(substanceToCategory);

      state = state.copyWith(
        isLoading: false,
        entries: entries,
        substanceToCategory: substanceToCategory,
      );

      AppLog.i(
        '[DATA] AnalyticsController.refresh done (${entries.length} entries)',
      );
    } catch (e) {
      AppLog.e('[DATA] AnalyticsController.refresh failed: $e', error: e);
      state = state.copyWith(
        isLoading: false,
        entries: const <LogEntry>[],
        errorMessage: 'We were unable to load your analytics data.',
        errorDetails: e.toString(),
      );
    }
  }

  void setSelectedPeriod(TimePeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void setSelectedCategories(List<String> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  void setSelectedSubstances(List<String> substances) {
    state = state.copyWith(selectedSubstances: substances);
  }

  void setSelectedTypeIndex(int index) {
    state = state.copyWith(selectedTypeIndex: index);
  }

  void setSelectedPlaces(List<String> places) {
    state = state.copyWith(selectedPlaces: places);
  }

  void setSelectedRoutes(List<String> routes) {
    state = state.copyWith(selectedRoutes: routes);
  }

  void setSelectedFeelings(List<String> feelings) {
    state = state.copyWith(selectedFeelings: feelings);
  }

  void setMinCraving(double value) {
    state = state.copyWith(minCraving: value);
  }

  void setMaxCraving(double value) {
    state = state.copyWith(maxCraving: value);
  }

  void toggleCategoryZoom(String category) {
    // Replicate existing zoom behavior: if already zoomed into the tapped
    // category, clear. Compute directly to avoid circular dependency:
    // analyticsComputedProvider depends on analyticsControllerProvider.
    final service = ref.read(analyticsServiceProvider);

    final periodFilteredEntries = service.filterEntriesByPeriod(
      state.entries,
      state.selectedPeriod,
    );

    final categoryTypeFilteredEntries = periodFilteredEntries.where((e) {
      final mappedCategory =
          state.substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder';
      final matchesCategory =
          state.selectedCategories.isEmpty ||
          state.selectedCategories.contains(mappedCategory);
      final matchesType =
          state.selectedTypeIndex == 0 ||
          (state.selectedTypeIndex == 1 && e.isMedicalPurpose) ||
          (state.selectedTypeIndex == 2 && !e.isMedicalPurpose);
      return matchesCategory && matchesType;
    }).toList();

    final filteredWithoutSubstance = categoryTypeFilteredEntries.where((e) {
      final matchesPlace =
          state.selectedPlaces.isEmpty ||
          state.selectedPlaces.contains(e.location);
      final matchesRoute =
          state.selectedRoutes.isEmpty ||
          state.selectedRoutes.contains(e.route);
      final matchesFeeling =
          state.selectedFeelings.isEmpty ||
          e.feelings.any(state.selectedFeelings.contains);
      final matchesCraving =
          e.cravingIntensity >= state.minCraving &&
          e.cravingIntensity <= state.maxCraving;
      return matchesPlace && matchesRoute && matchesFeeling && matchesCraving;
    }).toList();

    final currentCategorySubstances = filteredWithoutSubstance
        .where((e) {
          final mappedCategory =
              state.substanceToCategory[e.substance.toLowerCase()] ??
              'Placeholder';
          return mappedCategory == category;
        })
        .map((e) => e.substance)
        .toSet()
        .toList();

    final selected = state.selectedSubstances;
    final isAlreadyZoomed =
        selected.isNotEmpty &&
        selected.every(currentCategorySubstances.contains) &&
        currentCategorySubstances.every(selected.contains);

    state = state.copyWith(
      selectedSubstances: isAlreadyZoomed
          ? const <String>[]
          : currentCategorySubstances,
    );
  }
}

@Riverpod(dependencies: [analyticsService, AnalyticsController])
AnalyticsComputed? analyticsComputed(Ref ref) {
  final service = ref.watch(analyticsServiceProvider);
  final state = ref.watch(analyticsControllerProvider);
  if (state.isLoading || state.hasError) return null;

  final entries = state.entries;
  final selectedPeriod = state.selectedPeriod;
  final selectedCategories = state.selectedCategories;
  final selectedTypeIndex = state.selectedTypeIndex;
  final selectedSubstances = state.selectedSubstances;
  final selectedPlaces = state.selectedPlaces;
  final selectedRoutes = state.selectedRoutes;
  final selectedFeelings = state.selectedFeelings;
  final minCraving = state.minCraving;
  final maxCraving = state.maxCraving;
  final substanceToCategory = state.substanceToCategory;

  final periodFilteredEntries = service.filterEntriesByPeriod(
    entries,
    selectedPeriod,
  );

  final categoryTypeFilteredEntries = periodFilteredEntries.where((e) {
    final category =
        substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder';
    final matchesCategory =
        selectedCategories.isEmpty || selectedCategories.contains(category);
    final matchesType =
        selectedTypeIndex == 0 ||
        (selectedTypeIndex == 1 && e.isMedicalPurpose) ||
        (selectedTypeIndex == 2 && !e.isMedicalPurpose);
    return matchesCategory && matchesType;
  }).toList();

  final filteredEntries = categoryTypeFilteredEntries.where((e) {
    final matchesSubstance =
        selectedSubstances.isEmpty || selectedSubstances.contains(e.substance);
    final matchesPlace =
        selectedPlaces.isEmpty || selectedPlaces.contains(e.location);
    final matchesRoute =
        selectedRoutes.isEmpty || selectedRoutes.contains(e.route);
    final matchesFeeling =
        selectedFeelings.isEmpty || e.feelings.any(selectedFeelings.contains);
    final matchesCraving =
        e.cravingIntensity >= minCraving && e.cravingIntensity <= maxCraving;
    return matchesSubstance &&
        matchesPlace &&
        matchesRoute &&
        matchesFeeling &&
        matchesCraving;
  }).toList();

  final avgPerWeek = service.calculateAvgPerWeek(filteredEntries);
  final categoryCounts = service.getCategoryCounts(filteredEntries);
  final mostUsedCategoryEntry = service.getMostUsedCategory(categoryCounts);
  final substanceCounts = service.getSubstanceCounts(filteredEntries);
  final mostUsedSubstanceEntry = service.getMostUsedSubstance(substanceCounts);
  final topCategoryPercent = service
      .getTopCategoryPercent(
        mostUsedCategoryEntry.value,
        filteredEntries.length,
      )
      .toDouble();

  final selectedPeriodText = TimePeriodUtils.getPeriodText(selectedPeriod);

  final insightText = _buildInsightText(
    totalEntries: filteredEntries.length,
    selectedPeriodText: selectedPeriodText,
    weeklyAverage: avgPerWeek,
    mostUsedCategory: mostUsedCategoryEntry.key,
  );

  final uniqueSubstances =
      categoryTypeFilteredEntries.map((e) => e.substance).toSet().toList()
        ..sort();
  final uniqueCategories =
      periodFilteredEntries
          .map(
            (e) =>
                substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder',
          )
          .toSet()
          .toList()
        ..sort();
  final uniquePlaces =
      periodFilteredEntries.map((e) => e.location).toSet().toList()..sort();
  final uniqueRoutes =
      periodFilteredEntries.map((e) => e.route).toSet().toList()..sort();
  final uniqueFeelings =
      periodFilteredEntries.expand((e) => e.feelings).toSet().toList()..sort();

  final substanceCountsByCategory = <String, Map<String, int>>{};
  for (final entry in filteredEntries) {
    final category =
        substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
    final existing = substanceCountsByCategory[category] ?? <String, int>{};
    existing[entry.substance] = (existing[entry.substance] ?? 0) + 1;
    substanceCountsByCategory[category] = existing;
  }

  return AnalyticsComputed(
    filteredEntries: filteredEntries,
    uniqueSubstances: uniqueSubstances,
    uniqueCategories: uniqueCategories,
    uniquePlaces: uniquePlaces,
    uniqueRoutes: uniqueRoutes,
    uniqueFeelings: uniqueFeelings,
    avgPerWeek: avgPerWeek,
    categoryCounts: categoryCounts,
    mostUsedCategory: mostUsedCategoryEntry.key,
    mostUsedCategoryCount: mostUsedCategoryEntry.value,
    substanceCounts: substanceCounts,
    mostUsedSubstance: mostUsedSubstanceEntry.key,
    mostUsedSubstanceCount: mostUsedSubstanceEntry.value,
    topCategoryPercent: topCategoryPercent,
    selectedPeriodText: selectedPeriodText,
    insightText: insightText,
    substanceCountsByCategory: substanceCountsByCategory,
  );
}

String _buildInsightText({
  required int totalEntries,
  required String selectedPeriodText,
  required double weeklyAverage,
  required String mostUsedCategory,
}) {
  if (totalEntries == 0) {
    return 'No usage records found for $selectedPeriodText. Start logging to receive personalized insights and healthier pattern tracking.';
  }
  if (totalEntries == 1) {
    return 'You logged 1 entry in $selectedPeriodText. Keep tracking to build a meaningful overview of your habits and long-term trends.';
  }
  final avg = weeklyAverage.toStringAsFixed(1);
  final cat = mostUsedCategory.isEmpty || mostUsedCategory == 'None'
      ? 'multiple categories'
      : mostUsedCategory;
  return 'In $selectedPeriodText, you logged $totalEntries entries — about $avg per week. Your most common category was $cat. Consider adding notes to better understand your patterns over time.';
}

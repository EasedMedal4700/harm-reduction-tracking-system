// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../models/log_entry_model.dart';
import '../../services/analytics_service.dart';
import '../../../../constants/enums/time_period.dart';
import '../../../../common/inputs/filter_widget.dart';
import 'analytics_summary.dart';
import 'category_pie_chart.dart';
import 'time_period_selector.dart';
import 'usage_trend_chart.dart';
import '../../../../common/logging/app_log.dart';

class AnalyticsContent extends StatelessWidget {
  final List<LogEntry> entries;
  final AnalyticsService service;
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoryChanged;
  final List<String> selectedSubstances;
  final ValueChanged<List<String>> onSubstanceChanged;
  final int selectedTypeIndex;
  final ValueChanged<int> onTypeChanged;
  final List<String> selectedPlaces;
  final ValueChanged<List<String>> onPlaceChanged;
  final List<String> selectedRoutes;
  final ValueChanged<List<String>> onRouteChanged;
  final List<String> selectedFeelings;
  final ValueChanged<List<String>> onFeelingChanged;
  final double minCraving;
  final double maxCraving;
  final ValueChanged<double> onMinCravingChanged;
  final ValueChanged<double> onMaxCravingChanged;
  const AnalyticsContent({
    super.key,
    required this.entries,
    required this.service,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.selectedCategories,
    required this.onCategoryChanged,
    required this.selectedSubstances,
    required this.onSubstanceChanged,
    required this.selectedTypeIndex,
    required this.onTypeChanged,
    required this.selectedPlaces,
    required this.onPlaceChanged,
    required this.selectedRoutes,
    required this.onRouteChanged,
    required this.selectedFeelings,
    required this.onFeelingChanged,
    required this.minCraving,
    required this.onMinCravingChanged,
    required this.maxCraving,
    required this.onMaxCravingChanged,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    AppLog.d(
      '[BUILD] AnalyticsContent build (entries: ${entries.length}, period: $selectedPeriod)',
    );
    final periodFilteredEntries = service.filterEntriesByPeriod(
      entries,
      selectedPeriod,
    );
    AppLog.d('[DATA] Period filtered entries: ${periodFilteredEntries.length}');
    final categoryTypeFilteredEntries = periodFilteredEntries.where((e) {
      final category =
          service.substanceToCategory[e.substance.toLowerCase()] ??
          'Placeholder';
      final matchesCategory =
          selectedCategories.isEmpty || selectedCategories.contains(category);
      final matchesType =
          selectedTypeIndex == 0 ||
          (selectedTypeIndex == 1 && e.isMedicalPurpose) ||
          (selectedTypeIndex == 2 && !e.isMedicalPurpose);
      return matchesCategory && matchesType;
    }).toList();
    AppLog.d(
      '[DATA] Category/type filtered entries: ${categoryTypeFilteredEntries.length}',
    );
    final filteredEntries = categoryTypeFilteredEntries.where((e) {
      final matchesSubstance =
          selectedSubstances.isEmpty ||
          selectedSubstances.contains(e.substance);
      final matchesPlace =
          selectedPlaces.isEmpty || selectedPlaces.contains(e.location);
      final matchesRoute =
          selectedRoutes.isEmpty || selectedRoutes.contains(e.route);
      final matchesFeeling =
          selectedFeelings.isEmpty ||
          e.feelings.any((f) => selectedFeelings.contains(f));
      final matchesCraving =
          e.cravingIntensity >= minCraving && e.cravingIntensity <= maxCraving;
      return matchesSubstance &&
          matchesPlace &&
          matchesRoute &&
          matchesFeeling &&
          matchesCraving;
    }).toList();
    AppLog.d('[DATA] Fully filtered entries: ${filteredEntries.length}');
    final avgPerWeek = service.calculateAvgPerWeek(filteredEntries);
    final categoryCounts = service.getCategoryCounts(filteredEntries);
    final mostUsed = service.getMostUsedCategory(categoryCounts);
    final substanceCounts = service.getSubstanceCounts(filteredEntries);
    final mostUsedSubstance = service.getMostUsedSubstance(substanceCounts);
    final totalEntries = filteredEntries.length;
    final topCategoryPercent = service.getTopCategoryPercent(
      mostUsed.value,
      totalEntries,
    );
    AppLog.d(
      '[METRICS] Total entries: $totalEntries, avg/week: $avgPerWeek, most used category: ${mostUsed.key} (${mostUsed.value}), most used substance: ${mostUsedSubstance.key} (${mostUsedSubstance.value})',
    );
    final selectedPeriodText = _getSelectedPeriodText();
    final uniqueSubstances =
        categoryTypeFilteredEntries.map((e) => e.substance).toSet().toList()
          ..sort();
    final uniqueCategories =
        periodFilteredEntries
            .map(
              (e) =>
                  service.substanceToCategory[e.substance.toLowerCase()] ??
                  'Placeholder',
            )
            .toSet()
            .toList()
          ..sort();
    final uniquePlaces =
        periodFilteredEntries.map((e) => e.location).toSet().toList()..sort();
    final uniqueRoutes =
        periodFilteredEntries.map((e) => e.route).toSet().toList()..sort();
    final uniqueFeelings =
        periodFilteredEntries.expand((e) => e.feelings).toSet().toList()
          ..sort();
    AppLog.d(
      '[FILTERS] Unique substances: ${uniqueSubstances.length}, categories: ${uniqueCategories.length}, places: ${uniquePlaces.length}, routes: ${uniqueRoutes.length}, feelings: ${uniqueFeelings.length}',
    );
    return Padding(
      padding: EdgeInsets.all(th.spacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TimePeriodSelector(
              selectedPeriod: selectedPeriod,
              onPeriodChanged: onPeriodChanged,
            ),
            SizedBox(height: th.spacing.lg),
            FilterWidget(
              uniqueCategories: uniqueCategories,
              uniqueSubstances: uniqueSubstances,
              selectedCategories: selectedCategories,
              onCategoryChanged: onCategoryChanged,
              selectedSubstances: selectedSubstances,
              onSubstanceChanged: onSubstanceChanged,
              selectedTypeIndex: selectedTypeIndex,
              onTypeChanged: onTypeChanged,
              uniquePlaces: uniquePlaces,
              selectedPlaces: selectedPlaces,
              onPlaceChanged: onPlaceChanged,
              uniqueRoutes: uniqueRoutes,
              selectedRoutes: selectedRoutes,
              onRouteChanged: onRouteChanged,
              uniqueFeelings: uniqueFeelings,
              selectedFeelings: selectedFeelings,
              onFeelingChanged: onFeelingChanged,
              minCraving: minCraving,
              maxCraving: maxCraving,
              onMinCravingChanged: onMinCravingChanged,
              onMaxCravingChanged: onMaxCravingChanged,
            ),
            SizedBox(height: th.spacing.lg),
            AnalyticsSummary(
              totalEntries: totalEntries,
              avgPerWeek: avgPerWeek,
              mostUsedCategory: mostUsed.key,
              mostUsedCount: mostUsed.value,
              selectedPeriodText: selectedPeriodText,
              mostUsedSubstance: mostUsedSubstance.key,
              mostUsedSubstanceCount: mostUsedSubstance.value,
              topCategoryPercent: topCategoryPercent,
            ),
            SizedBox(height: th.spacing.lg),
            CategoryPieChart(
              filteredEntries: filteredEntries,
              substanceToCategory: service.substanceToCategory,
            ),
            SizedBox(height: th.spacing.lg),
            UsageTrendChart(
              filteredEntries: filteredEntries,
              period: selectedPeriod,
              substanceToCategory: service.substanceToCategory,
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedPeriodText() {
    switch (selectedPeriod) {
      case TimePeriod.all:
        return 'All Time';
      case TimePeriod.last7Days:
        return 'Last 7 Days';
      case TimePeriod.last7Weeks:
        return 'Last 7 Weeks';
      case TimePeriod.last7Months:
        return 'Last 7 Months';
    }
  }
}

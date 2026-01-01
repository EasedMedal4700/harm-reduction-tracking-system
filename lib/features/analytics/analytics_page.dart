// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Page is Riverpod-driven; filtering/metrics live in providers.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/common/layout/common_drawer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/features/analytics/providers/analytics_providers.dart';
import 'package:mobile_drug_use_app/features/analytics/widgets/analytics_app_bar.dart';
import 'package:mobile_drug_use_app/features/analytics/widgets/analytics_error_state.dart';
import 'package:mobile_drug_use_app/features/analytics/widgets/analytics_layout.dart';
import 'package:mobile_drug_use_app/features/analytics/widgets/analytics_loading_state.dart';
import 'package:mobile_drug_use_app/common/inputs/filter_widget.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/substance_repository.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({
    super.key,
    this.analyticsService,
    this.substanceRepository,
  });

  final AnalyticsService? analyticsService;
  final SubstanceRepository? substanceRepository;

  @override
  Widget build(BuildContext context) {
    final injectedAnalyticsService = analyticsService;
    final injectedSubstanceRepository = substanceRepository;

    final overrides = [
      if (injectedAnalyticsService != null)
        analyticsServiceProvider.overrideWithValue(injectedAnalyticsService),
      if (injectedSubstanceRepository != null)
        substanceRepositoryProvider.overrideWithValue(
          injectedSubstanceRepository,
        ),
    ];

    if (overrides.isEmpty) {
      return const _AnalyticsPageBody();
    }

    return ProviderScope(
      overrides: overrides,
      child: const _AnalyticsPageBody(),
    );
  }
}

class _AnalyticsPageBody extends ConsumerWidget {
  const _AnalyticsPageBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(analyticsControllerProvider);
    final computed = ref.watch(analyticsComputedProvider);
    final controller = ref.read(analyticsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AnalyticsAppBar(
        selectedPeriod: state.selectedPeriod,
        onPeriodChanged: controller.setSelectedPeriod,
        onExport: () {
          // TODO: Implement export functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Export functionality coming soon'),
              backgroundColor: c.info,
            ),
          );
        },
      ),
      drawer: const CommonDrawer(),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const AnalyticsLoadingState();
          }
          if (state.hasError) {
            return AnalyticsErrorState(
              message: state.errorMessage!,
              details: state.errorDetails,
              onRetry: controller.refresh,
            );
          }
          if (computed == null) {
            return const AnalyticsLoadingState();
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: AnalyticsLayout(
              filterContent: FilterWidget(
                uniqueCategories: computed.uniqueCategories,
                uniqueSubstances: computed.uniqueSubstances,
                selectedCategories: state.selectedCategories,
                onCategoryChanged: controller.setSelectedCategories,
                selectedSubstances: state.selectedSubstances,
                onSubstanceChanged: controller.setSelectedSubstances,
                selectedTypeIndex: state.selectedTypeIndex,
                onTypeChanged: controller.setSelectedTypeIndex,
                uniquePlaces: computed.uniquePlaces,
                selectedPlaces: state.selectedPlaces,
                onPlaceChanged: controller.setSelectedPlaces,
                uniqueRoutes: computed.uniqueRoutes,
                selectedRoutes: state.selectedRoutes,
                onRouteChanged: controller.setSelectedRoutes,
                uniqueFeelings: computed.uniqueFeelings,
                selectedFeelings: state.selectedFeelings,
                onFeelingChanged: controller.setSelectedFeelings,
                minCraving: state.minCraving,
                maxCraving: state.maxCraving,
                onMinCravingChanged: controller.setMinCraving,
                onMaxCravingChanged: controller.setMaxCraving,
                selectedPeriod: state.selectedPeriod,
                onPeriodChanged: controller.setSelectedPeriod,
              ),
              totalEntries: computed.totalEntries,
              mostUsedSubstance: computed.mostUsedSubstance,
              mostUsedCount: computed.mostUsedSubstanceCount,
              weeklyAverage: computed.avgPerWeek,
              topCategory: computed.mostUsedCategory,
              topCategoryPercent: computed.topCategoryPercent,
              categoryCounts: computed.categoryCounts,
              substanceCounts: computed.substanceCounts,
              substanceCountsByCategory: computed.substanceCountsByCategory,
              filteredEntries: computed.filteredEntries,
              substanceToCategory: state.substanceToCategory,
              onCategoryTapped: controller.toggleCategoryZoom,
              period: state.selectedPeriod,
              selectedPeriodText: computed.selectedPeriodText,
              mostUsedCategory: computed.mostUsedCategory,
              insightText: computed.insightText,
            ),
          );
        },
      ),
    );
  }
}

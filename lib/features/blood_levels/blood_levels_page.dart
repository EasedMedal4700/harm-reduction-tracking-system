// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Page structure migrated.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/blood_levels_constants.dart';
import 'models/blood_levels_state.dart';
import 'providers/blood_levels_providers.dart';
import 'services/blood_levels_service.dart';
import 'package:mobile_drug_use_app/core/services/onboarding_service.dart';
import 'widgets/filter_panel.dart';
import 'widgets/blood_levels_app_bar.dart';
import 'widgets/blood_levels_loading_state.dart';
import 'widgets/blood_levels_error_state.dart';
import 'widgets/blood_levels_empty_state.dart';
import 'widgets/blood_levels_content.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/feedback/harm_reduction_banner.dart';
import '../../constants/theme/app_theme_extension.dart';

class BloodLevelsPage extends ConsumerWidget {
  final BloodLevelsService? service;
  const BloodLevelsPage({super.key, this.service});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = _BloodLevelsPageBody();
    if (service == null) {
      return page;
    }

    return ProviderScope(
      overrides: [bloodLevelsServiceProvider.overrideWithValue(service!)],
      child: page,
    );
  }
}

class _BloodLevelsPageBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    final asyncState = ref.watch(bloodLevelsControllerProvider);
    final viewState = asyncState.valueOrNull;
    final selectedTime = viewState?.selectedTime ?? DateTime.now();

    return Scaffold(
      backgroundColor: c.background,
      appBar: BloodLevelsAppBar(
        selectedTime: selectedTime,
        onTimeMachinePressed: () =>
            _showTimeMachine(context, ref, selectedTime),
        onFilterPressed: () =>
            ref.read(bloodLevelsControllerProvider.notifier).toggleFilters(),
        onTimelinePressed: () =>
            ref.read(bloodLevelsControllerProvider.notifier).toggleTimeline(),
        onRefreshPressed: () =>
            ref.read(bloodLevelsControllerProvider.notifier).refresh(),
        filterCount: viewState?.filterCount ?? 0,
        timelineVisible: viewState?.showTimeline ?? true,
      ),
      drawer: const CommonDrawer(),
      body: Column(
        children: [
          HarmReductionBanner(
            dismissKey: OnboardingService.bloodLevelsHarmNoticeDismissedKey,
            message:
                'Blood level calculations are mathematical estimates based on '
                'pharmacokinetic models. Actual blood concentrations vary significantly '
                'based on individual metabolism, substance purity, route of administration, '
                'and many other factors. Never use these numbers to make dosing decisions.',
          ),
          if (viewState?.showFilters ?? false)
            _FilterPanel(viewState: viewState),
          Expanded(child: _MainContent(asyncState: asyncState)),
        ],
      ),
    );
  }

  Future<void> _showTimeMachine(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedTime,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedTime,
      firstDate: DateTime.now().subtract(
        const Duration(days: BloodLevelsConstants.timeMachinePastDays),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: BloodLevelsConstants.timeMachineFutureDays),
      ),
    );
    if (date == null) return;

    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
    );
    if (time == null) return;

    final next = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    await ref
        .read(bloodLevelsControllerProvider.notifier)
        .setSelectedTime(next);
  }
}

class _FilterPanel extends ConsumerWidget {
  final BloodLevelsState? viewState;
  const _FilterPanel({required this.viewState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = viewState;
    if (state == null) return const SizedBox.shrink();

    return FilterPanel(
      availableDrugs: state.availableDrugs,
      includedDrugs: state.includedDrugs,
      excludedDrugs: state.excludedDrugs,
      onIncludeChanged: (drug, selected) => ref
          .read(bloodLevelsControllerProvider.notifier)
          .includeDrug(drug, selected),
      onExcludeChanged: (drug, selected) => ref
          .read(bloodLevelsControllerProvider.notifier)
          .excludeDrug(drug, selected),
      onClearAll: () =>
          ref.read(bloodLevelsControllerProvider.notifier).clearFilters(),
    );
  }
}

class _MainContent extends ConsumerWidget {
  final AsyncValue<BloodLevelsState> asyncState;
  const _MainContent({required this.asyncState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(bloodLevelsControllerProvider.notifier);
    final viewState = asyncState.valueOrNull;

    if (asyncState.isLoading && viewState == null) {
      return const BloodLevelsLoadingState();
    }

    if (asyncState.hasError && viewState == null) {
      return BloodLevelsErrorState(
        error: 'Failed to load: ${asyncState.error}',
        onRetry: controller.refresh,
      );
    }

    if (viewState == null) {
      return const BloodLevelsLoadingState();
    }

    final filteredLevels = viewState.filteredLevels;
    if (filteredLevels.isEmpty) {
      return BloodLevelsEmptyState(
        hasActiveFilters: viewState.hasActiveFilters,
      );
    }

    return BloodLevelsContent(
      filteredLevels: filteredLevels,
      allLevels: viewState.levels,
      showTimeline: viewState.showTimeline,
      chartHoursBack: viewState.chartHoursBack,
      chartHoursForward: viewState.chartHoursForward,
      chartAdaptiveScale: viewState.chartAdaptiveScale,
      referenceTime: viewState.selectedTime,
      onHoursBackChanged: controller.setHoursBack,
      onHoursForwardChanged: controller.setHoursForward,
      onAdaptiveScaleChanged: controller.setAdaptiveScale,
      onPresetSelected: controller.setPreset,
    );
  }
}

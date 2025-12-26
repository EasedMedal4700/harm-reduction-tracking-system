// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Feature provider.
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/logging/logger.dart';
import '../constants/blood_levels_constants.dart';
import '../models/blood_levels_models.dart';
import '../models/blood_levels_state.dart';
import '../models/blood_levels_timeline_request.dart';
import '../services/blood_levels_service.dart';

part 'blood_levels_providers.g.dart';

@riverpod
BloodLevelsService bloodLevelsService(Ref ref) {
  return BloodLevelsService();
}

@Riverpod(dependencies: [bloodLevelsService])
class BloodLevelsController extends _$BloodLevelsController {
  @override
  Future<BloodLevelsState> build() async {
    final selectedTime = DateTime.now();
    final service = ref.watch(bloodLevelsServiceProvider);

    final levels = await service.calculateLevels(referenceTime: selectedTime);

    return BloodLevelsState(
      levels: levels,
      selectedTime: selectedTime,
      chartHoursBack: BloodLevelsConstants.defaultChartHoursBack,
      chartHoursForward: BloodLevelsConstants.defaultChartHoursForward,
      chartAdaptiveScale: BloodLevelsConstants.defaultAdaptiveScale,
      showTimeline: BloodLevelsConstants.defaultShowTimeline,
    );
  }

  Future<void> refresh() async {
    final previous = state.valueOrNull;
    if (previous == null) return;

    state = const AsyncLoading<BloodLevelsState>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final levels = await ref
          .read(bloodLevelsServiceProvider)
          .calculateLevels(referenceTime: previous.selectedTime);

      return previous.copyWith(levels: levels);
    });

    if (state.hasError) {
      logger.error(
        '[BloodLevelsController] refresh failed',
        error: state.error,
        stackTrace: state.stackTrace,
      );
    }
  }

  Future<void> setSelectedTime(DateTime selectedTime) async {
    final previous = state.valueOrNull;
    if (previous == null) return;

    state = const AsyncLoading<BloodLevelsState>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final levels = await ref
          .read(bloodLevelsServiceProvider)
          .calculateLevels(referenceTime: selectedTime);

      return previous.copyWith(selectedTime: selectedTime, levels: levels);
    });

    if (state.hasError) {
      logger.error(
        '[BloodLevelsController] setSelectedTime failed',
        error: state.error,
        stackTrace: state.stackTrace,
      );
    }
  }

  void toggleFilters() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(showFilters: !current.showFilters));
  }

  void toggleTimeline() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(showTimeline: !current.showTimeline));
  }

  void includeDrug(String drugName, bool selected) {
    final current = state.valueOrNull;
    if (current == null) return;

    final included = {...current.includedDrugs};
    final excluded = {...current.excludedDrugs};

    if (selected) {
      included.add(drugName);
      excluded.remove(drugName);
    } else {
      included.remove(drugName);
    }

    state = AsyncData(
      current.copyWith(includedDrugs: included, excludedDrugs: excluded),
    );
  }

  void excludeDrug(String drugName, bool selected) {
    final current = state.valueOrNull;
    if (current == null) return;

    final included = {...current.includedDrugs};
    final excluded = {...current.excludedDrugs};

    if (selected) {
      excluded.add(drugName);
      included.remove(drugName);
    } else {
      excluded.remove(drugName);
    }

    state = AsyncData(
      current.copyWith(includedDrugs: included, excludedDrugs: excluded),
    );
  }

  void clearFilters() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(includedDrugs: const {}, excludedDrugs: const {}),
    );
  }

  void setHoursBack(int value) {
    final current = state.valueOrNull;
    if (current == null) return;

    final clamped = value.clamp(1, BloodLevelsConstants.maxTimelineHours);
    state = AsyncData(current.copyWith(chartHoursBack: clamped));
  }

  void setHoursForward(int value) {
    final current = state.valueOrNull;
    if (current == null) return;

    final clamped = value.clamp(1, BloodLevelsConstants.maxTimelineHours);
    state = AsyncData(current.copyWith(chartHoursForward: clamped));
  }

  void setAdaptiveScale(bool value) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(chartAdaptiveScale: value));
  }

  void setPreset(int back, int forward) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(chartHoursBack: back, chartHoursForward: forward),
    );
  }
}

@Riverpod(dependencies: [bloodLevelsService])
Future<Map<String, List<DoseEntry>>> bloodLevelsTimelineDoses(
  Ref ref,
  BloodLevelsTimelineRequest request,
) async {
  final service = ref.watch(bloodLevelsServiceProvider);

  final results = <String, List<DoseEntry>>{};

  for (final drugName in request.drugNames) {
    final doses = await service.getDosesForTimeline(
      drugName: drugName,
      referenceTime: request.referenceTime,
      hoursBack: request.hoursBack,
      hoursForward: request.hoursForward,
    );

    if (doses.isNotEmpty) {
      results[drugName] = doses;
    }
  }

  return results;
}

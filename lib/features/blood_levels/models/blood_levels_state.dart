// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Feature state.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/blood_levels_constants.dart';
import 'blood_levels_models.dart';

part 'blood_levels_state.freezed.dart';

@freezed
class BloodLevelsState with _$BloodLevelsState {
  const factory BloodLevelsState({
    @Default(<String, DrugLevel>{}) Map<String, DrugLevel> levels,
    required DateTime selectedTime,
    @Default(<String>{}) Set<String> includedDrugs,
    @Default(<String>{}) Set<String> excludedDrugs,
    @Default(false) bool showFilters,
    @Default(BloodLevelsConstants.defaultShowTimeline) bool showTimeline,
    @Default(BloodLevelsConstants.defaultChartHoursBack) int chartHoursBack,
    @Default(BloodLevelsConstants.defaultChartHoursForward)
    int chartHoursForward,
    @Default(BloodLevelsConstants.defaultAdaptiveScale) bool chartAdaptiveScale,
  }) = _BloodLevelsState;
}

extension BloodLevelsStateX on BloodLevelsState {
  int get filterCount => includedDrugs.length + excludedDrugs.length;

  bool get hasActiveFilters =>
      includedDrugs.isNotEmpty || excludedDrugs.isNotEmpty;

  List<String> get availableDrugs => levels.keys.toList()..sort();

  Map<String, DrugLevel> get filteredLevels {
    if (!hasActiveFilters) return levels;

    return Map.fromEntries(
      levels.entries.where((entry) {
        final drugName = entry.key;
        if (includedDrugs.isNotEmpty && !includedDrugs.contains(drugName)) {
          return false;
        }
        if (excludedDrugs.contains(drugName)) {
          return false;
        }
        return true;
      }),
    );
  }
}

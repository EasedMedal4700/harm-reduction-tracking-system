// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Freezed state for Analytics feature.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';
import 'package:mobile_drug_use_app/models/log_entry_model.dart';

part 'analytics_state.freezed.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    @Default(true) bool isLoading,
    @Default(<LogEntry>[]) List<LogEntry> entries,
    @Default(<String, String>{}) Map<String, String> substanceToCategory,
    @Default(TimePeriod.all) TimePeriod selectedPeriod,
    @Default(<String>[]) List<String> selectedCategories,
    @Default(0) int selectedTypeIndex,
    @Default(<String>[]) List<String> selectedSubstances,
    @Default(<String>[]) List<String> selectedPlaces,
    @Default(<String>[]) List<String> selectedRoutes,
    @Default(<String>[]) List<String> selectedFeelings,
    @Default(0) double minCraving,
    @Default(10) double maxCraving,
    String? errorMessage,
    String? errorDetails,
  }) = _AnalyticsState;

  const AnalyticsState._();

  bool get hasError => errorMessage != null;
}

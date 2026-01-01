// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Freezed computed snapshot derived from AnalyticsState.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';

part 'analytics_computed.freezed.dart';

@freezed
abstract class AnalyticsComputed with _$AnalyticsComputed {
  const factory AnalyticsComputed({
    required List<LogEntry> filteredEntries,
    required List<String> uniqueSubstances,
    required List<String> uniqueCategories,
    required List<String> uniquePlaces,
    required List<String> uniqueRoutes,
    required List<String> uniqueFeelings,
    required double avgPerWeek,
    required Map<String, int> categoryCounts,
    required String mostUsedCategory,
    required int mostUsedCategoryCount,
    required Map<String, int> substanceCounts,
    required String mostUsedSubstance,
    required int mostUsedSubstanceCount,
    required double topCategoryPercent,
    required String selectedPeriodText,
    required String insightText,
    required Map<String, Map<String, int>> substanceCountsByCategory,
  }) = _AnalyticsComputed;

  const AnalyticsComputed._();

  int get totalEntries => filteredEntries.length;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/features/analytics/services/analytics_service.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';

// Service provider (singleton)
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);
// State for selected time period
final selectedTimePeriodProvider = StateProvider<TimePeriod>(
  (ref) => TimePeriod.last7Weeks,
);
// Async provider for analytics data (fetches entries, computes metrics)
final analyticsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(analyticsServiceProvider);
  final period = ref.watch(selectedTimePeriodProvider);
  try {
    return await service.fetchAnalyticsData(
      period,
    ); // Ensure this method exists in AnalyticsService
  } catch (e) {
    throw Exception(
      'Failed to fetch analytics data: $e',
    ); // Basic error handling
  }
});
// Provider for filters (e.g., substances, places)
final analyticsFiltersProvider =
    StateNotifierProvider<AnalyticsFiltersNotifier, Map<String, List<String>>>(
      (ref) => AnalyticsFiltersNotifier(),
    );

class AnalyticsFiltersNotifier
    extends StateNotifier<Map<String, List<String>>> {
  AnalyticsFiltersNotifier() : super({'substances': [], 'places': []});
  void updateSubstances(List<String> substances) {
    state = {...state, 'substances': substances};
  }

  void updatePlaces(List<String> places) {
    state = {...state, 'places': places};
  }
}

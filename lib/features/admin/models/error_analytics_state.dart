// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Riverpod state for error analytics screen.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_analytics.dart';

part 'error_analytics_state.freezed.dart';

@freezed
class ErrorAnalyticsState with _$ErrorAnalyticsState {
  const factory ErrorAnalyticsState({
    @Default(true) bool isLoading,
    @Default(false) bool isClearingErrors,
    @Default(ErrorAnalytics()) ErrorAnalytics analytics,
    String? errorMessage,
  }) = _ErrorAnalyticsState;
}

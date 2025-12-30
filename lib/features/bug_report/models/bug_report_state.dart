// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod state for Bug Report flow.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bug_report_state.freezed.dart';

@freezed
class BugReportUiEvent with _$BugReportUiEvent {
  const factory BugReportUiEvent.snackbar({
    required String message,
    @Default(false) bool isError,
  }) = _BugReportSnackbar;

  const factory BugReportUiEvent.none() = _BugReportNone;
}

@freezed
class BugReportState with _$BugReportState {
  const factory BugReportState({
    @Default('Medium') String severity,
    @Default('General') String category,
    @Default(false) bool isSubmitting,
    @Default(BugReportUiEvent.none()) BugReportUiEvent uiEvent,
  }) = _BugReportState;
}

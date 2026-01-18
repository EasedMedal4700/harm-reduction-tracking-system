// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Provider-friendly state for the log entry save/confirmation flow.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../log_entry_controller.dart';

part 'log_entry_save_flow_state.freezed.dart';

enum LogEntryConfirmationType { roa, emotions, craving }

@freezed
abstract class LogEntryConfirmationRequest with _$LogEntryConfirmationRequest {
  const factory LogEntryConfirmationRequest({
    required LogEntryConfirmationType type,
    required String title,
    required String message,
  }) = _LogEntryConfirmationRequest;
}

@freezed
abstract class LogEntrySaveFlowState with _$LogEntrySaveFlowState {
  const LogEntrySaveFlowState._();

  const factory LogEntrySaveFlowState({
    @Default(false) bool isSaving,
    LogEntryConfirmationRequest? pendingConfirmation,
    @Default(false) bool roaConfirmed,
    @Default(false) bool emotionsConfirmed,
    @Default(false) bool cravingConfirmed,
    SaveResult? lastResult,
    String? errorTitle,
    String? errorMessage,
  }) = _LogEntrySaveFlowState;

  bool get hasPendingConfirmation => pendingConfirmation != null;
  bool get hasError =>
      (errorMessage != null && errorMessage!.trim().isNotEmpty);
  bool get hasResult => lastResult != null;
}

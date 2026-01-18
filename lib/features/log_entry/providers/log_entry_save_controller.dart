// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Centralized save orchestration for log entry page (validations + confirmations + persistence).
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../log_entry_controller.dart';
import '../models/log_entry_save_flow_state.dart';
import 'log_entry_providers.dart';

part 'log_entry_save_controller.g.dart';

@riverpod
class LogEntrySaveController extends _$LogEntrySaveController {
  late final LogEntryController _controller;

  @override
  LogEntrySaveFlowState build() {
    _controller = ref.read(logEntryControllerProvider);
    return const LogEntrySaveFlowState();
  }

  void clearError() {
    state = state.copyWith(errorTitle: null, errorMessage: null);
  }

  void clearResult() {
    state = state.copyWith(lastResult: null);
  }

  void resetFlow() {
    state = const LogEntrySaveFlowState();
  }

  Future<void> requestSave() async {
    if (state.isSaving) return;
    if (state.hasPendingConfirmation) return;

    final data = ref.read(logEntryProvider);

    final substanceValidation = await _controller.validateSubstance(data);
    if (!substanceValidation.isValid) {
      state = state.copyWith(
        errorTitle: substanceValidation.title ?? 'Validation Error',
        errorMessage: substanceValidation.message ?? 'Invalid substance.',
      );
      return;
    }

    final roaValidation = _controller.validateROA(data);
    if (roaValidation.needsConfirmation && !state.roaConfirmed) {
      state = state.copyWith(
        pendingConfirmation: LogEntryConfirmationRequest(
          type: LogEntryConfirmationType.roa,
          title: roaValidation.title ?? 'Unvalidated Route',
          message: roaValidation.message ?? 'Unvalidated route. Continue?',
        ),
      );
      return;
    }

    final emotionsValidation = _controller.validateEmotions(data);
    if (emotionsValidation.needsConfirmation && !state.emotionsConfirmed) {
      state = state.copyWith(
        pendingConfirmation: LogEntryConfirmationRequest(
          type: LogEntryConfirmationType.emotions,
          title: emotionsValidation.title ?? 'No Emotions Selected',
          message: emotionsValidation.message ?? 'Continue without emotions?',
        ),
      );
      return;
    }

    final cravingValidation = _controller.validateCraving(data);
    if (cravingValidation.needsConfirmation && !state.cravingConfirmed) {
      state = state.copyWith(
        pendingConfirmation: LogEntryConfirmationRequest(
          type: LogEntryConfirmationType.craving,
          title: cravingValidation.title ?? 'No Craving Intensity',
          message: cravingValidation.message ?? 'Continue with craving = 0?',
        ),
      );
      return;
    }

    state = state.copyWith(isSaving: true);
    final result = await _controller.saveLogEntry(data);
    state = state.copyWith(
      isSaving: false,
      lastResult: result,
      // Reset confirmation flags after an attempt so the next save re-validates.
      roaConfirmed: false,
      emotionsConfirmed: false,
      cravingConfirmed: false,
    );
  }

  Future<void> resolvePendingConfirmation(bool confirmed) async {
    final pending = state.pendingConfirmation;
    if (pending == null) return;

    // Clear pending first so the dialog doesn't re-open on rebuild.
    state = state.copyWith(pendingConfirmation: null);

    if (!confirmed) {
      // User cancelled; do not proceed.
      return;
    }

    switch (pending.type) {
      case LogEntryConfirmationType.roa:
        state = state.copyWith(roaConfirmed: true);
      case LogEntryConfirmationType.emotions:
        state = state.copyWith(emotionsConfirmed: true);
      case LogEntryConfirmationType.craving:
        state = state.copyWith(cravingConfirmed: true);
    }

    // Continue the save pipeline.
    await requestSave();
  }
}

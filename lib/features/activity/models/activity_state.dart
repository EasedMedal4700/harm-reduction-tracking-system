// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Feature state.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_models.dart';

part 'activity_state.freezed.dart';

@freezed
class ActivityUiEvent with _$ActivityUiEvent {
  const factory ActivityUiEvent.snackBar({
    required String message,
    @Default(ActivityUiEventTone.neutral) ActivityUiEventTone tone,
  }) = _SnackBar;
}

enum ActivityUiEventTone { neutral, success, error }

@freezed
class ActivityState with _$ActivityState {
  const factory ActivityState({
    @Default(ActivityData()) ActivityData data,
    @Default(false) bool isDeleting,
    ActivityUiEvent? event,
  }) = _ActivityState;
}

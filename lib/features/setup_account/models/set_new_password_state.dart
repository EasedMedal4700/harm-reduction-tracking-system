// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: State for setting new password.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_new_password_state.freezed.dart';

@freezed
class SetNewPasswordState with _$SetNewPasswordState {
  const factory SetNewPasswordState({
    @Default(false) bool isSubmitting,
    @Default(true) bool hasValidSession,
    String? errorMessage,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
  }) = _SetNewPasswordState;

  const SetNewPasswordState._();
}

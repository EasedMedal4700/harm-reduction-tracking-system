// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Immutable state for forgot password flow.
import 'package:freezed_annotation/freezed_annotation.dart';
part 'forgot_password_state.freezed.dart';

enum ForgotPasswordStatus { idle, submitting, success, error }

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(ForgotPasswordStatus.idle) ForgotPasswordStatus status,
    String? errorMessage,
    String? email,
  }) = _ForgotPasswordState;
}

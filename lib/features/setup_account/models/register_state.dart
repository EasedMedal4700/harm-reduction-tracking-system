import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isSubmitting,
    @Default(false) bool onboardingComplete,
    @Default(false) bool privacyAccepted,
    String? errorMessage,
  }) = _RegisterState;

  const RegisterState._();
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recovery_key_state.freezed.dart';

@freezed
class RecoveryKeyState with _$RecoveryKeyState {
  const factory RecoveryKeyState({
    @Default(false) bool isLoading,
    String? errorMessage,

    // UI
    @Default(true) bool keyObscure,
    @Default(true) bool pinObscure,
    @Default(true) bool confirmPinObscure,

    // Two-step flow
    @Default(false) bool recoveryKeyValidated,
    String? validatedRecoveryKey,
  }) = _RecoveryKeyState;

  const RecoveryKeyState._();
}

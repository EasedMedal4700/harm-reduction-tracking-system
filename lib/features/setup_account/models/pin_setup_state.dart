// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: State for PIN setup flow.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_setup_state.freezed.dart';

@freezed
abstract class PinSetupState with _$PinSetupState {
  const factory PinSetupState({
    @Default(false) bool isLoading,
    @Default(false) bool showRecoveryKey,
    String? recoveryKey,
    String? errorMessage,
    @Default(true) bool pin1Obscure,
    @Default(true) bool pin2Obscure,
  }) = _PinSetupState;

  const PinSetupState._();
}

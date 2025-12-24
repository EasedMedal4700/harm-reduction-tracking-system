// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Immutable state for PIN unlock flow.
import 'package:freezed_annotation/freezed_annotation.dart';
part 'pin_unlock_state.freezed.dart';

@freezed
class PinUnlockState with _$PinUnlockState {
  const factory PinUnlockState({
    @Default(false) bool isLoading,
    @Default(true) bool isCheckingAuth,
    @Default(false) bool biometricsAvailable,
    @Default(true) bool pinObscured,
    String? errorMessage,
  }) = _PinUnlockState;
}

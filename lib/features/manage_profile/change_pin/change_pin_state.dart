// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Immutable state for Change PIN flow.
import 'package:freezed_annotation/freezed_annotation.dart';
part 'change_pin_state.freezed.dart';

@freezed
abstract class ChangePinState with _$ChangePinState {
  const factory ChangePinState({
    @Default(false) bool isLoading,
    @Default(false) bool success,
    String? errorMessage,
  }) = _ChangePinState;
}

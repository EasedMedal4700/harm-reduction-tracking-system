// Comprehensive test coverage for PinUnlockState
// Covers: state creation, copyWith, equality

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/login/pin_unlock/pin_unlock_state.dart';

void main() {
  group('PinUnlockState', () {
    test('creates with default values', () {
      const state = PinUnlockState();

      expect(state.isLoading, false);
      expect(state.isCheckingAuth, true);
      expect(state.biometricsAvailable, false);
      expect(state.pinObscured, true);
      expect(state.errorMessage, null);
    });

    test('creates with custom values', () {
      const state = PinUnlockState(
        isLoading: true,
        isCheckingAuth: false,
        biometricsAvailable: true,
        pinObscured: false,
        errorMessage: 'Invalid PIN',
      );

      expect(state.isLoading, true);
      expect(state.isCheckingAuth, false);
      expect(state.biometricsAvailable, true);
      expect(state.pinObscured, false);
      expect(state.errorMessage, 'Invalid PIN');
    });

    test('copyWith updates only specified fields', () {
      const state = PinUnlockState();
      final updated = state.copyWith(
        isLoading: true,
        biometricsAvailable: true,
      );

      expect(updated.isLoading, true);
      expect(updated.biometricsAvailable, true);
      expect(updated.isCheckingAuth, true); // unchanged
      expect(updated.pinObscured, true); // unchanged
    });

    test('copyWith can clear nullable fields', () {
      const state = PinUnlockState(errorMessage: 'Error');
      final cleared = state.copyWith(errorMessage: null);

      expect(cleared.errorMessage, null);
    });

    test('equality works correctly', () {
      const state1 = PinUnlockState(isLoading: true, pinObscured: false);
      const state2 = PinUnlockState(isLoading: true, pinObscured: false);
      const state3 = PinUnlockState(isLoading: false, pinObscured: false);

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('hashCode is consistent', () {
      const state1 = PinUnlockState(biometricsAvailable: true);
      const state2 = PinUnlockState(biometricsAvailable: true);

      expect(state1.hashCode, state2.hashCode);
    });

    test('toString includes all fields', () {
      const state = PinUnlockState(
        isLoading: true,
        isCheckingAuth: false,
        biometricsAvailable: true,
        pinObscured: false,
        errorMessage: 'Test error',
      );

      final str = state.toString();
      expect(str, contains('isLoading'));
      expect(str, contains('isCheckingAuth'));
      expect(str, contains('biometricsAvailable'));
      expect(str, contains('pinObscured'));
      expect(str, contains('errorMessage'));
    });

    test('toggling pinObscured', () {
      const state = PinUnlockState(pinObscured: true);
      final toggled = state.copyWith(pinObscured: false);

      expect(state.pinObscured, true);
      expect(toggled.pinObscured, false);
    });

    test('biometrics availability states', () {
      const unavailable = PinUnlockState(biometricsAvailable: false);
      const available = PinUnlockState(biometricsAvailable: true);

      expect(unavailable.biometricsAvailable, false);
      expect(available.biometricsAvailable, true);
    });
  });
}

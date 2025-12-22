// Comprehensive test coverage for ChangePinState
// Covers: state creation, copyWith, equality

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/manage_profile/change_pin/change_pin_state.dart';

void main() {
  group('ChangePinState', () {
    test('creates with default values', () {
      const state = ChangePinState();

      expect(state.isLoading, false);
      expect(state.success, false);
      expect(state.errorMessage, null);
    });

    test('creates with custom values', () {
      const state = ChangePinState(
        isLoading: true,
        success: true,
        errorMessage: 'Error',
      );

      expect(state.isLoading, true);
      expect(state.success, true);
      expect(state.errorMessage, 'Error');
    });

    test('copyWith updates only specified fields', () {
      const state = ChangePinState();
      final updated = state.copyWith(
        isLoading: true,
        success: true,
      );

      expect(updated.isLoading, true);
      expect(updated.success, true);
      expect(updated.errorMessage, null); // unchanged
    });

    test('copyWith can clear nullable fields', () {
      const state = ChangePinState(errorMessage: 'Error');
      final cleared = state.copyWith(errorMessage: null);

      expect(cleared.errorMessage, null);
    });

    test('equality works correctly', () {
      const state1 = ChangePinState(isLoading: true, success: true);
      const state2 = ChangePinState(isLoading: true, success: true);
      const state3 = ChangePinState(isLoading: false, success: true);

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('hashCode is consistent', () {
      const state1 = ChangePinState(isLoading: true);
      const state2 = ChangePinState(isLoading: true);

      expect(state1.hashCode, state2.hashCode);
    });

    test('toString includes all fields', () {
      const state = ChangePinState(
        isLoading: true,
        success: true,
        errorMessage: 'Test',
      );

      final str = state.toString();
      expect(str, contains('isLoading'));
      expect(str, contains('success'));
      expect(str, contains('errorMessage'));
    });
  });
}

// Test coverage for LoginState
// Covers: state creation, copyWith, equality, serialization

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/login/login/login_state.dart';

void main() {
  group('LoginState', () {
    test('creates with default values', () {
      const state = LoginState();

      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.rememberMe, false);
      expect(state.hasNavigated, false);
      expect(state.isInitialized, false);
    });

    test('creates with custom values', () {
      const state = LoginState(
        isLoading: true,
        errorMessage: 'Test error',
        rememberMe: true,
        hasNavigated: true,
        isInitialized: true,
      );

      expect(state.isLoading, true);
      expect(state.errorMessage, 'Test error');
      expect(state.rememberMe, true);
      expect(state.hasNavigated, true);
      expect(state.isInitialized, true);
    });

    test('copyWith updates only specified fields', () {
      const state = LoginState();
      final updated = state.copyWith(
        isLoading: true,
        errorMessage: 'New error',
      );

      expect(updated.isLoading, true);
      expect(updated.errorMessage, 'New error');
      expect(updated.rememberMe, false); // unchanged
      expect(updated.hasNavigated, false); // unchanged
    });

    test('copyWith can clear nullable fields', () {
      const state = LoginState(errorMessage: 'Error');
      final cleared = state.copyWith(errorMessage: null);

      expect(cleared.errorMessage, null);
    });

    test('equality works correctly', () {
      const state1 = LoginState(isLoading: true, errorMessage: 'Error');
      const state2 = LoginState(isLoading: true, errorMessage: 'Error');
      const state3 = LoginState(isLoading: false, errorMessage: 'Error');

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('hashCode is consistent', () {
      const state1 = LoginState(rememberMe: true);
      const state2 = LoginState(rememberMe: true);

      expect(state1.hashCode, state2.hashCode);
    });

    test('toString includes all fields', () {
      const state = LoginState(
        isLoading: true,
        errorMessage: 'Test',
        rememberMe: true,
      );

      final str = state.toString();
      expect(str, contains('isLoading'));
      expect(str, contains('errorMessage'));
      expect(str, contains('rememberMe'));
    });
  });
}

// Comprehensive test coverage for ForgotPasswordState
// Covers: state creation, copyWith, equality, status enum

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/manage_profile/forgot_password/forgot_password_state.dart';

void main() {
  group('ForgotPasswordState', () {
    test('creates with default values', () {
      const state = ForgotPasswordState();

      expect(state.status, ForgotPasswordStatus.idle);
      expect(state.errorMessage, null);
      expect(state.email, null);
    });

    test('creates with custom values', () {
      const state = ForgotPasswordState(
        status: ForgotPasswordStatus.success,
        errorMessage: 'Test error',
        email: 'test@test.com',
      );

      expect(state.status, ForgotPasswordStatus.success);
      expect(state.errorMessage, 'Test error');
      expect(state.email, 'test@test.com');
    });

    test('copyWith updates only specified fields', () {
      const state = ForgotPasswordState();
      final updated = state.copyWith(
        status: ForgotPasswordStatus.submitting,
        email: 'new@test.com',
      );

      expect(updated.status, ForgotPasswordStatus.submitting);
      expect(updated.email, 'new@test.com');
      expect(updated.errorMessage, null); // unchanged
    });

    test('copyWith can clear nullable fields', () {
      const state = ForgotPasswordState(email: 'test@test.com', errorMessage: 'Error');
      final cleared = state.copyWith(email: null, errorMessage: null);

      expect(cleared.email, null);
      expect(cleared.errorMessage, null);
    });

    test('equality works correctly', () {
      const state1 = ForgotPasswordState(status: ForgotPasswordStatus.success, email: 'test@test.com');
      const state2 = ForgotPasswordState(status: ForgotPasswordStatus.success, email: 'test@test.com');
      const state3 = ForgotPasswordState(status: ForgotPasswordStatus.error, email: 'test@test.com');

      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('hashCode is consistent', () {
      const state1 = ForgotPasswordState(email: 'test@test.com');
      const state2 = ForgotPasswordState(email: 'test@test.com');

      expect(state1.hashCode, state2.hashCode);
    });
  });

  group('ForgotPasswordStatus', () {
    test('has all expected values', () {
      expect(ForgotPasswordStatus.values, contains(ForgotPasswordStatus.idle));
      expect(ForgotPasswordStatus.values, contains(ForgotPasswordStatus.submitting));
      expect(ForgotPasswordStatus.values, contains(ForgotPasswordStatus.success));
      expect(ForgotPasswordStatus.values, contains(ForgotPasswordStatus.error));
    });

    test('enum values are distinct', () {
      expect(ForgotPasswordStatus.idle, isNot(ForgotPasswordStatus.submitting));
      expect(ForgotPasswordStatus.success, isNot(ForgotPasswordStatus.error));
    });
  });
}

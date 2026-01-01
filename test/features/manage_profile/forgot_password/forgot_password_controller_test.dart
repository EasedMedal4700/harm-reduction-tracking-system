// Comprehensive test coverage for ForgotPasswordController
// Covers: sendResetEmail success/failure, reset, state transitions

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/manage_profile/forgot_password/forgot_password_controller.dart';
import 'package:mobile_drug_use_app/features/manage_profile/forgot_password/forgot_password_state.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'forgot_password_controller_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();

    when(mockSupabase.auth).thenReturn(mockAuth);

    container = ProviderContainer(
      overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ForgotPasswordController', () {
    test('creates with idle state', () {
      final state = container.read(forgotPasswordControllerProvider);

      expect(state.status, ForgotPasswordStatus.idle);
      expect(state.errorMessage, null);
      expect(state.email, null);
    });

    test('sendResetEmail succeeds with valid email', () async {
      when(
        mockAuth.resetPasswordForEmail(
          'test@test.com',
          redirectTo: 'substancecheck://reset-password',
        ),
      ).thenAnswer((_) async {});

      final notifier = container.read(
        forgotPasswordControllerProvider.notifier,
      );
      await notifier.sendResetEmail('test@test.com');

      final state = container.read(forgotPasswordControllerProvider);
      expect(state.status, ForgotPasswordStatus.success);
      expect(state.email, 'test@test.com');
      expect(state.errorMessage, null);
    });

    test('sendResetEmail handles errors', () async {
      when(
        mockAuth.resetPasswordForEmail(any, redirectTo: anyNamed('redirectTo')),
      ).thenThrow(Exception('Email not found'));

      final notifier = container.read(
        forgotPasswordControllerProvider.notifier,
      );
      await notifier.sendResetEmail('invalid@test.com');

      final state = container.read(forgotPasswordControllerProvider);
      expect(state.status, ForgotPasswordStatus.error);
      expect(state.errorMessage, contains('Email not found'));
    });

    test('sendResetEmail clears previous error', () async {
      // First call fails
      when(
        mockAuth.resetPasswordForEmail(any, redirectTo: anyNamed('redirectTo')),
      ).thenThrow(Exception('Error'));

      final notifier = container.read(
        forgotPasswordControllerProvider.notifier,
      );
      await notifier.sendResetEmail('test@test.com');

      var state = container.read(forgotPasswordControllerProvider);
      expect(state.errorMessage, isNotNull);

      // Second call succeeds
      when(
        mockAuth.resetPasswordForEmail(any, redirectTo: anyNamed('redirectTo')),
      ).thenAnswer((_) async {});

      await notifier.sendResetEmail('test@test.com');

      state = container.read(forgotPasswordControllerProvider);
      expect(state.errorMessage, null);
    });

    test('reset returns to initial state', () async {
      when(
        mockAuth.resetPasswordForEmail(any, redirectTo: anyNamed('redirectTo')),
      ).thenAnswer((_) async {});

      final notifier = container.read(
        forgotPasswordControllerProvider.notifier,
      );
      await notifier.sendResetEmail('test@test.com');

      var state = container.read(forgotPasswordControllerProvider);
      expect(state.status, ForgotPasswordStatus.success);

      notifier.reset();

      state = container.read(forgotPasswordControllerProvider);
      expect(state.status, ForgotPasswordStatus.idle);
      expect(state.email, null);
      expect(state.errorMessage, null);
    });
  });
}

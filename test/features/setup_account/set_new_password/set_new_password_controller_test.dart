import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_drug_use_app/features/setup_account/controllers/set_new_password_controller.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';

import '../../../mocks/supabase_mocks.mocks.dart';

void main() {
  group('SetNewPasswordController', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    ProviderContainer buildContainer() {
      return ProviderContainer(
        overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
      );
    }

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();

      when(mockSupabase.auth).thenReturn(mockAuth);
    });

    test('build() sets invalid session state when currentSession is null', () {
      when(mockAuth.currentSession).thenReturn(null);

      final container = buildContainer();
      addTearDown(container.dispose);

      final state = container.read(setNewPasswordControllerProvider);
      expect(state.hasValidSession, false);
      expect(state.errorMessage, isNotNull);
    });

    test('build() sets default state when currentSession is present', () {
      when(mockAuth.currentSession).thenReturn(MockSession());

      final container = buildContainer();
      addTearDown(container.dispose);

      final state = container.read(setNewPasswordControllerProvider);
      expect(state.hasValidSession, true);
      expect(state.errorMessage, null);
      expect(state.isSubmitting, false);
    });

    test('toggleObscurePassword flips obscurePassword', () {
      when(mockAuth.currentSession).thenReturn(MockSession());

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        setNewPasswordControllerProvider.notifier,
      );
      final before = container.read(setNewPasswordControllerProvider);

      notifier.toggleObscurePassword();

      final after = container.read(setNewPasswordControllerProvider);
      expect(after.obscurePassword, !before.obscurePassword);
    });

    test('toggleObscureConfirmPassword flips obscureConfirmPassword', () {
      when(mockAuth.currentSession).thenReturn(MockSession());

      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        setNewPasswordControllerProvider.notifier,
      );
      final before = container.read(setNewPasswordControllerProvider);

      notifier.toggleObscureConfirmPassword();

      final after = container.read(setNewPasswordControllerProvider);
      expect(after.obscureConfirmPassword, !before.obscureConfirmPassword);
    });

    test(
      'submitNewPassword success updates password, signs out, and returns true',
      () async {
        when(mockAuth.currentSession).thenReturn(MockSession());
        when(
          mockAuth.updateUser(any),
        ).thenAnswer((_) async => MockUserResponse());
        when(mockAuth.signOut()).thenAnswer((_) async {});

        final container = buildContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          setNewPasswordControllerProvider.notifier,
        );

        final future = notifier.submitNewPassword('password123');
        expect(
          container.read(setNewPasswordControllerProvider).isSubmitting,
          true,
        );

        final ok = await future;
        expect(ok, true);

        final state = container.read(setNewPasswordControllerProvider);
        expect(state.isSubmitting, false);
        expect(state.errorMessage, null);

        final captured =
            verify(mockAuth.updateUser(captureAny)).captured.single
                as UserAttributes;
        expect(captured.password, 'password123');
        verify(mockAuth.signOut()).called(1);
      },
    );

    test(
      'submitNewPassword AuthException returns false and uses exception message',
      () async {
        when(mockAuth.currentSession).thenReturn(MockSession());
        when(
          mockAuth.updateUser(any),
        ).thenThrow(const AuthException('Bad password'));

        final container = buildContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          setNewPasswordControllerProvider.notifier,
        );
        final ok = await notifier.submitNewPassword('password123');

        expect(ok, false);
        final state = container.read(setNewPasswordControllerProvider);
        expect(state.isSubmitting, false);
        expect(state.errorMessage, 'Bad password');
      },
    );

    test(
      'submitNewPassword generic error returns false with fallback message',
      () async {
        when(mockAuth.currentSession).thenReturn(MockSession());
        when(mockAuth.updateUser(any)).thenThrow(Exception('boom'));

        final container = buildContainer();
        addTearDown(container.dispose);

        final notifier = container.read(
          setNewPasswordControllerProvider.notifier,
        );
        final ok = await notifier.submitNewPassword('password123');

        expect(ok, false);
        final state = container.read(setNewPasswordControllerProvider);
        expect(state.isSubmitting, false);
        expect(state.errorMessage, 'An error occurred. Please try again.');
      },
    );
  });
}

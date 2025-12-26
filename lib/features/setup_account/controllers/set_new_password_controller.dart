import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/set_new_password_state.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';

part 'set_new_password_controller.g.dart';

@riverpod
class SetNewPasswordController extends _$SetNewPasswordController {
  @override
  SetNewPasswordState build() {
    final client = ref.read(supabaseClientProvider);
    final session = client.auth.currentSession;

    if (session == null) {
      return const SetNewPasswordState(
        hasValidSession: false,
        errorMessage: 'Your reset link has expired. Please request a new one.',
      );
    }

    return const SetNewPasswordState();
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  Future<bool> submitNewPassword(String password) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final client = ref.read(supabaseClientProvider);
      await client.auth.updateUser(UserAttributes(password: password));
      await client.auth.signOut();

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.message);
      return false;
    } catch (e, st) {
      logger.error('SetNewPasswordController.submitNewPassword failed', error: e, stackTrace: st);
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An error occurred. Please try again.',
      );
      return false;
    }
  }
}

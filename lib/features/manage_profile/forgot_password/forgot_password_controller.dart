// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Handles forgot password orchestration and Supabase interaction.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../providers/core_providers.dart';
import 'forgot_password_state.dart';

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
      (ref) => ForgotPasswordController(ref.read(supabaseClientProvider)),
    );

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordController(this._supabase) : super(const ForgotPasswordState());

  final SupabaseClient _supabase;

  Future<void> sendResetEmail(String email) async {
    state = state.copyWith(
      status: ForgotPasswordStatus.submitting,
      errorMessage: null,
    );

    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'substancecheck://reset-password',
      );

      state = state.copyWith(
        status: ForgotPasswordStatus.success,
        email: email,
      );
    } catch (e) {
      state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}

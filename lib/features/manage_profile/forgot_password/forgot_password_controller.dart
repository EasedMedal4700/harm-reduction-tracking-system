// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Handles forgot password orchestration and Supabase interaction.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'forgot_password_state.dart';

part 'forgot_password_controller.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

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

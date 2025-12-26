import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/register_state.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';
import 'package:mobile_drug_use_app/services/auth_service.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  Future<RegisterState> build() async {
    final onboarding = ref.watch(onboardingServiceProvider);

    final onboardingComplete = await onboarding.isOnboardingComplete();
    final privacyAccepted = await onboarding.isPrivacyPolicyAccepted();

    return RegisterState(
      onboardingComplete: onboardingComplete,
      privacyAccepted: privacyAccepted,
    );
  }

  Future<void> refreshOnboardingStatus() async {
    final previous = state.valueOrNull ?? const RegisterState();
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final onboarding = ref.read(onboardingServiceProvider);
      final onboardingComplete = await onboarding.isOnboardingComplete();
      final privacyAccepted = await onboarding.isPrivacyPolicyAccepted();
      return previous.copyWith(
        onboardingComplete: onboardingComplete,
        privacyAccepted: privacyAccepted,
      );
    });
  }

  Future<AuthResult> submitRegister({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final current = state.valueOrNull ?? const RegisterState();
    state = AsyncValue.data(current.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final auth = ref.read(authServiceProvider);
      final result = await auth.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (!result.success) {
        state = AsyncValue.data(
          current.copyWith(
            isSubmitting: false,
            errorMessage: result.errorMessage,
          ),
        );
      } else {
        state = AsyncValue.data(current.copyWith(isSubmitting: false));
      }

      return result;
    } catch (e, st) {
      logger.error('RegisterController.submitRegister failed', error: e, stackTrace: st);
      state = AsyncValue.data(
        current.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        ),
      );
      return const AuthResult.failure('Registration failed. Please try again.');
    }
  }
}

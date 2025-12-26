// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Controller for onboarding flow.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/onboarding_state.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';

part 'onboarding_controller.g.dart';

const int kOnboardingLastPageIndex = 3;

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() => const OnboardingState();

  void setCurrentPage(int page) {
    if (page == state.currentPage) return;
    state = state.copyWith(currentPage: page, errorMessage: null);
  }

  void togglePrivacyAccepted() {
    state = state.copyWith(privacyAccepted: !state.privacyAccepted);
  }

  void setPrivacyAccepted(bool value) {
    if (value == state.privacyAccepted) return;
    state = state.copyWith(privacyAccepted: value);
  }

  void selectFrequency(String? frequencyId) {
    if (frequencyId == state.selectedFrequency) return;
    state = state.copyWith(selectedFrequency: frequencyId);
  }

  void setDarkTheme(bool isDarkTheme) {
    if (isDarkTheme == state.isDarkTheme) return;
    state = state.copyWith(isDarkTheme: isDarkTheme);
  }

  Future<bool> completeOnboarding() async {
    if (state.isCompleting) return false;

    state = state.copyWith(isCompleting: true, errorMessage: null);

    try {
      final onboarding = ref.read(onboardingServiceProvider);

      final selectedFrequency = state.selectedFrequency;
      if (selectedFrequency != null) {
        await onboarding.saveUsageFrequency(selectedFrequency);
      }
      if (state.privacyAccepted) {
        await onboarding.acceptPrivacyPolicy();
      }

      await onboarding.completeOnboarding();
      state = state.copyWith(isCompleting: false);
      return true;
    } catch (e, st) {
      logger.error(
        'OnboardingController.completeOnboarding failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isCompleting: false,
        errorMessage: 'Failed to complete onboarding. Please try again.',
      );
      return false;
    }
  }
}

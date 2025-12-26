import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    String? selectedFrequency,
    @Default(false) bool privacyAccepted,
    @Default(false) bool isDarkTheme,
    @Default(false) bool isCompleting,
    String? errorMessage,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get canProceedFromCurrentPage {
    switch (currentPage) {
      case 0:
        return true;
      case 1:
        return true;
      case 2:
        return privacyAccepted;
      case 3:
        return selectedFrequency != null;
      default:
        return true;
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage onboarding state and user preferences
class OnboardingService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _privacyPolicyAcceptedKey = 'privacy_policy_accepted';
  static const String _usageFrequencyKey = 'usage_frequency';
  
  // Harm reduction banner dismissal keys
  static const String bloodLevelsHarmNoticeDismissedKey = 'blood_levels_harm_notice_dismissed';
  static const String toleranceHarmNoticeDismissedKey = 'tolerance_harm_notice_dismissed';

  /// Usage frequency options
  static const List<UsageFrequency> usageFrequencies = [
    UsageFrequency(
      id: 'rarely',
      label: 'Rarely',
      description: 'Once a month or less',
      icon: '🌙',
    ),
    UsageFrequency(
      id: 'occasionally',
      label: 'Occasionally',
      description: '2-4 times per month',
      icon: '⭐',
    ),
    UsageFrequency(
      id: 'weekly',
      label: 'Weekly',
      description: '1-3 times per week',
      icon: '📅',
    ),
    UsageFrequency(
      id: 'daily',
      label: 'Daily',
      description: 'Most days of the week',
      icon: '☀️',
    ),
  ];

  /// Check if onboarding has been completed
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Reset onboarding (for testing or re-onboarding)
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
    await prefs.remove(_privacyPolicyAcceptedKey);
    await prefs.remove(_usageFrequencyKey);
  }

  /// Check if privacy policy has been accepted
  Future<bool> isPrivacyPolicyAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyPolicyAcceptedKey) ?? false;
  }

  /// Accept privacy policy
  Future<void> acceptPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyPolicyAcceptedKey, true);
  }

  /// Get saved usage frequency
  Future<String?> getUsageFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usageFrequencyKey);
  }

  /// Save usage frequency
  Future<void> saveUsageFrequency(String frequencyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usageFrequencyKey, frequencyId);
  }

  // ============================================================================
  // HARM REDUCTION BANNER STATE
  // ============================================================================

  /// Check if harm notice is dismissed for a specific screen
  Future<bool> isHarmNoticeDismissed(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  /// Dismiss harm notice for a specific screen
  Future<void> dismissHarmNotice(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  /// Reset all harm notice dismissals
  Future<void> resetHarmNotices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(bloodLevelsHarmNoticeDismissedKey);
    await prefs.remove(toleranceHarmNoticeDismissedKey);
  }
}

/// Data class for usage frequency option
class UsageFrequency {
  final String id;
  final String label;
  final String description;
  final String icon;

  const UsageFrequency({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
  });
}

/// Global singleton instance
final onboardingService = OnboardingService();

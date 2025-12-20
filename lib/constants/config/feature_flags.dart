/// Constants for feature flag names.
///
/// These names must match the `feature_name` column in the
/// `public.feature_flags` table in Supabase.
class FeatureFlags {
  FeatureFlags._();

  // Main Navigation
  static const String homePage = 'home_page';
  static const String activityPage = 'activity_page';
  static const String cravingsPage = 'cravings_page';
  static const String reflectionPage = 'reflection_page';
  static const String bloodLevelsPage = 'blood_levels_page';

  // Data & Resources
  static const String personalLibraryPage = 'personal_library_page';
  static const String analyticsPage = 'analytics_page';
  static const String catalogPage = 'catalog_page';

  // Advanced Features
  static const String physiologicalPage = 'physiological_page';
  static const String interactionsPage = 'interactions_page';
  static const String toleranceDashboardPage = 'tolerance_dashboard_page';
  static const String wearosPage = 'wearos_page';
  static const String bucketDetailsPage = 'bucket_details_page';

  // Entry & Check-in
  static const String logEntryPage = 'log_entry_page';
  static const String dailyCheckin = 'daily_checkin';
  static const String checkinHistoryPage = 'checkin_history_page';

  // Auth & Security
  static const String loginPage = 'login_page';
  static const String registerPage = 'register_page';
  static const String onboardingScreen = 'onboarding_screen';
  static const String pinSetupScreen = 'pin_setup_screen';
  static const String pinUnlockScreen = 'pin_unlock_screen';
  static const String changePinScreen = 'change_pin_screen';
  static const String recoveryKeyScreen = 'recovery_key_screen';
  static const String encryptionMigrationScreen = 'encryption_migration_screen';
  static const String privacyPolicyScreen = 'privacy_policy_screen';

  // Admin
  static const String adminPanel = 'admin_panel';

  /// List of all feature flags for iteration.
  static const List<String> all = [
    homePage,
    activityPage,
    cravingsPage,
    reflectionPage,
    bloodLevelsPage,
    personalLibraryPage,
    analyticsPage,
    catalogPage,
    physiologicalPage,
    interactionsPage,
    toleranceDashboardPage,
    wearosPage,
    bucketDetailsPage,
    logEntryPage,
    dailyCheckin,
    checkinHistoryPage,
    loginPage,
    registerPage,
    onboardingScreen,
    pinSetupScreen,
    pinUnlockScreen,
    changePinScreen,
    recoveryKeyScreen,
    encryptionMigrationScreen,
    privacyPolicyScreen,
    adminPanel,
  ];

  /// Map of feature flags to user-friendly display names.
  static const Map<String, String> displayNames = {
    homePage: 'Home Page',
    activityPage: 'Activity Page',
    cravingsPage: 'Cravings Page',
    reflectionPage: 'Reflection Page',
    bloodLevelsPage: 'Blood Levels Page',
    personalLibraryPage: 'Personal Library',
    analyticsPage: 'Analytics Page',
    catalogPage: 'Substance Catalog',
    physiologicalPage: 'Physiological Page',
    interactionsPage: 'Interactions Page',
    toleranceDashboardPage: 'Tolerance Dashboard',
    wearosPage: 'WearOS Page',
    bucketDetailsPage: 'Bucket Details Page',
    logEntryPage: 'Log Entry Page',
    dailyCheckin: 'Daily Check-in',
    checkinHistoryPage: 'Check-in History',
    loginPage: 'Login Page',
    registerPage: 'Register Page',
    onboardingScreen: 'Onboarding',
    pinSetupScreen: 'PIN Setup',
    pinUnlockScreen: 'PIN Unlock',
    changePinScreen: 'Change PIN',
    recoveryKeyScreen: 'Recovery Key',
    encryptionMigrationScreen: 'Encryption Migration',
    privacyPolicyScreen: 'Privacy Policy',
    adminPanel: 'Admin Panel',
  };

  /// Get display name for a feature flag.
  static String getDisplayName(String featureName) {
    return displayNames[featureName] ?? featureName;
  }
}

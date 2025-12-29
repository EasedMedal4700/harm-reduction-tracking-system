// MIGRATION:
// State: MIXED (app-wide)
// Navigation: GOROUTER (CENTRALIZED)
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Central GoRouter configuration. Mirrors legacy named routes.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:mobile_drug_use_app/constants/config/feature_flags.dart';
import 'package:mobile_drug_use_app/features/admin/screens/admin_panel_screen.dart';
import 'package:mobile_drug_use_app/features/admin/screens/error_analytics_page.dart';
import 'package:mobile_drug_use_app/features/analytics/analytics_page.dart';
import 'package:mobile_drug_use_app/features/activity/activity_page.dart';
import 'package:mobile_drug_use_app/features/blood_levels/blood_levels_page.dart';
import 'package:mobile_drug_use_app/features/bug_report/bug_report_page.dart';
import 'package:mobile_drug_use_app/features/catalog/catalog_page.dart';
import 'package:mobile_drug_use_app/features/craving/cravings_page.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/checkin_history_page.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/daily_checkin_page.dart';
import 'package:mobile_drug_use_app/features/feature_flags/feature_flags_page.dart';
import 'package:mobile_drug_use_app/features/feature_flags/widgets/feature_gate.dart';
import 'package:mobile_drug_use_app/features/home/home_page.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_page.dart';
import 'package:mobile_drug_use_app/features/edit_craving/edit_craving_page.dart';
import 'package:mobile_drug_use_app/features/edit_log_entry/edit_log_entry_page.dart';
import 'package:mobile_drug_use_app/features/edit_reflection/edit_reflection_page.dart';
import 'package:mobile_drug_use_app/features/login/login/login_page.dart';
import 'package:mobile_drug_use_app/features/login/pin_unlock/pin_unlock_page.dart';
import 'package:mobile_drug_use_app/features/manage_profile/change_pin/change_pin_page.dart';
import 'package:mobile_drug_use_app/features/manage_profile/forgot_password/forgot_password_page.dart';
import 'package:mobile_drug_use_app/features/profile/profile_screen.dart';
import 'package:mobile_drug_use_app/features/reflection/reflection_page.dart';
import 'package:mobile_drug_use_app/features/settings/privacy_policy_page.dart';
import 'package:mobile_drug_use_app/features/settings/settings_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/email_confirmed_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/onboarding_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/pin_setup_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/recovery_key_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/register_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/set_new_password_page.dart';
import 'package:mobile_drug_use_app/features/tolerance/pages/tolerance_dashboard_page.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/providers/daily_checkin_provider.dart';

class AppRoutePaths {
  static const login = '/login_page';
  static const signup = '/signup'; // legacy alias
  static const register = '/register';
  static const privacyPolicy = '/privacy-policy';
  static const onboarding = '/onboarding';
  static const pinSetup = '/pin-setup';
  static const pinUnlock = '/pin-unlock';
  static const recoveryKey = '/recovery-key';
  static const encryptionMigration = '/encryption-migration';
  static const changePin = '/change-pin';
  static const forgotPassword = '/forgot-password';
  static const setNewPassword = '/set-new-password';
  static const emailConfirmed = '/email-confirmed';

  // Feature gated
  static const home = '/home_page';
  static const homeAlias = '/home'; // legacy alias
  static const logEntry = '/log_entry';
  static const analytics = '/analytics';
  static const catalog = '/catalog';
  static const cravings = '/cravings';
  static const bloodLevels = '/blood_levels';
  static const reflection = '/reflection';
  static const activity = '/activity';
  static const editDrugUse = '/activity/edit-drug-use';
  static const editCraving = '/activity/edit-craving';
  static const editReflection = '/activity/edit-reflection';
  static const dailyCheckin = '/daily-checkin';
  static const checkinHistory = '/checkin-history';
  static const profile = '/profile';
  static const adminPanel = '/admin-panel';
  static const adminFeatureFlags = '/admin/feature-flags';
  static const adminErrorAnalytics = '/admin/error-analytics';
  static const bugReport = '/bug-report';
  static const settings = '/settings';
  static const toleranceDashboard = '/tolerance-dashboard';
}

GoRouter createAppRouter({required NavigatorObserver observer}) {
  return GoRouter(
    initialLocation: AppRoutePaths.login,
    observers: [observer],
    routes: [
      // Auth
      GoRoute(
        path: AppRoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutePaths.signup,
        redirect: (context, state) => AppRoutePaths.register,
      ),
      GoRoute(
        path: AppRoutePaths.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutePaths.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.pinSetup,
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.pinUnlock,
        builder: (context, state) => const PinUnlockScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.recoveryKey,
        builder: (context, state) => const RecoveryKeyScreen(),
      ),
      // GoRoute(
      //   path: AppRoutePaths.encryptionMigration,
      //   builder: (context, state) => const EncryptionMigrationScreen(),
      // ),
      GoRoute(
        path: AppRoutePaths.changePin,
        builder: (context, state) => const ChangePinPage(),
      ),
      GoRoute(
        path: AppRoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutePaths.setNewPassword,
        builder: (context, state) => const SetNewPasswordPage(),
      ),
      GoRoute(
        path: AppRoutePaths.emailConfirmed,
        builder: (context, state) => const EmailConfirmedPage(),
      ),

      // Legacy alias
      GoRoute(
        path: AppRoutePaths.homeAlias,
        redirect: (context, state) => AppRoutePaths.home,
      ),

      // Feature-gated
      GoRoute(
        path: AppRoutePaths.home,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.homePage,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.logEntry,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.logEntryPage,
          child: const QuickLogEntryPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.analytics,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.analyticsPage,
          child: const AnalyticsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.catalog,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.catalogPage,
          child: const CatalogPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.cravings,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.cravingsPage,
          child: const CravingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.bloodLevels,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.bloodLevelsPage,
          child: const BloodLevelsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.reflection,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.reflectionPage,
          child: const ReflectionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.activity,
        builder: (context, state) => const ActivityPage(),
      ),
      GoRoute(
        path: AppRoutePaths.editDrugUse,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return EditDrugUsePage(entry: extra);
          }
          return const ActivityPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.editCraving,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return EditCravingPage(entry: extra);
          }
          return const ActivityPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.editReflection,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return EditReflectionPage(entry: extra);
          }
          return const ActivityPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.dailyCheckin,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.dailyCheckin,
          child: ChangeNotifierProvider(
            create: (_) => DailyCheckinProvider(),
            child: const DailyCheckinScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.checkinHistory,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.checkinHistoryPage,
          child: ChangeNotifierProvider(
            create: (_) => DailyCheckinProvider(),
            child: const CheckinHistoryScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.adminPanel,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.adminPanel,
          child: const AdminPanelScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.adminErrorAnalytics,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.adminPanel,
          child: const ErrorAnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.adminFeatureFlags,
        builder: (context, state) => const FeatureFlagsScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.bugReport,
        builder: (context, state) => const BugReportScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.toleranceDashboard,
        builder: (context, state) => FeatureGate(
          featureName: FeatureFlags.toleranceDashboardPage,
          child: const ToleranceDashboardPage(),
        ),
      ),
    ],
  );
}

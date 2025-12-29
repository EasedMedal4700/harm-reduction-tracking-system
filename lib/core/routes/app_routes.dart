// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Legacy route definitions.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_drug_use_app/features/reflection/reflection_provider.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/providers/daily_checkin_provider.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_page.dart';
import 'package:mobile_drug_use_app/features/analytics/analytics_page.dart';
import 'package:mobile_drug_use_app/features/catalog/catalog_page.dart';
import 'package:mobile_drug_use_app/features/craving/cravings_page.dart';
import 'package:mobile_drug_use_app/features/blood_levels/blood_levels_page.dart';
import 'package:mobile_drug_use_app/features/reflection/reflection_page.dart';
import 'package:mobile_drug_use_app/features/activity/activity_page.dart';
import 'package:mobile_drug_use_app/features/stockpile/stockpile_page.dart';
import 'package:mobile_drug_use_app/features/home/home_page.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/daily_checkin_page.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/checkin_history_page.dart';
import 'package:mobile_drug_use_app/features/profile/profile_screen.dart';
import 'package:mobile_drug_use_app/features/admin/screens/admin_panel_screen.dart';
import 'package:mobile_drug_use_app/features/settings/settings_page.dart';
import 'package:mobile_drug_use_app/features/tolerance/pages/tolerance_dashboard_page.dart';
import 'package:mobile_drug_use_app/features/physiological/physiological_page.dart';
import 'package:mobile_drug_use_app/features/interactions/interactions_page.dart';
import 'package:mobile_drug_use_app/features/wearOS/wearos_page.dart';
import 'package:mobile_drug_use_app/features/bug_report/bug_report_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/pin_setup_page.dart';
import 'package:mobile_drug_use_app/features/login/pin_unlock/pin_unlock_page.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/recovery_key_page.dart';
// import 'package:mobile_drug_use_app/legacy/encryption_migration_page.dart';
import 'package:mobile_drug_use_app/features/manage_profile/change_pin/change_pin_page.dart';

class AppRoutes {
  static Widget buildHomePage() => const HomePage();
  static Widget buildLogEntryPage() =>
      const QuickLogEntryPage(); // Change to QuickLogEntryPage
  static Widget buildAnalyticsPage() => const AnalyticsPage();
  static Widget buildCatalogPage() => const CatalogPage();
  static Widget buildCravingsPage() => const CravingsPage();
  static Widget buildBloodLevelsPage() => const BloodLevelsPage();
  static Widget buildLibraryPage() =>
      const PersonalLibraryPage(); // Add if implemented
  static Widget buildReflectionPage() => ChangeNotifierProvider(
    create: (_) => ReflectionProvider(),
    child: const ReflectionPage(),
  );
  static Widget buildActivityPage() =>
      const ActivityPage(); // Update to actual class name
  static Widget buildDailyCheckinPage() => ChangeNotifierProvider(
    create: (_) => DailyCheckinProvider(),
    child: const DailyCheckinScreen(),
  );
  static Widget buildCheckinHistoryPage() => ChangeNotifierProvider(
    create: (_) => DailyCheckinProvider(),
    child: const CheckinHistoryScreen(),
  );
  static Widget buildProfilePage() => const ProfileScreen();
  static Widget buildAdminPanelPage() => const AdminPanelScreen();
  // Add buildLibraryPage() if implemented
  static Widget buildSettingsPage() => const SettingsScreen();
  static Widget buildToleranceDashboardPage() => const ToleranceDashboardPage();
  static Widget buildPhysiologicalPage() => const PhysiologicalPage();
  static Widget buildInteractionsPage() => const InteractionsPage();
  static Widget buildWearOSPage() => const WearOSPage();
  static Widget buildBugReportPage() => const BugReportScreen();
  static Widget buildPinSetupPage() => const PinSetupScreen();
  static Widget buildPinUnlockPage() => const PinUnlockScreen();
  static Widget buildRecoveryKeyPage() => const RecoveryKeyScreen();
  // static Widget buildEncryptionMigrationPage() =>
  //     const EncryptionMigrationScreen();
  static Widget buildChangePinPage() => const ChangePinPage();
}

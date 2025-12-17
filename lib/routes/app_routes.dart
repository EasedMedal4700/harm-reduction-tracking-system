import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/reflection/reflection_provider.dart';
import '../providers/daily_checkin_provider.dart';
import '../features/log_entry/log_entry_page.dart'; // Add other imports as needed
import '../screens/analytics_page.dart';
import '../screens/catalog_page.dart';
import '../features/craving/cravings_page.dart';
import '../screens/blood_levels_page.dart';
import '../features/reflection/reflection_page.dart';
import '../features/activity/activity_page.dart';
import '../screens/personal_library_page.dart'; // Add LibraryPage import
import '../features/home/home_page_main.dart';
import '../screens/daily_checkin_page.dart';
import '../screens/checkin_history_page.dart';
import '../screens/profile_screen.dart';
import '../features/admin/screens/admin_panel_screen.dart';
import '../screens/settings_page.dart';
import '../screens/tolerance_dashboard_page.dart'; // Import ToleranceDashboardPage
import '../screens/physiological_page.dart';
import '../features/interactions/interactions_page.dart';
import '../features/wearOS/wearos_page.dart';
import '../features/bug_report/bug_report_page.dart';
import '../screens/pin_setup_page.dart';
import '../screens/pin_unlock_page.dart';
import '../screens/recovery_key_page.dart';
import '../screens/encryption_migration_page.dart';
import '../screens/change_pin_page.dart';

class AppRoutes {
  static Widget buildHomePage() => const HomePage();
  static Widget buildLogEntryPage() => const QuickLogEntryPage(); // Change to QuickLogEntryPage
  static Widget buildAnalyticsPage() => const AnalyticsPage();
  static Widget buildCatalogPage() => const CatalogPage();
  static Widget buildCravingsPage() => const CravingsPage();
  static Widget buildBloodLevelsPage() => const BloodLevelsPage();
  static Widget buildLibraryPage() => const PersonalLibraryPage(); // Add if implemented
  static Widget buildReflectionPage() => ChangeNotifierProvider(
    create: (_) => ReflectionProvider(),
    child: const ReflectionPage(),
  );
  static Widget buildActivityPage() => const ActivityPage(); // Update to actual class name
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
  static Widget buildEncryptionMigrationPage() => const EncryptionMigrationScreen();
  static Widget buildChangePinPage() => const ChangePinScreen();
}

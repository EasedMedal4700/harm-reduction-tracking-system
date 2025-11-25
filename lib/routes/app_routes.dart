import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reflection_provider.dart';
import '../providers/daily_checkin_provider.dart';
import '../screens/log_entry_page.dart'; // Add other imports as needed
import '../screens/analytics_page.dart';
import '../screens/catalog_page.dart';
import '../screens/cravings_page.dart';
import '../screens/blood_levels_page.dart';
import '../screens/reflection_page.dart';
import '../screens/activity_page.dart';
import '../screens/personal_library_page.dart'; // Add LibraryPage import
import '../screens/home_page.dart';
import '../screens/daily_checkin_screen.dart';
import '../screens/checkin_history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_panel_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tolerance_dashboard_page.dart'; // Import ToleranceDashboardPage
import '../screens/physiological_page.dart';
import '../screens/interactions_page.dart';
import '../screens/wearos_page.dart';
import '../screens/admin/bug_report_screen.dart';

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
}

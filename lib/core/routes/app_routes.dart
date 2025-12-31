// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Legacy route definitions.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/features/feature_pages.dart';
// import 'package:mobile_drug_use_app/legacy/encryption_migration_page.dart';

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
  static Widget buildReflectionPage() => const ReflectionPage();
  static Widget buildActivityPage() =>
      const ActivityPage(); // Update to actual class name
  static Widget buildDailyCheckinPage() => const DailyCheckinScreen();
  static Widget buildCheckinHistoryPage() => const CheckinHistoryScreen();
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reflection_provider.dart';
import '../screens/log_entry_page.dart'; // Add other imports as needed
import '../screens/analytics_page.dart';
import '../screens/catalog_page.dart';
import '../screens/cravings_page.dart';
import '../screens/blood_levels_page.dart';
import '../screens/reflection_page.dart';
import '../screens/activity_page.dart';
// Add other screens

class AppRoutes {
  static Widget buildLogEntryPage() => const QuickLogEntryPage(); // Change to QuickLogEntryPage
  static Widget buildAnalyticsPage() => const AnalyticsPage();
  static Widget buildCatalogPage() => const CatalogPage();
  static Widget buildCravingsPage() => const CravingsPage();
  static Widget buildBloodLevelsPage() => const BloodLevelsPage();
  static Widget buildReflectionPage() => ChangeNotifierProvider(
    create: (_) => ReflectionProvider(),
    child: const ReflectionPage(),
  );
  static Widget buildActivityPage() => const ActivityPage(); // Update to actual class name
  // Add buildLibraryPage() if implemented
}
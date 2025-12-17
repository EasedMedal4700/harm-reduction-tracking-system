
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

/// Mixin providing navigation methods for HomePage
mixin HomeNavigationMethods {
  void openLogEntry(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildLogEntryPage()));
  }
  
  void openAnalytics(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildAnalyticsPage()));
  }
  
  void openCatalog(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildCatalogPage()));
  }
  
  void openCravings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildCravingsPage()));
  }
  
  void openBloodLevels(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildBloodLevelsPage()));
  }
  
  void openReflection(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildReflectionPage()));
  }
  
  void openActivity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildActivityPage()));
  }
  
  void openLibrary(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildLibraryPage()));
  }
  
  void openToleranceDashboard(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildToleranceDashboardPage()));
  }
}

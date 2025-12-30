// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Legacy navigation helper; routes now centralized via NavigationService.
import 'package:mobile_drug_use_app/core/routes/app_router.dart'
    show AppRoutePaths;
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';

/// Mixin providing navigation methods for HomePage
mixin HomeNavigationMethods {
  void openLogEntry(NavigationService navigation) {
    navigation.push(AppRoutePaths.logEntry);
  }

  void openAnalytics(NavigationService navigation) {
    navigation.push(AppRoutePaths.analytics);
  }

  void openCatalog(NavigationService navigation) {
    navigation.push(AppRoutePaths.catalog);
  }

  void openCravings(NavigationService navigation) {
    navigation.push(AppRoutePaths.cravings);
  }

  void openBloodLevels(NavigationService navigation) {
    navigation.push(AppRoutePaths.bloodLevels);
  }

  void openReflection(NavigationService navigation) {
    navigation.push(AppRoutePaths.reflection);
  }

  void openActivity(NavigationService navigation) {
    navigation.push(AppRoutePaths.activity);
  }

  void openLibrary(NavigationService navigation) {
    navigation.push(AppRoutePaths.library);
  }

  void openToleranceDashboard(NavigationService navigation) {
    navigation.push(AppRoutePaths.toleranceDashboard);
  }
}

// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: String constants.
class AppStrings {
  const AppStrings._();
  static const String errorLoadingActivity = 'Failed to load activity: ';
  static const String entryDeletedSuccess = 'Entry deleted successfully';
  static const String errorDeletingEntry = 'Failed to delete entry: ';
  static const String errorLoadingAdminData = 'Error loading admin data';
  static const String userDemoted = 'User demoted from admin';
  static const String userPromoted = 'User promoted to admin';
  static const String errorToggleAdmin = 'Failed to toggle admin status';
  static const String cacheClearedSuccess =
      '\u2713 All cache cleared successfully';
  static const String errorClearingCache = 'Failed to clear cache';
  static const String drugCacheCleared = '\u2713 Drug profiles cache cleared';
  static const String errorClearingDrugCache = 'Failed to clear drug cache';
  static const String expiredCacheCleared =
      '\u2713 Expired cache entries cleared';
  static const String errorClearingExpiredCache =
      'Failed to clear expired cache';
  static const String errorRefreshingDatabase =
      'Failed to refresh from database';
  // Error Analytics
  static const String errorLoadingAnalytics = 'Error loading analytics data';
  static const String errorAnalyticsFilterRequired =
      'Add at least one filter or enable delete all.';
  static const String errorLogsCleaned = 'Error logs cleaned successfully';
  static const String errorCleaningLogs = 'Failed to clean error logs';
  static const String errorAnalyticsTitle = 'Error Analytics';
}

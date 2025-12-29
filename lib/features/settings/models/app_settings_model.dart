// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

/// Model for app settings stored locally
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // UI Settings
    @Default(false) bool darkMode,
    @Default(14.0) double fontSize,
    @Default(false) bool compactMode,
    @Default('en') String language,
    // Notification Settings
    @Default(true) bool notificationsEnabled,
    @Default(true) bool dailyCheckinReminder,
    @Default('09:00') String checkinReminderTime,
    @Default(true) bool medicationReminders,
    @Default(true) bool cravingAlerts,
    @Default(false) bool weeklyReports,
    // Privacy Settings
    @Default(false) bool biometricLock,
    @Default(false) bool requirePinOnOpen,
    @Default('5min')
    String autoLockDuration, // '1min', '5min', '15min', 'never'
    @Default(false) bool hideContentInRecents,
    @Default(false) bool analyticsEnabled,
    // Data Settings
    @Default(false) bool autoBackup,
    @Default('weekly') String backupFrequency, // 'daily', 'weekly', 'monthly'
    @Default(true) bool syncEnabled,
    @Default(false) bool offlineMode,
    @Default(true) bool cacheEnabled,
    @Default('1hour') String cacheDuration, // '1hour', '6hours', '1day'
    // Entry Settings
    @Default('mg') String defaultDoseUnit,
    @Default(false) bool quickEntryMode,
    @Default(true) bool autoSaveEntries,
    @Default(true) bool showRecentSubstances,
    @Default(5) int recentSubstancesCount,
    // Display Settings
    @Default(false) bool show24HourTime,
    @Default('MM/DD/YYYY')
    String dateFormat, // 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
    @Default(true) bool showBloodLevels,
    @Default(true) bool showAnalytics,
  }) = _AppSettings;

  /// Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

/// Model for app settings stored locally
class AppSettings {
  // UI Settings
  final bool darkMode;
  final double fontSize;
  final bool compactMode;
  final String language;
  // Notification Settings
  final bool notificationsEnabled;
  final bool dailyCheckinReminder;
  final String checkinReminderTime;
  final bool medicationReminders;
  final bool cravingAlerts;
  final bool weeklyReports;
  // Privacy Settings
  final bool biometricLock;
  final bool requirePinOnOpen;
  final String autoLockDuration; // '1min', '5min', '15min', 'never'
  final bool hideContentInRecents;
  final bool analyticsEnabled;
  // Data Settings
  final bool autoBackup;
  final String backupFrequency; // 'daily', 'weekly', 'monthly'
  final bool syncEnabled;
  final bool offlineMode;
  final bool cacheEnabled;
  final String cacheDuration; // '1hour', '6hours', '1day'
  // Entry Settings
  final String defaultDoseUnit;
  final bool quickEntryMode;
  final bool autoSaveEntries;
  final bool showRecentSubstances;
  final int recentSubstancesCount;
  // Display Settings
  final bool show24HourTime;
  final String dateFormat; // 'MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'
  final bool showBloodLevels;
  final bool showAnalytics;
  const AppSettings({
    // UI Settings
    this.darkMode = false,
    this.fontSize = 14.0,
    this.compactMode = false,
    this.language = 'en',
    // Notification Settings
    this.notificationsEnabled = true,
    this.dailyCheckinReminder = true,
    this.checkinReminderTime = '09:00',
    this.medicationReminders = true,
    this.cravingAlerts = true,
    this.weeklyReports = false,
    // Privacy Settings
    this.biometricLock = false,
    this.requirePinOnOpen = false,
    this.autoLockDuration = '5min',
    this.hideContentInRecents = false,
    this.analyticsEnabled = false,
    // Data Settings
    this.autoBackup = false,
    this.backupFrequency = 'weekly',
    this.syncEnabled = true,
    this.offlineMode = false,
    this.cacheEnabled = true,
    this.cacheDuration = '1hour',
    // Entry Settings
    this.defaultDoseUnit = 'mg',
    this.quickEntryMode = false,
    this.autoSaveEntries = true,
    this.showRecentSubstances = true,
    this.recentSubstancesCount = 5,
    // Display Settings
    this.show24HourTime = false,
    this.dateFormat = 'MM/DD/YYYY',
    this.showBloodLevels = true,
    this.showAnalytics = true,
  });

  /// Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      // UI Settings
      darkMode: json['darkMode'] as bool? ?? false,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      compactMode: json['compactMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      // Notification Settings
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyCheckinReminder: json['dailyCheckinReminder'] as bool? ?? true,
      checkinReminderTime: json['checkinReminderTime'] as String? ?? '09:00',
      medicationReminders: json['medicationReminders'] as bool? ?? true,
      cravingAlerts: json['cravingAlerts'] as bool? ?? true,
      weeklyReports: json['weeklyReports'] as bool? ?? false,
      // Privacy Settings
      biometricLock: json['biometricLock'] as bool? ?? false,
      requirePinOnOpen: json['requirePinOnOpen'] as bool? ?? false,
      autoLockDuration: json['autoLockDuration'] as String? ?? '5min',
      hideContentInRecents: json['hideContentInRecents'] as bool? ?? false,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
      // Data Settings
      autoBackup: json['autoBackup'] as bool? ?? false,
      backupFrequency: json['backupFrequency'] as String? ?? 'weekly',
      syncEnabled: json['syncEnabled'] as bool? ?? true,
      offlineMode: json['offlineMode'] as bool? ?? false,
      cacheEnabled: json['cacheEnabled'] as bool? ?? true,
      cacheDuration: json['cacheDuration'] as String? ?? '1hour',
      // Entry Settings
      defaultDoseUnit: json['defaultDoseUnit'] as String? ?? 'mg',
      quickEntryMode: json['quickEntryMode'] as bool? ?? false,
      autoSaveEntries: json['autoSaveEntries'] as bool? ?? true,
      showRecentSubstances: json['showRecentSubstances'] as bool? ?? true,
      recentSubstancesCount: json['recentSubstancesCount'] as int? ?? 5,
      // Display Settings
      show24HourTime: json['show24HourTime'] as bool? ?? false,
      dateFormat: json['dateFormat'] as String? ?? 'MM/DD/YYYY',
      showBloodLevels: json['showBloodLevels'] as bool? ?? true,
      showAnalytics: json['showAnalytics'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      // UI Settings
      'darkMode': darkMode,
      'fontSize': fontSize,
      'compactMode': compactMode,
      'language': language,
      // Notification Settings
      'notificationsEnabled': notificationsEnabled,
      'dailyCheckinReminder': dailyCheckinReminder,
      'checkinReminderTime': checkinReminderTime,
      'medicationReminders': medicationReminders,
      'cravingAlerts': cravingAlerts,
      'weeklyReports': weeklyReports,
      // Privacy Settings
      'biometricLock': biometricLock,
      'requirePinOnOpen': requirePinOnOpen,
      'autoLockDuration': autoLockDuration,
      'hideContentInRecents': hideContentInRecents,
      'analyticsEnabled': analyticsEnabled,
      // Data Settings
      'autoBackup': autoBackup,
      'backupFrequency': backupFrequency,
      'syncEnabled': syncEnabled,
      'offlineMode': offlineMode,
      'cacheEnabled': cacheEnabled,
      'cacheDuration': cacheDuration,
      // Entry Settings
      'defaultDoseUnit': defaultDoseUnit,
      'quickEntryMode': quickEntryMode,
      'autoSaveEntries': autoSaveEntries,
      'showRecentSubstances': showRecentSubstances,
      'recentSubstancesCount': recentSubstancesCount,
      // Display Settings
      'show24HourTime': show24HourTime,
      'dateFormat': dateFormat,
      'showBloodLevels': showBloodLevels,
      'showAnalytics': showAnalytics,
    };
  }

  /// Create a copy with updated values
  AppSettings copyWith({
    bool? darkMode,
    double? fontSize,
    bool? compactMode,
    String? language,
    bool? notificationsEnabled,
    bool? dailyCheckinReminder,
    String? checkinReminderTime,
    bool? medicationReminders,
    bool? cravingAlerts,
    bool? weeklyReports,
    bool? biometricLock,
    bool? requirePinOnOpen,
    String? autoLockDuration,
    bool? hideContentInRecents,
    bool? analyticsEnabled,
    bool? autoBackup,
    String? backupFrequency,
    bool? syncEnabled,
    bool? offlineMode,
    bool? cacheEnabled,
    String? cacheDuration,
    String? defaultDoseUnit,
    bool? quickEntryMode,
    bool? autoSaveEntries,
    bool? showRecentSubstances,
    int? recentSubstancesCount,
    bool? show24HourTime,
    String? dateFormat,
    bool? showBloodLevels,
    bool? showAnalytics,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      fontSize: fontSize ?? this.fontSize,
      compactMode: compactMode ?? this.compactMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyCheckinReminder: dailyCheckinReminder ?? this.dailyCheckinReminder,
      checkinReminderTime: checkinReminderTime ?? this.checkinReminderTime,
      medicationReminders: medicationReminders ?? this.medicationReminders,
      cravingAlerts: cravingAlerts ?? this.cravingAlerts,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      biometricLock: biometricLock ?? this.biometricLock,
      requirePinOnOpen: requirePinOnOpen ?? this.requirePinOnOpen,
      autoLockDuration: autoLockDuration ?? this.autoLockDuration,
      hideContentInRecents: hideContentInRecents ?? this.hideContentInRecents,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      offlineMode: offlineMode ?? this.offlineMode,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
      cacheDuration: cacheDuration ?? this.cacheDuration,
      defaultDoseUnit: defaultDoseUnit ?? this.defaultDoseUnit,
      quickEntryMode: quickEntryMode ?? this.quickEntryMode,
      autoSaveEntries: autoSaveEntries ?? this.autoSaveEntries,
      showRecentSubstances: showRecentSubstances ?? this.showRecentSubstances,
      recentSubstancesCount:
          recentSubstancesCount ?? this.recentSubstancesCount,
      show24HourTime: show24HourTime ?? this.show24HourTime,
      dateFormat: dateFormat ?? this.dateFormat,
      showBloodLevels: showBloodLevels ?? this.showBloodLevels,
      showAnalytics: showAnalytics ?? this.showAnalytics,
    );
  }
}

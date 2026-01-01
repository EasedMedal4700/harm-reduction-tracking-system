// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  darkMode: json['darkMode'] as bool? ?? false,
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
  compactMode: json['compactMode'] as bool? ?? false,
  language: json['language'] as String? ?? 'en',
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  dailyCheckinReminder: json['dailyCheckinReminder'] as bool? ?? true,
  checkinReminderTime: json['checkinReminderTime'] as String? ?? '09:00',
  medicationReminders: json['medicationReminders'] as bool? ?? true,
  cravingAlerts: json['cravingAlerts'] as bool? ?? true,
  weeklyReports: json['weeklyReports'] as bool? ?? false,
  biometricLock: json['biometricLock'] as bool? ?? false,
  requirePinOnOpen: json['requirePinOnOpen'] as bool? ?? false,
  autoLockDuration: json['autoLockDuration'] as String? ?? '5min',
  hideContentInRecents: json['hideContentInRecents'] as bool? ?? false,
  analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
  autoBackup: json['autoBackup'] as bool? ?? false,
  backupFrequency: json['backupFrequency'] as String? ?? 'weekly',
  syncEnabled: json['syncEnabled'] as bool? ?? true,
  offlineMode: json['offlineMode'] as bool? ?? false,
  cacheEnabled: json['cacheEnabled'] as bool? ?? true,
  cacheDuration: json['cacheDuration'] as String? ?? '1hour',
  defaultDoseUnit: json['defaultDoseUnit'] as String? ?? 'mg',
  quickEntryMode: json['quickEntryMode'] as bool? ?? false,
  autoSaveEntries: json['autoSaveEntries'] as bool? ?? true,
  showRecentSubstances: json['showRecentSubstances'] as bool? ?? true,
  recentSubstancesCount: (json['recentSubstancesCount'] as num?)?.toInt() ?? 5,
  show24HourTime: json['show24HourTime'] as bool? ?? false,
  dateFormat: json['dateFormat'] as String? ?? 'MM/DD/YYYY',
  showBloodLevels: json['showBloodLevels'] as bool? ?? true,
  showAnalytics: json['showAnalytics'] as bool? ?? true,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'darkMode': instance.darkMode,
      'fontSize': instance.fontSize,
      'compactMode': instance.compactMode,
      'language': instance.language,
      'notificationsEnabled': instance.notificationsEnabled,
      'dailyCheckinReminder': instance.dailyCheckinReminder,
      'checkinReminderTime': instance.checkinReminderTime,
      'medicationReminders': instance.medicationReminders,
      'cravingAlerts': instance.cravingAlerts,
      'weeklyReports': instance.weeklyReports,
      'biometricLock': instance.biometricLock,
      'requirePinOnOpen': instance.requirePinOnOpen,
      'autoLockDuration': instance.autoLockDuration,
      'hideContentInRecents': instance.hideContentInRecents,
      'analyticsEnabled': instance.analyticsEnabled,
      'autoBackup': instance.autoBackup,
      'backupFrequency': instance.backupFrequency,
      'syncEnabled': instance.syncEnabled,
      'offlineMode': instance.offlineMode,
      'cacheEnabled': instance.cacheEnabled,
      'cacheDuration': instance.cacheDuration,
      'defaultDoseUnit': instance.defaultDoseUnit,
      'quickEntryMode': instance.quickEntryMode,
      'autoSaveEntries': instance.autoSaveEntries,
      'showRecentSubstances': instance.showRecentSubstances,
      'recentSubstancesCount': instance.recentSubstancesCount,
      'show24HourTime': instance.show24HourTime,
      'dateFormat': instance.dateFormat,
      'showBloodLevels': instance.showBloodLevels,
      'showAnalytics': instance.showAnalytics,
    };

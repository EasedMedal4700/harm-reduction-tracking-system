import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/app_settings_model.dart';
import '../features/settings/services/settings_service.dart';

/// Provider for managing app settings state
class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;
  StreamSubscription<AppSettings>? _settingsSub;
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  SettingsProvider() {
    _loadSettings();
    _settingsSub = SettingsService.settingsChanged.listen((newSettings) {
      _settings = newSettings;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _settingsSub?.cancel();
    _settingsSub = null;
    super.dispose();
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    try {
      _isLoading = true;
      notifyListeners();
      _settings = await SettingsService.loadSettings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update settings
  Future<void> updateSettings(AppSettings newSettings) async {
    await SettingsService.saveSettings(newSettings);
    _settings = newSettings;
    notifyListeners();
  }

  /// Update a specific setting
  Future<void> updateSetting(AppSettings Function(AppSettings) updater) async {
    final newSettings = updater(_settings);
    await updateSettings(newSettings);
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    await SettingsService.resetSettings();
    _settings = const AppSettings();
    notifyListeners();
  }

  /// UI Settings
  Future<void> setDarkMode(bool enabled) async {
    await updateSetting((s) => s.copyWith(darkMode: enabled));
  }

  Future<void> setFontSize(double size) async {
    await updateSetting((s) => s.copyWith(fontSize: size));
  }

  Future<void> setCompactMode(bool enabled) async {
    await updateSetting((s) => s.copyWith(compactMode: enabled));
  }

  Future<void> setLanguage(String language) async {
    await updateSetting((s) => s.copyWith(language: language));
  }

  /// Notification Settings
  Future<void> setNotificationsEnabled(bool enabled) async {
    await updateSetting((s) => s.copyWith(notificationsEnabled: enabled));
  }

  Future<void> setDailyCheckinReminder(bool enabled) async {
    await updateSetting((s) => s.copyWith(dailyCheckinReminder: enabled));
  }

  Future<void> setCheckinReminderTime(String time) async {
    await updateSetting((s) => s.copyWith(checkinReminderTime: time));
  }

  Future<void> setMedicationReminders(bool enabled) async {
    await updateSetting((s) => s.copyWith(medicationReminders: enabled));
  }

  Future<void> setCravingAlerts(bool enabled) async {
    await updateSetting((s) => s.copyWith(cravingAlerts: enabled));
  }

  Future<void> setWeeklyReports(bool enabled) async {
    await updateSetting((s) => s.copyWith(weeklyReports: enabled));
  }

  /// Privacy Settings
  Future<void> setBiometricLock(bool enabled) async {
    await updateSetting((s) => s.copyWith(biometricLock: enabled));
  }

  Future<void> setRequirePinOnOpen(bool enabled) async {
    await updateSetting((s) => s.copyWith(requirePinOnOpen: enabled));
  }

  Future<void> setAutoLockDuration(String duration) async {
    await updateSetting((s) => s.copyWith(autoLockDuration: duration));
  }

  Future<void> setHideContentInRecents(bool enabled) async {
    await updateSetting((s) => s.copyWith(hideContentInRecents: enabled));
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    await updateSetting((s) => s.copyWith(analyticsEnabled: enabled));
  }

  /// Data Settings
  Future<void> setAutoBackup(bool enabled) async {
    await updateSetting((s) => s.copyWith(autoBackup: enabled));
  }

  Future<void> setBackupFrequency(String frequency) async {
    await updateSetting((s) => s.copyWith(backupFrequency: frequency));
  }

  Future<void> setSyncEnabled(bool enabled) async {
    await updateSetting((s) => s.copyWith(syncEnabled: enabled));
  }

  Future<void> setOfflineMode(bool enabled) async {
    await updateSetting((s) => s.copyWith(offlineMode: enabled));
  }

  Future<void> setCacheEnabled(bool enabled) async {
    await updateSetting((s) => s.copyWith(cacheEnabled: enabled));
  }

  Future<void> setCacheDuration(String duration) async {
    await updateSetting((s) => s.copyWith(cacheDuration: duration));
  }

  /// Entry Settings
  Future<void> setDefaultDoseUnit(String unit) async {
    await updateSetting((s) => s.copyWith(defaultDoseUnit: unit));
  }

  Future<void> setQuickEntryMode(bool enabled) async {
    await updateSetting((s) => s.copyWith(quickEntryMode: enabled));
  }

  Future<void> setAutoSaveEntries(bool enabled) async {
    await updateSetting((s) => s.copyWith(autoSaveEntries: enabled));
  }

  Future<void> setShowRecentSubstances(bool enabled) async {
    await updateSetting((s) => s.copyWith(showRecentSubstances: enabled));
  }

  Future<void> setRecentSubstancesCount(int count) async {
    await updateSetting((s) => s.copyWith(recentSubstancesCount: count));
  }

  /// Display Settings
  Future<void> setShow24HourTime(bool enabled) async {
    await updateSetting((s) => s.copyWith(show24HourTime: enabled));
  }

  Future<void> setDateFormat(String format) async {
    await updateSetting((s) => s.copyWith(dateFormat: format));
  }

  Future<void> setShowBloodLevels(bool enabled) async {
    await updateSetting((s) => s.copyWith(showBloodLevels: enabled));
  }

  Future<void> setShowAnalytics(bool enabled) async {
    await updateSetting((s) => s.copyWith(showAnalytics: enabled));
  }
}

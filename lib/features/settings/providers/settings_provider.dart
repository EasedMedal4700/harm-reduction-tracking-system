// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Riverpod Notifier for settings.
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/app_settings_model.dart';
import '../services/settings_service.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async {
    final stream = SettingsService.settingsChanged;
    final sub = stream.listen((newSettings) {
      state = AsyncData(newSettings);
    });
    ref.onDispose(sub.cancel);

    return SettingsService.loadSettings();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await SettingsService.saveSettings(newSettings);
      return newSettings;
    });
  }

  Future<void> updateSetting(AppSettings Function(AppSettings) updater) async {
    final current = state.value;
    if (current == null) return;
    final newSettings = updater(current);
    await updateSettings(newSettings);
  }

  Future<void> resetToDefaults() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await SettingsService.resetSettings();
      return const AppSettings();
    });
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

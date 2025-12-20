import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/providers/settings_provider.dart';
import 'package:mobile_drug_use_app/services/settings_service.dart';
import 'package:mobile_drug_use_app/models/app_settings_model.dart';

void main() {
  late SettingsProvider provider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SettingsService.clearCache();
    provider = SettingsProvider();
  });

  group('SettingsProvider', () {
    test('initializes with default settings', () async {
      // Wait for initialization
      await Future.delayed(Duration.zero);
      
      expect(provider.isLoading, false);
      expect(provider.settings, isA<AppSettings>());
      expect(provider.settings.darkMode, false);
    });

    test('loads settings from storage', () async {
      final prefs = await SharedPreferences.getInstance();
      final settings = const AppSettings(darkMode: true);
      // We need to save it using the service or manually to prefs
      // Since SettingsService uses a specific key, let's use SettingsService to save first
      // But we need to clear cache first to ensure provider loads from prefs
      SettingsService.clearCache();
      await SettingsService.saveSettings(settings);
      SettingsService.clearCache(); // Clear again so provider fetches from prefs

      provider = SettingsProvider();
      // Wait for async init in constructor
      await Future.delayed(Duration(milliseconds: 50));

      expect(provider.settings.darkMode, true);
    });

    test('updateSettings updates state and storage', () async {
      await Future.delayed(Duration.zero);
      
      final newSettings = provider.settings.copyWith(darkMode: true);
      await provider.updateSettings(newSettings);

      expect(provider.settings.darkMode, true);
      
      // Verify storage
      final stored = await SettingsService.loadSettings();
      expect(stored.darkMode, true);
    });

    test('resetToDefaults resets state and storage', () async {
      await Future.delayed(Duration.zero);
      
      await provider.setDarkMode(true);
      expect(provider.settings.darkMode, true);

      await provider.resetToDefaults();
      expect(provider.settings.darkMode, false);
      
      final stored = await SettingsService.loadSettings();
      expect(stored.darkMode, false);
    });

    group('UI Settings', () {
      test('setDarkMode updates setting', () async {
        await provider.setDarkMode(true);
        expect(provider.settings.darkMode, true);
      });

      test('setFontSize updates setting', () async {
        await provider.setFontSize(18.0);
        expect(provider.settings.fontSize, 18.0);
      });

      test('setCompactMode updates setting', () async {
        await provider.setCompactMode(true);
        expect(provider.settings.compactMode, true);
      });

      test('setLanguage updates setting', () async {
        await provider.setLanguage('es');
        expect(provider.settings.language, 'es');
      });
    });

    group('Notification Settings', () {
      test('setNotificationsEnabled updates setting', () async {
        await provider.setNotificationsEnabled(false);
        expect(provider.settings.notificationsEnabled, false);
      });

      test('setDailyCheckinReminder updates setting', () async {
        await provider.setDailyCheckinReminder(false);
        expect(provider.settings.dailyCheckinReminder, false);
      });

      test('setCheckinReminderTime updates setting', () async {
        await provider.setCheckinReminderTime('10:00');
        expect(provider.settings.checkinReminderTime, '10:00');
      });

      test('setMedicationReminders updates setting', () async {
        await provider.setMedicationReminders(false);
        expect(provider.settings.medicationReminders, false);
      });

      test('setCravingAlerts updates setting', () async {
        await provider.setCravingAlerts(false);
        expect(provider.settings.cravingAlerts, false);
      });

      test('setWeeklyReports updates setting', () async {
        await provider.setWeeklyReports(true);
        expect(provider.settings.weeklyReports, true);
      });
    });

    group('Privacy Settings', () {
      test('setBiometricLock updates setting', () async {
        await provider.setBiometricLock(true);
        expect(provider.settings.biometricLock, true);
      });

      test('setRequirePinOnOpen updates setting', () async {
        await provider.setRequirePinOnOpen(true);
        expect(provider.settings.requirePinOnOpen, true);
      });

      test('setAutoLockDuration updates setting', () async {
        await provider.setAutoLockDuration('15min');
        expect(provider.settings.autoLockDuration, '15min');
      });

      test('setHideContentInRecents updates setting', () async {
        await provider.setHideContentInRecents(true);
        expect(provider.settings.hideContentInRecents, true);
      });

      test('setAnalyticsEnabled updates setting', () async {
        await provider.setAnalyticsEnabled(true);
        expect(provider.settings.analyticsEnabled, true);
      });
    });

    group('Data Settings', () {
      test('setAutoBackup updates setting', () async {
        await provider.setAutoBackup(true);
        expect(provider.settings.autoBackup, true);
      });

      test('setBackupFrequency updates setting', () async {
        await provider.setBackupFrequency('daily');
        expect(provider.settings.backupFrequency, 'daily');
      });

      test('setSyncEnabled updates setting', () async {
        await provider.setSyncEnabled(false);
        expect(provider.settings.syncEnabled, false);
      });

      test('setOfflineMode updates setting', () async {
        await provider.setOfflineMode(true);
        expect(provider.settings.offlineMode, true);
      });

      test('setCacheEnabled updates setting', () async {
        await provider.setCacheEnabled(false);
        expect(provider.settings.cacheEnabled, false);
      });

      test('setCacheDuration updates setting', () async {
        await provider.setCacheDuration('6hours');
        expect(provider.settings.cacheDuration, '6hours');
      });
    });

    group('Entry Settings', () {
      test('setDefaultDoseUnit updates setting', () async {
        await provider.setDefaultDoseUnit('g');
        expect(provider.settings.defaultDoseUnit, 'g');
      });

      test('setQuickEntryMode updates setting', () async {
        await provider.setQuickEntryMode(true);
        expect(provider.settings.quickEntryMode, true);
      });

      test('setAutoSaveEntries updates setting', () async {
        await provider.setAutoSaveEntries(false);
        expect(provider.settings.autoSaveEntries, false);
      });

      test('setShowRecentSubstances updates setting', () async {
        await provider.setShowRecentSubstances(false);
        expect(provider.settings.showRecentSubstances, false);
      });

      test('setRecentSubstancesCount updates setting', () async {
        await provider.setRecentSubstancesCount(10);
        expect(provider.settings.recentSubstancesCount, 10);
      });
    });

    group('Display Settings', () {
      test('setShow24HourTime updates setting', () async {
        await provider.setShow24HourTime(true);
        expect(provider.settings.show24HourTime, true);
      });

      test('setDateFormat updates setting', () async {
        await provider.setDateFormat('YYYY-MM-DD');
        expect(provider.settings.dateFormat, 'YYYY-MM-DD');
      });

      test('setShowBloodLevels updates setting', () async {
        await provider.setShowBloodLevels(false);
        expect(provider.settings.showBloodLevels, false);
      });

      test('setShowAnalytics updates setting', () async {
        await provider.setShowAnalytics(false);
        expect(provider.settings.showAnalytics, false);
      });
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/features/settings/providers/settings_provider.dart';
import 'package:mobile_drug_use_app/features/settings/services/settings_service.dart';
import 'package:mobile_drug_use_app/features/settings/models/app_settings_model.dart';

void main() {
  late ProviderContainer container;
  late SettingsController controller;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SettingsService.clearCache();
    container = ProviderContainer();
    // Initialize provider
    container.read(settingsControllerProvider);
    controller = container.read(settingsControllerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsController', () {
    test('initializes with default settings', () async {
      final settings = await container.read(settingsControllerProvider.future);
      expect(settings, isA<AppSettings>());
      expect(settings.darkMode, false);
    });

    test('loads settings from storage', () async {
      final settings = const AppSettings(darkMode: true);
      SettingsService.clearCache();
      await SettingsService.saveSettings(settings);
      SettingsService.clearCache();

      container.dispose();
      container = ProviderContainer();

      final loadedSettings = await container.read(
        settingsControllerProvider.future,
      );
      expect(loadedSettings.darkMode, true);
    });

    test('updateSettings updates state and storage', () async {
      await container.read(settingsControllerProvider.future);

      final current = await container.read(settingsControllerProvider.future);
      final newSettings = current.copyWith(darkMode: true);
      await controller.updateSettings(newSettings);

      final state = await container.read(settingsControllerProvider.future);
      expect(state.darkMode, true);

      final stored = await SettingsService.loadSettings();
      expect(stored.darkMode, true);
    });

    test('resetToDefaults resets state and storage', () async {
      await container.read(settingsControllerProvider.future);

      await controller.setDarkMode(true);
      expect(
        (await container.read(settingsControllerProvider.future)).darkMode,
        true,
      );

      await controller.resetToDefaults();
      expect(
        (await container.read(settingsControllerProvider.future)).darkMode,
        false,
      );

      final stored = await SettingsService.loadSettings();
      expect(stored.darkMode, false);
    });

    group('UI Settings', () {
      test('setDarkMode updates setting', () async {
        await controller.setDarkMode(true);
        expect(
          (await container.read(settingsControllerProvider.future)).darkMode,
          true,
        );
      });

      test('setFontSize updates setting', () async {
        await controller.setFontSize(18.0);
        expect(
          (await container.read(settingsControllerProvider.future)).fontSize,
          18.0,
        );
      });

      test('setCompactMode updates setting', () async {
        await controller.setCompactMode(true);
        expect(
          (await container.read(settingsControllerProvider.future)).compactMode,
          true,
        );
      });

      test('setLanguage updates setting', () async {
        await controller.setLanguage('es');
        expect(
          (await container.read(settingsControllerProvider.future)).language,
          'es',
        );
      });
    });

    group('Notification Settings', () {
      test('setNotificationsEnabled updates setting', () async {
        await controller.setNotificationsEnabled(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).notificationsEnabled,
          false,
        );
      });

      test('setDailyCheckinReminder updates setting', () async {
        await controller.setDailyCheckinReminder(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).dailyCheckinReminder,
          false,
        );
      });

      test('setCheckinReminderTime updates setting', () async {
        await controller.setCheckinReminderTime('10:00');
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).checkinReminderTime,
          '10:00',
        );
      });

      test('setMedicationReminders updates setting', () async {
        await controller.setMedicationReminders(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).medicationReminders,
          false,
        );
      });

      test('setCravingAlerts updates setting', () async {
        await controller.setCravingAlerts(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).cravingAlerts,
          false,
        );
      });

      test('setWeeklyReports updates setting', () async {
        await controller.setWeeklyReports(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).weeklyReports,
          true,
        );
      });
    });

    group('Privacy Settings', () {
      test('setBiometricLock updates setting', () async {
        await controller.setBiometricLock(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).biometricLock,
          true,
        );
      });

      test('setRequirePinOnOpen updates setting', () async {
        await controller.setRequirePinOnOpen(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).requirePinOnOpen,
          true,
        );
      });

      test('setAutoLockDuration updates setting', () async {
        await controller.setAutoLockDuration('15min');
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).autoLockDuration,
          '15min',
        );
      });

      test('setHideContentInRecents updates setting', () async {
        await controller.setHideContentInRecents(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).hideContentInRecents,
          true,
        );
      });

      test('setAnalyticsEnabled updates setting', () async {
        await controller.setAnalyticsEnabled(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).analyticsEnabled,
          true,
        );
      });
    });

    group('Data Settings', () {
      test('setAutoBackup updates setting', () async {
        await controller.setAutoBackup(true);
        expect(
          (await container.read(settingsControllerProvider.future)).autoBackup,
          true,
        );
      });

      test('setBackupFrequency updates setting', () async {
        await controller.setBackupFrequency('daily');
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).backupFrequency,
          'daily',
        );
      });

      test('setSyncEnabled updates setting', () async {
        await controller.setSyncEnabled(false);
        expect(
          (await container.read(settingsControllerProvider.future)).syncEnabled,
          false,
        );
      });

      test('setOfflineMode updates setting', () async {
        await controller.setOfflineMode(true);
        expect(
          (await container.read(settingsControllerProvider.future)).offlineMode,
          true,
        );
      });

      test('setCacheEnabled updates setting', () async {
        await controller.setCacheEnabled(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).cacheEnabled,
          false,
        );
      });

      test('setCacheDuration updates setting', () async {
        await controller.setCacheDuration('6hours');
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).cacheDuration,
          '6hours',
        );
      });
    });

    group('Entry Settings', () {
      test('setDefaultDoseUnit updates setting', () async {
        await controller.setDefaultDoseUnit('g');
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).defaultDoseUnit,
          'g',
        );
      });

      test('setQuickEntryMode updates setting', () async {
        await controller.setQuickEntryMode(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).quickEntryMode,
          true,
        );
      });

      test('setAutoSaveEntries updates setting', () async {
        await controller.setAutoSaveEntries(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).autoSaveEntries,
          false,
        );
      });

      test('setShowRecentSubstances updates setting', () async {
        await controller.setShowRecentSubstances(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).showRecentSubstances,
          false,
        );
      });

      test('setRecentSubstancesCount updates setting', () async {
        await controller.setRecentSubstancesCount(10);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).recentSubstancesCount,
          10,
        );
      });
    });

    group('Display Settings', () {
      test('setShow24HourTime updates setting', () async {
        await controller.setShow24HourTime(true);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).show24HourTime,
          true,
        );
      });

      test('setDateFormat updates setting', () async {
        await controller.setDateFormat('YYYY-MM-DD');
        expect(
          (await container.read(settingsControllerProvider.future)).dateFormat,
          'YYYY-MM-DD',
        );
      });

      test('setShowBloodLevels updates setting', () async {
        await controller.setShowBloodLevels(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).showBloodLevels,
          false,
        );
      });

      test('setShowAnalytics updates setting', () async {
        await controller.setShowAnalytics(false);
        expect(
          (await container.read(
            settingsControllerProvider.future,
          )).showAnalytics,
          false,
        );
      });
    });
  });
}

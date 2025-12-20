import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/app_settings_model.dart';

void main() {
  group('AppSettings', () {
    group('Constructor', () {
      test('initializes with correct defaults', () {
        const settings = AppSettings();

        // UI Settings
        expect(settings.darkMode, false);
        expect(settings.fontSize, 14.0);
        expect(settings.compactMode, false);
        expect(settings.language, 'en');

        // Notification Settings
        expect(settings.notificationsEnabled, true);
        expect(settings.dailyCheckinReminder, true);
        expect(settings.checkinReminderTime, '09:00');
        expect(settings.medicationReminders, true);
        expect(settings.cravingAlerts, true);
        expect(settings.weeklyReports, false);

        // Privacy Settings
        expect(settings.biometricLock, false);
        expect(settings.requirePinOnOpen, false);
        expect(settings.autoLockDuration, '5min');
        expect(settings.hideContentInRecents, false);
        expect(settings.analyticsEnabled, false);

        // Data Settings
        expect(settings.autoBackup, false);
        expect(settings.backupFrequency, 'weekly');
        expect(settings.syncEnabled, true);
        expect(settings.offlineMode, false);
        expect(settings.cacheEnabled, true);
        expect(settings.cacheDuration, '1hour');

        // Entry Settings
        expect(settings.defaultDoseUnit, 'mg');
        expect(settings.quickEntryMode, false);
        expect(settings.autoSaveEntries, true);
        expect(settings.showRecentSubstances, true);
        expect(settings.recentSubstancesCount, 5);

        // Display Settings
        expect(settings.show24HourTime, false);
        expect(settings.dateFormat, 'MM/DD/YYYY');
        expect(settings.showBloodLevels, true);
        expect(settings.showAnalytics, true);
      });

      test('allows overriding defaults', () {
        const settings = AppSettings(
          darkMode: true,
          fontSize: 16.0,
          language: 'es',
        );

        expect(settings.darkMode, true);
        expect(settings.fontSize, 16.0);
        expect(settings.language, 'es');
        // Check a default wasn't changed
        expect(settings.compactMode, false);
      });
    });

    group('JSON Serialization', () {
      test('toJson includes all fields', () {
        const settings = AppSettings(
          darkMode: true,
          fontSize: 18.0,
          language: 'fr',
          notificationsEnabled: false,
        );

        final json = settings.toJson();

        expect(json['darkMode'], true);
        expect(json['fontSize'], 18.0);
        expect(json['language'], 'fr');
        expect(json['notificationsEnabled'], false);
        expect(json['compactMode'], false); // Default
      });

      test('fromJson reconstructs object correctly', () {
        final json = {
          'darkMode': true,
          'fontSize': 20.0,
          'language': 'de',
          'notificationsEnabled': false,
          'compactMode': true,
        };

        final settings = AppSettings.fromJson(json);

        expect(settings.darkMode, true);
        expect(settings.fontSize, 20.0);
        expect(settings.language, 'de');
        expect(settings.notificationsEnabled, false);
        expect(settings.compactMode, true);
      });

      test('fromJson handles missing fields by using defaults', () {
        final json = <String, dynamic>{};
        final settings = AppSettings.fromJson(json);

        expect(settings.darkMode, false);
        expect(settings.fontSize, 14.0);
        expect(settings.language, 'en');
      });

      test('fromJson handles null values by using defaults', () {
        final json = {'darkMode': null, 'fontSize': null};
        final settings = AppSettings.fromJson(json);

        expect(settings.darkMode, false);
        expect(settings.fontSize, 14.0);
      });

      test('fromJson handles numeric type conversions', () {
        final json = {
          'fontSize': 16, // int instead of double
        };
        final settings = AppSettings.fromJson(json);

        expect(settings.fontSize, 16.0);
      });
    });

    group('CopyWith', () {
      test('creates copy with updated fields', () {
        const settings = AppSettings(darkMode: false, fontSize: 14.0);

        final updated = settings.copyWith(darkMode: true, fontSize: 16.0);

        expect(updated.darkMode, true);
        expect(updated.fontSize, 16.0);
        // Check other fields remain same
        expect(updated.language, 'en');
      });

      test('creates copy with no changes if no arguments provided', () {
        const settings = AppSettings(darkMode: true);

        final updated = settings.copyWith();

        expect(updated.darkMode, true);
        expect(updated.fontSize, 14.0);
      });

      test('preserves values when other fields are updated', () {
        const settings = AppSettings(darkMode: true, fontSize: 18.0);

        final updated = settings.copyWith(language: 'es');

        expect(updated.darkMode, true);
        expect(updated.fontSize, 18.0);
        expect(updated.language, 'es');
      });
    });
  });
}

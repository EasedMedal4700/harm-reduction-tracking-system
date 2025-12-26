// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Settings dialogs.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../providers/settings_provider.dart';

class SettingsDialogs {
  static void showLanguagePicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Portuguese'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                provider.setLanguage(lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static Future<void> showTimePickerDialog(
    BuildContext context,
    SettingsProvider provider,
    String currentTime,
  ) async {
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      await provider.setCheckinReminderTime(timeString);
    }
  }

  static void showAutoLockPicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final durations = ['1min', '5min', '15min', '30min', 'never'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-lock Duration'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: durations.map((duration) {
            return ListTile(
              title: Text(duration),
              onTap: () {
                provider.setAutoLockDuration(duration);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showBackupFrequencyPicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final frequencies = ['daily', 'weekly', 'monthly'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Frequency'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: frequencies.map((freq) {
            return ListTile(
              title: Text(freq[0].toUpperCase() + freq.substring(1)),
              onTap: () {
                provider.setBackupFrequency(freq);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showCacheDurationPicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final durations = ['15min', '30min', '1hour', '6hours', '1day'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Duration'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: durations.map((duration) {
            return ListTile(
              title: Text(duration),
              onTap: () {
                provider.setCacheDuration(duration);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showDoseUnitPicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final units = ['mg', 'g', 'µg', 'ml', 'pills', 'puffs'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Dose Unit'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: units.map((unit) {
            return ListTile(
              title: Text(unit),
              onTap: () {
                provider.setDefaultDoseUnit(unit);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showDateFormatPicker(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final formats = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Format'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: formats.map((format) {
            return ListTile(
              title: Text(format),
              onTap: () {
                provider.setDateFormat(format);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showResetDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text(
          'This will reset all settings to their default values.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

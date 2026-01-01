// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Settings dialogs.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';
import '../providers/settings_provider.dart';

class SettingsDialogs {
  static void showLanguagePicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setLanguage(lang);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static Future<void> showTimePickerDialog(
    BuildContext context,
    SettingsController controller,
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
      await controller.setCheckinReminderTime(timeString);
    }
  }

  static void showAutoLockPicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setAutoLockDuration(duration);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showBackupFrequencyPicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setBackupFrequency(freq);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showCacheDurationPicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setCacheDuration(duration);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showDoseUnitPicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setDefaultDoseUnit(unit);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showDateFormatPicker(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
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
                controller.setDateFormat(format);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static void showResetDialog(
    BuildContext context,
    SettingsController controller,
    NavigationService nav,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text(
          'This will reset all settings to their default values.',
        ),
        actions: [
          TextButton(onPressed: () => nav.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              nav.pop();
              controller.resetToDefaults();
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

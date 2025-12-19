// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import '../../../../providers/settings_provider.dart';
import 'settings_section.dart';
import '../../../../common/inputs/switch_tile.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Notifications section widget
class NotificationSettingsSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onReminderTimeTap;

  const NotificationSettingsSection({
    required this.settingsProvider,
    required this.onReminderTimeTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;
    final t = context.theme;

    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        CommonSwitchTile(
          title: 'Enable Notifications',
          value: settings.notificationsEnabled,
          onChanged: settingsProvider.setNotificationsEnabled,
        ),
        CommonSwitchTile(
          title: 'Daily Check-in Reminder',
          subtitle: 'At ${settings.checkinReminderTime}',
          value: settings.dailyCheckinReminder,
          onChanged: settingsProvider.setDailyCheckinReminder,
          enabled: settings.notificationsEnabled,
        ),
        if (settings.dailyCheckinReminder && settings.notificationsEnabled)
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(settings.checkinReminderTime),
            trailing: Icon(Icons.access_time, size: t.sizes.iconSm),
            onTap: onReminderTimeTap,
          ),
        CommonSwitchTile(
          title: 'Medication Reminders',
          value: settings.medicationReminders,
          onChanged: settingsProvider.setMedicationReminders,
          enabled: settings.notificationsEnabled,
        ),
        CommonSwitchTile(
          title: 'Craving Alerts',
          value: settings.cravingAlerts,
          onChanged: settingsProvider.setCravingAlerts,
          enabled: settings.notificationsEnabled,
        ),
        CommonSwitchTile(
          title: 'Weekly Reports',
          value: settings.weeklyReports,
          onChanged: settingsProvider.setWeeklyReports,
          enabled: settings.notificationsEnabled,
        ),
      ],
    );
  }
}

// MIGRATION
// Theme: PARTIAL
// Common: TODO
// Riverpod: TODO
// Notes: Uses Theme.of(context) and Colors directly; needs migration to AppTheme/context extensions.
import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

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

    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: settings.notificationsEnabled,
          onChanged: settingsProvider.setNotificationsEnabled,
        ),
        SwitchListTile(
          title: const Text('Daily Check-in Reminder'),
          subtitle: Text('At ${settings.checkinReminderTime}'),
          value: settings.dailyCheckinReminder,
          onChanged: settings.notificationsEnabled
              ? settingsProvider.setDailyCheckinReminder
              : null,
        ),
        if (settings.dailyCheckinReminder && settings.notificationsEnabled)
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(settings.checkinReminderTime),
            trailing: const Icon(Icons.access_time),
            onTap: onReminderTimeTap,
          ),
        SwitchListTile(
          title: const Text('Medication Reminders'),
          value: settings.medicationReminders,
          onChanged: settings.notificationsEnabled
              ? settingsProvider.setMedicationReminders
              : null,
        ),
        SwitchListTile(
          title: const Text('Craving Alerts'),
          value: settings.cravingAlerts,
          onChanged: settings.notificationsEnabled
              ? settingsProvider.setCravingAlerts
              : null,
        ),
        SwitchListTile(
          title: const Text('Weekly Reports'),
          value: settings.weeklyReports,
          onChanged: settings.notificationsEnabled
              ? settingsProvider.setWeeklyReports
              : null,
        ),
      ],
    );
  }
}

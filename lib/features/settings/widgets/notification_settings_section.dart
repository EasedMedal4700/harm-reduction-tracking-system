// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Notification settings section.
import 'package:flutter/material.dart';
import '../models/app_settings_model.dart';
import '../providers/settings_provider.dart';
import 'settings_section.dart';
import '../../../common/inputs/switch_tile.dart';
import '../../../constants/theme/app_theme_extension.dart';

/// Notifications section widget
class NotificationSettingsSection extends StatelessWidget {
  final AppSettings settings;
  final SettingsController controller;
  final VoidCallback onReminderTimeTap;
  const NotificationSettingsSection({
    required this.settings,
    required this.controller,
    required this.onReminderTimeTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        CommonSwitchTile(
          title: 'Enable Notifications',
          subtitle: 'Allow app to send notifications',
          value: settings.notificationsEnabled,
          onChanged: controller.setNotificationsEnabled,
        ),
        if (settings.notificationsEnabled) ...[
          CommonSwitchTile(
            title: 'Daily Check-in',
            subtitle: 'Remind me to log my day',
            value: settings.dailyCheckinReminder,
            onChanged: controller.setDailyCheckinReminder,
          ),
          if (settings.dailyCheckinReminder)
            ListTile(
              title: const Text('Reminder Time'),
              subtitle: Text(settings.checkinReminderTime),
              trailing: Icon(Icons.access_time, size: th.sizes.iconSm),
              onTap: onReminderTimeTap,
            ),
          CommonSwitchTile(
            title: 'Medication Reminders',
            subtitle: 'Remind me to take medications',
            value: settings.medicationReminders,
            onChanged: controller.setMedicationReminders,
          ),
          CommonSwitchTile(
            title: 'Craving Alerts',
            subtitle: 'Notify when craving intensity is high',
            value: settings.cravingAlerts,
            onChanged: controller.setCravingAlerts,
          ),
          CommonSwitchTile(
            title: 'Weekly Reports',
            subtitle: 'Weekly summary of your progress',
            value: settings.weeklyReports,
            onChanged: controller.setWeeklyReports,
          ),
        ],
      ],
    );
  }
}

// MIGRATION
// Theme: PARTIAL
// Common: TODO
// Riverpod: TODO
// Notes: Uses Theme.of(context) and Colors directly; needs migration to AppTheme/context extensions.
import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

/// Display settings section widget
class DisplaySettingsSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onDateFormatTap;

  const DisplaySettingsSection({
    required this.settingsProvider,
    required this.onDateFormatTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;

    return SettingsSection(
      title: 'Display',
      icon: Icons.display_settings,
      children: [
        SwitchListTile(
          title: const Text('24-Hour Time'),
          value: settings.show24HourTime,
          onChanged: settingsProvider.setShow24HourTime,
        ),
        ListTile(
          title: const Text('Date Format'),
          subtitle: Text(settings.dateFormat),
          trailing: const Icon(Icons.chevron_right),
          onTap: onDateFormatTap,
        ),
        SwitchListTile(
          title: const Text('Show Blood Levels'),
          subtitle: const Text('Display pharmacokinetic graphs'),
          value: settings.showBloodLevels,
          onChanged: settingsProvider.setShowBloodLevels,
        ),
        SwitchListTile(
          title: const Text('Show Analytics'),
          subtitle: const Text('Display usage statistics'),
          value: settings.showAnalytics,
          onChanged: settingsProvider.setShowAnalytics,
        ),
      ],
    );
  }
}

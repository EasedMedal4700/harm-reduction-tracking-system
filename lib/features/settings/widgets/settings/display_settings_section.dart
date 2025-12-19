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
    final t = context.theme;

    return SettingsSection(
      title: 'Display',
      icon: Icons.display_settings,
      children: [
        CommonSwitchTile(
          title: '24-Hour Time',
          value: settings.show24HourTime,
          onChanged: settingsProvider.setShow24HourTime,
        ),
        ListTile(
          title: const Text('Date Format'),
          subtitle: Text(settings.dateFormat),
          trailing: Icon(Icons.chevron_right, size: t.sizes.iconSm),
          onTap: onDateFormatTap,
        ),
        CommonSwitchTile(
          title: 'Show Blood Levels',
          subtitle: 'Display pharmacokinetic graphs',
          value: settings.showBloodLevels,
          onChanged: settingsProvider.setShowBloodLevels,
        ),
        CommonSwitchTile(
          title: 'Show Analytics',
          subtitle: 'Display usage statistics',
          value: settings.showAnalytics,
          onChanged: settingsProvider.setShowAnalytics,
        ),
      ],
    );
  }
}

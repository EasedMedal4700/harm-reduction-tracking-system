// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

/// UI Settings section widget
class UISettingsSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onLanguageTap;

  const UISettingsSection({
    required this.settingsProvider,
    required this.onLanguageTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;

    return SettingsSection(
      title: 'UI Settings',
      icon: Icons.palette,
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch between light and dark theme'),
          value: settings.darkMode,
          onChanged: settingsProvider.setDarkMode,
        ),
        ListTile(
          title: const Text('Font Size'),
          subtitle: Slider(
            value: settings.fontSize,
            min: 12.0,
            max: 20.0,
            divisions: 8,
            label: settings.fontSize.toStringAsFixed(0),
            onChanged: settingsProvider.setFontSize,
          ),
        ),
        SwitchListTile(
          title: const Text('Compact Mode'),
          subtitle: const Text('Reduce spacing and padding'),
          value: settings.compactMode,
          onChanged: settingsProvider.setCompactMode,
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(settings.language),
          trailing: const Icon(Icons.chevron_right),
          onTap: onLanguageTap,
        ),
      ],
    );
  }
}

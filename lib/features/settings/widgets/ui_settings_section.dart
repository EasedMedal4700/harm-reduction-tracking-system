// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI settings section.
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import 'settings_section.dart';
import '../../../common/inputs/switch_tile.dart';
import '../../../common/inputs/slider.dart';
import '../../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    return SettingsSection(
      title: 'UI Settings',
      icon: Icons.palette,
      children: [
        CommonSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Switch between light and dark theme',
          value: settings.darkMode,
          onChanged: settingsProvider.setDarkMode,
        ),
        ListTile(
          title: const Text('Font Size'),
          subtitle: CommonSlider(
            value: settings.fontSize,
            min: 12.0,
            max: 20.0,
            divisions: 8,
            label: settings.fontSize.toStringAsFixed(0),
            onChanged: settingsProvider.setFontSize,
          ),
        ),
        CommonSwitchTile(
          title: 'Compact Mode',
          subtitle: 'Reduce spacing and padding',
          value: settings.compactMode,
          onChanged: settingsProvider.setCompactMode,
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(settings.language),
          trailing: Icon(Icons.chevron_right, size: th.sizes.iconSm),
          onTap: onLanguageTap,
        ),
      ],
    );
  }
}

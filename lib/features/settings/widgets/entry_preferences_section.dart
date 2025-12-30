// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Entry preferences section.
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../models/app_settings_model.dart';
import 'settings_section.dart';
import '../../../common/inputs/switch_tile.dart';
import '../../../common/inputs/slider.dart';
import '../../../constants/theme/app_theme_extension.dart';

/// Entry Preferences section widget
class EntryPreferencesSection extends StatelessWidget {
  final AppSettings settings;
  final SettingsController controller;
  final VoidCallback onDoseUnitTap;
  const EntryPreferencesSection({
    required this.settings,
    required this.controller,
    required this.onDoseUnitTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // final settings = controller.settings;
    final th = context.theme;
    return SettingsSection(
      title: 'Entry Preferences',
      icon: Icons.edit,
      children: [
        ListTile(
          title: const Text('Default Dose Unit'),
          subtitle: Text(settings.defaultDoseUnit),
          trailing: Icon(Icons.chevron_right, size: th.sizes.iconSm),
          onTap: onDoseUnitTap,
        ),
        CommonSwitchTile(
          title: 'Quick Entry Mode',
          subtitle: 'Skip confirmation dialogs',
          value: settings.quickEntryMode,
          onChanged: controller.setQuickEntryMode,
        ),
        CommonSwitchTile(
          title: 'Auto-save Entries',
          subtitle: 'Save without confirmation',
          value: settings.autoSaveEntries,
          onChanged: controller.setAutoSaveEntries,
        ),
        CommonSwitchTile(
          title: 'Show Recent Substances',
          subtitle: 'Show last ${settings.recentSubstancesCount} used',
          value: settings.showRecentSubstances,
          onChanged: controller.setShowRecentSubstances,
        ),
        if (settings.showRecentSubstances)
          ListTile(
            title: const Text('Recent Count'),
            subtitle: CommonSlider(
              value: settings.recentSubstancesCount.toDouble(),
              min: 3,
              max: 10,
              divisions: 7,
              label: settings.recentSubstancesCount.toString(),
              onChanged: (value) =>
                  controller.setRecentSubstancesCount(value.round()),
            ),
          ),
      ],
    );
  }
}

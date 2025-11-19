import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

/// Entry Preferences section widget
class EntryPreferencesSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onDoseUnitTap;

  const EntryPreferencesSection({
    required this.settingsProvider,
    required this.onDoseUnitTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;

    return SettingsSection(
      title: 'Entry Preferences',
      icon: Icons.edit,
      children: [
        ListTile(
          title: const Text('Default Dose Unit'),
          subtitle: Text(settings.defaultDoseUnit),
          trailing: const Icon(Icons.chevron_right),
          onTap: onDoseUnitTap,
        ),
        SwitchListTile(
          title: const Text('Quick Entry Mode'),
          subtitle: const Text('Skip confirmation dialogs'),
          value: settings.quickEntryMode,
          onChanged: settingsProvider.setQuickEntryMode,
        ),
        SwitchListTile(
          title: const Text('Auto-save Entries'),
          subtitle: const Text('Save without confirmation'),
          value: settings.autoSaveEntries,
          onChanged: settingsProvider.setAutoSaveEntries,
        ),
        SwitchListTile(
          title: const Text('Show Recent Substances'),
          subtitle: Text('Show last ${settings.recentSubstancesCount} used'),
          value: settings.showRecentSubstances,
          onChanged: settingsProvider.setShowRecentSubstances,
        ),
        if (settings.showRecentSubstances)
          ListTile(
            title: const Text('Recent Count'),
            subtitle: Slider(
              value: settings.recentSubstancesCount.toDouble(),
              min: 3,
              max: 10,
              divisions: 7,
              label: settings.recentSubstancesCount.toString(),
              onChanged: (value) => settingsProvider.setRecentSubstancesCount(value.round()),
            ),
          ),
      ],
    );
  }
}

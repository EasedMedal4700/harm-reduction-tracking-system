// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import '../../../../providers/settings_provider.dart';
import 'settings_section.dart';
import '../../../../common/inputs/switch_tile.dart';

/// Data & Sync section widget
class DataSyncSettingsSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onBackupFrequencyTap;
  final VoidCallback onCacheDurationTap;

  const DataSyncSettingsSection({
    required this.settingsProvider,
    required this.onBackupFrequencyTap,
    required this.onCacheDurationTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;

    return SettingsSection(
      title: 'Data & Sync',
      icon: Icons.cloud,
      children: [
        CommonSwitchTile(
          title: 'Auto Backup',
          subtitle: 'Frequency: ${settings.backupFrequency}',
          value: settings.autoBackup,
          onChanged: settingsProvider.setAutoBackup,
        ),
        if (settings.autoBackup)
          ListTile(
            title: const Text('Backup Frequency'),
            subtitle: Text(settings.backupFrequency),
            trailing: const Icon(Icons.chevron_right),
            onTap: onBackupFrequencyTap,
          ),
        CommonSwitchTile(
          title: 'Cloud Sync',
          subtitle: 'Sync data across devices',
          value: settings.syncEnabled,
          onChanged: settingsProvider.setSyncEnabled,
        ),
        CommonSwitchTile(
          title: 'Offline Mode',
          subtitle: 'Work without internet',
          value: settings.offlineMode,
          onChanged: settingsProvider.setOfflineMode,
        ),
        CommonSwitchTile(
          title: 'Enable Cache',
          subtitle: 'Duration: ${settings.cacheDuration}',
          value: settings.cacheEnabled,
          onChanged: settingsProvider.setCacheEnabled,
        ),
        if (settings.cacheEnabled)
          ListTile(
            title: const Text('Cache Duration'),
            subtitle: Text(settings.cacheDuration),
            trailing: const Icon(Icons.chevron_right),
            onTap: onCacheDurationTap,
          ),
      ],
    );
  }
}

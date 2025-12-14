// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: N/A
import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

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
        SwitchListTile(
          title: const Text('Auto Backup'),
          subtitle: Text('Frequency: ${settings.backupFrequency}'),
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
        SwitchListTile(
          title: const Text('Cloud Sync'),
          subtitle: const Text('Sync data across devices'),
          value: settings.syncEnabled,
          onChanged: settingsProvider.setSyncEnabled,
        ),
        SwitchListTile(
          title: const Text('Offline Mode'),
          subtitle: const Text('Work without internet'),
          value: settings.offlineMode,
          onChanged: settingsProvider.setOfflineMode,
        ),
        SwitchListTile(
          title: const Text('Enable Cache'),
          subtitle: Text('Duration: ${settings.cacheDuration}'),
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

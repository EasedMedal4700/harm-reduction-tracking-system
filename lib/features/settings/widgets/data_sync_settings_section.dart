// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Data sync settings section.
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../models/app_settings_model.dart';
import 'settings_section.dart';
import '../../../common/inputs/switch_tile.dart';
import '../../../constants/theme/app_theme_extension.dart';

/// Data & Sync section widget
class DataSyncSettingsSection extends StatelessWidget {
  final AppSettings settings;
  final SettingsController controller;
  final VoidCallback onBackupFrequencyTap;
  final VoidCallback onCacheDurationTap;
  const DataSyncSettingsSection({
    required this.settings,
    required this.controller,
    required this.onBackupFrequencyTap,
    required this.onCacheDurationTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // final settings = controller.settings;
    final th = context.theme;
    return SettingsSection(
      title: 'Data & Sync',
      icon: Icons.cloud,
      children: [
        CommonSwitchTile(
          title: 'Auto Backup',
          subtitle: 'Frequency: ${settings.backupFrequency}',
          value: settings.autoBackup,
          onChanged: controller.setAutoBackup,
        ),
        if (settings.autoBackup)
          ListTile(
            title: const Text('Backup Frequency'),
            subtitle: Text(settings.backupFrequency),
            trailing: Icon(Icons.chevron_right, size: th.sizes.iconSm),
            onTap: onBackupFrequencyTap,
          ),
        CommonSwitchTile(
          title: 'Cloud Sync',
          subtitle: 'Sync data across devices',
          value: settings.syncEnabled,
          onChanged: controller.setSyncEnabled,
        ),
        CommonSwitchTile(
          title: 'Offline Mode',
          subtitle: 'Work without internet',
          value: settings.offlineMode,
          onChanged: controller.setOfflineMode,
        ),
        CommonSwitchTile(
          title: 'Enable Cache',
          subtitle: 'Duration: ${settings.cacheDuration}',
          value: settings.cacheEnabled,
          onChanged: controller.setCacheEnabled,
        ),
        if (settings.cacheEnabled)
          ListTile(
            title: const Text('Cache Duration'),
            subtitle: Text(settings.cacheDuration),
            trailing: Icon(Icons.chevron_right, size: th.sizes.iconSm),
            onTap: onCacheDurationTap,
          ),
      ],
    );
  }
}

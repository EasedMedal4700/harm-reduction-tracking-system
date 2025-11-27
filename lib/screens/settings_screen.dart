import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings/ui_settings_section.dart';
import '../widgets/settings/notification_settings_section.dart';
import '../widgets/settings/privacy_settings_section.dart';
import '../widgets/settings/data_sync_settings_section.dart';
import '../widgets/settings/entry_preferences_section.dart';
import '../widgets/settings/display_settings_section.dart';
import '../widgets/settings/about_section.dart';
import '../widgets/settings/account_management_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsProvider.settings;

          return ListView(
            children: [
              UISettingsSection(
                settingsProvider: settingsProvider,
                onLanguageTap: () => _showLanguagePicker(context, settingsProvider),
              ),
              NotificationSettingsSection(
                settingsProvider: settingsProvider,
                onReminderTimeTap: () => _showTimePicker(context, settingsProvider, settings.checkinReminderTime),
              ),
              PrivacySettingsSection(
                settingsProvider: settingsProvider,
                onAutoLockTap: () => _showAutoLockPicker(context, settingsProvider),
              ),
              DataSyncSettingsSection(
                settingsProvider: settingsProvider,
                onBackupFrequencyTap: () => _showBackupFrequencyPicker(context, settingsProvider),
                onCacheDurationTap: () => _showCacheDurationPicker(context, settingsProvider),
              ),
              EntryPreferencesSection(
                settingsProvider: settingsProvider,
                onDoseUnitTap: () => _showDoseUnitPicker(context, settingsProvider),
              ),
              DisplaySettingsSection(
                settingsProvider: settingsProvider,
                onDateFormatTap: () => _showDateFormatPicker(context, settingsProvider),
              ),
              const AccountManagementSection(),
              AboutSection(packageInfo: _packageInfo),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider provider) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Portuguese'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                provider.setLanguage(lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, SettingsProvider provider, String currentTime) async {
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time != null) {
      final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      await provider.setCheckinReminderTime(timeString);
    }
  }

  void _showAutoLockPicker(BuildContext context, SettingsProvider provider) {
    final durations = ['1min', '5min', '15min', '30min', 'never'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-lock Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: durations.map((duration) {
            return ListTile(
              title: Text(duration),
              onTap: () {
                provider.setAutoLockDuration(duration);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showBackupFrequencyPicker(BuildContext context, SettingsProvider provider) {
    final frequencies = ['daily', 'weekly', 'monthly'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: frequencies.map((freq) {
            return ListTile(
              title: Text(freq[0].toUpperCase() + freq.substring(1)),
              onTap: () {
                provider.setBackupFrequency(freq);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCacheDurationPicker(BuildContext context, SettingsProvider provider) {
    final durations = ['15min', '30min', '1hour', '6hours', '1day'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: durations.map((duration) {
            return ListTile(
              title: Text(duration),
              onTap: () {
                provider.setCacheDuration(duration);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDoseUnitPicker(BuildContext context, SettingsProvider provider) {
    final units = ['mg', 'g', 'µg', 'ml', 'pills', 'puffs'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Dose Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.map((unit) {
            return ListTile(
              title: Text(unit),
              onTap: () {
                provider.setDefaultDoseUnit(unit);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDateFormatPicker(BuildContext context, SettingsProvider provider) {
    final formats = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return ListTile(
              title: Text(format),
              onTap: () {
                provider.setDateFormat(format);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text('This will reset all settings to their default values.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsProvider>().resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

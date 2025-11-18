import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/settings_provider.dart';

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
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsProvider.settings;

          return ListView(
            children: [
              _buildSection(
                'UI Settings',
                Icons.palette,
                [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    value: settings.darkMode,
                    onChanged: settingsProvider.setDarkMode,
                  ),
                  ListTile(
                    title: const Text('Theme Color'),
                    subtitle: Text(settings.themeColor),
                    trailing: _buildColorIndicator(settings.themeColor),
                    onTap: () => _showThemeColorPicker(context, settingsProvider),
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
                    onTap: () => _showLanguagePicker(context, settingsProvider),
                  ),
                ],
              ),
              _buildSection(
                'Notifications',
                Icons.notifications,
                [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    value: settings.notificationsEnabled,
                    onChanged: settingsProvider.setNotificationsEnabled,
                  ),
                  SwitchListTile(
                    title: const Text('Daily Check-in Reminder'),
                    subtitle: Text('At ${settings.checkinReminderTime}'),
                    value: settings.dailyCheckinReminder,
                    onChanged: settings.notificationsEnabled
                        ? settingsProvider.setDailyCheckinReminder
                        : null,
                  ),
                  if (settings.dailyCheckinReminder && settings.notificationsEnabled)
                    ListTile(
                      title: const Text('Reminder Time'),
                      subtitle: Text(settings.checkinReminderTime),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _showTimePicker(context, settingsProvider, settings.checkinReminderTime),
                    ),
                  SwitchListTile(
                    title: const Text('Medication Reminders'),
                    value: settings.medicationReminders,
                    onChanged: settings.notificationsEnabled
                        ? settingsProvider.setMedicationReminders
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Craving Alerts'),
                    value: settings.cravingAlerts,
                    onChanged: settings.notificationsEnabled
                        ? settingsProvider.setCravingAlerts
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Weekly Reports'),
                    value: settings.weeklyReports,
                    onChanged: settings.notificationsEnabled
                        ? settingsProvider.setWeeklyReports
                        : null,
                  ),
                ],
              ),
              _buildSection(
                'Privacy & Security',
                Icons.lock,
                [
                  SwitchListTile(
                    title: const Text('Biometric Lock'),
                    subtitle: const Text('Use fingerprint/face to unlock'),
                    value: settings.biometricLock,
                    onChanged: settingsProvider.setBiometricLock,
                  ),
                  SwitchListTile(
                    title: const Text('Require PIN on Open'),
                    value: settings.requirePinOnOpen,
                    onChanged: settingsProvider.setRequirePinOnOpen,
                  ),
                  ListTile(
                    title: const Text('Auto-lock Duration'),
                    subtitle: Text(settings.autoLockDuration),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAutoLockPicker(context, settingsProvider),
                  ),
                  SwitchListTile(
                    title: const Text('Hide in Recent Apps'),
                    subtitle: const Text('Blur content in app switcher'),
                    value: settings.hideContentInRecents,
                    onChanged: settingsProvider.setHideContentInRecents,
                  ),
                  SwitchListTile(
                    title: const Text('Analytics'),
                    subtitle: const Text('Share anonymous usage data'),
                    value: settings.analyticsEnabled,
                    onChanged: settingsProvider.setAnalyticsEnabled,
                  ),
                ],
              ),
              _buildSection(
                'Data & Sync',
                Icons.cloud,
                [
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
                      onTap: () => _showBackupFrequencyPicker(context, settingsProvider),
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
                      onTap: () => _showCacheDurationPicker(context, settingsProvider),
                    ),
                ],
              ),
              _buildSection(
                'Entry Preferences',
                Icons.edit,
                [
                  ListTile(
                    title: const Text('Default Dose Unit'),
                    subtitle: Text(settings.defaultDoseUnit),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showDoseUnitPicker(context, settingsProvider),
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
              ),
              _buildSection(
                'Display',
                Icons.display_settings,
                [
                  SwitchListTile(
                    title: const Text('24-Hour Time'),
                    value: settings.show24HourTime,
                    onChanged: settingsProvider.setShow24HourTime,
                  ),
                  ListTile(
                    title: const Text('Date Format'),
                    subtitle: Text(settings.dateFormat),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showDateFormatPicker(context, settingsProvider),
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
              ),
              _buildSection(
                'About',
                Icons.info,
                [
                  ListTile(
                    title: const Text('App Version'),
                    subtitle: Text(_packageInfo?.version ?? 'Loading...'),
                  ),
                  ListTile(
                    title: const Text('Build Number'),
                    subtitle: Text(_packageInfo?.buildNumber ?? 'Loading...'),
                  ),
                  ListTile(
                    title: const Text('Open Source Licenses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showLicensePage(context: context),
                  ),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showComingSoon(context, 'Privacy Policy'),
                  ),
                  ListTile(
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showComingSoon(context, 'Terms of Service'),
                  ),
                  ListTile(
                    title: const Text('Support'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showComingSoon(context, 'Support'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildColorIndicator(String colorName) {
    final colorMap = {
      'blue': Colors.blue,
      'purple': Colors.purple,
      'green': Colors.green,
      'orange': Colors.orange,
      'red': Colors.red,
      'teal': Colors.teal,
    };
    final color = colorMap[colorName] ?? Colors.blue;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
    );
  }

  void _showThemeColorPicker(BuildContext context, SettingsProvider provider) {
    final colors = ['blue', 'purple', 'green', 'orange', 'red', 'teal'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: colors.map((color) {
            return ListTile(
              leading: _buildColorIndicator(color),
              title: Text(color[0].toUpperCase() + color.substring(1)),
              onTap: () {
                provider.setThemeColor(color);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
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

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings/ui_settings_section.dart';
import 'widgets/settings/notification_settings_section.dart';
import 'widgets/settings/privacy_settings_section.dart';
import 'widgets/settings/data_sync_settings_section.dart';
import 'widgets/settings/entry_preferences_section.dart';
import 'widgets/settings/display_settings_section.dart';
import 'widgets/settings/about_section.dart';
import 'widgets/settings/account_management_section.dart';
import 'widgets/settings/settings_dialogs.dart';

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
    final ac = context.accent;
    final sp = context.spacing;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () => SettingsDialogs.showResetDialog(
              context,
              context.read<SettingsProvider>(),
            ),
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: ac.primary));
          }
          final settings = settingsProvider.settings;
          return ListView(
            children: [
              UISettingsSection(
                settingsProvider: settingsProvider,
                onLanguageTap: () => SettingsDialogs.showLanguagePicker(
                  context,
                  settingsProvider,
                ),
              ),
              NotificationSettingsSection(
                settingsProvider: settingsProvider,
                onReminderTimeTap: () => SettingsDialogs.showTimePickerDialog(
                  context,
                  settingsProvider,
                  settings.checkinReminderTime,
                ),
              ),
              PrivacySettingsSection(
                settingsProvider: settingsProvider,
                onAutoLockTap: () => SettingsDialogs.showAutoLockPicker(
                  context,
                  settingsProvider,
                ),
              ),
              DataSyncSettingsSection(
                settingsProvider: settingsProvider,
                onBackupFrequencyTap: () =>
                    SettingsDialogs.showBackupFrequencyPicker(
                      context,
                      settingsProvider,
                    ),
                onCacheDurationTap: () =>
                    SettingsDialogs.showCacheDurationPicker(
                      context,
                      settingsProvider,
                    ),
              ),
              EntryPreferencesSection(
                settingsProvider: settingsProvider,
                onDoseUnitTap: () => SettingsDialogs.showDoseUnitPicker(
                  context,
                  settingsProvider,
                ),
              ),
              DisplaySettingsSection(
                settingsProvider: settingsProvider,
                onDateFormatTap: () => SettingsDialogs.showDateFormatPicker(
                  context,
                  settingsProvider,
                ),
              ),
              const AccountManagementSection(),
              AboutSection(packageInfo: _packageInfo),
              CommonSpacer.vertical(sp.md),
            ],
          );
        },
      ),
    );
  }
}

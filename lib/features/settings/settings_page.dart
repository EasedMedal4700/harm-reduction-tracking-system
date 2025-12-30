// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Settings page using Provider.
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_providers.dart';
import 'widgets/ui_settings_section.dart';
import 'widgets/notification_settings_section.dart';
import 'widgets/privacy_settings_section.dart';
import 'widgets/data_sync_settings_section.dart';
import 'widgets/entry_preferences_section.dart';
import 'widgets/display_settings_section.dart';
import 'widgets/about_section.dart';
import 'widgets/account_management_section.dart';
import 'widgets/settings_dialogs.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
    final settings = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () => SettingsDialogs.showResetDialog(
              context,
              ref.read(settingsControllerProvider),
            ),
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: settings.isLoading
          ? Center(child: CircularProgressIndicator(color: ac.primary))
          : ListView(
              children: [
                UISettingsSection(
                  settingsProvider: settings,
                  onLanguageTap: () =>
                      SettingsDialogs.showLanguagePicker(context, settings),
                ),
                NotificationSettingsSection(
                  settingsProvider: settings,
                  onReminderTimeTap: () => SettingsDialogs.showTimePickerDialog(
                    context,
                    settings,
                    settings.settings.checkinReminderTime,
                  ),
                ),
                PrivacySettingsSection(
                  settingsProvider: settings,
                  onAutoLockTap: () =>
                      SettingsDialogs.showAutoLockPicker(context, settings),
                ),
                DataSyncSettingsSection(
                  settingsProvider: settings,
                  onBackupFrequencyTap: () =>
                      SettingsDialogs.showBackupFrequencyPicker(
                        context,
                        settings,
                      ),
                  onCacheDurationTap: () =>
                      SettingsDialogs.showCacheDurationPicker(
                        context,
                        settings,
                      ),
                ),
                EntryPreferencesSection(
                  settingsProvider: settings,
                  onDoseUnitTap: () =>
                      SettingsDialogs.showDoseUnitPicker(context, settings),
                ),
                DisplaySettingsSection(
                  settingsProvider: settings,
                  onDateFormatTap: () =>
                      SettingsDialogs.showDateFormatPicker(context, settings),
                ),
                const AccountManagementSection(),
                AboutSection(packageInfo: _packageInfo),
                CommonSpacer.vertical(sp.md),
              ],
            ),
    );
  }
}

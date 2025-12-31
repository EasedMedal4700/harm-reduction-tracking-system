// MIGRATION:
// State: MODERN
// Navigation: LEGACY
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Settings page using Riverpod Notifier.
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';

import 'settings.dart';
import 'widgets/ui_settings_section.dart';
import 'widgets/data_sync_settings_section.dart';
import 'widgets/entry_preferences_section.dart';
import 'widgets/display_settings_section.dart';
import 'widgets/about_section.dart';
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
    final asyncSettings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final nav = ref.read(navigationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () =>
                SettingsDialogs.showResetDialog(context, controller, nav),
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: asyncSettings.when(
        data: (settings) => ListView(
          children: [
            UISettingsSection(
              settings: settings,
              controller: controller,
              onLanguageTap: () =>
                  SettingsDialogs.showLanguagePicker(context, controller, nav),
            ),
            NotificationSettingsSection(
              settings: settings,
              controller: controller,
              onReminderTimeTap: () => SettingsDialogs.showTimePickerDialog(
                context,
                controller,
                settings.checkinReminderTime,
              ),
            ),
            PrivacySettingsSection(
              settings: settings,
              controller: controller,
              onAutoLockTap: () =>
                  SettingsDialogs.showAutoLockPicker(context, controller, nav),
            ),
            DataSyncSettingsSection(
              settings: settings,
              controller: controller,
              onBackupFrequencyTap: () =>
                  SettingsDialogs.showBackupFrequencyPicker(
                    context,
                    controller,
                    nav,
                  ),
              onCacheDurationTap: () => SettingsDialogs.showCacheDurationPicker(
                context,
                controller,
                nav,
              ),
            ),
            EntryPreferencesSection(
              settings: settings,
              controller: controller,
              onDoseUnitTap: () =>
                  SettingsDialogs.showDoseUnitPicker(context, controller, nav),
            ),
            DisplaySettingsSection(
              settings: settings,
              controller: controller,
              onDateFormatTap: () => SettingsDialogs.showDateFormatPicker(
                context,
                controller,
                nav,
              ),
            ),
            const AccountManagementSection(),
            AboutSection(packageInfo: _packageInfo),
            CommonSpacer.vertical(sp.md),
          ],
        ),
        loading: () =>
            Center(child: CircularProgressIndicator(color: ac.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

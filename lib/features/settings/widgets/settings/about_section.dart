// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'settings_section.dart';

/// About section widget
class AboutSection extends StatelessWidget {
  final PackageInfo? packageInfo;

  const AboutSection({this.packageInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'About',
      icon: Icons.info,
      children: [
        ListTile(
          title: const Text('App Version'),
          subtitle: Text(packageInfo?.version ?? 'Loading...'),
        ),
        ListTile(
          title: const Text('Build Number'),
          subtitle: Text(packageInfo?.buildNumber ?? 'Loading...'),
        ),
        ListTile(
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            // TODO: Open terms
          },
        ),
        ListTile(
          title: const Text('Licenses'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showLicensePage(context: context);
          },
        ),
      ],
    );
  }
}

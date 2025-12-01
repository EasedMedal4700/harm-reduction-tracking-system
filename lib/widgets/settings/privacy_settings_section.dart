import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import 'settings_section.dart';

/// Privacy & Security section widget
class PrivacySettingsSection extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onAutoLockTap;

  const PrivacySettingsSection({
    required this.settingsProvider,
    required this.onAutoLockTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsProvider.settings;

    return SettingsSection(
      title: 'Privacy & Security',
      icon: Icons.lock,
      children: [
        ListTile(
          title: const Text('Setup PIN Encryption'),
          subtitle: const Text('Create a PIN for enhanced security'),
          leading: const Icon(Icons.security),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).pushNamed('/pin-setup');
          },
        ),
        const Divider(),
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
          onTap: onAutoLockTap,
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
    );
  }
}

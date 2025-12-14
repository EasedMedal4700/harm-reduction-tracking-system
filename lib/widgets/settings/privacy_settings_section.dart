// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/settings_provider.dart';
import '../../services/pin_timeout_service.dart';
import '../../services/encryption_service_v2.dart';
import '../../services/onboarding_service.dart';
import 'settings_section.dart';

/// Privacy & Security section widget
class PrivacySettingsSection extends StatefulWidget {
  final SettingsProvider settingsProvider;
  final VoidCallback onAutoLockTap;

  const PrivacySettingsSection({
    required this.settingsProvider,
    required this.onAutoLockTap,
    super.key,
  });

  @override
  State<PrivacySettingsSection> createState() => _PrivacySettingsSectionState();
}

class _PrivacySettingsSectionState extends State<PrivacySettingsSection> {
  static const String _privacyPolicyUrl = 
      'https://resume-drab-five.vercel.app/privacy/substance-check';
  
  final _encryptionService = EncryptionServiceV2();
  int _foregroundTimeout = PinTimeoutService.defaultForegroundTimeout;
  int _backgroundTimeout = PinTimeoutService.defaultBackgroundTimeout;
  int _maxSessionDuration = PinTimeoutService.defaultMaxSessionDuration;
  bool _isLoading = true;
  bool _hasEncryption = false;

  @override
  void initState() {
    super.initState();
    _loadTimeoutSettings();
    _checkEncryptionStatus();
  }

  Future<void> _checkEncryptionStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final hasEncryption = await _encryptionService.hasEncryptionSetup(user.id);
      if (mounted) {
        setState(() => _hasEncryption = hasEncryption);
      }
    }
  }

  Future<void> _loadTimeoutSettings() async {
    final settings = await pinTimeoutService.getSettings();
    if (mounted) {
      setState(() {
        _foregroundTimeout = settings['foregroundTimeout']!;
        _backgroundTimeout = settings['backgroundTimeout']!;
        _maxSessionDuration = settings['maxSessionDuration']!;
        _isLoading = false;
      });
    }
  }

  String _formatDuration(int minutes) {
    if (minutes == 0) return 'Disabled';
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hr';
    return '$hours hr $mins min';
  }

  Future<void> _showTimeoutPicker({
    required String title,
    required String subtitle,
    required int currentValue,
    required int minValue,
    required int maxValue,
    required List<int> presets,
    required Function(int) onChanged,
    bool allowDisable = false,
  }) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => _TimeoutPickerDialog(
        title: title,
        subtitle: subtitle,
        currentValue: currentValue,
        minValue: minValue,
        maxValue: maxValue,
        presets: presets,
        allowDisable: allowDisable,
      ),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settingsProvider.settings;

    return SettingsSection(
      title: 'Privacy & Security',
      icon: Icons.lock,
      children: [
        // Show "Change PIN" if encryption is set up, otherwise show "Setup PIN"
        if (_hasEncryption) ...[
          ListTile(
            title: const Text('Change PIN'),
            subtitle: const Text('Update your encryption PIN'),
            leading: const Icon(Icons.lock_reset),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Navigator.of(context).pushNamed('/change-pin');
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PIN changed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ] else ...[
          ListTile(
            title: const Text('Setup PIN Encryption'),
            subtitle: const Text('Create a PIN for enhanced security'),
            leading: const Icon(Icons.security),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed('/pin-setup');
            },
          ),
        ],
        const Divider(),
        SwitchListTile(
          title: const Text('Biometric Lock'),
          subtitle: const Text('Use fingerprint/face to unlock'),
          value: settings.biometricLock,
          onChanged: widget.settingsProvider.setBiometricLock,
        ),
        
        // PIN Timeout Settings Header
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'PIN Timeout Settings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        
        // Foreground Timeout
        ListTile(
          title: const Text('PIN Timeout (Active)'),
          subtitle: Text(
            _isLoading 
                ? 'Loading...' 
                : 'Require PIN after ${_formatDuration(_foregroundTimeout)} of inactivity',
          ),
          leading: const Icon(Icons.timer),
          trailing: const Icon(Icons.chevron_right),
          onTap: _isLoading ? null : () => _showTimeoutPicker(
            title: 'Active Timeout',
            subtitle: 'Time before PIN is required when app is in use',
            currentValue: _foregroundTimeout,
            minValue: 1,
            maxValue: 60,
            presets: [1, 2, 5, 10, 15, 30, 60],
            onChanged: (value) async {
              await pinTimeoutService.setForegroundTimeout(value);
              setState(() => _foregroundTimeout = value);
            },
          ),
        ),
        
        // Background Timeout
        ListTile(
          title: const Text('PIN Timeout (Background)'),
          subtitle: Text(
            _isLoading 
                ? 'Loading...' 
                : 'Require PIN after ${_formatDuration(_backgroundTimeout)} in background',
          ),
          leading: const Icon(Icons.phonelink_lock),
          trailing: const Icon(Icons.chevron_right),
          onTap: _isLoading ? null : () => _showTimeoutPicker(
            title: 'Background Timeout',
            subtitle: 'Time in background before PIN is required',
            currentValue: _backgroundTimeout,
            minValue: 1,
            maxValue: 1440,
            presets: [5, 15, 30, 60, 120, 480, 1440],
            onChanged: (value) async {
              await pinTimeoutService.setBackgroundTimeout(value);
              setState(() => _backgroundTimeout = value);
            },
          ),
        ),
        
        // Max Session Duration
        ListTile(
          title: const Text('Max Session Duration'),
          subtitle: Text(
            _isLoading 
                ? 'Loading...' 
                : _maxSessionDuration == 0 
                    ? 'No limit'
                    : 'Auto-lock after ${_formatDuration(_maxSessionDuration)}',
          ),
          leading: const Icon(Icons.lock_clock),
          trailing: const Icon(Icons.chevron_right),
          onTap: _isLoading ? null : () => _showTimeoutPicker(
            title: 'Max Session Duration',
            subtitle: 'Auto-lock after this time regardless of activity',
            currentValue: _maxSessionDuration,
            minValue: 0,
            maxValue: 1440,
            presets: [0, 60, 120, 240, 480, 720, 1440],
            allowDisable: true,
            onChanged: (value) async {
              await pinTimeoutService.setMaxSessionDuration(value);
              setState(() => _maxSessionDuration = value);
            },
          ),
        ),
        
        const Divider(),
        SwitchListTile(
          title: const Text('Hide in Recent Apps'),
          subtitle: const Text('Blur content in app switcher'),
          value: settings.hideContentInRecents,
          onChanged: widget.settingsProvider.setHideContentInRecents,
        ),
        SwitchListTile(
          title: const Text('Analytics'),
          subtitle: const Text('Share anonymous usage data'),
          value: settings.analyticsEnabled,
          onChanged: widget.settingsProvider.setAnalyticsEnabled,
        ),
        const Divider(),
        // Reset harm reduction notices option
        ListTile(
          title: const Text('Reset Harm Reduction Notices'),
          subtitle: const Text('Show dismissed warning banners again'),
          leading: const Icon(Icons.restore),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reset Notices'),
                content: const Text(
                  'This will show all harm reduction warning banners again. '
                  'These banners provide important safety information.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );
            
            if (confirm == true && mounted) {
              final onboardingSvc = OnboardingService();
              await onboardingSvc.resetHarmNotices();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Harm reduction notices will appear again'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
        ),
        const Divider(),
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) => debugPrint('🖱 PointerDown on Privacy Policy tile: $event'),
          onPointerUp: (event) => debugPrint('🖱 PointerUp on Privacy Policy tile: $event'),
          child: InkWell(
            onTap: () {
              debugPrint('🔔 Privacy Policy tile tapped - calling _openPrivacyPolicy()');
              // _openPrivacyPolicy();
              Navigator.of(context).pushNamed('/privacy-policy');
            },
            child: ListTile(
              title: const Text('Privacy Policy'),
              subtitle: const Text('View our privacy policy'),
              leading: const Icon(Icons.policy),
              trailing: const Icon(Icons.open_in_new),
            ),
          ),
        ),
        // ListTile(
        //   title: const Text('Privacy Policy'),
        //   subtitle: const Text('View our privacy policy'),
        //   leading: const Icon(Icons.policy),
        //   trailing: const Icon(Icons.open_in_new),
        //   onTap: () {
        //     debugPrint("🔥 TAPPED PRIVACY POLICY LIST TILE");
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text("Tapped!")),
        //     );
        //   },
        // ),
      ],
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(_privacyPolicyUrl);

    debugPrint("🔍 Trying to open privacy policy: $uri");

    try {
      final bool isLaunchable = await canLaunchUrl(uri);
      debugPrint("📡 canLaunchUrl = $isLaunchable");

      if (!isLaunchable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open URL (canLaunch returned false)')),
        );
        return;
      }

      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint("🚀 launchUrl success = $success");

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to launch URL')),
        );
      }
    } catch (e) {
      debugPrint("❌ Error opening URL: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening privacy policy: $e')),
        );
      }
    }
  }
}

/// Dialog for picking timeout duration
class _TimeoutPickerDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final List<int> presets;
  final bool allowDisable;

  const _TimeoutPickerDialog({
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.presets,
    this.allowDisable = false,
  });

  @override
  State<_TimeoutPickerDialog> createState() => _TimeoutPickerDialogState();
}

class _TimeoutPickerDialogState extends State<_TimeoutPickerDialog> {
  late int _selectedValue;
  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String _formatDuration(int minutes) {
    if (minutes == 0) return 'Disabled';
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hr';
    return '$hours hr $mins min';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.presets.map((value) {
                final isSelected = _selectedValue == value;
                return ChoiceChip(
                  label: Text(_formatDuration(value)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedValue = value);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Custom (minutes)',
                      hintText: '${widget.minValue}-${widget.maxValue}',
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final value = int.tryParse(_customController.text);
                    if (value != null) {
                      final clamped = value.clamp(
                        widget.allowDisable ? 0 : widget.minValue,
                        widget.maxValue,
                      );
                      setState(() => _selectedValue = clamped);
                    }
                  },
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Current: ${_formatDuration(_selectedValue)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedValue),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import '../../services/pin_timeout_service.dart';
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
  int _foregroundTimeout = PinTimeoutService.defaultForegroundTimeout;
  int _backgroundTimeout = PinTimeoutService.defaultBackgroundTimeout;
  int _maxSessionDuration = PinTimeoutService.defaultMaxSessionDuration;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeoutSettings();
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
      ],
    );
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

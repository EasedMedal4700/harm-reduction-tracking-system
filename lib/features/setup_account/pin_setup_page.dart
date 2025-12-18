import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/core_providers.dart';
import '../../services/encryption_service_v2.dart';


/// Screen for setting up PIN-based encryption
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _encryptionService = EncryptionServiceV2();
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  
  bool _isLoading = false;
  bool _showRecoveryKey = false;
  String? _recoveryKey;
  String? _errorMessage;
  bool _pin1Obscure = true;
  bool _pin2Obscure = true;

  @override
  void dispose() {
    _pin1Controller.dispose();
    _pin2Controller.dispose();
    super.dispose();
  }

  Future<void> _setupEncryption() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pin1 = _pin1Controller.text;
      final pin2 = _pin2Controller.text;

      // Validation
      if (pin1.length != 6) {
        throw Exception('PIN must be exactly 6 digits');
      }
      if (pin1 != pin2) {
        throw Exception('PINs do not match');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Setup encryption
      final recoveryKey = await _encryptionService.setupNewSecrets(
        user.id,
        pin1,
      );

      setState(() {
        _recoveryKey = recoveryKey;
        _showRecoveryKey = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _enableBiometrics() async {
    try {
      await _encryptionService.enableBiometrics(_pin1Controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint unlock enabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable biometrics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyRecoveryKey() {
    if (_recoveryKey != null) {
      Clipboard.setData(ClipboardData(text: _recoveryKey!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recovery key copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _finishSetup() {
    unawaited(ref.read(appLockControllerProvider.notifier).recordUnlock());
    Navigator.of(context).pushReplacementNamed('/home_page');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.text;

    if (_showRecoveryKey) {
      return _buildRecoveryKeyView(context);
    }

    return PopScope(
      canPop: false, // Prevent back navigation - user must complete PIN setup
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          title: Text(
            'Setup Encryption',
            style: t.heading3.copyWith(color: c.textPrimary),
          ),
          backgroundColor: c.surface,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.lock_outline,
              size: 80,
              color: a.primary,
            ),
            SizedBox(height: sp.xl),

            // Title
            Text(
              'Create Your PIN',
              style: t.heading2.copyWith(
                fontWeight: AppThemeConstants.fontBold,
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sp.sm),

            // Description
            Text(
              'Your PIN encrypts all sensitive data. Choose a 6-digit PIN you can remember.',
              style: t.body.copyWith(
                color: c.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sp.xl2),

            // PIN 1
            Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: c.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter PIN',
                    style: t.labelLarge.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: sp.sm),
                  TextField(
                    controller: _pin1Controller,
                    obscureText: _pin1Obscure,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: t.heading3.copyWith(
                      letterSpacing: 8,
                      color: c.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '● ● ● ● ● ●',
                      counterText: '',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _pin1Obscure ? Icons.visibility : Icons.visibility_off,
                          color: c.textSecondary,
                        ),
                        onPressed: () => setState(() => _pin1Obscure = !_pin1Obscure),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.lg),

            // PIN 2
            Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: c.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm PIN',
                    style: t.labelLarge.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: sp.sm),
                  TextField(
                    controller: _pin2Controller,
                    obscureText: _pin2Obscure,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: t.heading3.copyWith(
                      letterSpacing: 8,
                      color: c.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '● ● ● ● ● ●',
                      counterText: '',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _pin2Obscure ? Icons.visibility : Icons.visibility_off,
                          color: c.textSecondary,
                        ),
                        onPressed: () => setState(() => _pin2Obscure = !_pin2Obscure),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              SizedBox(height: sp.md),
              Container(
                padding: EdgeInsets.all(sp.sm),
                decoration: BoxDecoration(
                  color: c.error.withValues(alpha: AppThemeConstants.opacityOverlay),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  border: Border.all(color: c.error.withValues(alpha: AppThemeConstants.opacityMedium)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: c.error, size: AppThemeConstants.iconSm),
                    SizedBox(width: sp.sm),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: t.body.copyWith(color: c.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: sp.xl2),

            // Setup button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _setupEncryption,
                style: ElevatedButton.styleFrom(
                  backgroundColor: a.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Create PIN',
                        style: t.labelLarge.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
    ); // Close PopScope
  }

  Widget _buildRecoveryKeyView(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.text;

    return PopScope(
      canPop: false, // Prevent back navigation - user must save recovery key
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          title: Text(
            'Recovery Key',
            style: t.heading3.copyWith(color: c.textPrimary),
          ),
          backgroundColor: c.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.key,
              size: 80,
              color: c.warning,
            ),
            SizedBox(height: sp.xl),

            // Title
            Text(
              'Save Your Recovery Key',
              style: t.heading2.copyWith(
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sp.sm),

            // Warning
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: c.warning.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber, color: c.warning),
                      SizedBox(width: sp.sm),
                      Expanded(
                        child: Text(
                          'IMPORTANT: Save this key securely',
                          style: t.heading4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sp.xs),
                  Text(
                    'If you forget your PIN, this recovery key is the ONLY way to access your encrypted data. Write it down and store it somewhere safe.',
                    style: t.body.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.xl),

            // Recovery key
            Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: a.primary,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  SelectableText(
                    _recoveryKey ?? '',
                    style: t.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: a.primary,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sp.md),
                  OutlinedButton.icon(
                    onPressed: _copyRecoveryKey,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: a.primary,
                      side: BorderSide(color: a.primary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.xl2),

            // Enable biometrics option
            OutlinedButton.icon(
              onPressed: _enableBiometrics,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Enable Fingerprint Unlock (Optional)'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: sp.md),
                foregroundColor: a.primary,
                side: BorderSide(color: a.primary),
              ),
            ),
            SizedBox(height: sp.md),

            // Finish button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _finishSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'I\'ve Saved My Recovery Key',
                  style: t.labelLarge.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    ); // Close PopScope
  }
}





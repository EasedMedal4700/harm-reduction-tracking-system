// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Screen for setting up PIN-based encryption.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_typography.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/pin_setup_controller.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/buttons/common_primary_button.dart';

/// Screen for setting up PIN-based encryption
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});
  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  @override
  void dispose() {
    _pin1Controller.dispose();
    _pin2Controller.dispose();
    super.dispose();
  }

  Future<void> _setupEncryption() async {
    await ref
        .read(pinSetupControllerProvider.notifier)
        .setupEncryption(
          pin1: _pin1Controller.text,
          pin2: _pin2Controller.text,
        );
  }

  Future<void> _enableBiometrics() async {
    final c = context.colors;
    final ok = await ref
        .read(pinSetupControllerProvider.notifier)
        .enableBiometrics(_pin1Controller.text);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Fingerprint unlock enabled' : 'Failed to enable biometrics',
        ),
        backgroundColor: ok ? c.success : c.error,
      ),
    );
  }

  void _copyRecoveryKey(String recoveryKey) {
    Clipboard.setData(ClipboardData(text: recoveryKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recovery key copied to clipboard'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _finishSetup() {
    unawaited(ref.read(pinSetupControllerProvider.notifier).recordUnlock());
    context.go('/home_page');
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    final pinState = ref.watch(pinSetupControllerProvider);
    if (pinState.showRecoveryKey && pinState.recoveryKey != null) {
      return _buildRecoveryKeyView(context, pinState.recoveryKey!);
    }
    return PopScope(
      canPop: false, // Prevent back navigation - user must complete PIN setup
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          title: Text(
            'Setup Encryption',
            style: tx.heading3.copyWith(color: c.textPrimary),
          ),
          backgroundColor: c.surface,
          elevation: context.sizes.elevationNone,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
            children: [
              // Icon
              Icon(Icons.lock_outline, size: 80, color: ac.primary),
              CommonSpacer.vertical(sp.xl),
              // Title
              Text(
                'Create Your PIN',
                style: tx.heading2.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.sm),
              // Description
              Text(
                'Your PIN encrypts all sensitive data. Choose a 6-digit PIN you can remember.',
                style: tx.body.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.xl2),
              // PIN 1
              Container(
                padding: EdgeInsets.all(sp.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(
                      'Enter PIN',
                      style: tx.labelLarge.copyWith(color: c.textPrimary),
                    ),
                    CommonSpacer.vertical(sp.sm),
                    TextField(
                      controller: _pin1Controller,
                      obscureText: pinState.pin1Obscure,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: tx.heading3.copyWith(
                        letterSpacing: 8,
                        color: c.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '● ● ● ● ● ●',
                        counterText: '',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            pinState.pin1Obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: c.textSecondary,
                          ),
                          onPressed: ref
                              .read(pinSetupControllerProvider.notifier)
                              .togglePin1Obscure,
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              CommonSpacer.vertical(sp.lg),
              // PIN 2
              Container(
                padding: EdgeInsets.all(sp.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(
                      'Confirm PIN',
                      style: tx.labelLarge.copyWith(color: c.textPrimary),
                    ),
                    CommonSpacer.vertical(sp.sm),
                    TextField(
                      controller: _pin2Controller,
                      obscureText: pinState.pin2Obscure,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: tx.heading3.copyWith(
                        letterSpacing: 8,
                        color: c.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '● ● ● ● ● ●',
                        counterText: '',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            pinState.pin2Obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: c.textSecondary,
                          ),
                          onPressed: ref
                              .read(pinSetupControllerProvider.notifier)
                              .togglePin2Obscure,
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              // Error message
              if (pinState.errorMessage != null) ...[
                CommonSpacer.vertical(sp.md),
                Container(
                  padding: EdgeInsets.all(sp.sm),
                  decoration: BoxDecoration(
                    color: c.error.withValues(alpha: context.opacities.overlay),
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                    border: Border.all(
                      color: c.error.withValues(
                        alpha: context.opacities.medium,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: c.error,
                        size: context.sizes.iconSm,
                      ),
                      CommonSpacer.horizontal(sp.sm),
                      Expanded(
                        child: Text(
                          pinState.errorMessage!,
                          style: tx.body.copyWith(color: c.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              CommonSpacer.vertical(sp.xl2),
              // Setup button
              CommonPrimaryButton(
                onPressed: _setupEncryption,
                isLoading: pinState.isLoading,
                label: 'Create PIN',
                height: context.sizes.buttonHeightLg,
              ),
            ],
          ),
        ),
      ),
    ); // Close PopScope
  }

  Widget _buildRecoveryKeyView(BuildContext context, String recoveryKey) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return PopScope(
      canPop: false, // Prevent back navigation - user must save recovery key
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          title: Text(
            'Recovery Key',
            style: tx.heading3.copyWith(color: c.textPrimary),
          ),
          backgroundColor: c.surface,
          elevation: context.sizes.elevationNone,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
            children: [
              // Icon
              Icon(Icons.key, size: 80, color: c.warning),
              CommonSpacer.vertical(sp.xl),
              // Title
              Text(
                'Save Your Recovery Key',
                style: tx.heading2.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.sm),
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
                        CommonSpacer.horizontal(sp.sm),
                        Expanded(
                          child: Text(
                            'IMPORTANT: Save this key securely',
                            style: tx.heading4.copyWith(
                              fontWeight: tx.bodyBold.fontWeight,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonSpacer.vertical(sp.xs),
                    Text(
                      'If you forget your PIN, this recovery key is the ONLY way to access your encrypted data. Write it down and store it somewhere safe.',
                      style: tx.body.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
              CommonSpacer.vertical(sp.xl),
              // Recovery key
              Container(
                padding: EdgeInsets.all(sp.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: ac.primary,
                    width: context.sizes.borderRegular,
                  ),
                ),
                child: Column(
                  children: [
                    SelectableText(
                      recoveryKey,
                      style: tx.heading3.copyWith(
                        fontWeight: tx.bodyBold.fontWeight,
                        letterSpacing: 2,
                        color: ac.primary,
                        fontFamily: AppTypographyConstants.fontFamilyMonospace,
                      ),
                      textAlign: AppLayout.textAlignCenter,
                    ),
                    CommonSpacer.vertical(sp.md),
                    OutlinedButton.icon(
                      onPressed: () => _copyRecoveryKey(recoveryKey),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy to Clipboard'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ac.primary,
                        side: BorderSide(color: ac.primary),
                      ),
                    ),
                  ],
                ),
              ),
              CommonSpacer.vertical(sp.xl2),
              // Enable biometrics option
              OutlinedButton.icon(
                onPressed: _enableBiometrics,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Enable Fingerprint Unlock (Optional)'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: sp.md),
                  foregroundColor: ac.primary,
                  side: BorderSide(color: ac.primary),
                ),
              ),
              CommonSpacer.vertical(sp.md),
              // Finish button
              CommonPrimaryButton(
                onPressed: _finishSetup,
                label: 'I\'ve Saved My Recovery Key',
                backgroundColor: c.success,
                height: context.sizes.buttonHeightLg,
              ),
            ],
          ),
        ),
      ),
    ); // Close PopScope
  }
}

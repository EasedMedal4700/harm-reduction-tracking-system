// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Screen for unlocking with recovery key and optionally resetting PIN.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_typography.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/recovery_key_controller.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/buttons/common_primary_button.dart';

/// Screen for unlocking with recovery key and optionally resetting PIN
class RecoveryKeyScreen extends ConsumerStatefulWidget {
  const RecoveryKeyScreen({super.key});
  @override
  ConsumerState<RecoveryKeyScreen> createState() => _RecoveryKeyScreenState();
}

class _RecoveryKeyScreenState extends ConsumerState<RecoveryKeyScreen> {
  final _recoveryKeyController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  static const double _pinLetterSpacing = 8.0;

  @override
  void dispose() {
    _recoveryKeyController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  /// Step 1: Validate the recovery key
  Future<void> _validateRecoveryKey() async {
    await ref
        .read(recoveryKeyControllerProvider.notifier)
        .validateRecoveryKey(_recoveryKeyController.text);
  }

  /// Step 2: Create new PIN using the validated recovery key
  Future<void> _createNewPin() async {
    final c = context.colors;
    final nav = ref.read(navigationProvider);
    final ok = await ref
        .read(recoveryKeyControllerProvider.notifier)
        .resetPin(
          newPinRaw: _newPinController.text,
          confirmPinRaw: _confirmPinController.text,
        );
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PIN reset successful!'),
          backgroundColor: c.success,
          duration: const Duration(seconds: 3),
        ),
      );
      nav.replace(AppRoutePaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final flow = ref.watch(recoveryKeyControllerProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          flow.recoveryKeyValidated ? 'Create New PIN' : 'Recovery Key',
        ),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        leading: flow.recoveryKeyValidated
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref
                      .read(recoveryKeyControllerProvider.notifier)
                      .backToRecoveryKeyEntry();
                  _newPinController.clear();
                  _confirmPinController.clear();
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.lg),
        child: flow.recoveryKeyValidated
            ? _buildPinCreationView(context)
            : _buildRecoveryKeyView(context),
      ),
    );
  }

  /// Build the recovery key input view (Step 1)
  Widget _buildRecoveryKeyView(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final flow = ref.watch(recoveryKeyControllerProvider);

    final ac = context.accent;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
      children: [
        CommonSpacer.vertical(sp.lg),
        // Key Icon
        Icon(Icons.vpn_key, size: 100, color: ac.primary),
        CommonSpacer.vertical(sp.xl),
        // Title
        Text(
          'Enter Recovery Key',
          style: tx.heading2.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.sm),
        // Description
        Text(
          'Enter your recovery key to reset your PIN',
          style: tx.bodyLarge.copyWith(color: c.textSecondary),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.xl2),
        // Info box
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: ac.primary.withValues(alpha: context.opacities.overlay),
            borderRadius: BorderRadius.circular(context.shapes.radiusMd),
            border: Border.all(
              color: ac.primary.withValues(alpha: context.opacities.slow),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ac.primary,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Expanded(
                child: Text(
                  'Your recovery key is a 24-character hexadecimal code',
                  style: tx.body.copyWith(color: c.textPrimary),
                ),
              ),
            ],
          ),
        ),
        CommonSpacer.vertical(sp.lg),
        // Recovery Key Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(context.shapes.radiusLg),
            border: Border.all(
              color: c.border,
              width: context.sizes.borderRegular,
            ),
          ),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                'Recovery Key',
                style: tx.labelLarge.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
              CommonSpacer.vertical(sp.sm),
              TextField(
                controller: _recoveryKeyController,
                obscureText: flow.keyObscure,
                autocorrect: false,
                enableSuggestions: false,
                style: tx.bodyLarge.copyWith(
                  fontFamily: AppTypographyConstants.fontFamilyMonospace,
                  letterSpacing: context.sizes.letterSpacingMd,
                  color: c.textPrimary,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter your 24-character recovery key',
                  hintStyle: tx.bodyLarge.copyWith(color: c.textSecondary),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      flow.keyObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
                    ),
                    onPressed: ref
                        .read(recoveryKeyControllerProvider.notifier)
                        .toggleKeyObscure,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Error message
        if (flow.errorMessage != null) ...[
          CommonSpacer.vertical(sp.lg),
          _buildErrorMessage(context, flow.errorMessage!),
        ],
        CommonSpacer.vertical(sp.xl),
        // Validate button
        CommonPrimaryButton(
          onPressed: _validateRecoveryKey,
          isLoading: flow.isLoading,
          label: 'Continue',
          height: context.sizes.buttonHeightLg,
        ),
        CommonSpacer.vertical(sp.lg),
        // Back button
        TextButton.icon(
          onPressed: () {
            final nav = ref.read(navigationProvider);
            nav.pop();
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to PIN Unlock'),
          style: TextButton.styleFrom(
            foregroundColor: ac.primary,
            padding: EdgeInsets.symmetric(vertical: sp.md),
          ),
        ),
      ],
    );
  }

  /// Build the PIN creation view (Step 2)
  Widget _buildPinCreationView(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final flow = ref.watch(recoveryKeyControllerProvider);

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
      children: [
        CommonSpacer.vertical(sp.lg),
        // Lock Icon
        Icon(Icons.lock_reset, size: 100, color: ac.primary),
        CommonSpacer.vertical(sp.xl),
        // Title
        Text(
          'Create New PIN',
          style: tx.heading2.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.sm),
        // Description
        Text(
          'Recovery key validated! Now create a new 6-digit PIN',
          style: tx.bodyLarge.copyWith(color: c.textSecondary),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.xl2),
        // Success indicator
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: c.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.shapes.radiusMd),
            border: Border.all(color: c.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: c.success,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Expanded(
                child: Text(
                  'Recovery key verified successfully',
                  style: tx.body.copyWith(
                    color: c.textPrimary,
                    fontWeight: tx.bodyMedium.fontWeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        CommonSpacer.vertical(sp.lg),
        // New PIN Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(context.shapes.radiusLg),
            border: Border.all(
              color: c.border,
              width: context.sizes.borderRegular,
            ),
          ),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                'New PIN',
                style: tx.labelLarge.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
              CommonSpacer.vertical(sp.sm),
              TextField(
                controller: _newPinController,
                obscureText: flow.pinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: tx.heading3.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  letterSpacing: _pinLetterSpacing,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: tx.heading3.copyWith(
                    color: c.textSecondary,
                    letterSpacing: _pinLetterSpacing,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      flow.pinObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
                    ),
                    onPressed: ref
                        .read(recoveryKeyControllerProvider.notifier)
                        .togglePinObscure,
                  ),
                ),
              ),
            ],
          ),
        ),
        CommonSpacer.vertical(sp.md),
        // Confirm PIN Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(context.shapes.radiusLg),
            border: Border.all(
              color: c.border,
              width: context.sizes.borderRegular,
            ),
          ),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                'Confirm PIN',
                style: tx.labelLarge.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
              CommonSpacer.vertical(sp.sm),
              TextField(
                controller: _confirmPinController,
                obscureText: flow.confirmPinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: tx.heading3.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  letterSpacing: _pinLetterSpacing,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: tx.heading3.copyWith(
                    color: c.textSecondary,
                    letterSpacing: _pinLetterSpacing,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      flow.confirmPinObscure
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: c.textSecondary,
                    ),
                    onPressed: ref
                        .read(recoveryKeyControllerProvider.notifier)
                        .toggleConfirmPinObscure,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Error message
        if (flow.errorMessage != null) ...[
          CommonSpacer.vertical(sp.lg),
          _buildErrorMessage(context, flow.errorMessage!),
        ],
        CommonSpacer.vertical(sp.xl),
        // Create PIN button
        CommonPrimaryButton(
          onPressed: _createNewPin,
          isLoading: flow.isLoading,
          label: 'Reset PIN',
          height: context.sizes.buttonHeightLg,
        ),
      ],
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage(BuildContext context, String message) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.shapes.radiusMd),
        border: Border.all(color: c.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: c.error, size: context.sizes.iconMd),
          CommonSpacer.horizontal(sp.sm),
          Expanded(
            child: Text(
              message,
              style: tx.body.copyWith(
                color: c.error,
                fontWeight: tx.bodyMedium.fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Page for setting a new password after clicking a reset link.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/set_new_password_controller.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../../common/inputs/input_field.dart';

/// Page for setting a new password after clicking a reset link.
///
/// Users must be authenticated via the recovery link before accessing this page.
/// After successfully updating the password, users are redirected to login.
class SetNewPasswordPage extends ConsumerStatefulWidget {
  const SetNewPasswordPage({super.key});
  @override
  ConsumerState<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends ConsumerState<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final c = context.colors;
    final ok = await ref
        .read(setNewPasswordControllerProvider.notifier)
        .submitNewPassword(_passwordController.text);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password updated successfully! Please log in.'),
          backgroundColor: c.success,
        ),
      );
      context.go('/login_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;

    final flow = ref.watch(setNewPasswordControllerProvider);

    // Show error state if no session
    if (!flow.hasValidSession) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          backgroundColor: c.transparent,
          elevation: context.sizes.elevationNone,
          title: Text('Reset Password', style: TextStyle(color: c.textPrimary)),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(sp.lg),
            child: Column(
              mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
              children: [
                Container(
                  width: 100,
                  height: context.sizes.heightSm,
                  decoration: BoxDecoration(
                    color: c.error.withValues(alpha: context.opacities.overlay),
                    shape: context.shapes.boxShapeCircle,
                  ),
                  child: Icon(
                    Icons.link_off_rounded,
                    size: context.sizes.iconXl,
                    color: c.error,
                  ),
                ),
                CommonSpacer.vertical(sp.lg),
                Text(
                  'Link Expired',
                  style: tx.headlineMedium.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                ),
                CommonSpacer.vertical(sp.sm),
                Text(
                  flow.errorMessage ??
                      'Your reset link has expired. Please request a new one.',
                  style: tx.bodyMedium.copyWith(color: c.textSecondary),
                  textAlign: AppLayout.textAlignCenter,
                ),
                CommonSpacer.vertical(sp.xl),
                CommonPrimaryButton(
                  onPressed: () => context.push('/forgot-password'),
                  label: 'Request New Link',
                ),
                CommonSpacer.vertical(sp.md),
                TextButton(
                  onPressed: () => context.go('/login_page'),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: ac.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.transparent,
        elevation: context.sizes.elevationNone,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => context.go('/login_page'),
        ),
        title: Text(
          'Set New Password',
          style: TextStyle(
            color: c.textPrimary,
            fontWeight: tx.bodyBold.fontWeight,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
              children: [
                CommonSpacer.vertical(sp.lg),
                // Icon
                Container(
                  width: 100,
                  height: context.sizes.heightSm,
                  decoration: BoxDecoration(
                    color: ac.primary.withValues(
                      alpha: context.opacities.overlay,
                    ),
                    shape: context.shapes.boxShapeCircle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: context.sizes.iconXl,
                    color: ac.primary,
                  ),
                ),
                CommonSpacer.vertical(sp.xl),
                // Title
                Text(
                  'Create a new password',
                  style: tx.headlineMedium.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                  textAlign: AppLayout.textAlignCenter,
                ),
                CommonSpacer.vertical(sp.sm),
                // Description
                Text(
                  'Your new password must be different from your previous password.',
                  style: tx.bodyMedium.copyWith(
                    color: c.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: AppLayout.textAlignCenter,
                ),
                CommonSpacer.vertical(sp.xl),
                // Error message
                if (flow.errorMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(sp.sm),
                    decoration: BoxDecoration(
                      color: c.error.withValues(
                        alpha: context.opacities.overlay,
                      ),
                      borderRadius: BorderRadius.circular(
                        context.shapes.radiusSm,
                      ),
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
                        CommonSpacer.horizontal(sp.xs),
                        Expanded(
                          child: Text(
                            flow.errorMessage!,
                            style: TextStyle(
                              color: c.error,
                              fontSize: tx.bodySmall.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonSpacer.vertical(sp.md),
                ],
                // Password field
                CommonInputField(
                  controller: _passwordController,
                  enabled: !flow.isSubmitting,
                  obscureText: flow.obscurePassword,
                  textInputAction: TextInputAction.next,
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline, color: c.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      flow.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: c.textSecondary,
                    ),
                    onPressed: () {
                      ref
                          .read(setNewPasswordControllerProvider.notifier)
                          .toggleObscurePassword();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                CommonSpacer.vertical(sp.md),
                // Confirm password field
                CommonInputField(
                  controller: _confirmPasswordController,
                  enabled: !flow.isSubmitting,
                  obscureText: flow.obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline, color: c.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      flow.obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: c.textSecondary,
                    ),
                    onPressed: () {
                      ref
                          .read(setNewPasswordControllerProvider.notifier)
                          .toggleObscureConfirmPassword();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                CommonSpacer.vertical(sp.lg),
                // Submit button
                CommonPrimaryButton(
                  onPressed: _handleSubmit,
                  label: 'Update Password',
                  isLoading: flow.isSubmitting,
                ),
                CommonSpacer.vertical(sp.lg),
                // Password requirements
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _passwordController,
                    _confirmPasswordController,
                  ]),
                  builder: (context, _) {
                    return Container(
                      padding: EdgeInsets.all(sp.md),
                      decoration: BoxDecoration(
                        color: ac.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(
                          context.shapes.radiusMd,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            'Password requirements:',
                            style: tx.bodySmall.copyWith(
                              fontWeight: tx.bodyBold.fontWeight,
                              color: c.textPrimary,
                            ),
                          ),
                          CommonSpacer.vertical(sp.xs),
                          _buildRequirement(
                            context,
                            'At least 6 characters',
                            _passwordController.text.length >= 6,
                          ),
                          _buildRequirement(
                            context,
                            'Passwords match',
                            _passwordController.text.isNotEmpty &&
                                _passwordController.text ==
                                    _confirmPasswordController.text,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, String text, bool met) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    final color = met ? c.success : c.textSecondary;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: context.sizes.iconSm,
            color: color,
          ),
          CommonSpacer.horizontal(sp.xs),
          Text(text, style: tx.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

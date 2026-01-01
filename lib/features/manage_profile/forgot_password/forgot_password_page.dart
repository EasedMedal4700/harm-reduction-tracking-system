// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only forgot password screen. Emits intent to controller.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import '../../../common/layout/common_spacer.dart';
import 'forgot_password_controller.dart';
import 'forgot_password_state.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final nav = ref.read(navigationProvider);
    final state = ref.watch(forgotPasswordControllerProvider);
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    // Listen for error side-effects
    ref.listen<ForgotPasswordState>(forgotPasswordControllerProvider, (
      previous,
      next,
    ) {
      if (next.status == ForgotPasswordStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: c.error),
        );
      }
    });
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.transparent,
        elevation: context.sizes.elevationNone,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => nav.pop(),
        ),
        title: Text('Reset Password', style: tx.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.xl),
          child: state.status == ForgotPasswordStatus.success
              ? _SuccessContent(
                  email: state.email ?? '',
                  onTryAgain: controller.reset,
                  onBackToLogin: () => nav.replace(AppRoutePaths.login),
                )
              : _FormContent(
                  formKey: _formKey,
                  emailController: _emailController,
                  isSubmitting: state.status == ForgotPasswordStatus.submitting,
                  onSubmit: () {
                    if (_formKey.currentState!.validate()) {
                      controller.sendResetEmail(_emailController.text.trim());
                    }
                  },
                  onBack: () => nav.pop(),
                ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Form content
/// ---------------------------------------------------------------------------
class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.formKey,
    required this.emailController,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onBack,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    final sh = context.shapes;
    final ac = context.accent;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
        children: [
          SizedBox(height: sp.xl2),
          // Icon
          Container(
            width: context.sizes.icon2xl,
            height: context.sizes.icon2xl,
            decoration: BoxDecoration(
              color: ac.primary.withValues(alpha: context.opacities.overlay),
              shape: sh.boxShapeCircle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              size: context.sizes.iconXl,
              color: ac.primary,
            ),
          ),
          SizedBox(height: sp.xl2),
          Text(
            'Forgot your password?',
            style: tx.headlineMedium.copyWith(color: c.textPrimary),
            textAlign: AppLayout.textAlignCenter,
          ),
          SizedBox(height: sp.md),
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: tx.bodyMedium.copyWith(color: c.textSecondary),
            textAlign: AppLayout.textAlignCenter,
          ),
          SizedBox(height: sp.xl2),
          // Email input
          Container(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(sh.radiusMd),
              border: Border.all(color: c.border),
            ),
            child: TextFormField(
              controller: emailController,
              enabled: !isSubmitting,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              style: TextStyle(color: c.textPrimary),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: c.textSecondary),
                prefixIcon: Icon(Icons.email_outlined, color: c.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: sp.lg,
                  vertical: sp.lg,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: sp.xl),
          // Submit button
          SizedBox(
            height: context.sizes.buttonHeightLg,
            child: Semantics(
              button: true,
              enabled: !isSubmitting,
              label: isSubmitting ? 'Sending reset link' : 'Send Reset Link',
              child: ElevatedButton(
                onPressed: () {
                  if (!isSubmitting) onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ac.primary,
                  foregroundColor: c.textInverse,
                  disabledBackgroundColor: ac.primary.withValues(
                    alpha: context.opacities.slow,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                ),
                child: isSubmitting
                    ? SizedBox(
                        width: context.sizes.iconMd,
                        height: context.sizes.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: context.borders.medium,
                          color: c.textInverse,
                        ),
                      )
                    : Text(
                        'Send Reset Link',
                        style: tx.labelLarge.copyWith(
                          fontWeight: tx.bodyBold.fontWeight,
                          color: c.textInverse,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: sp.lg),
          TextButton(
            onPressed: onBack,
            child: Text(
              'Back to Login',
              style: tx.labelLarge.copyWith(color: ac.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Success content
/// ---------------------------------------------------------------------------
class _SuccessContent extends StatelessWidget {
  const _SuccessContent({
    required this.email,
    required this.onTryAgain,
    required this.onBackToLogin,
  });
  final String email;
  final VoidCallback onTryAgain;
  final VoidCallback onBackToLogin;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
      children: [
        SizedBox(height: sp.xl2),
        // Success icon
        Container(
          width: context.sizes.icon2xl,
          height: context.sizes.icon2xl,
          decoration: BoxDecoration(
            color: c.success.withValues(alpha: context.opacities.overlay),
            shape: sh.boxShapeCircle,
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: context.sizes.iconXl,
            color: c.success,
          ),
        ),
        CommonSpacer.vertical(sp.xl2),
        Text(
          'Check your email',
          style: tx.headlineMedium.copyWith(color: c.textPrimary),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.md),
        Text(
          'We\'ve sent a password reset link to:',
          style: tx.bodyMedium.copyWith(color: c.textSecondary),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.sm),
        Text(
          email,
          style: tx.bodyMedium.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),
        CommonSpacer.vertical(sp.xl),
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: ac.primary.withValues(alpha: context.opacities.overlay),
            borderRadius: BorderRadius.circular(sh.radiusMd),
            border: Border.all(
              color: ac.primary.withValues(alpha: context.opacities.medium),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: ac.primary,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                child: Text(
                  'Click the link in the email to reset your password. '
                  'The link expires in 24 hours.',
                  style: tx.bodySmall.copyWith(color: ac.primary),
                ),
              ),
            ],
          ),
        ),
        CommonSpacer.vertical(sp.xl2),
        SizedBox(
          height: context.sizes.buttonHeightLg,
          child: ElevatedButton(
            onPressed: onBackToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: ac.primary,
              foregroundColor: c.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
              ),
            ),
            child: Text(
              'Back to Login',
              style: tx.labelLarge.copyWith(
                fontWeight: tx.bodyBold.fontWeight,
                color: c.textInverse,
              ),
            ),
          ),
        ),
        CommonSpacer.vertical(sp.lg),
        TextButton(
          onPressed: onTryAgain,
          child: Text(
            'Didn\'t receive the email? Try again',
            style: tx.labelLarge.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

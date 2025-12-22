// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED (TODO: replace Navigator calls)
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only forgot password screen. Emits intent to controller.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: context.colors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.transparent,
        elevation: context.sizes.elevationNone,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reset Password', style: context.text.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing.xl),
          child: state.status == ForgotPasswordStatus.success
              ? _SuccessContent(
                  email: state.email ?? '',
                  onTryAgain: controller.reset,
                  onBackToLogin: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login_page', (route) => false);
                  },
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
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final a = context.accent;

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
              color: a.primary.withValues(alpha: context.opacities.overlay),
              shape: context.shapes.boxShapeCircle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              size: context.sizes.iconXl,
              color: a.primary,
            ),
          ),

          SizedBox(height: sp.xl2),

          Text(
            'Forgot your password?',
            style: text.headlineMedium.copyWith(color: c.textPrimary),
            textAlign: AppLayout.textAlignCenter,
          ),

          SizedBox(height: sp.md),

          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: text.bodyMedium.copyWith(color: c.textSecondary),
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
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: a.primary,
                foregroundColor: c.textInverse,
                disabledBackgroundColor: a.primary.withValues(
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
                      style: text.labelLarge.copyWith(
                        fontWeight: text.bodyBold.fontWeight,
                        color: c.textInverse,
                      ),
                    ),
            ),
          ),

          SizedBox(height: sp.lg),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to Login',
              style: text.labelLarge.copyWith(color: a.primary),
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
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final a = context.accent;

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
            shape: context.shapes.boxShapeCircle,
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
          style: text.headlineMedium.copyWith(color: c.textPrimary),
          textAlign: AppLayout.textAlignCenter,
        ),

        CommonSpacer.vertical(sp.md),

        Text(
          'We\'ve sent a password reset link to:',
          style: text.bodyMedium.copyWith(color: c.textSecondary),
          textAlign: AppLayout.textAlignCenter,
        ),

        CommonSpacer.vertical(sp.sm),

        Text(
          email,
          style: text.bodyMedium.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),

        CommonSpacer.vertical(sp.xl),

        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: a.primary.withValues(alpha: context.opacities.overlay),
            borderRadius: BorderRadius.circular(sh.radiusMd),
            border: Border.all(
              color: a.primary.withValues(alpha: context.opacities.medium),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: a.primary,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                child: Text(
                  'Click the link in the email to reset your password. '
                  'The link expires in 24 hours.',
                  style: text.bodySmall.copyWith(color: a.primary),
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
              backgroundColor: a.primary,
              foregroundColor: c.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sh.radiusMd),
              ),
            ),
            child: Text(
              'Back to Login',
              style: text.labelLarge.copyWith(
                fontWeight: text.bodyBold.fontWeight,
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
            style: text.labelLarge.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/layout/common_spacer.dart';

/// Page for requesting a password reset email.
///
/// Users enter their email address and receive a reset link via email.
/// The link redirects to [SetNewPasswordPage] using deep linking.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        redirectTo: 'substancecheck://reset-password',
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _emailSent = true;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: text.headlineSmall.copyWith(
            color: c.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.xl),
          child: _emailSent ? _buildSuccessContent(context) : _buildFormContent(context),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: sp.xl2),
          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: a.primary.withValues(alpha: context.opacities.overlay),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              size: context.sizes.iconXl,
              color: a.primary,
            ),
          ),
          SizedBox(height: sp.xl2),
          // Title
          Text(
            'Forgot your password?',
            style: text.headlineMedium.copyWith(
              color: c.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: sp.md),
          // Description
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: text.bodyMedium.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: sp.xl2),
          // Email field
          Container(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(sh.radiusMd),
              border: Border.all(
                color: c.border,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
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
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: a.primary,
                foregroundColor: c.textInverse,
                disabledBackgroundColor: a.primary.withValues(alpha: context.opacities.slow),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: context.borders.medium,
                        color: c.textInverse,
                      ),
                    )
                  : Text(
                      'Send Reset Link',
                      style: text.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textInverse,
                      ),
                    ),
            ),
          ),
          SizedBox(height: sp.lg),
          // Back to login
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to Login',
              style: text.labelLarge.copyWith(
                color: a.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: sp.xl2), // Approximate space48
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: c.success.withValues(alpha: context.opacities.overlay),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: context.sizes.iconXl,
            color: c.success,
          ),
        ),
        CommonSpacer.vertical(sp.xl2),
        // Title
        Text(
          'Check your email',
          style: text.headlineMedium.copyWith(
            color: c.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        CommonSpacer.vertical(sp.md),
        // Description
        Text(
          'We\'ve sent a password reset link to:',
          style: text.bodyMedium.copyWith(
            color: c.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        CommonSpacer.vertical(sp.sm),
        Text(
          _emailController.text.trim(),
          style: text.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        CommonSpacer.vertical(sp.xl),
        // Info box
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
                  style: text.bodySmall.copyWith(
                    color: a.primary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        CommonSpacer.vertical(sp.xl2),
        // Back to login button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/login_page',
              (route) => false,
            ),
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
                fontWeight: FontWeight.w600,
                color: c.textInverse,
              ),
            ),
          ),
        ),
        CommonSpacer.vertical(sp.lg),
        // Resend link
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            'Didn\'t receive the email? Try again',
            style: text.labelLarge.copyWith(
              color: c.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}





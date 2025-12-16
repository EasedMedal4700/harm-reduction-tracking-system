import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



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
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final primaryColor =
        isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final textSecondaryColor =
        isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: textColor,
            fontWeight: ThemeConstants.fontSemiBold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ThemeConstants.space24),
          child: _emailSent ? _buildSuccessContent(
            primaryColor: primaryColor,
            textColor: textColor,
            textSecondaryColor: textSecondaryColor,
          ) : _buildFormContent(
            surfaceColor: surfaceColor,
            primaryColor: primaryColor,
            textColor: textColor,
            textSecondaryColor: textSecondaryColor,
            isDark: isDark,
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent({
    required Color surfaceColor,
    required Color primaryColor,
    required Color textColor,
    required Color textSecondaryColor,
    required bool isDark,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: ThemeConstants.space32),
          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              size: 48,
              color: primaryColor,
            ),
          ),
          SizedBox(height: ThemeConstants.space32),
          // Title
          Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: ThemeConstants.font2XLarge,
              fontWeight: ThemeConstants.fontBold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ThemeConstants.space12),
          // Description
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ThemeConstants.space32),
          // Email field
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: textSecondaryColor),
                prefixIcon: Icon(Icons.email_outlined, color: textSecondaryColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space16,
                  vertical: ThemeConstants.space16,
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
          SizedBox(height: ThemeConstants.space24),
          // Submit button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          // Back to login
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to Login',
              style: TextStyle(
                color: primaryColor,
                fontWeight: ThemeConstants.fontMediumWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent({
    required Color primaryColor,
    required Color textColor,
    required Color textSecondaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: ThemeConstants.space48),
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: UIColors.lightAccentGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 48,
            color: UIColors.lightAccentGreen,
          ),
        ),
        SizedBox(height: ThemeConstants.space32),
        // Title
        Text(
          'Check your email',
          style: TextStyle(
            fontSize: ThemeConstants.font2XLarge,
            fontWeight: ThemeConstants.fontBold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ThemeConstants.space12),
        // Description
        Text(
          'We\'ve sent a password reset link to:',
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            color: textSecondaryColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ThemeConstants.space8),
        Text(
          _emailController.text.trim(),
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            fontWeight: ThemeConstants.fontSemiBold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ThemeConstants.space24),
        // Info box
        Container(
          padding: EdgeInsets.all(ThemeConstants.space16),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: primaryColor,
                size: ThemeConstants.iconMedium,
              ),
              SizedBox(width: ThemeConstants.space12),
              Expanded(
                child: Text(
                  'Click the link in the email to reset your password. '
                  'The link expires in 24 hours.',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    color: primaryColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ThemeConstants.space32),
        // Back to login button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/login_page',
              (route) => false,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
              ),
            ),
            child: const Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: ThemeConstants.space16),
        // Resend link
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            'Didn\'t receive the email? Try again',
            style: TextStyle(
              color: textSecondaryColor,
              fontWeight: ThemeConstants.fontMediumWeight,
            ),
          ),
        ),
      ],
    );
  }
}





import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



/// Page for setting a new password after clicking a reset link.
///
/// Users must be authenticated via the recovery link before accessing this page.
/// After successfully updating the password, users are redirected to login.
class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Check if user has a valid session from the recovery link
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Your reset link has expired. Please request a new one.';
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      // Sign out to clear the recovery session
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully! Please log in.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login_page',
        (route) => false,
      );
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'An error occurred. Please try again.';
        });
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

    // Show error state if no session
    if (_errorMessage != null && Supabase.instance.client.auth.currentSession == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Reset Password',
            style: TextStyle(color: textColor),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ThemeConstants.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: UIColors.lightAccentRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.link_off_rounded,
                    size: 48,
                    color: UIColors.lightAccentRed,
                  ),
                ),
                SizedBox(height: ThemeConstants.space24),
                Text(
                  'Link Expired',
                  style: TextStyle(
                    fontSize: ThemeConstants.font2XLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: ThemeConstants.space12),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    color: textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeConstants.space32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
                      ),
                    ),
                    child: const Text('Request New Link'),
                  ),
                ),
                SizedBox(height: ThemeConstants.space16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login_page',
                    (route) => false,
                  ),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/login_page',
            (route) => false,
          ),
        ),
        title: Text(
          'Set New Password',
          style: TextStyle(
            color: textColor,
            fontWeight: ThemeConstants.fontSemiBold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ThemeConstants.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ThemeConstants.space24),
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 48,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: ThemeConstants.space32),
                // Title
                Text(
                  'Create a new password',
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
                  'Your new password must be different from your previous password.',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    color: textSecondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeConstants.space32),
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(ThemeConstants.space12),
                    decoration: BoxDecoration(
                      color: UIColors.lightAccentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                      border: Border.all(
                        color: UIColors.lightAccentRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: UIColors.lightAccentRed,
                          size: 20,
                        ),
                        SizedBox(width: ThemeConstants.space8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: UIColors.lightAccentRed,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ThemeConstants.space16),
                ],
                // Password field
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
                    border: Border.all(
                      color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    ),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    enabled: !_isSubmitting,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: textSecondaryColor),
                      prefixIcon: Icon(Icons.lock_outline, color: textSecondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: textSecondaryColor,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space16,
                        vertical: ThemeConstants.space16,
                      ),
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
                ),
                SizedBox(height: ThemeConstants.space16),
                // Confirm password field
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
                    border: Border.all(
                      color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    ),
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    enabled: !_isSubmitting,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSubmit(),
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: textSecondaryColor),
                      prefixIcon: Icon(Icons.lock_outline, color: textSecondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: textSecondaryColor,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space16,
                        vertical: ThemeConstants.space16,
                      ),
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
                            'Update Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: ThemeConstants.space24),
                // Password requirements
                Container(
                  padding: EdgeInsets.all(ThemeConstants.space16),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password requirements:',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          fontWeight: ThemeConstants.fontSemiBold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: ThemeConstants.space8),
                      _buildRequirement(
                        'At least 6 characters',
                        _passwordController.text.length >= 6,
                        textSecondaryColor,
                      ),
                      _buildRequirement(
                        'Passwords match',
                        _passwordController.text.isNotEmpty &&
                            _passwordController.text == _confirmPasswordController.text,
                        textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool met, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ThemeConstants.space4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: met ? UIColors.lightAccentGreen : textColor,
          ),
          SizedBox(width: ThemeConstants.space8),
          Text(
            text,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: met ? UIColors.lightAccentGreen : textColor,
            ),
          ),
        ],
      ),
    );
  }
}





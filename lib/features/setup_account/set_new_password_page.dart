import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/buttons/common_primary_button.dart';
import '../../common/inputs/input_field.dart';

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
    final c = context.colors;
    final a = context.accent;
    final text = context.text;
    final sp = context.spacing;

    // Show error state if no session
    if (_errorMessage != null && Supabase.instance.client.auth.currentSession == null) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Reset Password',
            style: TextStyle(color: c.textPrimary),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(sp.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: c.error.withValues(alpha: context.opacities.overlay),
                    shape: BoxShape.circle,
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
                  style: text.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                ),
                CommonSpacer.vertical(sp.sm),
                Text(
                  _errorMessage!,
                  style: text.bodyMedium.copyWith(
                    color: c.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                CommonSpacer.vertical(sp.xl),
                CommonPrimaryButton(
                  onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                  label: 'Request New Link',
                ),
                CommonSpacer.vertical(sp.md),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login_page',
                    (route) => false,
                  ),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: a.primary),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/login_page',
            (route) => false,
          ),
        ),
        title: Text(
          'Set New Password',
          style: TextStyle(
            color: c.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommonSpacer.vertical(sp.lg),
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: a.primary.withValues(alpha: context.opacities.overlay),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: context.sizes.iconXl,
                    color: a.primary,
                  ),
                ),
                CommonSpacer.vertical(sp.xl),
                // Title
                Text(
                  'Create a new password',
                  style: text.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                CommonSpacer.vertical(sp.sm),
                // Description
                Text(
                  'Your new password must be different from your previous password.',
                  style: text.bodyMedium.copyWith(
                    color: c.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                CommonSpacer.vertical(sp.xl),
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: EdgeInsets.all(sp.sm),
                    decoration: BoxDecoration(
                      color: c.error.withValues(alpha: context.opacities.overlay),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: c.error.withValues(alpha: context.opacities.medium),
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
                            _errorMessage!,
                            style: TextStyle(
                              color: c.error,
                              fontSize: 14,
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
                  enabled: !_isSubmitting,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline, color: c.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: c.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
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
                  enabled: !_isSubmitting,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline, color: c.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: c.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
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
                  isLoading: _isSubmitting,
                ),
                CommonSpacer.vertical(sp.lg),
                // Password requirements
                Container(
                  padding: EdgeInsets.all(sp.md),
                  decoration: BoxDecoration(
                    color: a.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password requirements:',
                        style: text.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
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
                            _passwordController.text == _confirmPasswordController.text,
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

  Widget _buildRequirement(BuildContext context, String text, bool met) {
    final c = context.colors;
    final sp = context.spacing;
    final textStyle = context.text;
    final color = met ? Colors.green : c.textSecondary;

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
          Text(
            text,
            style: textStyle.bodySmall.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}





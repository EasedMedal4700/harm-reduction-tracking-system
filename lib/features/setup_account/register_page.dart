import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/core_providers.dart';
import '../../services/onboarding_service.dart';
import '../../common/inputs/input_field.dart';
import '../../common/buttons/common_primary_button.dart';
import '../../common/layout/common_spacer.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _onboardingService = OnboardingService();

  bool _isSubmitting = false;
  bool _privacyAccepted = false;
  bool _isCheckingOnboarding = true;
  bool _onboardingComplete = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final isOnboardingComplete = await _onboardingService
        .isOnboardingComplete();
    final isPrivacyAccepted = await _onboardingService
        .isPrivacyPolicyAccepted();

    if (mounted) {
      setState(() {
        _onboardingComplete = isOnboardingComplete;
        _privacyAccepted = isPrivacyAccepted;
        _isCheckingOnboarding = false;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await ref
        .read(authServiceProvider)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
        );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
    final t = context.text;
    final sp = context.spacing;

    if (_isCheckingOnboarding) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Redirect to onboarding if not complete
    if (!_onboardingComplete) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: Padding(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              Icon(
                Icons.info_outline,
                size: context.sizes.icon2xl,
                color: c.textTertiary,
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Complete Onboarding First',
                style: t.headlineSmall.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Please complete the onboarding process before creating an account. '
                'This helps us personalize your experience.',
                textAlign: AppLayout.textAlignCenter,
                style: t.bodyLarge,
              ),
              CommonSpacer.vertical(sp.xl),
              CommonPrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                },
                icon: Icons.arrow_forward,
                label: 'Go to Onboarding',
              ),
            ],
          ),
        ),
      );
    }

    // Check privacy policy accepted
    if (!_privacyAccepted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: Padding(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              Icon(Icons.policy, size: context.sizes.icon2xl, color: a.primary),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Accept Privacy Policy',
                style: t.headlineSmall.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'You need to accept the privacy policy before creating an account. '
                'Please complete the onboarding process.',
                textAlign: AppLayout.textAlignCenter,
                style: t.bodyLarge,
              ),
              CommonSpacer.vertical(sp.xl),
              CommonPrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                },
                icon: Icons.arrow_forward,
                label: 'Go to Onboarding',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: EdgeInsets.all(sp.md),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CommonInputField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              CommonSpacer.vertical(sp.sm),
              CommonInputField(
                controller: _displayNameController,
                labelText: 'Display name (optional)',
              ),
              CommonSpacer.vertical(sp.sm),
              CommonInputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Use at least 6 characters';
                  }
                  return null;
                },
              ),
              CommonSpacer.vertical(sp.sm),
              CommonInputField(
                controller: _confirmPasswordController,
                labelText: 'Confirm password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              CommonSpacer.vertical(sp.lg),
              CommonPrimaryButton(
                onPressed: _handleRegister,
                label: 'Create account',
                isLoading: _isSubmitting,
                isEnabled: !_isSubmitting,
                width: double.infinity,
              ),
              CommonSpacer.vertical(sp.md),
              TextButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Already have an account? Log in'),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login_page');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

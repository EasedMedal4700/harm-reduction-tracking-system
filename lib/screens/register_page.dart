import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import '../services/auth_service.dart';
import '../services/onboarding_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _authService = AuthService();
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
    final isOnboardingComplete = await _onboardingService.isOnboardingComplete();
    final isPrivacyAccepted = await _onboardingService.isPrivacyPolicyAccepted();
    
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

    final result = await _authService.register(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: c.textTertiary,
              ),
              SizedBox(height: sp.lg),
              Text(
                'Complete Onboarding First',
                style: t.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.md),
              Text(
                'Please complete the onboarding process before creating an account. '
                'This helps us personalize your experience.',
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
              SizedBox(height: sp.xl),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Onboarding'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.lg,
                    vertical: sp.sm,
                  ),
                ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.policy,
                size: 64,
                color: a.primary,
              ),
              SizedBox(height: sp.lg),
              Text(
                'Accept Privacy Policy',
                style: t.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.md),
              Text(
                'You need to accept the privacy policy before creating an account. '
                'Please complete the onboarding process.',
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
              SizedBox(height: sp.xl),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Onboarding'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.lg,
                    vertical: sp.sm,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(sp.md),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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
              SizedBox(height: sp.sm),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display name (optional)',
                ),
              ),
              SizedBox(height: sp.sm),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
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
              SizedBox(height: sp.sm),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm password'),
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
              SizedBox(height: sp.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create account'),
                ),
              ),
              SizedBox(height: sp.md),
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

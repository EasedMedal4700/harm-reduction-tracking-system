import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/register_controller.dart';
import '../../../common/inputs/input_field.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../../common/layout/common_spacer.dart';

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
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await ref.read(registerControllerProvider.notifier).submitRegister(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
        );
    if (!mounted) return;
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final registerAsync = ref.watch(registerControllerProvider);

    return registerAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: Padding(
          padding: EdgeInsets.all(sp.lg),
          child: Center(
            child: Text(
              'Failed to load onboarding status.\n$e',
              textAlign: AppLayout.textAlignCenter,
              style: tx.bodyMedium.copyWith(color: c.textSecondary),
            ),
          ),
        ),
      ),
      data: (registerState) {
        // Redirect to onboarding if not complete
        if (!registerState.onboardingComplete) {
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
                style: tx.headlineSmall.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Please complete the onboarding process before creating an account. '
                'This helps us personalize your experience.',
                textAlign: AppLayout.textAlignCenter,
                style: tx.bodyLarge,
              ),
              CommonSpacer.vertical(sp.xl),
              CommonPrimaryButton(
                onPressed: () {
                  context.go('/onboarding');
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
    if (!registerState.privacyAccepted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: Padding(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              Icon(
                Icons.policy,
                size: context.sizes.icon2xl,
                color: ac.primary,
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Accept Privacy Policy',
                style: tx.headlineSmall.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'You need to accept the privacy policy before creating an account. '
                'Please complete the onboarding process.',
                textAlign: AppLayout.textAlignCenter,
                style: tx.bodyLarge,
              ),
              CommonSpacer.vertical(sp.xl),
              CommonPrimaryButton(
                onPressed: () {
                  context.go('/onboarding');
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
                isLoading: registerState.isSubmitting,
                isEnabled: !registerState.isSubmitting,
                width: double.infinity,
              ),
              CommonSpacer.vertical(sp.md),
              TextButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Already have an account? Log in'),
                onPressed: () {
                  context.go('/login_page');
                },
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

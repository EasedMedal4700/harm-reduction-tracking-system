// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED (TODO: replace Navigator calls)
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI only. All logic moved to controller/router.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../common/inputs/input_field.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../../common/layout/common_spacer.dart';
import 'login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final sf = context.surfaces;
    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppLayout.authCardMaxWidth),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusLg),
                boxShadow: context.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header strip
                  Container(
                    height: AppLayout.authHeaderHeight,
                    decoration: sf.authHeader.copyWith(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(sh.radiusLg),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(sp.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Welcome back',
                          style: tx.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        CommonSpacer.vertical(sp.sm),
                        Text(
                          'Sign in to continue',
                          style: tx.bodyMedium.copyWith(color: c.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        CommonSpacer.vertical(sp.xl),
                        // Email
                        CommonInputField(
                          controller: emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CommonSpacer.vertical(sp.md),
                        // Password
                        CommonInputField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true,
                        ),
                        CommonSpacer.vertical(sp.sm),
                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO(navigation): replace with NavigationService
                              Navigator.of(
                                context,
                              ).pushNamed('/forgot_password');
                            },
                            child: Text(
                              'Forgot password?',
                              style: tx.labelLarge.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        CommonSpacer.vertical(sp.sm),
                        // Remember me
                        CheckboxListTile(
                          value: state.rememberMe,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Keep me logged in',
                            style: tx.bodyMedium,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) =>
                              controller.toggleRememberMe(v ?? false),
                        ),
                        CommonSpacer.vertical(sp.lg),
                        // Primary CTA
                        CommonPrimaryButton(
                          isLoading: state.isLoading,
                          label: 'Sign in',
                          onPressed: () => controller.submitLogin(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        ),
                        // Error message
                        if (state.errorMessage != null) ...[
                          CommonSpacer.vertical(sp.md),
                          Text(
                            state.errorMessage!,
                            style: tx.bodyMedium.copyWith(color: c.error),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        CommonSpacer.vertical(sp.lg),
                        // Sign up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account?',
                              style: tx.bodyMedium.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO(navigation): replace with NavigationService
                                Navigator.of(context).pushNamed('/signup');
                              },
                              child: Text(
                                'Sign up',
                                style: tx.labelLarge.copyWith(
                                  color: context.accent.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

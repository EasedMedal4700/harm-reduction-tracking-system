// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI only. All logic moved to controller/router.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';

import '../../../../common/inputs/input_field.dart';
import '../../../../common/buttons/common_primary_button.dart';
import '../../../../common/layout/common_spacer.dart';
import '../controller/login_controller.dart';

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
    final t = context.text;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('Login', style: t.headlineSmall),
        backgroundColor: c.surface,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            CommonInputField(controller: emailController, labelText: 'Email'),
            CommonSpacer.vertical(sp.md),
            CommonInputField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            CheckboxListTile(
              value: state.rememberMe,
              title: const Text('Keep me logged in'),
              onChanged: (v) => controller.toggleRememberMe(v ?? false),
            ),
            CommonSpacer.vertical(sp.xl),
            CommonPrimaryButton(
              isLoading: state.isLoading,
              label: 'Login',
              onPressed: () => controller.submitLogin(
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
            if (state.errorMessage != null) ...[
              CommonSpacer.vertical(sp.md),
              Text(
                state.errorMessage!,
                style: t.bodyMedium.copyWith(color: c.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

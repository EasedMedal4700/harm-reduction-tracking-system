// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only PIN unlock screen.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/layout/app_layout.dart';
import '../../../common/layout/common_spacer.dart';

import 'pin_unlock_controller.dart';

class PinUnlockScreen extends ConsumerStatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  ConsumerState<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends ConsumerState<PinUnlockScreen> {
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(pinUnlockControllerProvider.notifier).onInit(),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinUnlockControllerProvider);
    final controller = ref.read(pinUnlockControllerProvider.notifier);

    final c = context.colors;
    final t = context.text;
    final sp = context.spacing;

    if (state.isCheckingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            TextField(
              controller: _pinController,
              obscureText: state.pinObscured,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: controller.submitPin,
            ),

            if (state.errorMessage != null) ...[
              CommonSpacer.vertical(sp.md),
              Text(
                state.errorMessage!,
                style: t.bodyMedium.copyWith(color: c.error),
              ),
            ],

            CommonSpacer.vertical(sp.lg),

            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => controller.submitPin(_pinController.text),
              child: const Text('Unlock'),
            ),

            if (state.biometricsAvailable)
              TextButton(
                onPressed: state.isLoading
                    ? null
                    : controller.unlockWithBiometrics,
                child: const Text('Use biometrics'),
              ),

            TextButton(
              onPressed: controller.openRecoveryKey,
              child: const Text('Forgot PIN?'),
            ),
          ],
        ),
      ),
    );
  }
}

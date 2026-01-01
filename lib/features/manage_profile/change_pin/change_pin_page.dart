// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Pure UI for Change PIN flow. No business logic.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/layout/app_layout.dart';
import '../../../common/layout/common_spacer.dart';
import 'change_pin_controller.dart';

class ChangePinPage extends ConsumerStatefulWidget {
  const ChangePinPage({super.key});
  @override
  ConsumerState<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends ConsumerState<ChangePinPage> {
  // UI-only state (allowed)
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _oldPinObscure = true;
  bool _newPinObscure = true;
  bool _confirmPinObscure = true;
  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePinControllerProvider);
    final controller = ref.read(changePinControllerProvider.notifier);
    final tx = context.text;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    if (state.success) {
      return _SuccessView(onDone: controller.close);
    }
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('Change PIN'),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
          children: [
            Icon(
              Icons.lock_reset,
              size: context.sizes.icon2xl,
              color: ac.primary,
            ),
            CommonSpacer.vertical(sp.xl),
            Text(
              'Change Your PIN',
              style: tx.headlineMedium,
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.md),
            Text(
              'Your encrypted data stays intact. Only the PIN changes.',
              style: tx.bodyMedium.copyWith(color: c.textSecondary),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.xl),
            _PinField(
              label: 'Current PIN',
              controller: _oldPinController,
              obscure: _oldPinObscure,
              onToggle: () => setState(() => _oldPinObscure = !_oldPinObscure),
            ),
            CommonSpacer.vertical(sp.lg),
            _PinField(
              label: 'New PIN',
              controller: _newPinController,
              obscure: _newPinObscure,
              onToggle: () => setState(() => _newPinObscure = !_newPinObscure),
            ),
            CommonSpacer.vertical(sp.lg),
            _PinField(
              label: 'Confirm New PIN',
              controller: _confirmPinController,
              obscure: _confirmPinObscure,
              onToggle: () =>
                  setState(() => _confirmPinObscure = !_confirmPinObscure),
            ),
            if (state.errorMessage != null) ...[
              CommonSpacer.vertical(sp.lg),
              Text(
                state.errorMessage!,
                style: tx.bodyMedium.copyWith(color: c.error),
              ),
            ],
            CommonSpacer.vertical(sp.xl2),
            SizedBox(
              height: context.sizes.buttonHeightLg,
              child: Semantics(
                label: state.isLoading
                    ? 'Changing PIN, please wait'
                    : 'Confirm change of PIN',
                button: true,
                enabled: !state.isLoading,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => controller.submit(
                          oldPin: _oldPinController.text,
                          newPin: _newPinController.text,
                          confirmPin: _confirmPinController.text,
                        ),
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Change PIN'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Private widgets
// -----------------------------------------------------------------------------
class _PinField extends StatelessWidget {
  const _PinField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(label, style: tx.labelMedium),
        CommonSpacer.vertical(sp.sm),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
                color: c.textSecondary,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onDone});
  final VoidCallback onDone;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            Icon(Icons.check_circle, size: 96, color: c.success),
            CommonSpacer.vertical(sp.xl),
            Text(
              'PIN changed successfully',
              style: tx.headlineMedium,
              textAlign: TextAlign.center,
            ),
            CommonSpacer.vertical(sp.lg),
            Semantics(
              label: 'Close change PIN success screen',
              button: true,
              child: ElevatedButton(
                onPressed: onDone,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

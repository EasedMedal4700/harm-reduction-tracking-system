import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/encryption_service_v2.dart';


/// Screen for changing the user's PIN without regenerating encryption keys
/// 
/// This screen:
/// 1. Validates the current PIN
/// 2. Accepts a new PIN with confirmation
/// 3. Re-wraps the data key (no data re-encryption needed)
class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _encryptionService = EncryptionServiceV2();
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _oldPinObscure = true;
  bool _newPinObscure = true;
  bool _confirmPinObscure = true;
  bool _success = false;

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _changePIN() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final oldPin = _oldPinController.text;
      final newPin = _newPinController.text;
      final confirmPin = _confirmPinController.text;

      // Validation
      if (oldPin.length != 6) {
        throw Exception('Current PIN must be exactly 6 digits');
      }
      if (newPin.length != 6) {
        throw Exception('New PIN must be exactly 6 digits');
      }
      if (newPin != confirmPin) {
        throw Exception('New PINs do not match');
      }
      if (oldPin == newPin) {
        throw Exception('New PIN must be different from current PIN');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Change PIN - this re-wraps the data key without regenerating it
      final success = await _encryptionService.changePin(
        user.id,
        oldPin,
        newPin,
      );

      if (!success) {
        throw Exception('Current PIN is incorrect');
      }

      setState(() {
        _success = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _goBack() {
    Navigator.of(context).pop(_success); // Return success status
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    if (_success) {
      return _buildSuccessView(context);
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
            // Icon
            Icon(
              Icons.lock_reset,
              size: context.sizes.icon2xl,
              color: a.primary,
            ),
            SizedBox(height: sp.xl),

            // Title
            Text(
              'Change Your PIN',
              style: text.headlineMedium.copyWith(
                color: c.textPrimary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            SizedBox(height: sp.md),

            // Description
            Text(
              'Your encrypted data will remain accessible. Only the PIN used to unlock it will change.',
              style: text.bodyMedium.copyWith(
                color: c.textSecondary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            SizedBox(height: sp.xl),

            // Info box about recovery key
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: a.primary.withValues(alpha: context.opacities.overlay),
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: a.primary.withValues(alpha: context.opacities.medium)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: a.primary, size: context.sizes.iconSm),
                  SizedBox(width: sp.md),
                  Expanded(
                    child: Text(
                      'Your recovery key will not change. Keep using the same one you saved during initial setup.',
                      style: text.bodySmall.copyWith(
                        color: a.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sp.xl),

            // Current PIN
            _buildPinField(
              context: context,
              controller: _oldPinController,
              label: 'Current PIN',
              obscure: _oldPinObscure,
              onToggleObscure: () => setState(() => _oldPinObscure = !_oldPinObscure),
            ),
            SizedBox(height: sp.lg),

            // New PIN
            _buildPinField(
              context: context,
              controller: _newPinController,
              label: 'New PIN',
              obscure: _newPinObscure,
              onToggleObscure: () => setState(() => _newPinObscure = !_newPinObscure),
            ),
            SizedBox(height: sp.lg),

            // Confirm New PIN
            _buildPinField(
              context: context,
              controller: _confirmPinController,
              label: 'Confirm New PIN',
              obscure: _confirmPinObscure,
              onToggleObscure: () => setState(() => _confirmPinObscure = !_confirmPinObscure),
            ),

            // Error message
            if (_errorMessage != null) ...[
              SizedBox(height: sp.lg),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.error.withValues(alpha: context.opacities.overlay),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: c.error.withValues(alpha: context.opacities.medium)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: c.error, size: context.sizes.iconSm),
                    SizedBox(width: sp.md),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: text.bodyMedium.copyWith(color: c.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: sp.xl2),

            // Change PIN button
            SizedBox(
              height: context.sizes.buttonHeightLg,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePIN,
                style: ElevatedButton.styleFrom(
                  backgroundColor: a.primary,
                  foregroundColor: c.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  elevation: context.sizes.elevationSm,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: context.borders.medium,
                          valueColor: AlwaysStoppedAnimation<Color>(c.textInverse),
                        ),
                      )
                    : Text(
                        'Change PIN',
                        style: text.labelLarge.copyWith(
                          fontWeight: text.bodyBold.fontWeight,
                          color: c.textInverse,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            label,
            style: text.labelMedium.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: text.headlineSmall.copyWith(
              letterSpacing: 8,
              color: c.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: '● ● ● ● ● ●',
              counterText: '',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                  color: c.textSecondary,
                ),
                onPressed: onToggleObscure,
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('PIN Changed'),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: c.success,
            ),
            CommonSpacer.vertical(sp.xl2),
            Text(
              'PIN Changed Successfully!',
              style: text.headlineMedium.copyWith(
                color: c.textPrimary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.lg),
            Text(
              'Your new PIN is now active. Use it the next time you need to unlock your data.',
              style: text.bodyMedium.copyWith(
                color: c.textSecondary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.lg),
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: c.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.key, color: c.warning, size: context.sizes.iconSm),
                  CommonSpacer.horizontal(sp.md),
                  Expanded(
                    child: Text(
                      'Remember: Your recovery key has not changed.',
                      style: text.bodySmall.copyWith(
                        color: c.warning,
                        fontWeight: text.bodyMedium.fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _goBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.success,
                  foregroundColor: c.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  elevation: context.sizes.elevationSm,
                ),
                child: Text(
                  'Done',
                  style: text.labelLarge.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                    color: c.textInverse,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/encryption_service_v2.dart';
import '../constants/colors/ui_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    if (_success) {
      return _buildSuccessView(isDark, backgroundColor, surfaceColor, textColor, accentColor);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Change PIN'),
        backgroundColor: surfaceColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.lock_reset,
              size: 64,
              color: accentColor,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Change Your PIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Your encrypted data will remain accessible. Only the PIN used to unlock it will change.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Info box about recovery key
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your recovery key will not change. Keep using the same one you saved during initial setup.',
                      style: TextStyle(
                        color: isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current PIN
            _buildPinField(
              controller: _oldPinController,
              label: 'Current PIN',
              obscure: _oldPinObscure,
              onToggleObscure: () => setState(() => _oldPinObscure = !_oldPinObscure),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
            const SizedBox(height: 16),

            // New PIN
            _buildPinField(
              controller: _newPinController,
              label: 'New PIN',
              obscure: _newPinObscure,
              onToggleObscure: () => setState(() => _newPinObscure = !_newPinObscure),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
            const SizedBox(height: 16),

            // Confirm New PIN
            _buildPinField(
              controller: _confirmPinController,
              label: 'Confirm New PIN',
              obscure: _confirmPinObscure,
              onToggleObscure: () => setState(() => _confirmPinObscure = !_confirmPinObscure),
              isDark: isDark,
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Change PIN button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePIN,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Change PIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: TextStyle(
              fontSize: 24,
              letterSpacing: 8,
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: '● ● ● ● ● ●',
              counterText: '',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
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

  Widget _buildSuccessView(
    bool isDark,
    Color backgroundColor,
    Color surfaceColor,
    Color textColor,
    Color accentColor,
  ) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('PIN Changed'),
        backgroundColor: surfaceColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 32),
            Text(
              'PIN Changed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your new PIN is now active. Use it the next time you need to unlock your data.',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.key, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Remember: Your recovery key has not changed.',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w500,
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
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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



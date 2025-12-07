import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/encryption_service_v2.dart';
import '../constants/deprecated/ui_colors.dart';

/// Screen for unlocking with recovery key and optionally resetting PIN
class RecoveryKeyScreen extends StatefulWidget {
  const RecoveryKeyScreen({super.key});

  @override
  State<RecoveryKeyScreen> createState() => _RecoveryKeyScreenState();
}

class _RecoveryKeyScreenState extends State<RecoveryKeyScreen> {
  final _encryptionService = EncryptionServiceV2();
  final _recoveryKeyController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _keyObscure = true;
  bool _pinObscure = true;
  bool _confirmPinObscure = true;
  
  // Two-step flow: first validate recovery key, then create new PIN
  bool _recoveryKeyValidated = false;
  String _validatedRecoveryKey = '';

  @override
  void dispose() {
    _recoveryKeyController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  /// Step 1: Validate the recovery key
  Future<void> _validateRecoveryKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recoveryKey = _recoveryKeyController.text.trim();

      if (recoveryKey.isEmpty) {
        throw Exception('Please enter your recovery key');
      }

      if (recoveryKey.length != 24) {
        throw Exception('Recovery key must be 24 characters');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Try to unlock with recovery key to validate it
      final success = await _encryptionService.unlockWithRecoveryKey(
        user.id,
        recoveryKey,
      );

      if (success) {
        // Recovery key is valid - move to PIN creation step
        setState(() {
          _recoveryKeyValidated = true;
          _validatedRecoveryKey = recoveryKey;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Invalid recovery key. Please check and try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  /// Step 2: Create new PIN using the validated recovery key
  Future<void> _createNewPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newPin = _newPinController.text.trim();
      final confirmPin = _confirmPinController.text.trim();

      // Validate PIN
      if (newPin.isEmpty) {
        throw Exception('Please enter a new PIN');
      }

      if (newPin.length != 6) {
        throw Exception('PIN must be exactly 6 digits');
      }

      if (!RegExp(r'^\d{6}$').hasMatch(newPin)) {
        throw Exception('PIN must contain only numbers');
      }

      if (newPin != confirmPin) {
        throw Exception('PINs do not match');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Reset PIN using the validated recovery key
      final success = await _encryptionService.resetPinWithRecoveryKey(
        user.id,
        _validatedRecoveryKey,
        newPin,
      );

      if (success) {
        // PIN reset successful - navigate to home
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PIN reset successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacementNamed('/home_page');
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to reset PIN. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(_recoveryKeyValidated ? 'Create New PIN' : 'Recovery Key'),
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: _recoveryKeyValidated 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _recoveryKeyValidated = false;
                  _newPinController.clear();
                  _confirmPinController.clear();
                  _errorMessage = null;
                });
              },
            )
          : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _recoveryKeyValidated 
          ? _buildPinCreationView(isDark, surfaceColor, textColor, accentColor)
          : _buildRecoveryKeyView(isDark, surfaceColor, textColor, accentColor),
      ),
    );
  }

  /// Build the recovery key input view (Step 1)
  Widget _buildRecoveryKeyView(bool isDark, Color surfaceColor, Color textColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Key Icon
        const Icon(
          Icons.vpn_key,
          size: 100,
          color: Colors.amber,
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          'Enter Recovery Key',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          'Enter your recovery key to reset your PIN',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your recovery key is a 24-character hexadecimal code',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Recovery Key Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recovery Key',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _recoveryKeyController,
                obscureText: _keyObscure,
                autocorrect: false,
                enableSuggestions: false,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                  color: textColor,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter your 24-character recovery key',
                  hintStyle: TextStyle(
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _keyObscure ? Icons.visibility : Icons.visibility_off,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                    onPressed: () => setState(() => _keyObscure = !_keyObscure),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 20),
          _buildErrorMessage(),
        ],

        const SizedBox(height: 32),

        // Validate button
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _validateRecoveryKey,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // Back button
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to PIN Unlock'),
          style: TextButton.styleFrom(
            foregroundColor: accentColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  /// Build the PIN creation view (Step 2)
  Widget _buildPinCreationView(bool isDark, Color surfaceColor, Color textColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Lock Icon
        Icon(
          Icons.lock_reset,
          size: 100,
          color: accentColor,
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          'Create New PIN',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          'Recovery key validated! Now create a new 6-digit PIN',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Success indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recovery key verified successfully',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // New PIN Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New PIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPinController,
                obscureText: _pinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: TextStyle(
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                    letterSpacing: 8,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _pinObscure ? Icons.visibility : Icons.visibility_off,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                    onPressed: () => setState(() => _pinObscure = !_pinObscure),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Confirm PIN Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm PIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPinController,
                obscureText: _confirmPinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: TextStyle(
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                    letterSpacing: 8,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPinObscure ? Icons.visibility : Icons.visibility_off,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                    onPressed: () => setState(() => _confirmPinObscure = !_confirmPinObscure),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 20),
          _buildErrorMessage(),
        ],

        const SizedBox(height: 32),

        // Create PIN button
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createNewPin,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
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
                    'Reset PIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

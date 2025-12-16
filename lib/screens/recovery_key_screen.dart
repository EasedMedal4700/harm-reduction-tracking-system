import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../services/encryption_service_v2.dart';

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
    final c = context.colors;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(_recoveryKeyValidated ? 'Create New PIN' : 'Recovery Key'),
        backgroundColor: c.surface,
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
        padding: EdgeInsets.all(sp.lg),
        child: _recoveryKeyValidated 
          ? _buildPinCreationView(context)
          : _buildRecoveryKeyView(context),
      ),
    );
  }

  /// Build the recovery key input view (Step 1)
  Widget _buildRecoveryKeyView(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final t = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: sp.lg),

        // Key Icon
        Icon(
          Icons.vpn_key,
          size: 100,
          color: a.primary,
        ),
        SizedBox(height: sp.xl),

        // Title
        Text(
          'Enter Recovery Key',
          style: t.heading2.copyWith(
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: sp.sm),

        // Description
        Text(
          'Enter your recovery key to reset your PIN',
          style: t.bodyLarge.copyWith(
            color: c.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: sp.xl2),

        // Info box
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: a.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: a.primary.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: a.primary, size: 24),
              SizedBox(width: sp.sm),
              Expanded(
                child: Text(
                  'Your recovery key is a 24-character hexadecimal code',
                  style: t.body.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: sp.lg),

        // Recovery Key Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: c.border,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recovery Key',
                style: t.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: sp.sm),
              TextField(
                controller: _recoveryKeyController,
                obscureText: _keyObscure,
                autocorrect: false,
                enableSuggestions: false,
                style: t.bodyLarge.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                  color: c.textPrimary,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter your 24-character recovery key',
                  hintStyle: TextStyle(
                    color: c.textSecondary,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _keyObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
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
          SizedBox(height: sp.lg),
          _buildErrorMessage(context),
        ],

        SizedBox(height: sp.xl),

        // Validate button
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _validateRecoveryKey,
            style: ElevatedButton.styleFrom(
              backgroundColor: a.primary,
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
                : Text(
                    'Continue',
                    style: t.heading4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        SizedBox(height: sp.lg),

        // Back button
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to PIN Unlock'),
          style: TextButton.styleFrom(
            foregroundColor: a.primary,
            padding: EdgeInsets.symmetric(vertical: sp.md),
          ),
        ),
      ],
    );
  }

  /// Build the PIN creation view (Step 2)
  Widget _buildPinCreationView(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final t = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: sp.lg),

        // Lock Icon
        Icon(
          Icons.lock_reset,
          size: 100,
          color: a.primary,
        ),
        SizedBox(height: sp.xl),

        // Title
        Text(
          'Create New PIN',
          style: t.heading2.copyWith(
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: sp.sm),

        // Description
        Text(
          'Recovery key validated! Now create a new 6-digit PIN',
          style: t.bodyLarge.copyWith(
            color: c.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: sp.xl2),

        // Success indicator
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: sp.sm),
              Expanded(
                child: Text(
                  'Recovery key verified successfully',
                  style: t.body.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: sp.lg),

        // New PIN Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: c.border,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New PIN',
                style: t.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: sp.sm),
              TextField(
                controller: _newPinController,
                obscureText: _pinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: t.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: TextStyle(
                    color: c.textSecondary,
                    letterSpacing: 8,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _pinObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
                    ),
                    onPressed: () => setState(() => _pinObscure = !_pinObscure),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: sp.md),

        // Confirm PIN Input
        Container(
          padding: EdgeInsets.all(sp.lg),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: c.border,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm PIN',
                style: t.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: sp.sm),
              TextField(
                controller: _confirmPinController,
                obscureText: _confirmPinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: t.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '• • • • • •',
                  hintStyle: TextStyle(
                    color: c.textSecondary,
                    letterSpacing: 8,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPinObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
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
          SizedBox(height: sp.lg),
          _buildErrorMessage(context),
        ],

        SizedBox(height: sp.xl),

        // Create PIN button
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createNewPin,
            style: ElevatedButton.styleFrom(
              backgroundColor: a.primary,
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
                : Text(
                    'Reset PIN',
                    style: t.heading4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final t = context.text;
    
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: c.error, size: 24),
          SizedBox(width: sp.sm),
          Expanded(
            child: Text(
              _errorMessage!,
              style: t.body.copyWith(
                color: c.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






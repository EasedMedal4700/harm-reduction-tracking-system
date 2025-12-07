import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/encryption_service_v2.dart';
import '../constants/deprecated/ui_colors.dart';

/// Screen for setting up PIN-based encryption
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _encryptionService = EncryptionServiceV2();
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  
  bool _isLoading = false;
  bool _showRecoveryKey = false;
  String? _recoveryKey;
  String? _errorMessage;
  bool _pin1Obscure = true;
  bool _pin2Obscure = true;

  @override
  void dispose() {
    _pin1Controller.dispose();
    _pin2Controller.dispose();
    super.dispose();
  }

  Future<void> _setupEncryption() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pin1 = _pin1Controller.text;
      final pin2 = _pin2Controller.text;

      // Validation
      if (pin1.length != 6) {
        throw Exception('PIN must be exactly 6 digits');
      }
      if (pin1 != pin2) {
        throw Exception('PINs do not match');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Setup encryption
      final recoveryKey = await _encryptionService.setupNewSecrets(
        user.id,
        pin1,
      );

      setState(() {
        _recoveryKey = recoveryKey;
        _showRecoveryKey = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _enableBiometrics() async {
    try {
      await _encryptionService.enableBiometrics(_pin1Controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint unlock enabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable biometrics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyRecoveryKey() {
    if (_recoveryKey != null) {
      Clipboard.setData(ClipboardData(text: _recoveryKey!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recovery key copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _finishSetup() {
    Navigator.of(context).pushReplacementNamed('/home_page');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    if (_showRecoveryKey) {
      return _buildRecoveryKeyView(
        isDark,
        backgroundColor,
        surfaceColor,
        textColor,
        accentColor,
      );
    }

    return PopScope(
      canPop: false, // Prevent back navigation - user must complete PIN setup
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Setup Encryption'),
          backgroundColor: surfaceColor,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.lock_outline,
              size: 80,
              color: accentColor,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Create Your PIN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Your PIN encrypts all sensitive data. Choose a 6-digit PIN you can remember.',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // PIN 1
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter PIN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pin1Controller,
                    obscureText: _pin1Obscure,
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
                          _pin1Obscure ? Icons.visibility : Icons.visibility_off,
                          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                        ),
                        onPressed: () => setState(() => _pin1Obscure = !_pin1Obscure),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // PIN 2
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
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
                    controller: _pin2Controller,
                    obscureText: _pin2Obscure,
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
                          _pin2Obscure ? Icons.visibility : Icons.visibility_off,
                          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                        ),
                        onPressed: () => setState(() => _pin2Obscure = !_pin2Obscure),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
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

            // Setup button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _setupEncryption,
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
                        'Create PIN',
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
    ),
    ); // Close PopScope
  }

  Widget _buildRecoveryKeyView(
    bool isDark,
    Color backgroundColor,
    Color surfaceColor,
    Color textColor,
    Color accentColor,
  ) {
    return PopScope(
      canPop: false, // Prevent back navigation - user must save recovery key
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Recovery Key'),
          backgroundColor: surfaceColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.key,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Save Your Recovery Key',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Warning
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.amber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'IMPORTANT: Save this key securely',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you forget your PIN, this recovery key is the ONLY way to access your encrypted data. Write it down and store it somewhere safe.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recovery key
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  SelectableText(
                    _recoveryKey ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: accentColor,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _copyRecoveryKey,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor,
                      side: BorderSide(color: accentColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Enable biometrics option
            OutlinedButton.icon(
              onPressed: _enableBiometrics,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Enable Fingerprint Unlock (Optional)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor),
              ),
            ),
            const SizedBox(height: 16),

            // Finish button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _finishSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'I\'ve Saved My Recovery Key',
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
    ),
    ); // Close PopScope
  }
}

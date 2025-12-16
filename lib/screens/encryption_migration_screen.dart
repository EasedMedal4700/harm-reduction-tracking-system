import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
/// Encryption Migration Screen
/// 
/// This screen is shown to existing users who have data encrypted with the old
/// JWT-based system. It explains the migration to the new PIN-based system and
/// guides them through creating a PIN and re-encrypting their data.

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/encryption_migration_service.dart';

import '../utils/error_handler.dart';
import '../states/migration_step_controller.dart';

class EncryptionMigrationScreen extends StatefulWidget {
  const EncryptionMigrationScreen({super.key});

  @override
  State<EncryptionMigrationScreen> createState() =>
      _EncryptionMigrationScreenState();
}

class _EncryptionMigrationScreenState extends State<EncryptionMigrationScreen> {
  final EncryptionMigrationService _migrationService =
      EncryptionMigrationService();
  final MigrationStepController _stepController = MigrationStepController();

  // Step 1: Explanation
  // Step 2: Create PIN
  // Step 3: Confirm PIN
  // Step 4: Migrating (progress)
  // Step 5: Show recovery key
  // int _currentStep = 1;

  String _pin = '';
  String _confirmPin = '';
  bool _pinVisible = false;
  bool _confirmPinVisible = false;
  bool _isMigrating = false;
  String _recoveryKey = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: _stepController.currentStep < 4
          ? AppBar(
              title: const Text('Security Upgrade'),
              backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildStepContent(isDark),
        ),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_stepController.currentStep) {
      case 1:
        return _buildExplanationStep(isDark);
      case 2:
        return _buildCreatePinStep(isDark);
      case 3:
        return _buildConfirmPinStep(isDark);
      case 4:
        return _buildMigratingStep(isDark);
      case 5:
        return _buildRecoveryKeyStep(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Explain the migration
  Widget _buildExplanationStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.security,
          size: 64,
          color: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
        ),
        const SizedBox(height: 32),
        Text(
          'Security Upgrade Required',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve upgraded our encryption system to be more secure and reliable.',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildFeatureItem(
          isDark,
          Icons.pin,
          'PIN Protection',
          'Unlock your data with a 6-digit PIN',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          isDark,
          Icons.fingerprint,
          'Biometric Unlock',
          'Use your fingerprint or face (optional)',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          isDark,
          Icons.key,
          'Recovery Key',
          'Never lose access to your data',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          isDark,
          Icons.cloud_off,
          'Zero-Knowledge',
          'Your data stays private, even from us',
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? UIColors.darkNeonCyan.withOpacity(0.1)
                : UIColors.lightAccentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This will take a moment to re-encrypt your data. Don\'t close the app during migration.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _stepController.goTo(2);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
      bool isDark, IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark
                ? UIColors.darkNeonCyan.withOpacity(0.2)
                : UIColors.lightAccentBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 2: Create PIN
  Widget _buildCreatePinStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create Your PIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter a 6-digit PIN to protect your data',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          obscureText: !_pinVisible,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '••••••',
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(_pinVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _pinVisible = !_pinVisible;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _pin = value;
            });
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _pin.length == 6
                ? () {
                    setState(() {
                      _stepController.goTo(3);
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Step 3: Confirm PIN
  Widget _buildConfirmPinStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Confirm Your PIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter your PIN again to confirm',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          obscureText: !_confirmPinVisible,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '••••••',
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(
                  _confirmPinVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _confirmPinVisible = !_confirmPinVisible;
                });
              },
            ),
            errorText: _confirmPin.length == 6 && _confirmPin != _pin
                ? 'PINs do not match'
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _confirmPin = value;
            });
          },
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _stepController.goTo(2);
                    _confirmPin = '';
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmPin.length == 6 && _confirmPin == _pin
                    ? _startMigration
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Start Migration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 4: Migrating (progress indicator)
  Widget _buildMigratingStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Upgrading Security...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Re-encrypting your data with the new system.\nThis may take a minute.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // Step 5: Show recovery key
  Widget _buildRecoveryKeyStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 64,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'Migration Complete!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your data has been successfully upgraded to the new encryption system.',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'IMPORTANT: Save Your Recovery Key',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'If you forget your PIN, you\'ll need this recovery key to access your data. Store it somewhere safe.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Recovery Key:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            _recoveryKey,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'monospace',
              color: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _recoveryKey));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recovery key copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy Recovery Key'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to home screen
              Navigator.of(context).pushReplacementNamed('/home_page');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Continue to App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Start the migration process
  Future<void> _startMigration() async {
    setState(() {
      _isMigrating = true;
      _stepController.goTo(4);
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Perform migration
      final recoveryKey =
          await _migrationService.migrateUserData(user.id, _pin);

      setState(() {
        _recoveryKey = recoveryKey;
        _stepController.goTo(5);
        _isMigrating = false;
      });
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationScreen',
        'Migration failed: $e',
        stack,
      );

      setState(() {
        _isMigrating = false;
        _stepController.goTo(2); // Back to create PIN step
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}






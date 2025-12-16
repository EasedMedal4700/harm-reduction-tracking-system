import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/encryption_service_v2.dart';
import '../services/debug_config.dart';
import '../services/pin_timeout_service.dart';
import '../services/security_manager.dart';


/// Screen for unlocking with PIN or biometrics
class PinUnlockScreen extends StatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  State<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends State<PinUnlockScreen> {
  final _encryptionService = EncryptionServiceV2();
  final _pinController = TextEditingController();
  
  bool _isLoading = false;
  bool _isBiometricsAvailable = false;
  bool _isCheckingAuth = true;
  String? _errorMessage;
  bool _pinObscure = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndInitialize();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  /// Check if user is authenticated before showing PIN screen
  Future<void> _checkAuthAndInitialize() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        // User not logged in, redirect to login
        print('🔐 PIN screen: No authenticated user, redirecting to login');
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login_page');
        }
        return;
      }

      // User is authenticated, proceed with normal initialization
      if (mounted) {
        setState(() => _isCheckingAuth = false);
      }
      
      await _checkBiometrics();
      await _tryDebugAutoUnlock();
    } catch (e) {
      print('❌ PIN screen auth check error: $e');
      // On error, redirect to login for safety
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login_page');
      }
    }
  }

  /// Try to auto-unlock if debug mode is enabled
  Future<void> _tryDebugAutoUnlock() async {
    if (!DebugConfig.instance.isAutoLoginEnabled) return;
    
    final pin = DebugConfig.instance.debugPin;
    if (pin == null || pin.isEmpty) return;
    
    print('🔧 DEBUG: Attempting auto-unlock with debug PIN');
    
    // Small delay to ensure widget is mounted
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print('❌ DEBUG: No user for auto-unlock');
        setState(() => _isLoading = false);
        return;
      }
      
      final success = await _encryptionService.unlockWithPin(user.id, pin);
      
      if (success) {
        // Record successful unlock for timeout tracking (both services)
        await pinTimeoutService.recordUnlock();
        await securityManager.recordUnlock();
        
        print('✅ DEBUG: Auto-unlock successful');
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home_page');
        }
      } else {
        print('❌ DEBUG: Auto-unlock failed, showing PIN screen');
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('❌ DEBUG: Auto-unlock error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkBiometrics() async {
    final available = await _encryptionService.isBiometricsEnabled();
    setState(() {
      _isBiometricsAvailable = available;
    });
  }

  Future<void> _unlockWithPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pin = _pinController.text;

      if (pin.length != 6) {
        throw Exception('PIN must be exactly 6 digits');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // User logged out, redirect to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login_page');
        }
        return;
      }

      final success = await _encryptionService.unlockWithPin(user.id, pin);

      if (success) {
        // Record successful unlock for timeout tracking (both services)
        await pinTimeoutService.recordUnlock();
        await securityManager.recordUnlock();
        
        // Navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home_page');
        }
      } else {
        setState(() {
          _errorMessage = 'Incorrect PIN. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      
      // Check for specific error types
      if (errorMsg.contains('NOT_AUTHENTICATED') || 
          errorMsg.contains('not logged in') ||
          errorMsg.contains('No authenticated user')) {
        // User session expired, redirect to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login_page');
        }
        return;
      }
      
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
    }
  }

  Future<void> _unlockWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // User logged out, redirect to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login_page');
        }
        return;
      }

      final success = await _encryptionService.unlockWithBiometrics(user.id);

      if (success) {
        // Record successful unlock for timeout tracking (both services)
        await pinTimeoutService.recordUnlock();
        await securityManager.recordUnlock();
        
        // Navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home_page');
        }
      } else {
        setState(() {
          _errorMessage = 'Biometric authentication failed. Please use PIN.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric unlock failed. Please use PIN.';
        _isLoading = false;
      });
    }
  }

  void _openRecoveryKey() {
    Navigator.of(context).pushNamed('/recovery-key');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final surfaceColor = isDark ? UIColors.darkSurface : UIColors.lightSurface;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    // Show loading while checking authentication
    if (_isCheckingAuth) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: accentColor),
              const SizedBox(height: 16),
              Text(
                'Verifying session...',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false, // Prevent back navigation - user must enter PIN
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Unlock'),
          backgroundColor: surfaceColor,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Lock Icon
            Icon(
              Icons.lock_outline,
              size: 100,
              color: accentColor,
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Enter Your PIN',
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
              'Unlock to access your encrypted data',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // PIN Input
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  width: 2,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: TextField(
                controller: _pinController,
                obscureText: _pinObscure,
                keyboardType: TextInputType.number,
                maxLength: 6,
                autofocus: true,
                style: TextStyle(
                  fontSize: 32,
                  letterSpacing: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '● ● ● ● ● ●',
                  hintStyle: TextStyle(
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                  counterText: '',
                  border: InputBorder.none,
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (_) => _unlockWithPin(),
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
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
              ),
            ],

            const SizedBox(height: 32),

            // Unlock button
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _unlockWithPin,
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
                        'Unlock',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            // Biometrics button
            if (_isBiometricsAvailable) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _unlockWithBiometrics,
                icon: const Icon(Icons.fingerprint, size: 28),
                label: const Text(
                  'Unlock with Fingerprint',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Forgot PIN link
            TextButton(
              onPressed: _openRecoveryKey,
              child: Text(
                'Forgot PIN? Use Recovery Key',
                style: TextStyle(
                  fontSize: 16,
                  color: accentColor,
                  decoration: TextDecoration.underline,
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





import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/core_providers.dart';
import '../../services/encryption_service_v2.dart';
import '../../services/debug_config.dart';


/// Screen for unlocking with PIN or biometrics
class PinUnlockScreen extends ConsumerStatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  ConsumerState<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends ConsumerState<PinUnlockScreen> {
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
    await Future.delayed(const context.animations.extraFast);
    
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
        await ref.read(appLockControllerProvider.notifier).recordUnlock();
        
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
        await ref.read(appLockControllerProvider.notifier).recordUnlock();
        
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
        await ref.read(appLockControllerProvider.notifier).recordUnlock();
        
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
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final t = context.text;
    final sh = context.shapes;

    // Show loading while checking authentication
    if (_isCheckingAuth) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              CircularProgressIndicator(color: a.primary),
              SizedBox(height: sp.md),
              Text(
                'Verifying session...',
                style: t.bodyMedium.copyWith(color: c.textPrimary),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false, // Prevent back navigation - user must enter PIN
      child: Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          title: Text(
            'Unlock',
            style: t.heading3.copyWith(color: c.textPrimary),
          ),
          backgroundColor: c.surface,
          elevation: context.sizes.elevationNone,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
          children: [
            SizedBox(height: sp.xl2),

            // Lock Icon
            Icon(
              Icons.lock_outline,
              size: 100,
              color: a.primary,
            ),
            SizedBox(height: sp.xl),

            // Title
            Text(
              'Enter Your PIN',
              style: t.heading1.copyWith(
                fontWeight: text.bodyBold.fontWeight,
                color: c.textPrimary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            SizedBox(height: sp.sm),

            // Description
            Text(
              'Unlock to access your encrypted data',
              style: t.bodyMedium.copyWith(
                color: c.textSecondary,
              ),
              textAlign: AppLayout.textAlignCenter,
            ),
            SizedBox(height: sp.xl2),

            // PIN Input
            Container(
              padding: EdgeInsets.all(sp.xl),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusLg),
                border: Border.all(
                  color: c.border,
                  width: context.sizes.borderRegular,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                style: t.heading1.copyWith(
                  letterSpacing: 12,
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
                decoration: InputDecoration(
                  hintText: '● ● ● ● ● ●',
                  hintStyle: t.heading1.copyWith(
                    letterSpacing: 12,
                    fontWeight: text.bodyBold.fontWeight,
                    color: c.textSecondary,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _pinObscure ? Icons.visibility : Icons.visibility_off,
                      color: c.textSecondary,
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
              CommonSpacer.vertical(sp.md),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: c.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: c.error, size: context.sizes.iconMd),
                    CommonSpacer.horizontal(sp.md),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: t.bodyMedium.copyWith(
                          color: c.error,
                          fontWeight: text.bodyMedium.fontWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            CommonSpacer.vertical(sp.xl),

            // Unlock button
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _unlockWithPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: a.primary,
                  foregroundColor: c.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                  elevation: context.sizes.elevationMd,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: context.sizes.iconMd,
                        height: context.sizes.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(c.textInverse),
                        ),
                      )
                    : Text(
                        'Unlock',
                        style: t.heading3.copyWith(
                          fontWeight: text.bodyBold.fontWeight,
                          color: c.textInverse,
                        ),
                      ),
              ),
            ),

            // Biometrics button
            if (_isBiometricsAvailable) ...[
              CommonSpacer.vertical(sp.md),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _unlockWithBiometrics,
                icon: Icon(Icons.fingerprint, size: context.sizes.iconLg),
                label: Text(
                  'Unlock with Fingerprint',
                  style: t.labelLarge.copyWith(fontWeight: text.bodyBold.fontWeight),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: sp.md),
                  foregroundColor: a.primary,
                  side: BorderSide(color: a.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                  ),
                ),
              ),
            ],

            CommonSpacer.vertical(sp.xl),

            // Forgot PIN link
            TextButton(
              onPressed: _openRecoveryKey,
              child: Text(
                'Forgot PIN? Use Recovery Key',
                style: t.bodyMedium.copyWith(
                  color: a.primary,
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





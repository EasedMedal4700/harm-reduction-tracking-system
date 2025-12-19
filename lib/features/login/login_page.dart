import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/core_providers.dart';
import '../../services/encryption_service_v2.dart';
import '../../services/encryption_migration_service.dart';
import '../../services/debug_config.dart';
import '../../services/onboarding_service.dart';
import '../../common/inputs/input_field.dart';
import '../../common/buttons/common_primary_button.dart';
import '../../common/layout/common_spacer.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static const String _rememberMeKey = 'remember_me';
  bool _rememberMe = false;
  bool _isLoading = false;
  StreamSubscription<AuthState>? _authStateSub;

  @override
  void initState() {
    super.initState();
    _initializeSessionState();
    _listenForRestoredSession();
  }

  void _listenForRestoredSession() {
    final client = _tryGetSupabaseClient();
    if (client == null) return;

    _authStateSub = client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (!mounted) return;

      final remember = ref.read(sharedPreferencesProvider).getBool(_rememberMeKey) ?? false;
      if (remember && session != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _navigateToHome();
        });
      }
    });
  }

  Future<void> _initializeSessionState() async {
    print('🔄 DEBUG: Initializing session state...');
    
    // Check if onboarding is complete first (for new users)
    final isOnboardingComplete = await onboardingService.isOnboardingComplete();
    if (!isOnboardingComplete && mounted) {
      print('🔄 DEBUG: Onboarding not complete, redirecting...');
      Navigator.of(context).pushReplacementNamed('/onboarding');
      return;
    }
    
    // Log debug config status
    DebugConfig.instance.logStatus();
    
    final remember = await _readRememberPreference();
    final client = _tryGetSupabaseClient();
    final session = client?.auth.currentSession;

    print('🔄 DEBUG: Remember me: $remember');
    print('🔄 DEBUG: Client available: ${client != null}');
    print('🔄 DEBUG: Session exists: ${session != null}');

    if (!mounted) return;

    setState(() => _rememberMe = remember);

    // Check for debug auto-login
    if (DebugConfig.instance.isAutoLoginEnabled && 
        DebugConfig.instance.hasValidCredentials) {
      print('🔧 DEBUG: Auto-login enabled, attempting automatic login...');
      await _performDebugAutoLogin();
      return;
    }

    if (session != null && client != null) {
      if (remember) {
        // Rely on Supabase persisted session + token refresh.
        // Do NOT clear auth state automatically.
        try {
          await client.auth.refreshSession();
        } catch (_) {
          // Ignore refresh errors; user can still log in manually.
        }

        print('🔄 DEBUG: Auto-login with existing session');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _navigateToHome();
          }
        });
      }
    } else {
      print('🔄 DEBUG: No session or client, staying on login page');
    }
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    print('🔑 DEBUG: Login button pressed');
    print('🔑 DEBUG: Email: $email');
    print('🔑 DEBUG: Password length: ${password.length}');

    setState(() => _isLoading = true);
    
    try {
      final success = await ref.read(authServiceProvider).login(email, password);
      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        print('✅ DEBUG: Login returned success');
        await _persistRememberPreference(_rememberMe);
        print('✅ DEBUG: Remember me preference saved: $_rememberMe');
        print('✅ DEBUG: Navigating to home page...');
        _navigateToHome();
      } else {
        print('❌ DEBUG: Login returned false');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials, please try again')),
        );
      }
    } catch (e, stackTrace) {
      print('❌ DEBUG: Exception in _handleLogin');
      print('❌ DEBUG: Error: $e');
      print('❌ DEBUG: Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToHome() {
    print('🏠 DEBUG: _navigateToHome called');
    _checkEncryptionAndNavigate();
  }

  /// Performs automatic login using debug credentials from .env
  Future<void> _performDebugAutoLogin() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final email = DebugConfig.instance.debugEmail!;
      final password = DebugConfig.instance.debugPassword!;
      
      print('🔧 DEBUG: Auto-logging in as $email');
      
      final success = await ref.read(authServiceProvider).login(email, password);
      
      if (!mounted) return;
      
      if (success) {
        print('✅ DEBUG: Auto-login successful');
        await _persistRememberPreference(true);
        
        // For debug mode, go directly to home with auto-unlock
        await _checkEncryptionAndNavigateDebug();
      } else {
        print('❌ DEBUG: Auto-login failed, falling back to manual login');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ DEBUG: Auto-login error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Debug version that auto-unlocks PIN
  Future<void> _checkEncryptionAndNavigateDebug() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/home_page');
        return;
      }

      // Check if user needs migration
      final migrationService = EncryptionMigrationService();
      final needsMigration = await migrationService.needsMigration(user.id);
      
      if (needsMigration) {
        print('🔐 DEBUG: User needs encryption migration (cannot auto-skip)');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/encryption-migration');
        }
        return;
      }

      // Check if user has PIN setup
      final encryptionService = EncryptionServiceV2();
      final hasEncryption = await encryptionService.hasEncryptionSetup(user.id);
      
      if (!hasEncryption) {
        print('🔐 DEBUG: User needs PIN setup (cannot auto-skip)');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/pin-setup');
        }
        return;
      }

      // User has PIN setup - auto-unlock in debug mode
      final pin = DebugConfig.instance.debugPin;
      if (pin != null && pin.isNotEmpty) {
        print('🔧 DEBUG: Auto-unlocking with debug PIN');
        final unlocked = await encryptionService.unlockWithPin(user.id, pin);
        
        if (unlocked) {
          if (mounted) {
            await ref.read(appLockControllerProvider.notifier).recordUnlock();
          }
          
          print('✅ DEBUG: Auto-unlock successful, going to home');
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home_page');
          }
          return;
        } else {
          print('❌ DEBUG: Auto-unlock failed, PIN might be wrong');
        }
      }
      
      // Fall back to PIN unlock screen if auto-unlock fails
      print('🔐 DEBUG: Falling back to PIN unlock screen');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/pin-unlock');
      }
    } catch (e) {
      print('⚠️ DEBUG: Error in debug navigation: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    }
  }

  Future<void> _checkEncryptionAndNavigate() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/home_page');
        return;
      }

      // Check if user needs migration
      final migrationService = EncryptionMigrationService();
      final needsMigration = await migrationService.needsMigration(user.id);
      
      if (needsMigration) {
        // User has old encryption, needs to migrate
        print('🔐 DEBUG: User needs encryption migration');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/encryption-migration');
        }
        return;
      }

      // Check if user has PIN setup
      final encryptionService = EncryptionServiceV2();
      final hasEncryption = await encryptionService.hasEncryptionSetup(user.id);
      
      if (!hasEncryption) {
        // New user, needs to setup PIN
        print('🔐 DEBUG: User needs PIN setup');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/pin-setup');
        }
        return;
      }

      // User has PIN setup - check if PIN is required based on timeout
      final isPinRequired =
          await ref.read(appLockControllerProvider.notifier).shouldRequirePinNow();
      
      if (isPinRequired) {
        // PIN timeout expired, need to unlock
        print('🔐 DEBUG: User needs to unlock with PIN (timeout expired)');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/pin-unlock');
        }
      } else {
        // PIN still valid, go directly to home
        print('✅ DEBUG: PIN still valid, skipping unlock screen');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home_page');
        }
      }
    } catch (e) {
      print('⚠️ DEBUG: Error checking encryption: $e');
      // On error, just go to home (old behavior)
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    }
  }

  SupabaseClient? _tryGetSupabaseClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _readRememberPreference() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _persistRememberPreference(bool value) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(_rememberMeKey, value);
    } catch (_) {
      // Ignore persistence issues; user will be asked to log in again.
    }
  }

  @override
  void dispose() {
    _authStateSub?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Login',
          style: text.headlineSmall.copyWith(color: c.textPrimary),
        ),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: context.sizes.elevationNone,
      ),
      body: Padding(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonInputField(
              controller: emailController,
              enabled: !_isLoading,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            CommonSpacer.vertical(sp.md),
            CommonInputField(
              controller: passwordController,
              enabled: !_isLoading,
              labelText: 'Password',
              obscureText: true,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Keep me logged in',
                style: text.bodyMedium.copyWith(color: c.textPrimary),
              ),
              value: _rememberMe,
              activeColor: a.primary,
              checkColor: c.textInverse,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _rememberMe = value ?? false),
            ),
            CommonSpacer.vertical(sp.xl),
            CommonPrimaryButton(
              onPressed: _handleLogin,
              label: 'Login',
              isLoading: _isLoading,
              isEnabled: !_isLoading,
              width: double.infinity,
            ),
            CommonSpacer.vertical(sp.md),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.pushNamed(context, '/register'),
              style: TextButton.styleFrom(
                foregroundColor: a.primary,
              ),
              child: const Text('Create an account'),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.pushNamed(context, '/forgot-password'),
              style: TextButton.styleFrom(
                foregroundColor: c.textSecondary,
              ),
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/encryption_service_v2.dart';
import '../services/encryption_migration_service.dart';
import '../services/debug_config.dart';
import '../services/pin_timeout_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  static const String _rememberMeKey = 'remember_me';
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSessionState();
  }

  Future<void> _initializeSessionState() async {
    print('🔄 DEBUG: Initializing session state...');
    
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
      // Check if session is still valid (not expired)
      final now = DateTime.now().millisecondsSinceEpoch / 1000;
      final isSessionValid = session.expiresAt != null && session.expiresAt! > now;

      print('🔄 DEBUG: Session expires at: ${session.expiresAt}');
      print('🔄 DEBUG: Current time: $now');
      print('🔄 DEBUG: Session valid: $isSessionValid');

      if (remember && isSessionValid) {
        print('🔄 DEBUG: Auto-login with valid session');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _navigateToHome();
          }
        });
      } else {
        // Session is invalid or remember me is false, clear it
        print('🔄 DEBUG: Clearing invalid session or remember me is false');
        try {
          await authService.logout();
        } catch (e) {
          print('⚠️ DEBUG: Error during logout in init: $e');
        }
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
      final success = await authService.login(email, password);
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
      
      final success = await authService.login(email, password);
      
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
          // Record the unlock for timeout tracking
          await pinTimeoutService.recordUnlock();
          
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
      final isPinRequired = await pinTimeoutService.isPinRequired();
      
      if (isPinRequired) {
        // PIN timeout expired, need to unlock
        print('🔐 DEBUG: User needs to unlock with PIN (timeout expired)');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/pin-unlock');
        }
      } else {
        // PIN still valid, go directly to home
        print('✅ DEBUG: PIN still valid, skipping unlock screen');
        // Update activity to extend session
        await pinTimeoutService.recordForegroundResume();
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
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _persistRememberPreference(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, value);
    } catch (_) {
      // Ignore persistence issues; user will be asked to log in again.
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              enabled: !_isLoading,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              enabled: !_isLoading,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Keep me logged in'),
              value: _rememberMe,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _rememberMe = value ?? false),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.pushNamed(context, '/register'),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

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
    final remember = await _readRememberPreference();
    final client = _tryGetSupabaseClient();
    final session = client?.auth.currentSession;

    print('🔄 DEBUG: Remember me: $remember');
    print('🔄 DEBUG: Client available: ${client != null}');
    print('🔄 DEBUG: Session exists: ${session != null}');

    if (!mounted) return;

    setState(() => _rememberMe = remember);

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
    Navigator.pushReplacementNamed(context, '/home_page');
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

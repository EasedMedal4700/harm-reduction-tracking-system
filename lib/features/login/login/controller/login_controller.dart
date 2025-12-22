// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Owns login orchestration, session restore, debug auto-login.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../providers/core_providers.dart';
import '../../../../services/debug_config.dart';
import '../../../../services/onboarding_service.dart';
import '../../services/post_login_router.dart';
import '../state/login_state.dart';

/// Provider wiring owns lifecycle.
/// UI MUST NOT call init().
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
      final controller = LoginController(ref);
      controller.init();
      ref.onDispose(controller.dispose);
      return controller;
    });

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginState());

  final Ref _ref;
  static const _rememberMeKey = 'remember_me';

  StreamSubscription<AuthState>? _authSub;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void init() {
    _listenForRestoredSession();
    _initializeSession();
  }

  void dispose() {
    _authSub?.cancel();
  }

  // ---------------------------------------------------------------------------
  // Session restore
  // ---------------------------------------------------------------------------

  void _listenForRestoredSession() {
    final client = Supabase.instance.client;

    _authSub = client.auth.onAuthStateChange.listen((data) async {
      if (state.hasNavigated) return;

      final remember = await _readRememberMe();
      if (remember && data.session != null) {
        _navigateOnce(debug: false);
      }
    });
  }

  Future<void> _initializeSession() async {
    // Onboarding always has priority
    if (!await onboardingService.isOnboardingComplete()) {
      _ref.read(postLoginRouterProvider).goToOnboarding();
      return;
    }

    final remember = await _readRememberMe();

    state = state.copyWith(rememberMe: remember, isInitialized: true);

    // Debug auto-login (dev only)
    if (DebugConfig.instance.isAutoLoginEnabled &&
        DebugConfig.instance.hasValidCredentials) {
      await _performDebugAutoLogin();
    }
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  Future<void> submitLogin({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(errorMessage: 'Email and password required');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final success = await _ref.read(authServiceProvider).login(email, password);

    state = state.copyWith(isLoading: false);

    if (!success) {
      state = state.copyWith(errorMessage: 'Invalid credentials');
      return;
    }

    await _persistRememberMe(state.rememberMe);
    _navigateOnce(debug: false);
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  // ---------------------------------------------------------------------------
  // Debug
  // ---------------------------------------------------------------------------

  Future<void> _performDebugAutoLogin() async {
    state = state.copyWith(isLoading: true);

    final success = await _ref
        .read(authServiceProvider)
        .login(
          DebugConfig.instance.debugEmail!,
          DebugConfig.instance.debugPassword!,
        );

    state = state.copyWith(isLoading: false);

    if (success) {
      await _persistRememberMe(true);
      _navigateOnce(debug: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation (guarded)
  // ---------------------------------------------------------------------------

  void _navigateOnce({required bool debug}) {
    if (state.hasNavigated) return;

    state = state.copyWith(hasNavigated: true);
    _ref.read(postLoginRouterProvider).routeAfterLogin(debug: debug);
  }

  // ---------------------------------------------------------------------------
  // Persistence helpers
  // ---------------------------------------------------------------------------

  Future<bool> _readRememberMe() async {
    return _ref.read(sharedPreferencesProvider).getBool(_rememberMeKey) ??
        false;
  }

  Future<void> _persistRememberMe(bool value) async {
    await _ref.read(sharedPreferencesProvider).setBool(_rememberMeKey, value);
  }
}

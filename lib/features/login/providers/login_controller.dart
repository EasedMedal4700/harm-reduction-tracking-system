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

import '../../../providers/core_providers.dart';
import '../../../services/debug_config.dart';
import '../../../services/onboarding_service.dart';
import '../services/post_login_router.dart';
import 'login_state.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(ref),
);

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginState());

  final Ref _ref;
  static const _rememberMeKey = 'remember_me';

  StreamSubscription<AuthState>? _authSub;

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
      final remember = await _readRememberMe();
      if (remember && data.session != null) {
        _routeAfterLogin(debug: false);
      }
    });
  }

  Future<void> _initializeSession() async {
    if (!await onboardingService.isOnboardingComplete()) {
      _ref.read(postLoginRouterProvider).goToOnboarding();
      return;
    }

    state = state.copyWith(rememberMe: await _readRememberMe());

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

    final success =
        await _ref.read(authServiceProvider).login(email, password);

    state = state.copyWith(isLoading: false);

    if (!success) {
      state = state.copyWith(errorMessage: 'Invalid credentials');
      return;
    }

    await _persistRememberMe(state.rememberMe);
    _routeAfterLogin(debug: false);
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  // ---------------------------------------------------------------------------
  // Debug
  // ---------------------------------------------------------------------------

  Future<void> _performDebugAutoLogin() async {
    state = state.copyWith(isLoading: true);

    final success = await _ref.read(authServiceProvider).login(
          DebugConfig.instance.debugEmail!,
          DebugConfig.instance.debugPassword!,
        );

    state = state.copyWith(isLoading: false);

    if (success) {
      await _persistRememberMe(true);
      _routeAfterLogin(debug: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _routeAfterLogin({required bool debug}) {
    _ref.read(postLoginRouterProvider).routeAfterLogin(debug: debug);
  }

  Future<bool> _readRememberMe() async {
    return _ref
            .read(sharedPreferencesProvider)
            .getBool(_rememberMeKey) ??
        false;
  }

  Future<void> _persistRememberMe(bool value) async {
    await _ref
        .read(sharedPreferencesProvider)
        .setBool(_rememberMeKey, value);
  }
}

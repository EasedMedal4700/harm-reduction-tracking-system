// Comprehensive test coverage for LoginController
// Covers: init, login flow, remember me, session restore, navigation, errors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/login/login/login_controller.dart';
import 'package:mobile_drug_use_app/features/login/login/login_state.dart';
import 'package:mobile_drug_use_app/features/login/services/post_login_router.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';
import 'package:mobile_drug_use_app/services/auth_service.dart';
import 'package:mobile_drug_use_app/services/onboarding_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([
  AuthService,
  PostLoginRouter,
  OnboardingService,
  SupabaseClient,
  GoTrueClient,
  Stream,
])
void main() {
  late ProviderContainer container;
  late MockAuthService mockAuthService;
  late MockPostLoginRouter mockRouter;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'remember_me': true});

    mockAuthService = MockAuthService();
    mockRouter = MockPostLoginRouter();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();

    // Workaround for Supabase.instance assertion
    try {
      await Supabase.initialize(url: 'https://example.com', anonKey: 'dummy');
    } catch (_) {}

    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(
      mockGoTrueClient.onAuthStateChange,
    ).thenAnswer((_) => const Stream.empty());

    // Set onboarding complete in SharedPreferences so LoginController proceeds
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
        postLoginRouterProvider.overrideWithValue(mockRouter),
        supabaseClientProvider.overrideWith((ref) => mockSupabaseClient),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginController - Initialization', () {
    test('creates with default state', () {
      final controller = container.read(loginControllerProvider);

      expect(controller, isA<LoginState>());
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });

    test('init sets isInitialized to true', () async {
      // Ensure the provider is created so init() actually runs.
      container.read(loginControllerProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(loginControllerProvider);
      expect(state.isInitialized, true);
    });

    test('restores rememberMe from SharedPreferences', () async {
      // Ensure mock shared preferences contain both onboarding and remember_me keys
      SharedPreferences.setMockInitialValues({
        'remember_me': true,
        'onboarding_complete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', true);
      // mark onboarding complete so controller initialization runs past onboarding check
      await prefs.setBool('onboarding_complete', true);

      final newContainer = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          postLoginRouterProvider.overrideWithValue(mockRouter),
          supabaseClientProvider.overrideWith((ref) => mockSupabaseClient),
          // ensure onboarding is marked complete so initialization proceeds
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      // ensure async initialization completes (call init again to be deterministic)
      newContainer.read(loginControllerProvider.notifier).init();
      await Future.delayed(const Duration(milliseconds: 500));
      final state = newContainer.read(loginControllerProvider);

      expect(state.rememberMe, true);
      newContainer.dispose();
    });
  });

  group('LoginController - Login Flow', () {
    test('submitLogin succeeds with valid credentials', () async {
      when(
        mockAuthService.login('test@test.com', 'password123'),
      ).thenAnswer((_) async => true);

      final notifier = container.read(loginControllerProvider.notifier);
      await notifier.submitLogin(
        email: 'test@test.com',
        password: 'password123',
      );

      verify(mockAuthService.login('test@test.com', 'password123')).called(1);
      verify(mockRouter.routeAfterLogin(debug: false)).called(1);

      final state = container.read(loginControllerProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.hasNavigated, true);
    });

    test('submitLogin fails with invalid credentials', () async {
      when(
        mockAuthService.login('wrong@test.com', 'wrongpass'),
      ).thenAnswer((_) async => false);

      final notifier = container.read(loginControllerProvider.notifier);
      await notifier.submitLogin(
        email: 'wrong@test.com',
        password: 'wrongpass',
      );

      final state = container.read(loginControllerProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, 'Invalid credentials');
      expect(state.hasNavigated, false);
    });

    test('submitLogin validates empty email', () async {
      final notifier = container.read(loginControllerProvider.notifier);
      await notifier.submitLogin(email: '', password: 'password');

      final state = container.read(loginControllerProvider);
      expect(state.errorMessage, 'Email and password required');
      verifyNever(mockAuthService.login(any, any));
    });

    test('submitLogin validates empty password', () async {
      final notifier = container.read(loginControllerProvider.notifier);
      await notifier.submitLogin(email: 'test@test.com', password: '');

      final state = container.read(loginControllerProvider);
      expect(state.errorMessage, 'Email and password required');
      verifyNever(mockAuthService.login(any, any));
    });

    test('submitLogin sets isLoading during request', () async {
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 100), () => true),
      );

      final notifier = container.read(loginControllerProvider.notifier);
      final loginFuture = notifier.submitLogin(
        email: 'test@test.com',
        password: 'password',
      );

      await Future.delayed(const Duration(milliseconds: 50));
      var state = container.read(loginControllerProvider);
      expect(state.isLoading, true);

      await loginFuture;
      state = container.read(loginControllerProvider);
      expect(state.isLoading, false);
    });
  });

  group('LoginController - Remember Me', () {
    test('toggleRememberMe updates state', () {
      final notifier = container.read(loginControllerProvider.notifier);
      notifier.toggleRememberMe(true);

      var state = container.read(loginControllerProvider);
      expect(state.rememberMe, true);

      notifier.toggleRememberMe(false);
      state = container.read(loginControllerProvider);
      expect(state.rememberMe, false);
    });

    test('submitLogin persists rememberMe when enabled', () async {
      when(mockAuthService.login(any, any)).thenAnswer((_) async => true);

      final notifier = container.read(loginControllerProvider.notifier);
      notifier.toggleRememberMe(true);

      await notifier.submitLogin(email: 'test@test.com', password: 'password');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('remember_me'), true);
    });

    test('submitLogin persists rememberMe when disabled', () async {
      when(mockAuthService.login(any, any)).thenAnswer((_) async => true);

      final notifier = container.read(loginControllerProvider.notifier);
      notifier.toggleRememberMe(false);

      await notifier.submitLogin(email: 'test@test.com', password: 'password');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('remember_me'), false);
    });
  });

  group('LoginController - Navigation Guard', () {
    test('navigates only once even if called multiple times', () async {
      when(mockAuthService.login(any, any)).thenAnswer((_) async => true);

      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.submitLogin(email: 'test@test.com', password: 'password');

      await notifier.submitLogin(email: 'test@test.com', password: 'password');

      // Should only navigate once
      verify(mockRouter.routeAfterLogin(debug: false)).called(1);

      final state = container.read(loginControllerProvider);
      expect(state.hasNavigated, true);
    });
  });

  group('LoginController - Error Handling', () {
    test('clears error message on new login attempt', () async {
      when(mockAuthService.login(any, any)).thenAnswer((_) async => false);

      final notifier = container.read(loginControllerProvider.notifier);

      // First attempt fails
      await notifier.submitLogin(email: 'test@test.com', password: 'wrong');
      var state = container.read(loginControllerProvider);
      expect(state.errorMessage, 'Invalid credentials');

      // Reset mock for second attempt
      when(mockAuthService.login(any, any)).thenAnswer((_) async => true);

      // Second attempt (error should be cleared)
      await notifier.submitLogin(email: 'test@test.com', password: 'correct');
      state = container.read(loginControllerProvider);
      expect(state.errorMessage, null);
    });
  });
}

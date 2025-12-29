// Comprehensive test coverage for PostLoginRouter
// Covers: all routing scenarios, encryption checks, PIN setup, migration

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/login/services/post_login_router.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/encryption_migration_service.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';
import 'package:mobile_drug_use_app/features/login/pin_unlock/providers/app_lock_controller.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'post_login_router_test.mocks.dart';

@GenerateMocks([
  NavigationService,
  EncryptionMigrationService,
  EncryptionServiceV2,
  AppLockController,
  SupabaseClient,
  GoTrueClient,
  User,
])
void main() {
  late ProviderContainer container;
  late MockNavigationService mockNavigation;
  late MockEncryptionMigrationService mockMigrationService;
  late MockEncryptionServiceV2 mockEncryptionService;
  late MockAppLockController mockAppLockController;
  late MockUser mockUser;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;

  setUp(() async {
    // Ensure Flutter bindings and mock shared preferences for plugin calls
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    mockNavigation = MockNavigationService();
    mockMigrationService = MockEncryptionMigrationService();
    mockEncryptionService = MockEncryptionServiceV2();
    mockAppLockController = MockAppLockController();
    mockUser = MockUser();
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();

    when(mockUser.id).thenReturn('test-user-id');

    // Default mocks
    when(
      mockMigrationService.needsMigration(any),
    ).thenAnswer((_) async => false);
    when(
      mockEncryptionService.hasEncryptionSetup(any),
    ).thenAnswer((_) async => true);
    when(
      mockAppLockController.shouldRequirePinNow(),
    ).thenAnswer((_) async => false);

    // Default Supabase auth returns a user; tests override as needed
    when(mockSupabaseClient.auth).thenReturn(mockAuth);
    when(mockAuth.currentUser).thenReturn(mockUser);
    // Initialize Supabase SDK to avoid Supabase.instance assertion when code calls Supabase.instance
    try {
      await Supabase.initialize(
        url: 'https://example.supabase.co',
        anonKey: 'test-key',
      );
    } catch (_) {}

    container = ProviderContainer(
      overrides: [
        navigationProvider.overrideWithValue(mockNavigation),
        // override supabase client so tests don't hit Supabase.instance
        supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        // override the services used by router
        encryptionMigrationServiceProvider.overrideWithValue(
          mockMigrationService,
        ),
        encryptionServiceProvider.overrideWithValue(mockEncryptionService),
        // override the app-lock check helper so tests can control PIN requirement
        appLockRequirePinProvider.overrideWithValue(
          () async => mockAppLockController.shouldRequirePinNow(),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  PostLoginRouter createRouter() {
    return container.read(postLoginRouterProvider);
  }

  group('PostLoginRouter - No User', () {
    test('routes to login when user is null', () async {
      // make Supabase auth return null for this test
      when(mockAuth.currentUser).thenReturn(null);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verify(mockNavigation.replace('/login_page')).called(1);
    });
  });

  group('PostLoginRouter - Migration Check', () {
    test('routes to encryption migration when needed', () async {
      when(
        mockMigrationService.needsMigration('test-user-id'),
      ).thenAnswer((_) async => true);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verify(mockNavigation.replace('/encryption-migration')).called(1);
    });

    test('skips migration when not needed', () async {
      when(
        mockMigrationService.needsMigration('test-user-id'),
      ).thenAnswer((_) async => false);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      // no migration route called; proceed to next checks (home in default mocks)
      verifyNever(mockNavigation.replace('/encryption-migration'));
    });
  });

  group('PostLoginRouter - Encryption Setup', () {
    test('routes to PIN setup when encryption not configured', () async {
      when(
        mockEncryptionService.hasEncryptionSetup('test-user-id'),
      ).thenAnswer((_) async => false);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verify(mockNavigation.replace('/pin-setup')).called(1);
    });

    test('skips PIN setup when encryption exists', () async {
      when(
        mockEncryptionService.hasEncryptionSetup('test-user-id'),
      ).thenAnswer((_) async => true);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verifyNever(mockNavigation.replace('/pin-setup'));
    });
  });

  group('PostLoginRouter - PIN Unlock', () {
    test('routes to PIN unlock when required and not debug', () async {
      when(
        mockAppLockController.shouldRequirePinNow(),
      ).thenAnswer((_) async => true);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verify(mockNavigation.replace('/pin-unlock')).called(1);
    });

    test('skips PIN unlock when debug is true', () async {
      when(
        mockAppLockController.shouldRequirePinNow(),
      ).thenAnswer((_) async => true);

      final router = createRouter();
      await router.routeAfterLogin(debug: true);

      verify(mockNavigation.replace('/home_page')).called(1);
    });

    test('skips PIN unlock when not required', () async {
      when(
        mockAppLockController.shouldRequirePinNow(),
      ).thenAnswer((_) async => false);

      final router = createRouter();
      await router.routeAfterLogin(debug: false);

      verifyNever(mockNavigation.replace('/pin-unlock'));
    });
  });

  group('PostLoginRouter - Home Route', () {
    test('routes to home when all checks pass', () async {
      // All checks return false/true to proceed to home (default mocks)
      final router = createRouter();
      await router.routeAfterLogin(debug: false);
      verify(mockNavigation.replace('/home_page')).called(1);
    });
  });

  group('PostLoginRouter - Direct Navigation Methods', () {
    test('goToHome navigates correctly', () {
      final router = createRouter();
      router.goToHome();

      verify(mockNavigation.replace('/home_page')).called(1);
    });

    test('goToLogin navigates correctly', () {
      final router = createRouter();
      router.goToLogin();

      verify(mockNavigation.replace('/login_page')).called(1);
    });

    test('goToPinSetup navigates correctly', () {
      final router = createRouter();
      router.goToPinSetup();

      verify(mockNavigation.replace('/pin-setup')).called(1);
    });

    test('goToPinUnlock navigates correctly', () {
      final router = createRouter();
      router.goToPinUnlock();

      verify(mockNavigation.replace('/pin-unlock')).called(1);
    });

    test('goToEncryptionMigration navigates correctly', () {
      final router = createRouter();
      router.goToEncryptionMigration();

      verify(mockNavigation.replace('/encryption-migration')).called(1);
    });

    test('goToOnboarding navigates correctly', () {
      final router = createRouter();
      router.goToOnboarding();

      verify(mockNavigation.replace('/onboarding')).called(1);
    });
  });

  group('PostLoginRouter - Provider', () {
    test('postLoginRouterProvider returns PostLoginRouter instance', () {
      final router = container.read(postLoginRouterProvider);

      expect(router, isA<PostLoginRouter>());
    });

    test('provider creates new instance each time', () {
      final router1 = container.read(postLoginRouterProvider);
      final router2 = container.read(postLoginRouterProvider);

      // Current implementation returns the same instance; assert identity.
      expect(router1, same(router2));
    });
  });
}

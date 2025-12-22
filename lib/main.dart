import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/daily_checkin_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/screen_tracking_observer.dart';

import 'constants/theme/app_theme_provider.dart';

import 'features/admin/screens/admin_panel_screen.dart';
import 'features/analytics/analytics_page.dart';
import 'features/blood_levels/blood_levels_page.dart';
import 'features/catalog/catalog_page.dart';
import 'features/manage_profile/change_pin_page.dart';
import 'features/daily_chekin/checkin_history_page.dart';
import 'features/craving/cravings_page.dart';
import 'features/daily_chekin/daily_checkin_page.dart';
import 'features/manage_profile/encryption_migration_page.dart';
import 'features/home/home_page_main.dart';
import 'features/log_entry/log_entry_page.dart';
import 'features/login/pages/login_page.dart';
import 'features/setup_account/pin_setup_page.dart';
import 'features/login/pages/pin_unlock_page.dart';
import 'features/profile/profile_screen.dart';
import 'features/setup_account/recovery_key_page.dart';
import 'features/reflection/reflection_page.dart';
import 'features/setup_account/register_page.dart';
import 'features/settings/settings_page.dart';
import 'features/tolerence/tolerance_dashboard_page.dart';
import 'features/setup_account/onboarding_page.dart';
import 'features/settings/privacy_policy_page.dart';
import 'features/feature_flags/feature_flags_page.dart';
import 'features/manage_profile/forgot_password_page.dart';
import 'features/setup_account/set_new_password_page.dart';
import 'features/setup_account/email_confirmed_page.dart';

import 'services/error_logging_service.dart';
import 'services/feature_flag_service.dart';
import 'services/auth_link_handler.dart';
import 'services/app_lock_controller.dart';

import 'providers/core_providers.dart';

import 'constants/config/feature_flags.dart';
import 'features/feature_flags/widgets/feature_flags/feature_gate.dart';

Future<void> main() async {
  final errorLoggingService = ErrorLoggingService.instance;

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Load .env
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint('Error loading .env file: $e');
        // If .env fails to load, we might want to throw or handle it,
        // but for now let's at least see the error.
      }

      if (!dotenv.isInitialized) {
        debugPrint('DotEnv not initialized. Check if .env file exists.');
      }

      final supabaseUrl = dotenv.isInitialized
          ? (dotenv.env['SUPABASE_URL'] ?? '')
          : '';
      final supabaseKey = dotenv.isInitialized
          ? (dotenv.env['SUPABASE_ANON_KEY'] ?? '')
          : '';

      if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
        // Init Supabase
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseKey,
          authOptions: const FlutterAuthClientOptions(
            authFlowType: AuthFlowType.pkce,
            autoRefreshToken: true,
          ),
        );
      } else {
        debugPrint('Supabase not initialized: Missing credentials');
      }

      await errorLoggingService.init();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        unawaited(
          errorLoggingService.logError(
            error: details.exception,
            stackTrace: details.stack,
          ),
        );
      };

      ui.PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(
          errorLoggingService.logError(error: error, stackTrace: stack),
        );
        return true;
      };

      final navigatorObserver = ScreenTrackingNavigatorObserver();
      final prefs = await SharedPreferences.getInstance();

      runApp(
        riverpod.ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: MyApp(navigatorObserver: navigatorObserver),
        ),
      );
    },
    (error, stack) {
      errorLoggingService.logError(error: error, stackTrace: stack);
    },
  );
}

class MyApp extends riverpod.ConsumerStatefulWidget {
  const MyApp({required this.navigatorObserver, super.key});

  final NavigatorObserver navigatorObserver;

  @override
  riverpod.ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends riverpod.ConsumerState<MyApp>
    with WidgetsBindingObserver {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  riverpod.ProviderSubscription<AppLockState>? _appLockSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initServices();
    _setupAppLockListener();
  }

  Future<void> _initServices() async {
    await featureFlagService.load();

    authLinkHandler.init(navigatorKey);
  }

  void _setupAppLockListener() {
    _appLockSub?.close();
    _appLockSub = ref.listenManual(appLockControllerProvider, (previous, next) {
      final wasRequiringPin = previous?.requiresPin ?? false;
      if (wasRequiringPin || !next.requiresPin) return;

      final ctx = navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;

      unawaited(_navigateToPinUnlockIfEligible(ctx));
    });
  }

  Future<void> _navigateToPinUnlockIfEligible(BuildContext ctx) async {
    final currentRoute = ModalRoute.of(ctx)?.settings.name;
    if (currentRoute == '/pin-unlock' || currentRoute == '/login_page') {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final encryption = ref.read(encryptionServiceProvider);
    final hasEncryption = await encryption.hasEncryptionSetup(user.id);
    if (!hasEncryption) return;

    // Lock keys in memory; do NOT sign out.
    encryption.lock();

    if (!ctx.mounted) return;
    Navigator.of(ctx).pushNamedAndRemoveUntil(
      '/pin-unlock',
      (route) => route.settings.name == '/login_page',
    );
  }

  @override
  void dispose() {
    _appLockSub?.close();
    WidgetsBinding.instance.removeObserver(this);
    authLinkHandler.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(
        ref.read(appLockControllerProvider.notifier).onBackgroundStart(),
      );
    } else if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(appLockControllerProvider.notifier).onForegroundResume(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider.value(value: featureFlagService),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final appTheme = AppTheme.fromSettings(settingsProvider.settings);

          return AppThemeProvider(
            theme: appTheme,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light().themeData,
              darkTheme: AppTheme.dark().themeData,
              themeMode: settingsProvider.settings.darkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              initialRoute: '/login_page',

              routes: {
                // Auth
                '/login_page': (_) => const LoginPage(),
                '/register': (_) => const RegisterPage(),
                '/privacy-policy': (_) => const PrivacyPolicyScreen(),
                '/onboarding': (_) => const OnboardingScreen(),
                '/pin-setup': (_) => const PinSetupScreen(),
                '/pin-unlock': (_) => const PinUnlockScreen(),
                '/recovery-key': (_) => const RecoveryKeyScreen(),
                '/encryption-migration': (_) =>
                    const EncryptionMigrationScreen(),
                '/change-pin': (_) => const ChangePinScreen(),
                '/forgot-password': (_) => const ForgotPasswordPage(),
                '/set-new-password': (_) => const SetNewPasswordPage(),
                '/email-confirmed': (_) => const EmailConfirmedPage(),

                // Feature-gated
                '/home_page': (_) => FeatureGate(
                  featureName: FeatureFlags.homePage,
                  child: const HomePage(),
                ),

                '/log_entry': (_) => FeatureGate(
                  featureName: FeatureFlags.logEntryPage,
                  child: const QuickLogEntryPage(),
                ),

                '/analytics': (_) => FeatureGate(
                  featureName: FeatureFlags.analyticsPage,
                  child: const AnalyticsPage(),
                ),

                '/catalog': (_) => FeatureGate(
                  featureName: FeatureFlags.catalogPage,
                  child: const CatalogPage(),
                ),

                '/cravings': (_) => FeatureGate(
                  featureName: FeatureFlags.cravingsPage,
                  child: const CravingsPage(),
                ),

                '/blood_levels': (_) => FeatureGate(
                  featureName: FeatureFlags.bloodLevelsPage,
                  child: const BloodLevelsPage(),
                ),

                '/reflection': (_) => FeatureGate(
                  featureName: FeatureFlags.reflectionPage,
                  child: const ReflectionPage(),
                ),

                '/daily-checkin': (_) => FeatureGate(
                  featureName: FeatureFlags.dailyCheckin,
                  child: ChangeNotifierProvider(
                    create: (_) => DailyCheckinProvider(),
                    child: const DailyCheckinScreen(),
                  ),
                ),

                '/checkin-history': (_) => FeatureGate(
                  featureName: FeatureFlags.checkinHistoryPage,
                  child: ChangeNotifierProvider(
                    create: (_) => DailyCheckinProvider(),
                    child: const CheckinHistoryScreen(),
                  ),
                ),

                '/profile': (_) => const ProfileScreen(),

                '/admin-panel': (_) => FeatureGate(
                  featureName: FeatureFlags.adminPanel,
                  child: const AdminPanelScreen(),
                ),

                '/admin/feature-flags': (_) => const FeatureFlagsScreen(),

                '/settings': (_) => const SettingsScreen(),

                '/tolerance-dashboard': (context) {
                  final args =
                      ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>? ??
                      {};
                  final substance = args['substance'] as String?;
                  return FeatureGate(
                    featureName: FeatureFlags.toleranceDashboardPage,
                    child: ToleranceDashboardPage(initialSubstance: substance),
                  );
                },
              },

              navigatorObservers: [widget.navigatorObserver],
            ),
          );
        },
      ),
    );
  }
}

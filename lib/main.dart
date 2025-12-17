import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
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

import 'screens/admin_panel_screen.dart';
import 'screens/analytics_page.dart';
import 'screens/blood_levels_page.dart';
import 'screens/catalog_page.dart';
import 'screens/change_pin_screen.dart';
import 'screens/checkin_history_screen.dart';
import 'screens/cravings_page.dart';
import 'screens/daily_checkin_screen.dart';
import 'screens/encryption_migration_screen.dart';
import 'screens/home_page.dart';
import 'features/log_entry/log_entry_page.dart';
import 'screens/login_page.dart';
import 'screens/pin_setup_screen.dart';
import 'screens/pin_unlock_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recovery_key_screen.dart';
import 'screens/reflection_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_screen.dart';
import 'screens/tolerance_dashboard_page.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/admin/feature_flags_screen.dart';
import 'screens/forgot_password_page.dart';
import 'screens/set_new_password_page.dart';
import 'screens/email_confirmed_page.dart';

import 'services/error_logging_service.dart';
import 'services/feature_flag_service.dart';
import 'services/auth_link_handler.dart';
import 'services/app_lock_controller.dart';

import 'providers/core_providers.dart';

import 'constants/config/feature_flags.dart';
import 'widgets/feature_flags/feature_gate.dart';

Future<void> main() async {
  final errorLoggingService = ErrorLoggingService.instance;

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Load .env
      try {
        await dotenv.load(fileName: ".env");
      } catch (_) {}

      final supabaseUrl = dotenv.env['SUPABASE_URL']!;
      final supabaseKey = dotenv.env['SUPABASE_ANON_KEY']!;

      // Init Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
      );

      await errorLoggingService.init();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        unawaited(errorLoggingService.logError(
          error: details.exception,
          stackTrace: details.stack,
        ));
      };

      ui.PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(errorLoggingService.logError(
          error: error,
          stackTrace: stack,
        ));
        return true;
      };

      final navigatorObserver = ScreenTrackingNavigatorObserver();
      final prefs = await SharedPreferences.getInstance();

      runApp(
        riverpod.ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
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
    _appLockSub = ref.listenManual(
      appLockControllerProvider,
      (previous, next) {
        final wasRequiringPin = previous?.requiresPin ?? false;
        if (wasRequiringPin || !next.requiresPin) return;

        final ctx = navigatorKey.currentContext;
        if (ctx == null || !ctx.mounted) return;

        unawaited(_navigateToPinUnlockIfEligible(ctx));
      },
    );
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
      unawaited(ref.read(appLockControllerProvider.notifier).onBackgroundStart());
    } else if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(appLockControllerProvider.notifier).onForegroundResume());
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
          final appTheme =
              AppTheme.fromSettings(settingsProvider.settings);

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

                '/admin/feature-flags': (_) =>
                    const FeatureFlagsScreen(),

                '/settings': (_) => const SettingsScreen(),

                '/tolerance-dashboard': (context) {
                  final args = ModalRoute.of(context)
                          ?.settings
                          .arguments as Map<String, dynamic>? ??
                      {};
                  final substance = args['substance'] as String?;
                  return FeatureGate(
                    featureName: FeatureFlags.toleranceDashboardPage,
                    child: ToleranceDashboardPage(
                      initialSubstance: substance,
                    ),
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


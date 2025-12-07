import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/daily_checkin_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/screen_tracking_observer.dart';
import 'constants/theme/app_theme.dart';
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
import 'screens/log_entry_page.dart';
import 'screens/login_page.dart';
import 'screens/pin_setup_screen.dart';
import 'screens/pin_unlock_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recovery_key_screen.dart';
import 'screens/reflection_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_screen.dart';
import 'services/error_logging_service.dart';
import 'services/feature_flag_service.dart';
import 'services/pin_timeout_service.dart';
import 'services/security_manager.dart';
import 'constants/config/feature_flags.dart';
import 'widgets/feature_flags/feature_gate.dart';
import 'screens/tolerance_dashboard_page.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/admin/feature_flags_screen.dart';
import 'screens/forgot_password_page.dart';
import 'screens/set_new_password_page.dart';
import 'screens/email_confirmed_page.dart';
import 'services/auth_link_handler.dart';

Future<void> main() async {
  final errorLoggingService = ErrorLoggingService.instance;

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Load environment variables from .env file
      print('🔧 DEBUG: Loading .env file...');
      try {
        await dotenv.load(fileName: ".env");
        print('✅ DEBUG: .env file loaded successfully');
      } catch (e) {
        print('⚠️ WARNING: Could not load .env file: $e');
        print('⚠️ Attempting to use environment variables directly...');
        // In production or when .env is missing, try to use system environment
        if (dotenv.env['SUPABASE_URL'] == null) {
          throw Exception('SUPABASE_URL not found in .env or environment');
        }
      }
      
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
      
      print('🔧 DEBUG: Supabase URL: ${supabaseUrl?.substring(0, 30)}...');
      print('🔧 DEBUG: Supabase Key exists: ${supabaseKey != null && supabaseKey.isNotEmpty}');
      
      // Initialize Supabase with credentials from .env and session persistence
      await Supabase.initialize(
        url: supabaseUrl!,
        anonKey: supabaseKey!,
        authOptions: FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
      );
      print('✅ DEBUG: Supabase initialized successfully');

      await errorLoggingService.init();
      print('✅ DEBUG: Error logging service initialized');

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
          errorLoggingService.logError(
            error: error,
            stackTrace: stack,
          ),
        );
        return true;
      };

      final navigatorObserver = ScreenTrackingNavigatorObserver();
      runApp(MyApp(navigatorObserver: navigatorObserver));
    },
    (error, stack) {
      errorLoggingService.logError(
        error: error,
        stackTrace: stack,
      );
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({required this.navigatorObserver, super.key});

  final NavigatorObserver navigatorObserver;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initServices();
  }

  Future<void> _initServices() async {
    await pinTimeoutService.init();
    await securityManager.init();
    
    // Load feature flags from database
    await featureFlagService.load();
    
    // Initialize deep link handler for auth flows
    authLinkHandler.init(navigatorKey);
    
    // Set up SecurityManager callbacks for navigation
    securityManager.onPinRequired = () {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/pin-unlock',
          (route) => route.settings.name == '/login_page',
        );
      }
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    authLinkHandler.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background - delegate to SecurityManager
        securityManager.handleBackgroundStart();
        break;
      case AppLifecycleState.resumed:
        // App coming to foreground - delegate to SecurityManager
        securityManager.handleForegroundResume();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is being closed or hidden
        break;
    }
  }

  // Global navigator key to access navigation from lifecycle handler
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider.value(value: featureFlagService),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.settings.darkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/login_page',
            routes: {
              // Auth routes - no feature gate (critical paths)
              '/login_page': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/privacy-policy': (_) => const PrivacyPolicyScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/pin-setup': (context) => const PinSetupScreen(),
              '/pin-unlock': (context) => const PinUnlockScreen(),
              '/recovery-key': (context) => const RecoveryKeyScreen(),
              '/encryption-migration': (context) => const EncryptionMigrationScreen(),
              '/change-pin': (context) => const ChangePinScreen(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/set-new-password': (context) => const SetNewPasswordPage(),
              '/email-confirmed': (context) => const EmailConfirmedPage(),
              
              // Feature-gated routes
              '/home_page': (context) => FeatureGate(
                featureName: FeatureFlags.homePage,
                child: const HomePage(),
              ),
              '/log_entry': (context) => FeatureGate(
                featureName: FeatureFlags.logEntryPage,
                child: const QuickLogEntryPage(),
              ),
              '/analytics': (context) => FeatureGate(
                featureName: FeatureFlags.analyticsPage,
                child: const AnalyticsPage(),
              ),
              '/catalog': (context) => FeatureGate(
                featureName: FeatureFlags.catalogPage,
                child: const CatalogPage(),
              ),
              '/cravings': (context) => FeatureGate(
                featureName: FeatureFlags.cravingsPage,
                child: const CravingsPage(),
              ),
              '/blood_levels': (context) => FeatureGate(
                featureName: FeatureFlags.bloodLevelsPage,
                child: const BloodLevelsPage(),
              ),
              '/reflection': (context) => FeatureGate(
                featureName: FeatureFlags.reflectionPage,
                child: const ReflectionPage(),
              ),
              '/daily-checkin': (context) => FeatureGate(
                featureName: FeatureFlags.dailyCheckin,
                child: ChangeNotifierProvider(
                  create: (_) => DailyCheckinProvider(),
                  child: const DailyCheckinScreen(),
                ),
              ),
              '/checkin-history': (context) => FeatureGate(
                featureName: FeatureFlags.checkinHistoryPage,
                child: ChangeNotifierProvider(
                  create: (_) => DailyCheckinProvider(),
                  child: const CheckinHistoryScreen(),
                ),
              ),
              '/profile': (context) => const ProfileScreen(),
              '/admin-panel': (context) => FeatureGate(
                featureName: FeatureFlags.adminPanel,
                child: const AdminPanelScreen(),
              ),
              '/admin/feature-flags': (context) => const FeatureFlagsScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/tolerance-dashboard': (context) {
                final args =
                    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                final substance = args?['substance'] as String?;
                return FeatureGate(
                  featureName: FeatureFlags.toleranceDashboardPage,
                  child: ToleranceDashboardPage(initialSubstance: substance),
                );
              },
            },
            navigatorObservers: [widget.navigatorObserver],
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/daily_checkin_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/screen_tracking_observer.dart';
import 'theme/app_theme.dart';
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
import 'services/pin_timeout_service.dart';
import 'services/security_manager.dart';
import 'screens/tolerance_dashboard_page.dart';
import 'screens/onboarding_screen.dart';

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
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
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
              '/login_page': (context) => const LoginPage(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/home_page': (context) => const HomePage(),
              '/log_entry': (context) => const QuickLogEntryPage(),
              '/analytics': (context) => const AnalyticsPage(),
              '/catalog': (context) => const CatalogPage(),
              '/cravings': (context) => const CravingsPage(),
              '/blood_levels': (context) => const BloodLevelsPage(),
              '/reflection': (context) => const ReflectionPage(),
              '/daily-checkin': (context) => ChangeNotifierProvider(
                create: (_) => DailyCheckinProvider(),
                child: const DailyCheckinScreen(),
              ),
              '/checkin-history': (context) => ChangeNotifierProvider(
                create: (_) => DailyCheckinProvider(),
                child: const CheckinHistoryScreen(),
              ),
              '/profile': (context) => const ProfileScreen(),
              '/admin-panel': (context) => const AdminPanelScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/register': (context) => const RegisterPage(),
              '/pin-setup': (context) => const PinSetupScreen(),
              '/pin-unlock': (context) => const PinUnlockScreen(),
              '/recovery-key': (context) => const RecoveryKeyScreen(),
              '/encryption-migration': (context) => const EncryptionMigrationScreen(),
              '/change-pin': (context) => const ChangePinScreen(),
              '/tolerance-dashboard': (context) {
                final args =
                    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                final substance = args?['substance'] as String?;
                return ToleranceDashboardPage(initialSubstance: substance);
              },
            },
            navigatorObservers: [widget.navigatorObserver],
          );
        },
      ),
    );
  }
}

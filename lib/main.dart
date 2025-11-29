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
import 'screens/checkin_history_screen.dart';
import 'screens/cravings_page.dart';
import 'screens/daily_checkin_screen.dart';
import 'screens/home_page.dart';
import 'screens/log_entry_page.dart';
import 'screens/login_page.dart';
import 'screens/profile_screen.dart';
import 'screens/reflection_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_screen.dart';
import 'services/error_logging_service.dart';
import 'screens/tolerance_dashboard_page.dart';

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
      
      // Initialize Supabase with credentials from .env
      await Supabase.initialize(
        url: supabaseUrl!,
        anonKey: supabaseKey!,
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

class MyApp extends StatelessWidget {
  const MyApp({required this.navigatorObserver, super.key});

  final NavigatorObserver navigatorObserver;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.settings.darkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/login_page',
            routes: {
              '/login_page': (context) => const LoginPage(),
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
              '/tolerance-dashboard': (context) {
                final args =
                    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                final substance = args?['substance'] as String?;
                return ToleranceDashboardPage(initialSubstance: substance);
              },
            },
            navigatorObservers: [navigatorObserver],
          );
        },
      ),
    );
  }
}

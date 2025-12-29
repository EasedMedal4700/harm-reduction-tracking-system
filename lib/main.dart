// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: COMPLETE
// Common: N/A
// Notes: Entry point.
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'common/logging/app_log.dart';
import 'features/settings/providers/settings_provider.dart';
import 'core/routes/screen_tracking_observer.dart';
import 'core/providers/navigation_provider.dart';
import 'constants/theme/app_theme_provider.dart';
import 'core/services/error_logging_service.dart';
import 'features/feature_flags/services/feature_flag_service.dart';
import 'features/login/services/auth_link_handler.dart';
import 'features/login/pin_unlock/providers/app_lock_controller.dart';
import 'core/providers/core_providers.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  final errorLoggingService = ErrorLoggingService.instance;
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Load .env
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        AppLog.e('Error loading .env file: $e');
        // If .env fails to load, we might want to throw or handle it,
        // but for now let's at least see the error.
      }
      if (!dotenv.isInitialized) {
        AppLog.w('DotEnv not initialized. Check if .env file exists.');
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
        AppLog.e('Supabase not initialized: Missing credentials');
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
  late final GoRouter _router;
  riverpod.ProviderSubscription<AppLockState>? _appLockSub;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router = createAppRouter(observer: widget.navigatorObserver);
    // Bind legacy NavigationService to GoRouter so controller-driven navigation
    // continues to work while we migrate call sites.
    ref.read(navigationProvider).bind(_router.routerDelegate.navigatorKey);
    _initServices();
    _setupAppLockListener();
  }

  Future<void> _initServices() async {
    await featureFlagService.load();
    // Provide GoRouter's navigatorKey for deep-link routing.
    authLinkHandler.init(_router.routerDelegate.navigatorKey);
  }

  void _setupAppLockListener() {
    _appLockSub?.close();
    _appLockSub = ref.listenManual(appLockControllerProvider, (previous, next) {
      final wasRequiringPin = previous?.requiresPin ?? false;
      if (wasRequiringPin || !next.requiresPin) return;
      final ctx = _router.routerDelegate.navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      unawaited(_navigateToPinUnlockIfEligible(ctx));
    });
  }

  Future<void> _navigateToPinUnlockIfEligible(BuildContext ctx) async {
    final currentLocation = GoRouter.of(ctx).state.uri.toString();
    if (currentLocation == '/pin-unlock' || currentLocation == '/login_page') {
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
    GoRouter.of(ctx).go('/pin-unlock');
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
            child: MaterialApp.router(
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light().themeData,
              darkTheme: AppTheme.dark().themeData,
              themeMode: settingsProvider.settings.darkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
            ),
          );
        },
      ),
    );
  }
}

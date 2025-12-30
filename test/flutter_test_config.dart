import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart'; // Import Override from src
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

// Global test configuration for all Flutter tests
// This file is automatically discovered by Flutter's test runner

/// Sets up global test configuration
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Set up global test configuration
  TestWidgetsFlutterBinding.ensureInitialized();

  // Disable animations for consistent test results
  timeDilation = 1.0;

  // Configure golden file testing (if used)
  // GoldenFileComparator.rootPath = 'test/goldens';

  // Set up any global mocks or stubs here if needed
  // e.g., HTTP overrides, database mocks, etc.

  await testMain();
}

/// Common test utilities and helpers

/// Common test utilities and helpers
class TestUtils {
  /// Creates a test app wrapper with theme and providers
  static Widget createTestApp({
    required Widget child,
    List<Override> providerOverrides = const [],
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      overrides: providerOverrides,
      child: AppThemeProvider(
        theme: themeMode == ThemeMode.light
            ? AppTheme.light()
            : AppTheme.dark(),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: Scaffold(body: child),
          // Disable animations in tests for consistency
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Animation scale is handled globally in test setup
            ),
            child: child!,
          ),
        ),
      ),
    );
  }

  /// Creates a test app with navigation
  static Widget createTestAppWithNavigation({
    required Widget home,
    List<Override> providerOverrides = const [],
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      overrides: providerOverrides,
      child: AppThemeProvider(
        theme: themeMode == ThemeMode.light
            ? AppTheme.light()
            : AppTheme.dark(),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: home,
          // Disable animations in tests
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Animation scale is handled globally in test setup
            ),
            child: child!,
          ),
        ),
      ),
    );
  }

  /// Pumps a widget and waits for it to settle
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }
}

/// Custom test matchers for common assertions
extension CustomMatchers on WidgetTester {
  /// Waits for a widget to appear with timeout
  Future<void> waitFor(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      if (finder.evaluate().isNotEmpty) return;
      await pump(const Duration(milliseconds: 100));
    }
    throw TestFailure('Widget not found within timeout: $finder');
  }

  /// Pumps until a condition is met
  Future<void> pumpUntil(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      if (condition()) return;
      await pump(const Duration(milliseconds: 100));
    }
    throw TestFailure('Condition not met within timeout');
  }
}

/// Test configuration constants
class TestConfig {
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration animationTimeout = Duration(seconds: 5);
  static const Size defaultTestSize = Size(400, 800);

  /// Test device sizes for responsive testing
  static const Map<String, Size> deviceSizes = {
    'mobile': Size(375, 667), // iPhone SE
    'tablet': Size(768, 1024), // iPad
    'desktop': Size(1920, 1080), // Desktop
  };
}

/// Test data helpers
class TestData {
  static const String testUserId = 'test-user-123';
  static const String testEmail = 'test@example.com';
  static const String testPin = '1234';

  static Map<String, dynamic> createTestUserProfile({
    String name = 'Test User',
    String email = testEmail,
  }) {
    return {
      'id': testUserId,
      'name': name,
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/utils/error_reporter.dart';
import 'package:mobile_drug_use_app/utils/error_handler.dart';

/// Wrapper for test functions that logs failures to ErrorReporter
///
/// Usage:
/// ```dart
/// testWithErrorLogging('my test description', () {
///   expect(1 + 1, 2);
/// });
/// ```
void testWithErrorLogging(
  String description,
  dynamic Function() body, {
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  test(
    description,
    () async {
      try {
        await body();
      } catch (error, stackTrace) {
        // Log test failure to ErrorReporter
        try {
          await ErrorReporter.instance.reportError(
            error: error,
            stackTrace: stackTrace,
            screenName: 'unit_test',
            context: 'Test "$description" failed',
            extraData: {
              'test_name': description,
              'test_type': 'unit_test',
              'test_file': stackTrace.toString().split('\n').first,
            },
          );
        } catch (reportError) {
          // If error reporting fails, just log it
          ErrorHandler.logError('testWithErrorLogging', reportError);
        }

        // Re-throw to fail the test
        rethrow;
      }
    },
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

/// Wrapper for widget tests that logs failures to ErrorReporter
///
/// Usage:
/// ```dart
/// testWidgetsWithErrorLogging('renders correctly', (WidgetTester tester) async {
///   await tester.pumpWidget(MyWidget());
///   expect(find.text('Hello'), findsOneWidget);
/// });
/// ```
void testWidgetsWithErrorLogging(
  String description,
  WidgetTesterCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  testWidgets(
    description,
    (WidgetTester tester) async {
      try {
        await callback(tester);
      } catch (error, stackTrace) {
        // Log widget test failure to ErrorReporter
        try {
          await ErrorReporter.instance.reportError(
            error: error,
            stackTrace: stackTrace,
            screenName: 'widget_test',
            context: 'Widget test "$description" failed',
            extraData: {
              'test_name': description,
              'test_type': 'widget_test',
              'test_file': stackTrace.toString().split('\n').first,
              'semantics_enabled': semanticsEnabled,
            },
          );
        } catch (reportError) {
          // If error reporting fails, just log it
          ErrorHandler.logError('testWidgetsWithErrorLogging', reportError);
        }

        // Re-throw to fail the test
        rethrow;
      }
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

/// Wrapper for test groups that logs setup/teardown failures
///
/// Usage:
/// ```dart
/// groupWithErrorLogging('MyClass', () {
///   testWithErrorLogging('test 1', () { ... });
///   testWithErrorLogging('test 2', () { ... });
/// });
/// ```
void groupWithErrorLogging(String description, dynamic Function() body) {
  group(description, () {
    try {
      body();
    } catch (error, stackTrace) {
      // Log group setup failure
      try {
        ErrorReporter.instance.reportError(
          error: error,
          stackTrace: stackTrace,
          screenName: 'test_group',
          context: 'Test group "$description" setup failed',
          extraData: {'test_group': description, 'test_type': 'group_setup'},
        );
      } catch (reportError) {
        // If error reporting fails, just log it
        ErrorHandler.logError('groupWithErrorLogging', reportError);
      }

      rethrow;
    }
  });
}

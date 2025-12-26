import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_drug_use_app/utils/error_reporter.dart';

/// Test wrapper that reports test failures to the error database
///
/// Usage:
/// ```dart
/// testWithErrorReporting('my test', () {
///   expect(1 + 1, equals(2));
/// });
/// ```
void testWithErrorReporting(
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
        // Report test failure to database
        try {
          await ErrorReporter.instance.reportError(
            error: error,
            stackTrace: stackTrace,
            screenName: 'TestRunner',
            extraData: {
              'test_name': description,
              'test_file': stackTrace.toString().split('\n').first,
              'is_test_failure': true,
            },
          );
        } catch (reportError) {
          // If reporting fails, just print it
          debugPrint('Failed to report test error: $reportError');
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

/// Group wrapper that reports group setup/teardown failures
void groupWithErrorReporting(String description, dynamic Function() body) {
  group(description, () {
    try {
      body();
    } catch (error, stackTrace) {
      // Report group setup failure
      ErrorReporter.instance.reportError(
        error: error,
        stackTrace: stackTrace,
        screenName: 'TestRunner',
        extraData: {'group_name': description, 'is_group_setup_failure': true},
      );
      rethrow;
    }
  });
}

/// Setup function that reports errors during test setup
Future<void> setUpWithErrorReporting(
  dynamic Function() body, {
  String? context,
}) async {
  setUp(() async {
    try {
      await body();
    } catch (error, stackTrace) {
      await ErrorReporter.instance.reportError(
        error: error,
        stackTrace: stackTrace,
        screenName: 'TestRunner',
        extraData: {'context': context ?? 'setUp', 'is_setup_failure': true},
      );
      rethrow;
    }
  });
}

/// Teardown function that reports errors during test cleanup
Future<void> tearDownWithErrorReporting(
  dynamic Function() body, {
  String? context,
}) async {
  tearDown(() async {
    try {
      await body();
    } catch (error, stackTrace) {
      await ErrorReporter.instance.reportError(
        error: error,
        stackTrace: stackTrace,
        screenName: 'TestRunner',
        extraData: {
          'context': context ?? 'tearDown',
          'is_teardown_failure': true,
        },
      );
      rethrow;
    }
  });
}

// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod controller for bug report submission.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/logging/logger.dart';
import '../../../core/providers/navigation_provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/utils/error_reporter.dart';
import '../models/bug_report_state.dart';

part 'bug_report_providers.g.dart';

class BugReportOptions {
  static const severityLevels = <String>['Low', 'Medium', 'High', 'Critical'];
  static const categories = <String>[
    'General',
    'UI/UX',
    'Performance',
    'Data Entry',
    'Analytics',
    'Crash',
    'Other',
  ];
}

@Riverpod()
class BugReportController extends _$BugReportController {
  @override
  BugReportState build() {
    return const BugReportState();
  }

  void clearUiEvent() {
    state = state.copyWith(uiEvent: const BugReportUiEvent.none());
  }

  void setSeverity(String value) {
    state = state.copyWith(severity: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }

  Future<void> submit({
    required String title,
    required String description,
    required String steps,
  }) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final userId = UserService.getCurrentUserId();

      await ErrorReporter.instance.reportError(
        error: Exception(title),
        stackTrace: StackTrace.current,
        screenName: 'BugReport',
        extraData: {
          'type': 'user_bug_report',
          'title': title,
          'description': description,
          'steps_to_reproduce': steps,
          'severity': state.severity,
          'category': state.category,
          'uuid_user_id': userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      state = state.copyWith(
        isSubmitting: false,
        uiEvent: const BugReportUiEvent.snackbar(
          message: 'Bug report submitted successfully',
        ),
      );

      ref.read(navigationProvider).pop();
    } catch (e, st) {
      logger.error(
        '[BugReportController] submit failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isSubmitting: false,
        uiEvent: BugReportUiEvent.snackbar(
          message: 'Failed to submit bug report: $e',
          isError: true,
        ),
      );
    }
  }
}

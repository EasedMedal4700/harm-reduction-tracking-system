// MIGRATION:
// State: MIXED (legacy ChangeNotifier, Riverpod wiring)
// Navigation: N/A
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod wrapper for legacy LogEntryState.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../log_entry_state.dart';

final logEntryStateProvider = ChangeNotifierProvider.autoDispose<LogEntryState>(
  (ref) {
    return LogEntryState();
  },
);

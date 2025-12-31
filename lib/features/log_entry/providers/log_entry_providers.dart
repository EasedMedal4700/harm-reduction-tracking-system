export '../log_entry_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../log_entry_service.dart';

final logEntryServiceProvider = Provider<LogEntryService>((ref) {
  return LogEntryService();
});

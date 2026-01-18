export '../log_entry_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';

import '../log_entry_controller.dart';
import '../log_entry_service.dart';

final logEntryServiceProvider = Provider<LogEntryService>((ref) {
  return LogEntryService();
});

final logEntryControllerProvider = Provider<LogEntryController>((ref) {
  return LogEntryController(
    substanceRepo: ref.watch(substanceRepositoryProvider),
    stockpileRepo: ref.watch(stockpileRepositoryProvider),
    logEntryService: ref.watch(logEntryServiceProvider),
    timezoneService: ref.watch(timezoneServiceProvider),
  );
});

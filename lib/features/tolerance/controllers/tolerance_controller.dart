// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Controller for tolerance feature

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/tolerance_models.dart';
import 'tolerance_repository.dart';
import 'tolerance_logic.dart';

part 'tolerance_controller.g.dart';

@riverpod
class ToleranceController extends _$ToleranceController {
  @override
  Future<ToleranceResult> build(String userId) async {
    final repository = ref.watch(toleranceRepositoryProvider);

    // Fetch data in parallel
    final results = await Future.wait([
      repository.fetchToleranceModels(),
      repository.fetchUseLogs(userId: userId),
    ]);

    final models = results[0] as Map<String, ToleranceModel>;
    final logs = results[1] as List<UseLogEntry>;

    // Compute tolerance using pure logic
    return ToleranceLogic.computeTolerance(
      useLogs: logs,
      toleranceModels: models,
    );
  }
}

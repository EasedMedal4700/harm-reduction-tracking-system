// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Feature provider.
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/providers/core_providers.dart';

import '../models/activity_models.dart';
import '../models/activity_state.dart';
import '../services/activity_service.dart';

part 'activity_providers.g.dart';

@riverpod
ActivityService activityService(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final encryptionService = ref.watch(encryptionServiceProvider);
  return ActivityService(client: client, encryptionService: encryptionService);
}

@riverpod
class ActivityController extends _$ActivityController {
  @override
  Future<ActivityState> build() async {
    final data = await ref.watch(activityServiceProvider).fetchRecentActivity();
    return ActivityState(data: data);
  }

  Future<void> refreshActivity() async {
    state = const AsyncLoading<ActivityState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final data = await ref
          .read(activityServiceProvider)
          .fetchRecentActivity();
      return ActivityState(data: data);
    });
  }

  Future<void> deleteEntry({
    required String id,
    required ActivityItemType type,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isDeleting: true, event: null));

    try {
      await ref
          .read(activityServiceProvider)
          .deleteActivityItem(type: type, id: id);
      await refreshActivity();
      final refreshed = state.valueOrNull;
      if (refreshed != null) {
        state = AsyncData(
          refreshed.copyWith(
            event: ActivityUiEvent.snackBar(
              message: 'Deleted ${type.displayName} entry',
              tone: ActivityUiEventTone.success,
            ),
          ),
        );
      }
    } catch (_) {
      final stillCurrent = state.valueOrNull ?? current;
      state = AsyncData(
        stillCurrent.copyWith(
          isDeleting: false,
          event: const ActivityUiEvent.snackBar(
            message: 'Failed to delete entry',
            tone: ActivityUiEventTone.error,
          ),
        ),
      );
    }
  }

  void clearEvent() {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.event == null) return;
    state = AsyncData(current.copyWith(event: null));
  }
}

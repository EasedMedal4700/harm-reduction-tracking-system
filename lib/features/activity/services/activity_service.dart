import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/encryption_service_v2.dart';
import '../models/activity_models.dart';

class ActivityService {
  ActivityService({
    required SupabaseClient client,
    required EncryptionServiceV2 encryptionService,
  }) : _client = client,
       _encryptionService = encryptionService;

  final SupabaseClient _client;
  final EncryptionServiceV2 _encryptionService;

  static const _activityFetchLimit = 10;

  Future<ActivityData> fetchRecentActivity() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw StateError('User is not logged in.');
      }
      final userId = user.id;

      final entries = await _client
          .from('drug_use')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('start_time', ascending: false)
          .limit(_activityFetchLimit);

      final decryptedEntries = await Future.wait(
        (entries as List).map((entry) async {
          return await _encryptionService.decryptFields(
            entry as Map<String, dynamic>,
            ['notes'],
          );
        }),
      );

      final cravings = await _client
          .from('cravings')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('time', ascending: false) // Change to 'time'
          .limit(_activityFetchLimit);

      final decryptedCravings = await Future.wait(
        (cravings as List).map((craving) async {
          return await _encryptionService.decryptFields(
            craving as Map<String, dynamic>,
            ['action', 'thoughts'],
          );
        }),
      );

      final reflections = await _client
          .from('reflections')
          .select('*')
          .eq('uuid_user_id', userId)
          .order(
            'created_at',
            ascending: false,
          ) // Keep as is, or change to 'time' if needed
          .limit(_activityFetchLimit);

      final decryptedReflections = await Future.wait(
        (reflections as List).map((reflection) async {
          return await _encryptionService.decryptFields(
            reflection as Map<String, dynamic>,
            ['notes'],
          );
        }),
      );

      return ActivityData(
        entries: decryptedEntries
            .whereType<Map<String, dynamic>>()
            .map(ActivityDrugUseEntry.fromMap)
            .toList(growable: false),
        cravings: decryptedCravings
            .whereType<Map<String, dynamic>>()
            .map(ActivityCravingEntry.fromMap)
            .toList(growable: false),
        reflections: decryptedReflections
            .whereType<Map<String, dynamic>>()
            .map(ActivityReflectionEntry.fromMap)
            .toList(growable: false),
      );
    } catch (e, stackTrace) {
      logger.error(
        'ActivityService.fetchRecentActivity failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> deleteActivityItem({
    required ActivityItemType type,
    required String id,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }

    try {
      await _client
          .from(type.tableName)
          .delete()
          .eq(type.idColumn, id)
          .eq('uuid_user_id', user.id);
    } catch (e, stackTrace) {
      logger.error(
        'ActivityService.deleteActivityItem failed (type=${type.name})',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

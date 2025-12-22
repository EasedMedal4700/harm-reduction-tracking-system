import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/error_handler.dart';
import '../../../services/encryption_service_v2.dart';

class ActivityService {
  final SupabaseClient _client;
  final EncryptionServiceV2 _encryption;

  ActivityService({SupabaseClient? client, EncryptionServiceV2? encryption})
    : _client = client ?? Supabase.instance.client,
      _encryption = encryption ?? EncryptionServiceV2();

  Future<Map<String, dynamic>> fetchRecentActivity() async {
    try {
      final supabase = _client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw StateError('User is not logged in.');
      }
      final userId = user.id;

      // Fetch recent entries (last 10)
      final entries = await supabase
          .from('drug_use')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('start_time', ascending: false)
          .limit(10);

      // Decrypt notes field in drug_use entries
      final decryptedEntries = await Future.wait(
        (entries as List).map((entry) async {
          return await _encryption.decryptFields(
            entry as Map<String, dynamic>,
            ['notes'],
          );
        }),
      );

      // Fetch recent cravings (last 10)
      final cravings = await supabase
          .from('cravings')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('time', ascending: false) // Change to 'time'
          .limit(10);

      // Decrypt action and thoughts fields in cravings
      final decryptedCravings = await Future.wait(
        (cravings as List).map((craving) async {
          return await _encryption.decryptFields(
            craving as Map<String, dynamic>,
            ['action', 'thoughts'],
          );
        }),
      );

      // Fetch recent reflections (last 10)
      final reflections = await supabase
          .from('reflections')
          .select('*')
          .eq('uuid_user_id', userId)
          .order(
            'created_at',
            ascending: false,
          ) // Keep as is, or change to 'time' if needed
          .limit(10);

      // Decrypt notes field in reflections
      final decryptedReflections = await Future.wait(
        (reflections as List).map((reflection) async {
          return await _encryption.decryptFields(
            reflection as Map<String, dynamic>,
            ['notes'],
          );
        }),
      );

      return {
        'entries': decryptedEntries,
        'cravings': decryptedCravings,
        'reflections': decryptedReflections,
      };
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ActivityService.fetchRecentActivity',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'user_service.dart';

class ActivityService {
  Future<Map<String, dynamic>> fetchRecentActivity() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();

      // Fetch recent entries (last 10)
      final entries = await supabase
          .from('drug_use')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('start_time', ascending: false)
          .limit(10);

      // Fetch recent cravings (last 10)
      final cravings = await supabase
          .from('cravings')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('time', ascending: false) // Change to 'time'
          .limit(10);

      // Fetch recent reflections (last 10)
      final reflections = await supabase
          .from('reflections')
          .select('*')
          .eq('uuid_user_id', userId)
          .order('created_at', ascending: false) // Keep as is, or change to 'time' if needed
          .limit(10);

      return {
        'entries': entries,
        'cravings': cravings,
        'reflections': reflections,
      };
    } catch (e, stackTrace) {
      ErrorHandler.logError('ActivityService.fetchRecentActivity', e, stackTrace);
      rethrow;
    }
  }
}

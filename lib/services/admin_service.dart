import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

class AdminService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all users for admin panel
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      ErrorHandler.logDebug('AdminService', 'Fetching all users');

      final response = await _client
          .from('users')
          .select('user_id, email, display_name, is_admin, created_at, updated_at')
          .order('created_at', ascending: false);

      // Get entry counts for each user
      final users = response as List<dynamic>;
      final enrichedUsers = <Map<String, dynamic>>[];

      for (var user in users) {
        final userData = Map<String, dynamic>.from(user);
        
        // Get entry count
        final entryCountResponse = await _client
            .from('drug_use')
            .select('use_id')
            .eq('user_id', userData['user_id']);
        
        userData['entry_count'] = (entryCountResponse as List).length;
        enrichedUsers.add(userData);
      }

      ErrorHandler.logInfo('AdminService', 'Fetched ${enrichedUsers.length} users');
      return enrichedUsers;
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.fetchAllUsers', e, stackTrace);
      rethrow;
    }
  }

  /// Promote a user to admin
  Future<void> promoteUser(int userId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Promoting user: $userId');

      await _client
          .from('users')
          .update({'is_admin': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId);

      ErrorHandler.logInfo('AdminService', 'User $userId promoted to admin');
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.promoteUser', e, stackTrace);
      rethrow;
    }
  }

  /// Demote a user from admin
  Future<void> demoteUser(int userId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Demoting user: $userId');

      await _client
          .from('users')
          .update({'is_admin': false, 'updated_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId);

      ErrorHandler.logInfo('AdminService', 'User $userId demoted from admin');
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.demoteUser', e, stackTrace);
      rethrow;
    }
  }

  /// Get system statistics
  Future<Map<String, dynamic>> getSystemStats() async {
    try {
      ErrorHandler.logDebug('AdminService', 'Fetching system stats');

      // Total entries
      final entriesResponse = await _client
          .from('drug_use')
          .select('use_id');
      
      final totalEntries = (entriesResponse as List).length;

      // Active users (users with entries in last 30 days)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final activeUsersResponse = await _client
          .from('drug_use')
          .select('user_id')
          .gte('start_time', thirtyDaysAgo.toIso8601String());
      
      // Get unique user IDs
      final userIds = <int>{};
      for (var entry in activeUsersResponse as List) {
        userIds.add(entry['user_id'] as int);
      }
      final activeUsers = userIds.length;

      return {
        'total_entries': totalEntries,
        'active_users': activeUsers,
        'cache_hit_rate': 0.0, // Placeholder
        'avg_response_time': 0.0, // Placeholder
      };
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.getSystemStats', e, stackTrace);
      return {
        'total_entries': 0,
        'active_users': 0,
        'cache_hit_rate': 0.0,
        'avg_response_time': 0.0,
      };
    }
  }

  /// Delete a user (admin only)
  Future<void> deleteUser(int userId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Deleting user: $userId');

      await _client
          .from('users')
          .delete()
          .eq('user_id', userId);

      ErrorHandler.logInfo('AdminService', 'User $userId deleted');
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.deleteUser', e, stackTrace);
      rethrow;
    }
  }
}

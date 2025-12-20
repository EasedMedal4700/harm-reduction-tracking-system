import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';
import 'performance_service.dart';

class AdminService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all users for admin panel
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final stopwatch = Stopwatch()..start();
    try {
      ErrorHandler.logDebug(
        'AdminService',
        'Fetching all users from public.users table',
      );

      // Query public.users - only has auth_user_id, display_name, is_admin
      final response = await _client
          .from('users')
          .select('auth_user_id, display_name, is_admin')
          .order('auth_user_id', ascending: false);

      ErrorHandler.logDebug(
        'AdminService',
        'Got ${(response as List).length} users from public.users',
      );

      // Get entry counts for each user
      final users = response as List<dynamic>;
      final enrichedUsers = <Map<String, dynamic>>[];

      for (var user in users) {
        final userData = Map<String, dynamic>.from(user);
        final authUserId = userData['auth_user_id'] as String?;

        ErrorHandler.logDebug(
          'AdminService',
          'Processing user with auth_user_id: $authUserId',
        );

        if (authUserId != null) {
          // Get email and timestamps from auth.users
          try {
            ErrorHandler.logDebug(
              'AdminService',
              'Fetching auth data for user: $authUserId',
            );
            final authUser = await _client.auth.admin.getUserById(authUserId);
            userData['email'] = authUser.user?.email ?? 'N/A';
            userData['created_at'] = authUser.user?.createdAt;
            userData['updated_at'] = authUser.user?.updatedAt;
            ErrorHandler.logDebug(
              'AdminService',
              'Got email: ${userData['email']} for user: $authUserId',
            );
          } catch (e) {
            ErrorHandler.logWarning(
              'AdminService',
              'Failed to fetch auth data for user $authUserId: $e',
            );
            userData['email'] = 'N/A';
            userData['created_at'] = null;
            userData['updated_at'] = null;
          }

          // Get drug use entry count
          try {
            ErrorHandler.logDebug(
              'AdminService',
              'Fetching drug_use entries for user: $authUserId',
            );
            final entries = await _client
                .from('drug_use')
                .select('use_id')
                .eq('uuid_user_id', authUserId);
            userData['entry_count'] = (entries as List).length;
            ErrorHandler.logDebug(
              'AdminService',
              'User $authUserId has ${userData['entry_count']} entries',
            );

            // Get last activity date
            if ((entries as List).isNotEmpty) {
              final lastEntry = await _client
                  .from('drug_use')
                  .select('start_time')
                  .eq('uuid_user_id', authUserId)
                  .order('start_time', ascending: false)
                  .limit(1)
                  .maybeSingle();
              userData['last_activity'] = lastEntry?['start_time'];
              ErrorHandler.logDebug(
                'AdminService',
                'User $authUserId last activity: ${userData['last_activity']}',
              );
            } else {
              userData['last_activity'] = null;
            }

            // Get craving count
            ErrorHandler.logDebug(
              'AdminService',
              'Fetching cravings for user: $authUserId',
            );
            final cravings = await _client
                .from('cravings')
                .select('craving_id')
                .eq('uuid_user_id', authUserId);
            userData['craving_count'] = (cravings as List).length;
            ErrorHandler.logDebug(
              'AdminService',
              'User $authUserId has ${userData['craving_count']} cravings',
            );

            // Get reflection count
            ErrorHandler.logDebug(
              'AdminService',
              'Fetching reflections for user: $authUserId',
            );
            final reflections = await _client
                .from('reflections')
                .select('reflection_id')
                .eq('uuid_user_id', authUserId);
            userData['reflection_count'] = (reflections as List).length;
            ErrorHandler.logDebug(
              'AdminService',
              'User $authUserId has ${userData['reflection_count']} reflections',
            );
          } catch (e) {
            ErrorHandler.logError(
              'AdminService',
              'Error fetching stats for user $authUserId: $e',
              StackTrace.current,
            );
            userData['entry_count'] = 0;
            userData['craving_count'] = 0;
            userData['reflection_count'] = 0;
            userData['last_activity'] = null;
          }
        } else {
          ErrorHandler.logWarning(
            'AdminService',
            'User has null auth_user_id, skipping',
          );
          userData['email'] = 'N/A';
          userData['entry_count'] = 0;
          userData['craving_count'] = 0;
          userData['reflection_count'] = 0;
          userData['last_activity'] = null;
          userData['created_at'] = null;
          userData['updated_at'] = null;
        }

        enrichedUsers.add(userData);
      }

      ErrorHandler.logInfo(
        'AdminService',
        'Successfully fetched and enriched ${enrichedUsers.length} users',
      );

      // Record performance
      await PerformanceService.recordResponseTime(
        endpoint: 'fetchAllUsers',
        milliseconds: stopwatch.elapsedMilliseconds,
        fromCache: false,
      );

      return enrichedUsers;
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.fetchAllUsers', e, stackTrace);
      rethrow;
    }
  }

  /// Promote a user to admin
  Future<void> promoteUser(String authUserId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Promoting user: $authUserId');

      await _client
          .from('users')
          .update({
            'is_admin': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('auth_user_id', authUserId);

      ErrorHandler.logInfo(
        'AdminService',
        'User $authUserId promoted to admin',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.promoteUser', e, stackTrace);
      rethrow;
    }
  }

  /// Demote a user from admin
  Future<void> demoteUser(String authUserId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Demoting user: $authUserId');

      await _client
          .from('users')
          .update({
            'is_admin': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('auth_user_id', authUserId);

      ErrorHandler.logInfo(
        'AdminService',
        'User $authUserId demoted from admin',
      );
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
      final entriesResponse = await _client.from('drug_use').select('use_id');

      final totalEntries = (entriesResponse as List).length;

      // Active users (users with entries in last 30 days)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final activeUsersResponse = await _client
          .from('drug_use')
          .select('uuid_user_id')
          .gte('start_time', thirtyDaysAgo.toIso8601String());

      // Get unique user IDs
      final userIds = <String>{};
      for (var entry in activeUsersResponse as List) {
        userIds.add(entry['uuid_user_id'] as String);
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

  Future<Map<String, dynamic>> getErrorAnalytics() async {
    try {
      ErrorHandler.logDebug('AdminService', 'Fetching error analytics');

      final now = DateTime.now();
      final last24h = now.subtract(const Duration(hours: 24));

      final rawLogs =
          await _client
                  .from('error_logs')
                  .select(
                    'id, uuid_user_id, app_version, platform, os_version, device_model, screen_name, error_message, error_code, severity, stacktrace, extra_data, created_at',
                  )
                  .order('created_at', ascending: false)
                  .limit(500)
              as List;

      final logs = rawLogs
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      final totalErrors = logs.length;
      final last24hCount = logs.where((log) {
        final createdAt = DateTime.tryParse('${log['created_at']}');
        return createdAt != null && createdAt.isAfter(last24h);
      }).length;

      List<Map<String, dynamic>> buildTopCounts(
        String sourceKey,
        String labelKey,
      ) {
        final counts = <String, int>{};
        for (final log in logs) {
          final value = (log[sourceKey] ?? 'Unknown').toString();
          counts[value] = (counts[value] ?? 0) + 1;
        }
        final entries = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return entries.map((e) => {labelKey: e.key, 'count': e.value}).toList();
      }

      final recentLogs = logs.take(20).toList();

      return {
        'total_errors': totalErrors,
        'last_24h': last24hCount,
        'platform_breakdown': buildTopCounts('platform', 'platform'),
        'screen_breakdown': buildTopCounts('screen_name', 'screen_name'),
        'message_breakdown': buildTopCounts('error_message', 'error_message'),
        'severity_breakdown': buildTopCounts('severity', 'severity'),
        'error_code_breakdown': buildTopCounts('error_code', 'error_code'),
        'recent_logs': recentLogs,
      };
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.getErrorAnalytics', e, stackTrace);
      return {
        'total_errors': 0,
        'last_24h': 0,
        'platform_breakdown': const <Map<String, dynamic>>[],
        'screen_breakdown': const <Map<String, dynamic>>[],
        'message_breakdown': const <Map<String, dynamic>>[],
        'severity_breakdown': const <Map<String, dynamic>>[],
        'error_code_breakdown': const <Map<String, dynamic>>[],
        'recent_logs': const <Map<String, dynamic>>[],
      };
    }
  }

  Future<void> clearErrorLogs({
    bool deleteAll = false,
    int? olderThanDays,
    String? platform,
    String? screenName,
  }) async {
    if (!deleteAll &&
        olderThanDays == null &&
        (platform == null || platform.isEmpty) &&
        (screenName == null || screenName.isEmpty)) {
      throw ArgumentError('Select at least one filter or choose delete all.');
    }

    try {
      ErrorHandler.logDebug('AdminService', 'Clearing error logs');

      var deleteQuery = _client.from('error_logs').delete();

      if (!deleteAll) {
        if (olderThanDays != null) {
          final cutoff = DateTime.now().subtract(Duration(days: olderThanDays));
          deleteQuery = deleteQuery.lt('created_at', cutoff.toIso8601String());
        }
        if (platform != null && platform.isNotEmpty) {
          deleteQuery = deleteQuery.eq('platform', platform);
        }
        if (screenName != null && screenName.isNotEmpty) {
          deleteQuery = deleteQuery.eq('screen_name', screenName);
        }
      }

      await deleteQuery;
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.clearErrorLogs', e, stackTrace);
      rethrow;
    }
  }

  /// Delete a user (admin only)
  Future<void> deleteUser(String authUserId) async {
    try {
      ErrorHandler.logDebug('AdminService', 'Deleting user: $authUserId');

      await _client.from('users').delete().eq('auth_user_id', authUserId);

      ErrorHandler.logInfo('AdminService', 'User $authUserId deleted');
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminService.deleteUser', e, stackTrace);
      rethrow;
    }
  }
}

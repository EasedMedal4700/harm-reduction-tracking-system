import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/daily_checkin_model.dart';
import '../services/user_service.dart';
import '../utils/error_handler.dart';
import 'cache_service.dart';

abstract class DailyCheckinRepository {
  Future<void> saveCheckin(DailyCheckin checkin);
  Future<void> updateCheckin(String id, DailyCheckin checkin);
  Future<List<DailyCheckin>> fetchCheckinsByDate(DateTime date);
  Future<List<DailyCheckin>> fetchCheckinsInRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<DailyCheckin?> fetchCheckinByDateAndTime(
    DateTime date,
    String timeOfDay,
  );
  Future<void> deleteCheckin(String id);
}

class DailyCheckinService implements DailyCheckinRepository {
  final SupabaseClient _client;
  final CacheService _cache;
  final String Function() _getUserId;

  DailyCheckinService({
    SupabaseClient? client,
    CacheService? cache,
    String Function()? getUserId,
  }) : _client = client ?? Supabase.instance.client,
       _cache = cache ?? CacheService(),
       _getUserId = getUserId ?? UserService.getCurrentUserId;

  /// Save a new daily check-in to the database
  @override
  Future<void> saveCheckin(DailyCheckin checkin) async {
    try {
      ErrorHandler.logDebug('DailyCheckinService', 'Saving new check-in');

      final userId = _getUserId();
      final data = {
        'uuid_user_id': userId,
        'checkin_date': checkin.checkinDate.toIso8601String().split('T')[0],
        'mood': checkin.mood,
        'emotions': checkin.emotions,
        'time_of_day': checkin.timeOfDay,
        'notes': checkin.notes,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client.from('daily_checkins').insert(data);

      // Invalidate cache
      _cache.removePattern('daily_checkin');

      ErrorHandler.logInfo(
        'DailyCheckinService',
        'Check-in saved successfully',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('DailyCheckinService.saveCheckin', e, stackTrace);
      rethrow;
    }
  }

  /// Update an existing daily check-in
  @override
  Future<void> updateCheckin(String id, DailyCheckin checkin) async {
    try {
      ErrorHandler.logDebug('DailyCheckinService', 'Updating check-in: ');

      final userId = _getUserId();
      final data = {
        'mood': checkin.mood,
        'emotions': checkin.emotions,
        'time_of_day': checkin.timeOfDay,
        'notes': checkin.notes,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('daily_checkins')
          .update(data)
          .eq('id', id)
          .eq('uuid_user_id', userId)
          .select();

      if (response.isEmpty) {
        throw Exception('Check-in not found or access denied');
      }

      // Invalidate cache
      _cache.removePattern('daily_checkin');

      ErrorHandler.logInfo(
        'DailyCheckinService',
        'Check-in updated successfully',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('DailyCheckinService.updateCheckin', e, stackTrace);
      rethrow;
    }
  }

  /// Fetch check-ins for a specific date
  @override
  Future<List<DailyCheckin>> fetchCheckinsByDate(DateTime date) async {
    try {
      ErrorHandler.logDebug(
        'DailyCheckinService',
        'Fetching check-ins for date: $date',
      );

      final userId = _getUserId();
      final dateStr = date.toIso8601String().split('T')[0];

      final response = await _client
          .from('daily_checkins')
          .select()
          .eq('uuid_user_id', userId)
          .eq('checkin_date', dateStr)
          .order('created_at', ascending: true);

      final checkins = (response as List)
          .map((json) => DailyCheckin.fromJson(json as Map<String, dynamic>))
          .toList();

      ErrorHandler.logInfo(
        'DailyCheckinService',
        'Fetched ${checkins.length} check-ins',
      );
      return checkins;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'DailyCheckinService.fetchCheckinsByDate',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch check-ins for a date range
  @override
  Future<List<DailyCheckin>> fetchCheckinsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      ErrorHandler.logDebug(
        'DailyCheckinService',
        'Fetching check-ins from $startDate to $endDate',
      );

      final userId = _getUserId();
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final response = await _client
          .from('daily_checkins')
          .select()
          .eq('uuid_user_id', userId)
          .gte('checkin_date', startStr)
          .lte('checkin_date', endStr)
          .order('checkin_date', ascending: false)
          .order('created_at', ascending: false);

      final checkins = (response as List)
          .map((json) => DailyCheckin.fromJson(json as Map<String, dynamic>))
          .toList();

      ErrorHandler.logInfo(
        'DailyCheckinService',
        'Fetched ${checkins.length} check-ins in range',
      );
      return checkins;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'DailyCheckinService.fetchCheckinsInRange',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Check if a check-in exists for a specific date and time of day
  @override
  Future<DailyCheckin?> fetchCheckinByDateAndTime(
    DateTime date,
    String timeOfDay,
  ) async {
    try {
      ErrorHandler.logDebug(
        'DailyCheckinService',
        'Checking for existing check-in: $date, $timeOfDay',
      );

      final userId = _getUserId();
      final dateStr = date.toIso8601String().split('T')[0];

      final response = await _client
          .from('daily_checkins')
          .select()
          .eq('uuid_user_id', userId)
          .eq('checkin_date', dateStr)
          .eq('time_of_day', timeOfDay)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return DailyCheckin.fromJson(response);
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'DailyCheckinService.fetchCheckinByDateAndTime',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a check-in
  @override
  Future<void> deleteCheckin(String id) async {
    try {
      ErrorHandler.logDebug('DailyCheckinService', 'Deleting check-in: $id');

      final userId = _getUserId();

      await _client
          .from('daily_checkins')
          .delete()
          .eq('id', id)
          .eq('uuid_user_id', userId);

      ErrorHandler.logInfo(
        'DailyCheckinService',
        'Check-in deleted successfully',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('DailyCheckinService.deleteCheckin', e, stackTrace);
      rethrow;
    }
  }
}

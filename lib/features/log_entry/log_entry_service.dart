// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Service for log entry operations.

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/log_entry_model.dart';
import '../../services/user_service.dart'; // For user_id
import '../../utils/error_handler.dart';
import '../../services/cache_service.dart';
import '../../services/encryption_service_v2.dart';

class LogEntryService {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final _cache = CacheService();
  final _encryption = EncryptionServiceV2();

  Future<void> updateLogEntry(String id, Map<String, dynamic> data) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();

      // Encrypt notes field if it's being updated
      final encryptedData = await _encryption.encryptFields(data, ['notes']);

      await supabase
          .from('drug_use')
          .update(encryptedData)
          .eq('uuid_user_id', userId)
          .eq('use_id', id);

      // Invalidate cache for user's entries
      _cache.remove(CacheKeys.recentEntries(userId));
      _cache.remove(CacheKeys.drugEntry(id));
      _cache.removePattern('drug_entries:user:$userId');
    } catch (e, stackTrace) {
      ErrorHandler.logError('LogEntryService.updateLogEntry', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteLogEntry(String id) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      await supabase
          .from('drug_use')
          .delete()
          .eq('uuid_user_id', userId)
          .eq('use_id', id);

      // Invalidate cache for user's entries
      _cache.remove(CacheKeys.recentEntries(userId));
      _cache.remove(CacheKeys.drugEntry(id));
      _cache.removePattern('drug_entries:user:$userId');
    } catch (e, stackTrace) {
      ErrorHandler.logError('LogEntryService.deleteLogEntry', e, stackTrace);
      rethrow;
    }
  }

  Future<void> saveLogEntry(LogEntry entry) async {
    // Add validation
    if (entry.location == 'Select a location') {
      throw Exception('Please select a valid location');
    }

    try {
      // Get the auth user ID
      final userId = UserService.getCurrentUserId();

      // Encrypt notes field
      final encryptedNotes = await _encryption.encryptTextNullable(entry.notes);

      final data = {
        'uuid_user_id': userId,
        'name': entry.substance,
        'dose': '${entry.dosage} ${entry.unit}',
        'start_time': formatter.format(
          entry.datetime.toUtc(),
        ), // Format as UTC+00
        'consumption': entry.route,
        'intention':
            (entry.intention == null ||
                entry.intention == '-- Select Intention--')
            ? null
            : entry.intention,
        'craving_0_10': entry.cravingIntensity.toInt(), // Convert double to int
        'medical': entry.isMedicalPurpose.toString(),
        'primary_emotions': entry.feelings,
        'secondary_emotions': entry.secondaryFeelings.values
            .expand((list) => list)
            .toList(), // Flatten map to list
        'triggers': entry.triggers,
        'people': entry.people,
        'place': entry.location, // Remove default; use as-is
        'body_signals': entry.bodySignals,
        'notes': encryptedNotes,
        'linked_craving_ids': '{}',
        'timezone': entry.timezoneOffset.toString(),
      };

      await Supabase.instance.client.from('drug_use').insert(data);

      // Invalidate cache for user's entries
      _cache.remove(CacheKeys.recentEntries(userId));
      _cache.removePattern('drug_entries:user:$userId');
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError('LogEntryService.saveLogEntry', e, stackTrace);
      // Handle specific DB errors
      switch (e.code) {
        case 'PGRST116':
          throw Exception('Table not found. Please contact support.');
        case '23505':
          throw Exception('Duplicate entry detected.');
        case '42501':
          throw Exception('Permission denied. Please log in again.');
        default:
          throw Exception('Database error: ${e.message}');
      }
    } on Exception catch (e, stackTrace) {
      ErrorHandler.logError('LogEntryService.saveLogEntry', e, stackTrace);
      // Handle network/auth/other errors
      if (e.toString().contains('network')) {
        throw Exception('Network error. Check your connection.');
      } else if (e.toString().contains('auth')) {
        throw Exception('Authentication error. Please log in.');
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentEntriesRaw() async {
    try {
      final userId = UserService.getCurrentUserId();

      // Check cache first
      final cacheKey = CacheKeys.recentEntries(userId);
      final cached = _cache.get<List<Map<String, dynamic>>>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final response = await Supabase.instance.client
          .from('drug_use')
          .select('use_id, name, dose, start_time, place') // Select key fields
          .eq('uuid_user_id', userId)
          .order('start_time', ascending: false)
          .limit(10);

      final results = List<Map<String, dynamic>>.from(response);

      // Cache the results
      _cache.set(cacheKey, results, ttl: CacheService.defaultTTL);

      return results;
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError(
        'LogEntryService.fetchRecentEntriesRaw',
        e,
        stackTrace,
      );
      throw Exception('Failed to fetch entries: ${e.message}');
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'LogEntryService.fetchRecentEntriesRaw',
        e,
        stackTrace,
      );
      throw Exception('Unexpected error: $e');
    }
  }
}

// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Service for managing cravings.
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/craving_model.dart';
import 'package:mobile_drug_use_app/core/utils/error_handler.dart';
import 'package:mobile_drug_use_app/core/services/user_service.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';

class CravingService {
  final _uuid = const Uuid();
  final EncryptionServiceV2 _encryption;
  final SupabaseClient _supabase;
  final String Function() _getUserId;
  CravingService({
    EncryptionServiceV2? encryption,
    SupabaseClient? supabase,
    String Function()? getUserId,
  }) : _encryption = encryption ?? EncryptionServiceV2(),
       _supabase = supabase ?? Supabase.instance.client,
       _getUserId = getUserId ?? UserService.getCurrentUserId;
  Future<void> saveCraving(Craving craving) async {
    // Add validation
    if (craving.intensity <= 0) {
      throw Exception('Intensity must be higher than 0');
    }
    if (craving.substance.isEmpty || craving.substance == 'Unspecified') {
      throw Exception(
        'Substance must be one from the list and not unspecified or null',
      );
    }
    if (craving.location == 'Select a location') {
      throw Exception('Please select a valid location');
    }
    try {
      final userId = _getUserId();
      // Encrypt sensitive free-text fields
      final encryptedAction = await _encryption.encryptText(craving.action);
      final encryptedThoughts = await _encryption.encryptText(craving.thoughts);
      // Note: cravings table doesn't have a notes field, but keeping this for future compatibility
      final data = {
        'craving_id': _uuid.v4(),
        'uuid_user_id': userId,
        'substance': craving.substance,
        'intensity': craving.intensity.toInt(),
        'date': craving.date.toIso8601String().split('T')[0],
        'time': craving.time,
        'location': craving.location, // Remove default; use as-is
        'people': craving.people,
        'activity': craving.activity,
        'thoughts': encryptedThoughts,
        'triggers': craving.triggers.join(','),
        'body_sensations': craving.bodySensations.join(','),
        'primary_emotion': craving.primaryEmotion,
        'secondary_emotion': craving.secondaryEmotion,
        'action': encryptedAction,
        'timezone': craving.timezone.toString(),
      };
      await _supabase.from('cravings').insert(data);
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError(
        'CravingService.saveCraving.Postgrest',
        e,
        stackTrace,
      );
      // Handle specific DB errors
      switch (e.code) {
        case 'PGRST116':
          throw Exception('Table not found. Please contact support.');
        case '23505':
          throw Exception('Duplicate craving detected.');
        case '42501':
          throw Exception('Permission denied. Please log in again.');
        default:
          throw Exception('Database error: ${e.message}');
      }
    } on Exception catch (e, stackTrace) {
      ErrorHandler.logError('CravingService.saveCraving', e, stackTrace);
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

  Future<Map<String, dynamic>?> fetchCravingById(String cravingId) async {
    try {
      ErrorHandler.logDebug(
        'CravingService',
        'Fetching craving by ID: $cravingId',
      );
      if (cravingId.isEmpty) {
        throw Exception('Invalid craving ID: ID cannot be empty');
      }
      final userId = _getUserId();
      final result = await _supabase
          .from('cravings')
          .select('*')
          .eq('craving_id', cravingId)
          .eq('uuid_user_id', userId)
          .maybeSingle();
      ErrorHandler.logDebug('CravingService', 'Raw DB result: $result');
      if (result == null) {
        ErrorHandler.logWarning(
          'CravingService',
          'No craving found with ID: $cravingId',
        );
        throw Exception('Craving not found with ID: $cravingId');
      }
      // Decrypt sensitive fields
      final decryptedResult = await _encryption.decryptFields(result, [
        'action',
        'thoughts',
      ]);
      ErrorHandler.logInfo(
        'CravingService',
        'Craving fetched successfully: $cravingId',
      );
      return decryptedResult;
    } catch (e, stackTrace) {
      ErrorHandler.logError('CravingService.fetchCravingById', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateCraving(
    String cravingId,
    Map<String, dynamic> data,
  ) async {
    try {
      ErrorHandler.logDebug(
        'CravingService',
        'Updating craving $cravingId with ${data.keys.length} fields',
      );
      if (cravingId.isEmpty) {
        throw Exception('Invalid craving ID: ID cannot be empty');
      }
      // Validate required fields
      if (data['intensity'] != null && (data['intensity'] <= 0)) {
        throw Exception('Intensity must be higher than 0');
      }
      if (data['substance'] != null &&
          (data['substance'].isEmpty || data['substance'] == 'Unspecified')) {
        throw Exception(
          'Substance must be one from the list and not unspecified or null',
        );
      }
      if (data['location'] != null && data['location'] == 'Select a location') {
        throw Exception('Please select a valid location');
      }
      final userId = _getUserId();
      // Encrypt sensitive fields if they are being updated
      final encryptedData = await _encryption.encryptFields(data, [
        'action',
        'thoughts',
      ]);
      final response = await _supabase
          .from('cravings')
          .update(encryptedData)
          .eq('craving_id', cravingId)
          .eq('uuid_user_id', userId)
          .select();
      if (response.isEmpty) {
        throw Exception(
          'Craving not found or you do not have permission to edit it',
        );
      }
      ErrorHandler.logInfo(
        'CravingService',
        'Craving updated successfully: $cravingId',
      );
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError('CravingService.updateCraving', e, stackTrace);
      switch (e.code) {
        case 'PGRST116':
          throw Exception('Table not found. Please contact support.');
        case '42501':
          throw Exception('Permission denied. Please log in again.');
        default:
          throw Exception('Database error: ${e.message}');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError('CravingService.updateCraving', e, stackTrace);
      rethrow;
    }
  }
}

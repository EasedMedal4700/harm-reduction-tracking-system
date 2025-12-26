// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Service for reflection operations.
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../models/reflection_model.dart';
import '../../../services/user_service.dart';
import '../../../../utils/error_handler.dart';
import '../reflection_exceptions.dart';
import '../../../../utils/reflection_validator.dart';
import '../../../services/encryption_service_v2.dart';

class ReflectionService {
  final _encryption = EncryptionServiceV2();
  Future<int> getNextReflectionId() async {
    try {
      ErrorHandler.logDebug('ReflectionService', 'Fetching next reflection ID');
      final response = await Supabase.instance.client
          .from('reflections')
          .select('reflection_id')
          .order('reflection_id', ascending: false)
          .limit(1);
      final nextId = response.isNotEmpty
          ? (response[0]['reflection_id'] as int) + 1
          : 1;
      ErrorHandler.logDebug('ReflectionService', 'Next reflection ID: $nextId');
      return nextId;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ReflectionService.getNextReflectionId',
        e,
        stackTrace,
      );
      ErrorHandler.logWarning('ReflectionService', 'Defaulting to ID 1');
      return 1;
    }
  }

  Future<void> saveReflection(
    Reflection reflection,
    List<int> relatedEntries,
  ) async {
    try {
      ErrorHandler.logDebug(
        'ReflectionService',
        'Saving new reflection with ${relatedEntries.length} related entries',
      );
      final nextId = await getNextReflectionId();
      final userId = UserService.getCurrentUserId();
      // Encrypt notes field
      final reflectionData = reflection.toJson();
      final encryptedNotes = await _encryption.encryptTextNullable(
        reflectionData['notes'] as String?,
      );
      reflectionData['notes'] = encryptedNotes;
      await Supabase.instance.client.from('reflections').insert({
        'reflection_id': nextId,
        'uuid_user_id': userId,
        ...reflectionData,
        'created_at': DateTime.now().toIso8601String(),
        'related_entries': relatedEntries,
        'is_simple': false,
      });
      ErrorHandler.logInfo(
        'ReflectionService',
        'Reflection saved successfully with ID: $nextId',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('ReflectionService.saveReflection', e, stackTrace);
      if (e is ReflectionSaveException) rethrow;
      throw ReflectionSaveException(
        'Failed to save reflection',
        details: e.toString(),
        originalError: e,
      );
    }
  }

  Future<void> updateReflection(String id, Map<String, dynamic> data) async {
    try {
      ErrorHandler.logDebug(
        'ReflectionService',
        'Updating reflection $id with ${data.keys.length} fields',
      );
      if (!ReflectionValidator.isValidReflectionId(id)) {
        throw ReflectionSaveException(
          'Invalid reflection ID',
          details: 'ID "$id" is not valid',
        );
      }
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      final parsedId = int.tryParse(id);
      // Encrypt notes field if it's being updated
      final encryptedData = await _encryption.encryptFields(data, ['notes']);
      final response = await supabase
          .from('reflections')
          .update(encryptedData)
          .eq('uuid_user_id', userId)
          .eq('reflection_id', parsedId ?? id)
          .select();
      if (response.isEmpty) {
        throw ReflectionNotFoundException(id);
      }
      ErrorHandler.logInfo(
        'ReflectionService',
        'Reflection updated successfully: $id',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ReflectionService.updateReflection',
        e,
        stackTrace,
      );
      if (e is ReflectionException) rethrow;
      throw ReflectionSaveException(
        'Failed to update reflection',
        details: e.toString(),
        originalError: e,
      );
    }
  }

  Future<ReflectionModel?> fetchReflectionById(String id) async {
    try {
      ErrorHandler.logDebug(
        'ReflectionService',
        'Fetching reflection by ID: $id',
      );
      if (!ReflectionValidator.isValidReflectionId(id)) {
        throw ReflectionFetchException(
          'Invalid reflection ID',
          details: 'ID "$id" is not a valid integer',
        );
      }
      final supabase = Supabase.instance.client;
      final parsedId = int.tryParse(id);
      ErrorHandler.logDebug(
        'ReflectionService',
        'Query params - original_id: $id, parsed_id: $parsedId',
      );
      final result = await supabase
          .from('reflections')
          .select('*')
          .eq('reflection_id', parsedId ?? id)
          .maybeSingle();
      ErrorHandler.logDebug('ReflectionService', 'Raw DB result: $result');
      if (result == null) {
        ErrorHandler.logWarning(
          'ReflectionService',
          'No reflection found with ID: $id',
        );
        throw ReflectionNotFoundException(id);
      }
      // Validate raw data before parsing
      ReflectionValidator.validateRawData(result);
      // Decrypt notes field
      final decryptedResult = await _encryption.decryptFields(result, [
        'notes',
      ]);
      final model = ReflectionModel.fromJson(decryptedResult);
      ErrorHandler.logInfo(
        'ReflectionService',
        'Reflection fetched - ID: $id, notes: ${model.notes?.isNotEmpty ?? false}, selected_count: ${model.selectedReflections.length}, raw_related_entries: ${result['related_entries']}',
      );
      return model;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ReflectionService.fetchReflectionById',
        e,
        stackTrace,
      );
      if (e is ReflectionException) rethrow;
      throw ReflectionFetchException(
        'Failed to fetch reflection',
        details: 'ID: $id, Error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

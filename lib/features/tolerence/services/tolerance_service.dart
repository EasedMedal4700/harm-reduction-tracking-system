import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/tolerance_model.dart';
import '../../../utils/error_handler.dart';

/// Service for fetching tolerance calculation data from Supabase
class ToleranceService {
  final SupabaseClient _supabase;
  ToleranceService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;
  Future<List<String>> fetchUserSubstances(String userId) async {
    try {
      final response = await _supabase
          .from('drug_use')
          .select('name')
          .eq('uuid_user_id', userId)
          .not('name', 'is', null);
      final names = <String>{};
      for (final row in response as List) {
        final name = (row['name'] as String?)?.trim();
        if (name != null && name.isNotEmpty) {
          // Normalize to Title Case to merge "dexedrine" and "Dexedrine"
          final normalized = name.length > 1
              ? name[0].toUpperCase() + name.substring(1).toLowerCase()
              : name.toUpperCase();
          names.add(normalized);
        }
      }
      final sorted = names.toList()..sort();
      return sorted;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceService.fetchUserSubstances',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Fetch tolerance model for a specific substance
  Future<ToleranceModel?> fetchToleranceData(String substanceName) async {
    if (substanceName.isEmpty) return null;
    try {
      final response = await _supabase
          .from('drug_profiles')
          .select('tolerance_model, properties')
          .or('name.ilike.$substanceName,pretty_name.ilike.$substanceName')
          .maybeSingle();
      if (response == null) {
        ErrorHandler.logInfo(
          'ToleranceService',
          'No drug profile found for $substanceName',
        );
        return null;
      }
      // First check tolerance_model column
      var toleranceJson = response['tolerance_model'] as Map<String, dynamic>?;
      // Fallback to properties.tolerance_data for backward compatibility
      if (toleranceJson == null) {
        final properties = response['properties'] as Map<String, dynamic>?;
        toleranceJson = properties?['tolerance_data'] as Map<String, dynamic>?;
      }
      if (toleranceJson == null) {
        ErrorHandler.logInfo(
          'ToleranceService',
          'No tolerance data configured for $substanceName',
        );
        return null;
      }
      return ToleranceModel.fromJson(toleranceJson);
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceService.fetchToleranceData',
        e,
        stackTrace,
      );
      return null;
    } catch (e, stackTrace) {
      ErrorHandler.logError(
        'ToleranceService.fetchToleranceData',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Fetch use events for tolerance calculation
  Future<List<UseEvent>> fetchUseEvents({
    required String substanceName,
    required String userId,
    int daysBack = 30,
  }) async {
    if (substanceName.isEmpty) return [];
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      final response = await _supabase
          .from('drug_use')
          .select('start_time, dose, name')
          .eq('uuid_user_id', userId)
          .ilike('name', substanceName) // Case insensitive match
          .gte('start_time', cutoffDate.toIso8601String())
          .order('start_time', ascending: false);
      final events = <UseEvent>[];
      for (final row in response as List) {
        final timestampString = row['start_time'] as String?;
        final timestamp = timestampString != null
            ? DateTime.tryParse(timestampString)
            : null;
        if (timestamp == null) {
          continue;
        }
        final rawDose = row['dose'];
        final dose = _parseDose(rawDose);
        events.add(
          UseEvent(
            timestamp: timestamp,
            dose: dose,
            substanceName: substanceName,
          ),
        );
      }
      return events;
    } catch (e, stackTrace) {
      ErrorHandler.logError('ToleranceService.fetchUseEvents', e, stackTrace);
      return [];
    }
  }

  double _parseDose(dynamic rawDose) {
    if (rawDose == null) return 0.0;
    if (rawDose is num) return rawDose.toDouble();
    if (rawDose is String) {
      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(rawDose);
      if (match != null) {
        return double.tryParse(match.group(1)!) ?? 0.0;
      }
    }
    return 0.0;
  }
}

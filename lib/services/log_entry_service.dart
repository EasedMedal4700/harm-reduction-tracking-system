import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/log_entry_model.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart'; // For user_id

class LogEntryService {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  Future<void> saveLogEntry(LogEntry entry) async {
    try {
      final data = {
        'user_id': UserService.getCurrentUserId(),
        'name': entry.substance,
        'dose': '${entry.dosage} ${entry.unit}',
        'start_time': formatter.format(entry.datetime.toUtc()), // Format as UTC+00
        'consumption': entry.route,
        'intention': (entry.intention == null || entry.intention == '-- Select Intention--')
            ? null
            : entry.intention,
        'craving_0_10': entry.cravingIntensity.toInt(), // Convert double to int
        'medical': entry.isMedicalPurpose.toString(),
        'primary_emotions': entry.feelings,
        'secondary_emotions': entry.secondaryFeelings.values.expand((list) => list).toList(), // Flatten map to list
        'triggers': entry.triggers,
        'people': entry.people,
        'place': entry.location,
        'body_signals': entry.bodySignals,
        'notes': entry.notes,
        'linked_craving_ids': '{}',
        'timezone': entry.timezoneOffset.toString(),
      };

      await Supabase.instance.client.from('drug_use').insert(data);
    } on PostgrestException catch (e) {
      // Handle specific DB errors
      switch (e.code) {
        case 'PGRST116':
          throw Exception('Table not found. Please contact support.');
        case '23505':
          throw Exception('Duplicate entry detected.');
        default:
          throw Exception('Database error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/craving_model.dart';
import '../services/user_service.dart';

class CravingService {
  final _uuid = const Uuid();

  Future<void> saveCraving(Craving craving) async {
    // Add validation
    if (craving.intensity <= 0) {
      throw Exception('Intensity must be higher than 0');
    }
    if (craving.substance.isEmpty || craving.substance == 'Unspecified' || craving.substance == null) {
      throw Exception('Substance must be one from the list and not unspecified or null');
    }
    if (craving.location == 'Select a location') {
      throw Exception('Please select a valid location');
    }

    try {
      final data = {
        'craving_id': _uuid.v4(),
        'user_id': craving.userId,
        'substance': craving.substance,
        'intensity': craving.intensity.toInt(),
        'date': craving.date.toIso8601String().split('T')[0],
        'time': craving.time,
        'location': craving.location, // Remove default; use as-is
        'people': craving.people,
        'activity': craving.activity,
        'thoughts': craving.thoughts,
        'triggers': craving.triggers.join(','),
        'body_sensations': craving.bodySensations.join(','),
        'primary_emotion': craving.primaryEmotion,
        'secondary_emotion': craving.secondaryEmotion,
        'action': craving.action,
        'timezone': craving.timezone.toString(),
      };
      await Supabase.instance.client.from('cravings').insert(data);
    } on PostgrestException catch (e) {
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
    } on Exception catch (e) {
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
}
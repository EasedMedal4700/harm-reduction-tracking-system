// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\services\craving_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; // Add this
import '../models/craving_model.dart';
import '../services/user_service.dart';

class CravingService {
  final _uuid = const Uuid(); // Add UUID generator

  Future<void> saveCraving(Craving craving) async {
    // Add validation
    if (craving.intensity <= 0) {
      throw Exception('Intensity must be higher than 0');
    }
    if (craving.substance.isEmpty || craving.substance == 'Unspecified' || craving.substance == null) {
      throw Exception('Substance must be one from the list and not unspecified or null');
    }

    try {
      final data = {
        'craving_id': _uuid.v4(), // Generate UUID v4
        'user_id': craving.userId,
        'substance': craving.substance,
        'intensity': craving.intensity.toInt(), // Convert double to int
        'date': craving.date.toIso8601String().split('T')[0],
        'time': craving.time,
        'location': craving.location,
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
      throw Exception('DB error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\models\craving_model.dart
class Craving {
  final String? cravingId;
  final String userId;
  final String substance;
  final double intensity;
  final DateTime date;
  final String time; // Full timestamp string
  final String location;
  final String people;
  final String activity;
  final String thoughts;
  final List<String> triggers;
  final List<String> bodySensations;
  final String primaryEmotion;
  final String? secondaryEmotion;
  final String action;
  final double timezone;

  Craving({
    this.cravingId,
    required this.userId,
    required this.substance,
    required this.intensity,
    required this.date,
    required this.time,
    required this.location,
    required this.people,
    required this.activity,
    required this.thoughts,
    required this.triggers,
    required this.bodySensations,
    required this.primaryEmotion,
    this.secondaryEmotion,
    required this.action,
    required this.timezone,
  });

  Map<String, dynamic> toJson() => {
    'craving_id': cravingId,
    'uuid_user_id': userId,
    'substance': substance,
    'intensity': intensity.toString(), // Match SQL (string)
    'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
    'time': time, // Full timestamp (e.g., '2025-11-07 21:56:00+00')
    'location': location,
    'people': people,
    'activity': activity,
    'thoughts': thoughts,
    'triggers': triggers.join(','), // List to comma-separated string
    'body_sensations': bodySensations.join(','),
    'primary_emotion': primaryEmotion,
    'secondary_emotion': secondaryEmotion,
    'action': action,
    'timezone': timezone.toString(),
  };
}
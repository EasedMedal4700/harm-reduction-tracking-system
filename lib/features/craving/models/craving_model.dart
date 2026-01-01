// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'craving_model.freezed.dart';

@freezed
abstract class Craving with _$Craving {
  const factory Craving({
    String? cravingId,
    required String userId,
    required String substance,
    required double intensity,
    required DateTime date,
    required String time,
    required String location,
    required String people,
    required String activity,
    required String thoughts,
    required List<String> triggers,
    required List<String> bodySensations,
    required String primaryEmotion,
    String? secondaryEmotion,
    required String action,
    required double timezone,
  }) = _Craving;

  const Craving._();

  Map<String, dynamic> toJson() => {
    'craving_id': cravingId,
    'uuid_user_id': userId,
    'substance': substance,
    'intensity': intensity.toString(),
    'date': date.toIso8601String().split('T')[0],
    'time': time,
    'location': location,
    'people': people,
    'activity': activity,
    'thoughts': thoughts,
    'triggers': triggers.join(','),
    'body_sensations': bodySensations.join(','),
    'primary_emotion': primaryEmotion,
    'secondary_emotion': secondaryEmotion,
    'action': action,
    'timezone': timezone.toString(),
  };
}

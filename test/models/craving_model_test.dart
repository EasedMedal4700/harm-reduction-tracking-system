import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/craving/models/craving_model.dart';

void main() {
  test('Craving toJson flattens lists and formats values', () {
    final now = DateTime(2025, 11, 7, 21, 56);
    final craving = Craving(
      cravingId: 'abc',
      userId: 'user-123',
      substance: 'Cannabis',
      intensity: 7.4,
      date: now,
      time: '2025-11-07 21:56:00+00',
      location: 'Home',
      people: 'Friends',
      activity: 'Movie night',
      thoughts: 'Wanted to unwind',
      triggers: const ['stress', 'boredom'],
      bodySensations: const ['restlessness', 'dry mouth'],
      primaryEmotion: 'Anxious',
      secondaryEmotion: 'Worried',
      action: 'Resisted',
      timezone: -5.0,
    );

    final json = craving.toJson();

    expect(json['craving_id'], 'abc');
    expect(json['uuid_user_id'], 'user-123');
    expect(json['substance'], 'Cannabis');
    expect(json['intensity'], '7.4');
    expect(json['date'], '2025-11-07');
    expect(json['time'], '2025-11-07 21:56:00+00');
    expect(json['location'], 'Home');
    expect(json['people'], 'Friends');
    expect(json['activity'], 'Movie night');
    expect(json['thoughts'], 'Wanted to unwind');
    expect(json['triggers'], 'stress,boredom');
    expect(json['body_sensations'], 'restlessness,dry mouth');
    expect(json['primary_emotion'], 'Anxious');
    expect(json['secondary_emotion'], 'Worried');
    expect(json['action'], 'Resisted');
    expect(json['timezone'], '-5.0');
  });
}

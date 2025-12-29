import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/reflection/models/reflection_model.dart';

void main() {
  group('Reflection model', () {
    test('has sensible defaults', () {
      final reflection = Reflection();

      expect(reflection.effectiveness, 5.0);
      expect(reflection.sleepHours, 8.0);
      expect(reflection.sleepQuality, 'Good');
      expect(reflection.energyLevel, 'Neutral');
      expect(reflection.postUseCraving, 5.0);
      expect(reflection.overallSatisfaction, 5.0);
      expect(reflection.notes, '');
    });

    test('toJson rounds numeric sliders and nulls optional strings', () {
      final reflection = Reflection(
        effectiveness: 7.8,
        sleepHours: 6.5,
        sleepQuality: 'Fair',
        nextDayMood: '',
        energyLevel: 'High',
        sideEffects: '',
        postUseCraving: 2.2,
        copingStrategies: '',
        copingEffectiveness: 9.9,
        overallSatisfaction: 4.1,
        notes: 'Felt energized',
      );

      final json = reflection.toJson();

      expect(json['effectiveness'], 8);
      expect(json['sleep_hours'], 6.5);
      expect(json['sleep_quality'], 'Fair');
      expect(json['next_day_mood'], isNull);
      expect(json['energy_level'], 'High');
      expect(json['side_effects'], isNull);
      expect(json['post_use_craving'], 2);
      expect(json['coping_strategies'], isNull);
      expect(json['coping_effectiveness'], 10);
      expect(json['overall_satisfaction'], 4);
      expect(json['notes'], 'Felt energized');
    });

    test('reset returns to initial defaults', () {
      final reflection = Reflection(
        effectiveness: 2,
        sleepHours: 4,
        sleepQuality: 'Poor',
        nextDayMood: 'Foggy',
        energyLevel: 'Low',
        sideEffects: 'Dizzy',
        postUseCraving: 8,
        copingStrategies: 'Calling sponsor',
        copingEffectiveness: 3,
        overallSatisfaction: 2,
        notes: 'Hard day',
      );

      reflection.reset();

      expect(reflection.effectiveness, 5.0);
      expect(reflection.sleepHours, 8.0);
      expect(reflection.sleepQuality, 'Good');
      expect(reflection.nextDayMood, '');
      expect(reflection.energyLevel, 'Neutral');
      expect(reflection.sideEffects, '');
      expect(reflection.postUseCraving, 5.0);
      expect(reflection.copingStrategies, '');
      expect(reflection.copingEffectiveness, 5.0);
      expect(reflection.overallSatisfaction, 5.0);
      expect(reflection.notes, '');
    });
  });
}

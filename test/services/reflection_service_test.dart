import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/reflection_model.dart';

void main() {
  group('ReflectionService', () {
    test('Reflection model has correct defaults', () {
      final reflection = Reflection();
      
      expect(reflection.effectiveness, 5.0);
      expect(reflection.sleepHours, 8.0);
      expect(reflection.sleepQuality, 'Good');
      expect(reflection.energyLevel, 'Neutral');
      expect(reflection.postUseCraving, 5.0);
      expect(reflection.copingEffectiveness, 5.0);
      expect(reflection.overallSatisfaction, 5.0);
    });

    test('Reflection toJson rounds values correctly', () {
      final reflection = Reflection(
        effectiveness: 7.8,
        sleepHours: 6.5,
        sleepQuality: 'Fair',
        postUseCraving: 2.2,
        copingEffectiveness: 9.9,
        overallSatisfaction: 4.1,
        notes: 'Test',
      );

      final json = reflection.toJson();
      
      expect(json['effectiveness'], 8);
      expect(json['sleep_hours'], 6.5);
      expect(json['post_use_craving'], 2);
      expect(json['coping_effectiveness'], 10);
      expect(json['overall_satisfaction'], 4);
    });

    test('Reflection toJson handles null optional fields', () {
      final reflection = Reflection(
        effectiveness: 7.0,
        sleepHours: 8.0,
        sleepQuality: 'Good',
        nextDayMood: '',
        energyLevel: 'High',
        sideEffects: '',
        postUseCraving: 5.0,
        copingStrategies: '',
        copingEffectiveness: 5.0,
        overallSatisfaction: 5.0,
        notes: '',
      );

      final json = reflection.toJson();
      
      expect(json['next_day_mood'], isNull);
      expect(json['side_effects'], isNull);
      expect(json['coping_strategies'], isNull);
    });

    test('Reflection reset returns to defaults', () {
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

    test('validates reflection data structure', () {
      final reflection = Reflection(
        effectiveness: 9.0,
        sleepHours: 7.5,
        sleepQuality: 'Excellent',
        nextDayMood: 'Energized',
        energyLevel: 'High',
        sideEffects: 'None',
        postUseCraving: 1.0,
        copingStrategies: 'Exercise, meditation',
        copingEffectiveness: 9.0,
        overallSatisfaction: 8.0,
        notes: 'Great experience',
      );

      expect(reflection.effectiveness, inInclusiveRange(0, 10));
      expect(reflection.sleepHours, greaterThan(0));
      expect(reflection.sleepQuality, isNotEmpty);
      expect(reflection.postUseCraving, inInclusiveRange(0, 10));
      expect(reflection.copingEffectiveness, inInclusiveRange(0, 10));
      expect(reflection.overallSatisfaction, inInclusiveRange(0, 10));
    });
  });
}

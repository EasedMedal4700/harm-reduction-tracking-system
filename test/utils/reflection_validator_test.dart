import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/utils/reflection_validator.dart';
import 'package:mobile_drug_use_app/utils/reflection_exceptions.dart';
import 'package:mobile_drug_use_app/models/reflection_model.dart';

// Test constants for deterministic test behavior
const String kTestDateIso8601 = '2023-11-28T10:00:00Z';
final DateTime kTestDateTime = DateTime.parse(kTestDateIso8601);

void main() {
  group('ReflectionValidator', () {
    group('validateReflection', () {
      test('passes for valid reflection with defaults', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          returnsNormally,
        );
      });

      test('passes for valid reflection with boundary values', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 0.0,
          sleepHours: 0.0,
          sleepQuality: 'Poor',
          energyLevel: 'Low',
          postUseCraving: 0.0,
          copingEffectiveness: 0.0,
          overallSatisfaction: 0.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          returnsNormally,
        );
      });

      test('passes for valid reflection with max boundary values', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 10.0,
          sleepHours: 24.0,
          sleepQuality: 'Excellent',
          energyLevel: 'High',
          postUseCraving: 10.0,
          copingEffectiveness: 10.0,
          overallSatisfaction: 10.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          returnsNormally,
        );
      });

      test('throws for negative effectiveness', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: -1.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for effectiveness over 10', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 11.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for negative sleep hours', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: -1.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for sleep hours over 24', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 25.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for invalid sleep quality', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Terrible',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('passes for empty sleep quality', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: '',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          returnsNormally,
        );
      });

      test('throws for invalid energy level', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Medium',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('passes for empty energy level', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: '',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          returnsNormally,
        );
      });

      test('throws for negative post use craving', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: -1.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for post use craving over 10', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 11.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for negative coping effectiveness', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: -1.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for coping effectiveness over 10', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 11.0,
          overallSatisfaction: 5.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for negative overall satisfaction', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: -1.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for overall satisfaction over 10', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: 5.0,
          sleepHours: 8.0,
          sleepQuality: 'Good',
          energyLevel: 'Neutral',
          postUseCraving: 5.0,
          copingEffectiveness: 5.0,
          overallSatisfaction: 11.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws with multiple validation errors', () {
        final model = ReflectionModel(
          date: kTestDateTime,
          hour: 10,
          minute: 30,
          effectiveness: -1.0,
          sleepHours: 25.0,
          sleepQuality: 'Invalid',
          energyLevel: 'Invalid',
          postUseCraving: -5.0,
          copingEffectiveness: 15.0,
          overallSatisfaction: -10.0,
        );

        expect(
          () => ReflectionValidator.validateReflection(model),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('validates all sleep quality options', () {
        final validQualities = ['Poor', 'Fair', 'Good', 'Excellent'];
        for (final quality in validQualities) {
          final model = ReflectionModel(
            date: kTestDateTime,
            hour: 10,
            minute: 30,
            effectiveness: 5.0,
            sleepHours: 8.0,
            sleepQuality: quality,
            energyLevel: 'Neutral',
            postUseCraving: 5.0,
            copingEffectiveness: 5.0,
            overallSatisfaction: 5.0,
          );

          expect(
            () => ReflectionValidator.validateReflection(model),
            returnsNormally,
            reason: 'Sleep quality "$quality" should be valid',
          );
        }
      });

      test('validates all energy level options', () {
        final validLevels = ['Low', 'Neutral', 'High'];
        for (final level in validLevels) {
          final model = ReflectionModel(
            date: kTestDateTime,
            hour: 10,
            minute: 30,
            effectiveness: 5.0,
            sleepHours: 8.0,
            sleepQuality: 'Good',
            energyLevel: level,
            postUseCraving: 5.0,
            copingEffectiveness: 5.0,
            overallSatisfaction: 5.0,
          );

          expect(
            () => ReflectionValidator.validateReflection(model),
            returnsNormally,
            reason: 'Energy level "$level" should be valid',
          );
        }
      });
    });

    group('validateRawData', () {
      test('passes for valid raw data with reflection_id and created_at', () {
        final json = {
          'reflection_id': 1,
          'created_at': kTestDateIso8601,
        };

        expect(
          () => ReflectionValidator.validateRawData(json),
          returnsNormally,
        );
      });

      test('passes for valid raw data with id and created_at', () {
        final json = {
          'id': 1,
          'created_at': kTestDateIso8601,
        };

        expect(
          () => ReflectionValidator.validateRawData(json),
          returnsNormally,
        );
      });

      test('throws for missing id fields', () {
        final json = {
          'created_at': kTestDateIso8601,
        };

        expect(
          () => ReflectionValidator.validateRawData(json),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for missing created_at', () {
        final json = {
          'reflection_id': 1,
        };

        expect(
          () => ReflectionValidator.validateRawData(json),
          throwsA(isA<ReflectionValidationException>()),
        );
      });

      test('throws for empty raw data', () {
        final json = <String, dynamic>{};

        expect(
          () => ReflectionValidator.validateRawData(json),
          throwsA(isA<ReflectionValidationException>()),
        );
      });
    });

    group('isValidReflectionId', () {
      test('returns true for valid positive integer string', () {
        expect(ReflectionValidator.isValidReflectionId('1'), isTrue);
        expect(ReflectionValidator.isValidReflectionId('123'), isTrue);
        expect(ReflectionValidator.isValidReflectionId('999999'), isTrue);
      });

      test('returns false for null', () {
        expect(ReflectionValidator.isValidReflectionId(null), isFalse);
      });

      test('returns false for empty string', () {
        expect(ReflectionValidator.isValidReflectionId(''), isFalse);
      });

      test('returns false for zero', () {
        expect(ReflectionValidator.isValidReflectionId('0'), isFalse);
      });

      test('returns false for negative numbers', () {
        expect(ReflectionValidator.isValidReflectionId('-1'), isFalse);
        expect(ReflectionValidator.isValidReflectionId('-100'), isFalse);
      });

      test('returns false for non-numeric strings', () {
        expect(ReflectionValidator.isValidReflectionId('abc'), isFalse);
        expect(ReflectionValidator.isValidReflectionId('1a'), isFalse);
        expect(ReflectionValidator.isValidReflectionId('a1'), isFalse);
      });

      test('returns false for decimal numbers', () {
        expect(ReflectionValidator.isValidReflectionId('1.5'), isFalse);
        expect(ReflectionValidator.isValidReflectionId('3.14'), isFalse);
      });

      test('returns false for whitespace', () {
        expect(ReflectionValidator.isValidReflectionId(' '), isFalse);
        expect(ReflectionValidator.isValidReflectionId('  '), isFalse);
      });
    });

    group('sanitizeNotes', () {
      test('returns empty string for null', () {
        expect(ReflectionValidator.sanitizeNotes(null), '');
      });

      test('returns empty string for empty string', () {
        expect(ReflectionValidator.sanitizeNotes(''), '');
      });

      test('trims whitespace from notes', () {
        expect(ReflectionValidator.sanitizeNotes('  hello  '), 'hello');
        expect(ReflectionValidator.sanitizeNotes('\thello\t'), 'hello');
        expect(ReflectionValidator.sanitizeNotes('\nhello\n'), 'hello');
      });

      test('collapses multiple spaces into one', () {
        expect(ReflectionValidator.sanitizeNotes('hello    world'), 'hello world');
        expect(ReflectionValidator.sanitizeNotes('a  b  c'), 'a b c');
      });

      test('collapses newlines and tabs into single space', () {
        expect(ReflectionValidator.sanitizeNotes('hello\nworld'), 'hello world');
        expect(ReflectionValidator.sanitizeNotes('hello\tworld'), 'hello world');
        expect(ReflectionValidator.sanitizeNotes('hello\r\nworld'), 'hello world');
      });

      test('handles mixed whitespace', () {
        expect(
          ReflectionValidator.sanitizeNotes('  hello   \n  world  \t test  '),
          'hello world test',
        );
      });

      test('preserves normal text', () {
        expect(ReflectionValidator.sanitizeNotes('Hello World'), 'Hello World');
        expect(
          ReflectionValidator.sanitizeNotes('This is a normal note.'),
          'This is a normal note.',
        );
      });
    });

    group('validateRelatedEntries', () {
      test('returns empty list for null', () {
        expect(ReflectionValidator.validateRelatedEntries(null), isEmpty);
      });

      test('returns empty list for empty list', () {
        expect(ReflectionValidator.validateRelatedEntries([]), isEmpty);
      });

      test('converts list items to strings', () {
        final result = ReflectionValidator.validateRelatedEntries([1, 2, 3]);
        expect(result, ['1', '2', '3']);
      });

      test('filters out empty items from list', () {
        final List<dynamic> entries = ['a', '', 'b', null, 'c'];
        final result = ReflectionValidator.validateRelatedEntries(entries);
        expect(result, ['a', 'b', 'c']);
      });

      test('parses comma-separated string', () {
        final result = ReflectionValidator.validateRelatedEntries('a,b,c');
        expect(result, ['a', 'b', 'c']);
      });

      test('trims items in comma-separated string', () {
        final result = ReflectionValidator.validateRelatedEntries('  a  ,  b  ,  c  ');
        expect(result, ['a', 'b', 'c']);
      });

      test('filters empty items in comma-separated string', () {
        final result = ReflectionValidator.validateRelatedEntries('a,,b,  ,c');
        expect(result, ['a', 'b', 'c']);
      });

      test('returns empty list for empty string', () {
        expect(ReflectionValidator.validateRelatedEntries(''), isEmpty);
      });

      test('returns empty list for non-list non-string types', () {
        expect(ReflectionValidator.validateRelatedEntries(123), isEmpty);
        expect(ReflectionValidator.validateRelatedEntries(12.34), isEmpty);
        expect(ReflectionValidator.validateRelatedEntries(true), isEmpty);
      });

      test('handles list with mixed types', () {
        final result = ReflectionValidator.validateRelatedEntries([1, 'a', true, 2.5]);
        expect(result, ['1', 'a', 'true', '2.5']);
      });

      test('handles single item string without comma', () {
        final result = ReflectionValidator.validateRelatedEntries('single_entry');
        expect(result, ['single_entry']);
      });
    });
  });
}

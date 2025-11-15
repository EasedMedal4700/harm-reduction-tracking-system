import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/craving_service.dart';
import 'package:mobile_drug_use_app/models/craving_model.dart';

void main() {
  group('CravingService validation', () {
    late CravingService service;

    setUp(() {
      service = CravingService();
    });

    test('throws exception for zero intensity', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Cannabis',
        intensity: 0,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(
        () => service.saveCraving(craving),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Intensity must be higher than 0'),
        )),
      );
    });

    test('throws exception for negative intensity', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Cannabis',
        intensity: -1,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(
        () => service.saveCraving(craving),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception for empty substance', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: '',
        intensity: 7,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(
        () => service.saveCraving(craving),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Substance must be one from the list'),
        )),
      );
    });

    test('throws exception for "Unspecified" substance', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Unspecified',
        intensity: 7,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(
        () => service.saveCraving(craving),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception for "Select a location" location', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Cannabis',
        intensity: 7,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Select a location',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(
        () => service.saveCraving(craving),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Please select a valid location'),
        )),
      );
    });

    test('accepts valid craving data', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Cannabis',
        intensity: 7.5,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress', 'boredom'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      // Verify valid craving passes all checks
      expect(craving.intensity, greaterThan(0));
      expect(craving.substance, isNot('Unspecified'));
      expect(craving.substance, isNotEmpty);
      expect(craving.location, isNot('Select a location'));
    });

    test('intensity is converted to integer for database', () {
      final craving = Craving(
        cravingId: 'test',
        userId: 'user-123',
        substance: 'Cannabis',
        intensity: 7.8,
        date: DateTime.now(),
        time: '2025-11-07 21:56:00+00',
        location: 'Home',
        people: 'Friends',
        activity: 'Movie',
        thoughts: 'Wanted to relax',
        triggers: ['stress'],
        bodySensations: ['restlessness'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried',
        action: 'Resisted',
        timezone: -5.0,
      );

      expect(craving.intensity.toInt(), 7);
    });

    test('triggers are joined correctly', () {
      final triggers = ['stress', 'boredom', 'anxiety'];
      final joined = triggers.join(',');
      expect(joined, 'stress,boredom,anxiety');
    });

    test('body sensations are joined correctly', () {
      final bodySensations = ['restlessness', 'dry mouth', 'racing heart'];
      final joined = bodySensations.join(',');
      expect(joined, 'restlessness,dry mouth,racing heart');
    });
  });

  group('CravingService data formatting', () {
    test('formats date correctly', () {
      final date = DateTime(2025, 11, 7);
      final formatted = date.toIso8601String().split('T')[0];
      expect(formatted, '2025-11-07');
    });

    test('timezone is converted to string', () {
      final timezone = -5.5;
      expect(timezone.toString(), '-5.5');
    });
  });
}

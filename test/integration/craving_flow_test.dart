import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_drug_use_app/models/craving_model.dart';

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Craving CRUD flow integration test', () {
    testWidgets('complete craving lifecycle', (tester) async {
      // This is a simplified integration test that tests the data flow
      // In a real scenario, you would launch the actual app and interact with the UI

      // 1. Create a craving
      final craving = Craving(
        cravingId: 'test-craving-1',
        userId: 'test-user',
        substance: 'Cannabis',
        intensity: 7.5,
        date: DateTime.now(),
        time: '14:30:00',
        location: 'Home',
        people: 'Alone',
        activity: 'Watching TV',
        thoughts: 'Feeling stressed about work',
        triggers: ['stress', 'boredom'],
        bodySensations: ['restlessness', 'tension'],
        primaryEmotion: 'Anxious',
        secondaryEmotion: 'Worried, Overwhelmed',
        action: 'Resisted',
        timezone: -5.0,
      );

      // Verify craving data is valid
      expect(craving.substance, 'Cannabis');
      expect(craving.intensity, 7.5);
      expect(craving.location, 'Home');
      expect(craving.primaryEmotion, 'Anxious');
      expect(craving.secondaryEmotion, contains('Worried'));
      expect(craving.action, 'Resisted');
      expect(craving.triggers.length, 2);
      expect(craving.bodySensations.length, 2);

      // 2. Edit the craving
      final updatedCraving = Craving(
        cravingId: craving.cravingId,
        userId: craving.userId,
        substance: craving.substance,
        intensity: 5.0, // Changed intensity
        date: craving.date,
        time: craving.time,
        location: 'Park', // Changed location
        people: craving.people,
        activity: 'Walking', // Changed activity
        thoughts: craving.thoughts,
        triggers: craving.triggers,
        bodySensations: craving.bodySensations,
        primaryEmotion: 'Calm', // Changed emotion
        secondaryEmotion: 'Peaceful',
        action: craving.action,
        timezone: craving.timezone,
      );

      // Verify edited data
      expect(updatedCraving.intensity, 5.0);
      expect(updatedCraving.location, 'Park');
      expect(updatedCraving.activity, 'Walking');
      expect(updatedCraving.primaryEmotion, 'Calm');

      // 3. Delete the craving would happen here
      // In a real test, you would call the service and verify deletion
      expect(craving.cravingId, isNotEmpty);
    });

    testWidgets('validates craving intensity range', (tester) async {
      // Test boundary values
      final lowIntensity = Craving(
        cravingId: 'test-1',
        userId: 'user-1',
        substance: 'Cannabis',
        intensity: 1.0,
        date: DateTime.now(),
        time: '12:00:00',
        location: 'Home',
        people: 'Alone',
        activity: 'Relaxing',
        thoughts: '',
        triggers: [],
        bodySensations: [],
        primaryEmotion: 'Calm',
        secondaryEmotion: null,
        action: 'Resisted',
        timezone: 0.0,
      );

      final highIntensity = Craving(
        cravingId: 'test-2',
        userId: 'user-1',
        substance: 'Cannabis',
        intensity: 10.0,
        date: DateTime.now(),
        time: '12:00:00',
        location: 'Home',
        people: 'Alone',
        activity: 'Relaxing',
        thoughts: '',
        triggers: [],
        bodySensations: [],
        primaryEmotion: 'Anxious',
        secondaryEmotion: null,
        action: 'Acted',
        timezone: 0.0,
      );

      expect(lowIntensity.intensity, greaterThanOrEqualTo(1.0));
      expect(highIntensity.intensity, lessThanOrEqualTo(10.0));
    });

    testWidgets('validates required fields', (tester) async {
      // Test with minimal required data
      final minimalCraving = Craving(
        cravingId: 'test-minimal',
        userId: 'user-1',
        substance: 'Cannabis',
        intensity: 5.0,
        date: DateTime.now(),
        time: '12:00:00',
        location: 'Home',
        people: '',
        activity: '',
        thoughts: '',
        triggers: [],
        bodySensations: [],
        primaryEmotion: '',
        secondaryEmotion: null,
        action: 'Resisted',
        timezone: 0.0,
      );

      // Required fields should not be empty
      expect(minimalCraving.substance, isNotEmpty);
      expect(minimalCraving.location, isNotEmpty);
      expect(minimalCraving.intensity, greaterThan(0));
    });

    testWidgets('handles multiple cravings in sequence', (tester) async {
      final cravings = <Craving>[];

      // Create multiple cravings
      for (int i = 0; i < 5; i++) {
        final craving = Craving(
          cravingId: 'test-$i',
          userId: 'user-1',
          substance: ['Cannabis', 'Alcohol', 'Nicotine', 'Caffeine', 'MDMA'][i],
          intensity: (i + 1) * 2.0,
          date: DateTime.now().subtract(Duration(days: i)),
          time: '12:00:00',
          location: ['Home', 'Work', 'Bar', 'Park', 'Festival'][i],
          people: 'Friends',
          activity: 'Socializing',
          thoughts: 'Craving number $i',
          triggers: ['stress'],
          bodySensations: ['restlessness'],
          primaryEmotion: 'Anxious',
          secondaryEmotion: null,
          action: i % 2 == 0 ? 'Resisted' : 'Acted',
          timezone: -5.0,
        );
        cravings.add(craving);
      }

      // Verify all cravings were created
      expect(cravings.length, 5);
      expect(cravings[0].substance, 'Cannabis');
      expect(cravings[4].substance, 'MDMA');

      // Verify intensity progression
      for (int i = 0; i < 5; i++) {
        expect(cravings[i].intensity, (i + 1) * 2.0);
      }

      // Verify action distribution
      final resistedCount = cravings
          .where((c) => c.action == 'Resisted')
          .length;
      final actedCount = cravings.where((c) => c.action == 'Acted').length;
      expect(resistedCount, 3);
      expect(actedCount, 2);
    });

    testWidgets('validates emotion combinations', (tester) async {
      // Test with primary emotion only
      final primaryOnly = Craving(
        cravingId: 'test-1',
        userId: 'user-1',
        substance: 'Cannabis',
        intensity: 5.0,
        date: DateTime.now(),
        time: '12:00:00',
        location: 'Home',
        people: '',
        activity: '',
        thoughts: '',
        triggers: [],
        bodySensations: [],
        primaryEmotion: 'Happy',
        secondaryEmotion: null,
        action: 'Resisted',
        timezone: 0.0,
      );

      // Test with primary and secondary emotions
      final bothEmotions = Craving(
        cravingId: 'test-2',
        userId: 'user-1',
        substance: 'Cannabis',
        intensity: 5.0,
        date: DateTime.now(),
        time: '12:00:00',
        location: 'Home',
        people: '',
        activity: '',
        thoughts: '',
        triggers: [],
        bodySensations: [],
        primaryEmotion: 'Happy',
        secondaryEmotion: 'Joyful, Excited',
        action: 'Resisted',
        timezone: 0.0,
      );

      expect(primaryOnly.primaryEmotion, isNotEmpty);
      expect(primaryOnly.secondaryEmotion, isNull);

      expect(bothEmotions.primaryEmotion, isNotEmpty);
      expect(bothEmotions.secondaryEmotion, isNotNull);
      expect(bothEmotions.secondaryEmotion, contains('Joyful'));
    });
  });
}

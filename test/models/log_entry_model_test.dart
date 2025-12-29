import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';

void main() {
  group('LogEntry model', () {
    test('fromJson parses mixed formats into strong types', () {
      final entry = LogEntry.fromJson({
        'name': 'Cannabis',
        'dose': '20 mg',
        'consumption': 'oral',
        'primary_emotions': 'Happy;Calm',
        'secondary_emotions': 'Joyful;Relaxed',
        'triggers': 'stress;boredom',
        'body_signals': 'heart racing;tense muscles',
        'people': 'Alice Bob',
        'place': 'Home',
        'notes': 'Watched a movie',
        'medical': 'true',
        'craving_0_10': '7',
        'intention': 'Relax/Stress Relief',
        'start_time': '2025-11-07T21:56:00Z',
        'timezone': '-5.5',
      });

      expect(entry.substance, 'Cannabis');
      expect(entry.dosage, 20);
      expect(entry.unit, 'mg');
      expect(entry.route, 'oral');
      expect(entry.feelings, ['Happy', 'Calm']);
      expect(entry.triggers, ['stress', 'boredom']);
      expect(entry.bodySignals, ['heart racing', 'tense muscles']);
      expect(entry.people, ['Alice', 'Bob']);
      expect(entry.location, 'Home');
      expect(entry.isMedicalPurpose, isTrue);
      expect(entry.cravingIntensity, 7);
      expect(entry.intention, 'Relax/Stress Relief');
      expect(entry.timezoneOffset, -5.5);
    });

    test('toJson preserves primitive fields and lists', () {
      final entry = LogEntry(
        substance: 'MDMA',
        dosage: 120,
        unit: 'mg',
        route: 'oral',
        feelings: const ['Excited', 'Connected'],
        secondaryFeelings: const <String, List<String>>{},
        datetime: DateTime(2025, 7, 4, 22),
        location: 'Festival',
        notes: 'Great vibes',
        timezoneOffset: 2.0,
        isMedicalPurpose: false,
        cravingIntensity: 3,
        intention: 'Social Enhancement',
        triggers: const ['celebration'],
        bodySignals: const ['heart racing'],
        people: const ['Pat'],
      );

      final json = entry.toJson();

      expect(json['substance'], 'MDMA');
      expect(json['dosage'], 120);
      expect(json['unit'], 'mg');
      expect(json['route'], 'oral');
      expect(json['feelings'], ['Excited', 'Connected']);
      expect(json['secondaryFeelings'], const <String, List<String>>{});
      expect(json['datetime'], '2025-07-04T22:00:00.000');
      expect(json['location'], 'Festival');
      expect(json['notes'], 'Great vibes');
      expect(json['timezoneOffset'], 2.0);
      expect(json['isMedicalPurpose'], isFalse);
      expect(json['cravingIntensity'], 3);
      expect(json['intention'], 'Social Enhancement');
      expect(json['triggers'], ['celebration']);
      expect(json['bodySignals'], ['heart racing']);
      expect(json['people'], ['Pat']);
    });
  });
}

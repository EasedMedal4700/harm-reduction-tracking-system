import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_model.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/serialization/log_entry_serializer.dart';

void main() {
  group('LogEntrySerializer', () {
    group('fromJson', () {
      test('parses basic fields', () {
        final json = {
          'use_id': '123',
          'substance': 'Cannabis',
          'dosage': 10.0,
          'unit': 'mg',
          'route': 'oral',
          'start_time': '2024-01-15T10:30:00',
        };

        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.id, '123');
        expect(entry.substance, 'Cannabis');
        expect(entry.dosage, 10.0);
        expect(entry.unit, 'mg');
        expect(entry.route, 'oral');
      });

      test('handles alternative field names for substance', () {
        final json1 = {'name': 'Cannabis'};
        final json2 = {'substance': 'Alcohol'};

        expect(LogEntrySerializer.fromJson(json1).substance, 'Cannabis');
        expect(LogEntrySerializer.fromJson(json2).substance, 'Alcohol');
      });

      test('handles alternative field names for route', () {
        final json1 = {'route': 'oral'};
        final json2 = {'consumption': 'inhalation'};

        expect(LogEntrySerializer.fromJson(json1).route, 'oral');
        expect(LogEntrySerializer.fromJson(json2).route, 'inhalation');
      });

      test('handles alternative field names for location', () {
        final json1 = {'place': 'Home'};
        final json2 = {'location': 'Park'};

        expect(LogEntrySerializer.fromJson(json1).location, 'Home');
        expect(LogEntrySerializer.fromJson(json2).location, 'Park');
      });

      test('parses combined dose field like "20 mg"', () {
        final json = {'dose': '20 mg'};
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.dosage, 20.0);
        expect(entry.unit, 'mg');
      });

      test('parses combined dose with multiple spaces', () {
        final json = {'dose': '15  g'};
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.dosage, 15.0);
        expect(entry.unit, 'g');
      });

      test('parses numeric dose without unit', () {
        final json = {'dose': 10};
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.dosage, 10.0);
      });

      test('parses feelings as list', () {
        final json = {
          'feelings': ['happy', 'relaxed'],
        };
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.feelings, ['happy', 'relaxed']);
      });

      test('parses feelings from alternative field name', () {
        final json = {
          'primary_emotions': ['excited', 'energetic'],
        };
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.feelings, ['excited', 'energetic']);
      });

      test('parses secondary feelings as map', () {
        final json = {
          'secondary_feelings': {
            'happy': ['joyful', 'content'],
            'sad': ['lonely'],
          },
        };
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.secondaryFeelings, {
          'happy': ['joyful', 'content'],
          'sad': ['lonely'],
        });
      });

      test('parses triggers as list', () {
        final json = {
          'triggers': ['stress', 'social'],
        };
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.triggers, ['stress', 'social']);
      });

      test('parses body signals as list', () {
        final json = {
          'body_signals': ['rapid heartbeat', 'sweating'],
        };
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.bodySignals, ['rapid heartbeat', 'sweating']);
      });

      test('parses people with space splitting', () {
        final json = {'people': 'John Jane Bob'};
        final entry = LogEntrySerializer.fromJson(json);

        expect(entry.people, ['John', 'Jane', 'Bob']);
      });

      test('parses medical_purpose as bool', () {
        final json1 = {'medical_purpose': true};
        final json2 = {'medical_purpose': 'true'};
        final json3 = {'medical': true};

        expect(LogEntrySerializer.fromJson(json1).isMedicalPurpose, true);
        expect(LogEntrySerializer.fromJson(json2).isMedicalPurpose, true);
        expect(LogEntrySerializer.fromJson(json3).isMedicalPurpose, true);
      });

      test('parses medical_purpose as false', () {
        final json1 = {'medical_purpose': false};
        final Map<String, dynamic> json2 = {};

        expect(LogEntrySerializer.fromJson(json1).isMedicalPurpose, false);
        expect(LogEntrySerializer.fromJson(json2).isMedicalPurpose, false);
      });

      test('parses craving intensity from multiple field names', () {
        final json1 = {'craving_intensity': 8.5};
        final json2 = {'intensity': 7};
        final json3 = {'craving_0_10': 6};

        expect(LogEntrySerializer.fromJson(json1).cravingIntensity, 8.5);
        expect(LogEntrySerializer.fromJson(json2).cravingIntensity, 7.0);
        expect(LogEntrySerializer.fromJson(json3).cravingIntensity, 6.0);
      });

      test('parses timezone offset', () {
        final json1 = {'timezone': '+05:30'};
        final json2 = {'tz': '-08:00'};
        final json3 = {'time_zone': 5.5};

        expect(LogEntrySerializer.fromJson(json1).timezoneOffset, 5.5);
        expect(LogEntrySerializer.fromJson(json2).timezoneOffset, -8.0);
        expect(LogEntrySerializer.fromJson(json3).timezoneOffset, 5.5);
      });

      test('parses time difference in minutes', () {
        final json1 = {'time_difference': 30};
        final json2 = {'time_diff': -60};
        final json3 = {'tz_offset_minutes': 90};

        expect(LogEntrySerializer.fromJson(json1).timeDifferenceMinutes, 30);
        expect(LogEntrySerializer.fromJson(json2).timeDifferenceMinutes, -60);
        expect(LogEntrySerializer.fromJson(json3).timeDifferenceMinutes, 90);
      });

      test('applies time difference to datetime', () {
        final json = {
          'start_time': '2024-01-15T10:00:00',
          'time_difference': 30,
        };

        final entry = LogEntrySerializer.fromJson(json);
        final expected = DateTime.parse(
          '2024-01-15T10:00:00',
        ).add(Duration(minutes: 30));

        expect(entry.datetime, expected);
      });

      test('applies timezone offset to datetime', () {
        final json = {
          'start_time': '2024-01-15T10:00:00',
          'timezone': '+05:30',
        };

        final entry = LogEntrySerializer.fromJson(json);
        final expected = DateTime.parse(
          '2024-01-15T10:00:00',
        ).add(Duration(minutes: (5.5 * 60).round()));

        expect(entry.datetime, expected);
      });

      test('handles alternative datetime field names', () {
        final json1 = {'start_time': '2024-01-15T10:00:00'};
        final json2 = {'time': '2024-01-16T11:00:00'};
        final json3 = {'created_at': '2024-01-17T12:00:00'};

        expect(
          LogEntrySerializer.fromJson(json1).datetime,
          DateTime.parse('2024-01-15T10:00:00'),
        );
        expect(
          LogEntrySerializer.fromJson(json2).datetime,
          DateTime.parse('2024-01-16T11:00:00'),
        );
        expect(
          LogEntrySerializer.fromJson(json3).datetime,
          DateTime.parse('2024-01-17T12:00:00'),
        );
      });

      test('uses DateTime.now() for invalid datetime', () {
        final json = {'start_time': 'invalid-date'};
        final entry = LogEntrySerializer.fromJson(json);

        // Should be close to now (within a few seconds)
        final now = DateTime.now();
        expect(entry.datetime.difference(now).inSeconds.abs(), lessThan(5));
      });

      test('parses notes', () {
        final json = {'notes': 'Test note'};
        expect(LogEntrySerializer.fromJson(json).notes, 'Test note');
      });

      test('parses intention', () {
        final json = {'intention': 'Recreational'};
        expect(LogEntrySerializer.fromJson(json).intention, 'Recreational');
      });

      test('handles empty json', () {
        final entry = LogEntrySerializer.fromJson({});

        expect(entry.substance, '');
        expect(entry.dosage, 0.0);
        expect(entry.feelings, []);
        expect(entry.triggers, []);
      });
    });

    group('toJson', () {
      test('converts LogEntry to JSON with all fields', () {
        final entry = LogEntry(
          id: '123',
          substance: 'Cannabis',
          dosage: 10.0,
          unit: 'mg',
          route: 'oral',
          datetime: DateTime.parse('2024-01-15T10:30:00'),
          location: 'Home',
          notes: 'Test note',
          feelings: ['happy', 'relaxed'],
          secondaryFeelings: {
            'happy': ['joyful'],
          },
          triggers: ['stress'],
          bodySignals: ['calm'],
          people: ['John', 'Jane'],
          isMedicalPurpose: true,
          cravingIntensity: 7.5,
          intention: 'Recreational',
          timezoneOffset: 5.5,
          timeDifferenceMinutes: 30,
          timezone: '+05:30',
        );

        final json = LogEntrySerializer.toJson(entry);

        expect(json['use_id'], '123');
        expect(json['substance'], 'Cannabis');
        expect(json['name'], 'Cannabis'); // Duplicate for compatibility
        expect(json['dosage'], 10.0);
        expect(json['unit'], 'mg');
        expect(json['route'], 'oral');
        expect(json['start_time'], '2024-01-15T10:30:00.000');
        expect(json['datetime'], '2024-01-15T10:30:00.000'); // Duplicate
        expect(json['location'], 'Home');
        expect(json['place'], 'Home'); // Duplicate
        expect(json['notes'], 'Test note');
        expect(json['feelings'], ['happy', 'relaxed']);
        expect(json['secondary_feelings'], {
          'happy': ['joyful'],
        });
        expect(json['secondaryFeelings'], {
          'happy': ['joyful'],
        }); // Duplicate
        expect(json['triggers'], ['stress']);
        expect(json['body_signals'], ['calm']);
        expect(json['bodySignals'], ['calm']); // Duplicate
        expect(json['people'], ['John', 'Jane']);
        expect(json['medical_purpose'], true);
        expect(json['isMedicalPurpose'], true); // Duplicate
        expect(json['craving_intensity'], 7.5);
        expect(json['cravingIntensity'], 7.5); // Duplicate
        expect(json['intention'], 'Recreational');
        expect(json['timezone_offset'], 5.5);
        expect(json['timezoneOffset'], 5.5); // Duplicate
        expect(json['time_difference'], 30);
        expect(json['timezone'], '+05:30');
      });

      test('handles null optional fields', () {
        final entry = LogEntry(
          substance: 'Test',
          dosage: 1.0,
          unit: 'mg',
          route: 'oral',
          datetime: DateTime.now(),
          location: '',
          feelings: [],
          secondaryFeelings: {},
          triggers: [],
          bodySignals: [],
          people: [],
          isMedicalPurpose: false,
          cravingIntensity: 0,
        );

        final json = LogEntrySerializer.toJson(entry);

        expect(json['notes'], null);
        expect(json['id'], null);
        expect(json['intention'], null);
      });

      test('round-trip conversion preserves data', () {
        final original = LogEntry(
          substance: 'Cannabis',
          dosage: 25.5,
          unit: 'mg',
          route: 'inhalation',
          datetime: DateTime.parse('2024-01-15T14:30:00'),
          location: 'Park',
          notes: 'Sunny day',
          feelings: ['happy', 'energetic'],
          secondaryFeelings: {
            'happy': ['joyful', 'excited'],
          },
          triggers: ['social'],
          bodySignals: ['increased heart rate'],
          people: ['Alice', 'Bob'],
          isMedicalPurpose: false,
          cravingIntensity: 3.5,
          intention: 'Social',
          timezoneOffset: -5.0,
        );

        final json = LogEntrySerializer.toJson(original);
        final restored = LogEntrySerializer.fromJson(json);

        expect(restored.substance, original.substance);
        expect(restored.dosage, original.dosage);
        expect(restored.unit, original.unit);
        expect(restored.route, original.route);
        expect(restored.location, original.location);
        expect(restored.notes, original.notes);
        expect(restored.feelings, original.feelings);
        expect(restored.secondaryFeelings, original.secondaryFeelings);
        expect(restored.triggers, original.triggers);
        expect(restored.bodySignals, original.bodySignals);
        expect(restored.people, original.people);
        expect(restored.isMedicalPurpose, original.isMedicalPurpose);
        expect(restored.cravingIntensity, original.cravingIntensity);
        expect(restored.intention, original.intention);
      });
    });
  });
}

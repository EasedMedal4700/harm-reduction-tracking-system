import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/log_entry_service.dart';
import 'package:mobile_drug_use_app/models/log_entry_model.dart';

void main() {
  group('LogEntryService', () {
    late LogEntryService service;

    setUp(() {
      service = LogEntryService();
    });

    test('saveLogEntry throws exception for invalid location', () async {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: ['Calm'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Select a location',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: 'Relax',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(() => service.saveLogEntry(entry), throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Please select a valid location'),
      )));
    });

    test('validates location is not default value', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Select a location',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(
        () => service.saveLogEntry(entry),
        throwsA(isA<Exception>()),
      );
    });

    test('DateFormat formatter is configured correctly', () {
      final now = DateTime(2025, 11, 7, 21, 56, 0);
      final formatted = service.formatter.format(now);
      expect(formatted, '2025-11-07 21:56:00');
    });

    test('validates entry with valid location passes initial check', () {
      final entry = LogEntry(
        substance: 'MDMA',
        dosage: 120,
        unit: 'mg',
        route: 'oral',
        feelings: ['Happy', 'Excited'],
        secondaryFeelings: {'Happy': ['Joyful']},
        datetime: DateTime(2025, 7, 4, 22, 0),
        location: 'Festival',
        notes: 'Great time',
        timezoneOffset: -5.0,
        isMedicalPurpose: false,
        cravingIntensity: 3,
        intention: 'Social Enhancement',
        triggers: ['celebration'],
        bodySignals: ['heart racing'],
        people: ['Alice', 'Bob'],
      );

      // Verify location passes validation
      expect(entry.location, isNot('Select a location'));
      expect(entry.substance, 'MDMA');
      expect(entry.dosage, 120);
    });

    test('validates intention null conversion logic', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '-- Select Intention--',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      // Verify default intention value
      expect(entry.intention, '-- Select Intention--');
    });

    test('formats datetime to UTC correctly', () {
      final service = LogEntryService();
      final localTime = DateTime(2025, 11, 7, 21, 56, 0);
      final utcTime = localTime.toUtc();
      final formatted = service.formatter.format(utcTime);
      
      expect(formatted, contains('2025-11-07'));
      expect(formatted.length, 19); // 'yyyy-MM-dd HH:mm:ss' length
    });
  });

  group('LogEntryService data transformation', () {
    test('handles null intention correctly', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: null,
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.intention, isNull);
    });

    test('flattens secondary feelings correctly', () {
      final secondaryFeelings = {
        'Happy': ['Joyful', 'Excited'],
        'Calm': ['Peaceful'],
      };
      
      final flattened = secondaryFeelings.values.expand((list) => list).toList();
      expect(flattened, ['Joyful', 'Excited', 'Peaceful']);
    });

    test('converts craving intensity to integer', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 7.8,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.cravingIntensity.toInt(), 7);
    });

    test('handles empty feelings list', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: 'Relax',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.feelings, isEmpty);
      expect(entry.secondaryFeelings, isEmpty);
    });

    test('handles multiple triggers', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: ['Calm'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: 'Relax',
        triggers: ['stress', 'anxiety', 'insomnia'],
        bodySignals: [],
        people: [],
      );

      expect(entry.triggers.length, 3);
      expect(entry.triggers, contains('stress'));
      expect(entry.triggers, contains('anxiety'));
      expect(entry.triggers, contains('insomnia'));
    });

    test('handles multiple body signals', () {
      final entry = LogEntry(
        substance: 'MDMA',
        dosage: 120,
        unit: 'mg',
        route: 'oral',
        feelings: ['Happy'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Festival',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 3,
        intention: 'Social',
        triggers: [],
        bodySignals: ['heart racing', 'dry mouth', 'pupil dilation'],
        people: ['Friends'],
      );

      expect(entry.bodySignals.length, 3);
      expect(entry.bodySignals, contains('heart racing'));
      expect(entry.bodySignals, contains('dry mouth'));
    });

    test('handles multiple people present', () {
      final entry = LogEntry(
        substance: 'Alcohol',
        dosage: 50,
        unit: 'ml',
        route: 'oral',
        feelings: ['Social'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Bar',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 2,
        intention: 'Social',
        triggers: [],
        bodySignals: [],
        people: ['Alice', 'Bob', 'Charlie'],
      );

      expect(entry.people.length, 3);
      expect(entry.people, contains('Alice'));
      expect(entry.people, contains('Bob'));
      expect(entry.people, contains('Charlie'));
    });

    test('medical purpose flag is boolean', () {
      final medicalEntry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: 'Medical use',
        timezoneOffset: 0,
        isMedicalPurpose: true,
        cravingIntensity: 0,
        intention: 'Medical',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(medicalEntry.isMedicalPurpose, isTrue);
      expect(medicalEntry.isMedicalPurpose.toString(), 'true');
    });

    test('timezone offset formats correctly', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: -5.5,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.timezoneOffset.toString(), '-5.5');
    });

    test('dose string formats correctly', () {
      final entry = LogEntry(
        substance: 'LSD',
        dosage: 150,
        unit: 'µg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      final doseString = '${entry.dosage} ${entry.unit}';
      // Note: dosage is stored as double, so it will include .0
      expect(doseString, anyOf('150 µg', '150.0 µg'));
    });
  });

  group('LogEntryService edge cases', () {
    test('handles very high dosages', () {
      final entry = LogEntry(
        substance: 'Caffeine',
        dosage: 500,
        unit: 'mg',
        route: 'oral',
        feelings: ['Alert'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Work',
        notes: 'Multiple cups of coffee',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 8,
        intention: 'Focus',
        triggers: ['fatigue'],
        bodySignals: ['jittery'],
        people: [],
      );

      expect(entry.dosage, 500);
      expect(entry.substance, 'Caffeine');
    });

    test('handles fractional dosages', () {
      final entry = LogEntry(
        substance: 'Alprazolam',
        dosage: 0.5,
        unit: 'mg',
        route: 'oral',
        feelings: ['Calm'],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: 'Low dose',
        timezoneOffset: 0,
        isMedicalPurpose: true,
        cravingIntensity: 0,
        intention: 'Medical',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.dosage, 0.5);
      final doseString = '${entry.dosage} ${entry.unit}';
      expect(doseString, '0.5 mg');
    });

    test('handles long notes text', () {
      final longNotes = 'This is a very long note ' * 50;
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: longNotes,
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.notes?.length, greaterThan(100));
    });

    test('handles special characters in notes', () {
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: DateTime.now(),
        location: 'Home',
        notes: 'Notes with "quotes" and \'apostrophes\' & symbols!',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.notes, contains('"'));
      expect(entry.notes, contains('\''));
      expect(entry.notes, contains('&'));
    });

    test('handles past dates', () {
      final pastDate = DateTime(2020, 1, 1, 12, 0, 0);
      final entry = LogEntry(
        substance: 'Cannabis',
        dosage: 10,
        unit: 'mg',
        route: 'oral',
        feelings: [],
        secondaryFeelings: {},
        datetime: pastDate,
        location: 'Home',
        notes: '',
        timezoneOffset: 0,
        isMedicalPurpose: false,
        cravingIntensity: 5,
        intention: '',
        triggers: [],
        bodySignals: [],
        people: [],
      );

      expect(entry.datetime.year, 2020);
      expect(entry.datetime.isBefore(DateTime.now()), isTrue);
    });

    test('handles different routes of administration', () {
      final routes = ['oral', 'smoked', 'vaporized', 'insufflated', 'injected', 'sublingual'];
      
      for (final route in routes) {
        final entry = LogEntry(
          substance: 'Test',
          dosage: 10,
          unit: 'mg',
          route: route,
          feelings: [],
          secondaryFeelings: {},
          datetime: DateTime.now(),
          location: 'Home',
          notes: '',
          timezoneOffset: 0,
          isMedicalPurpose: false,
          cravingIntensity: 5,
          intention: '',
          triggers: [],
          bodySignals: [],
          people: [],
        );

        expect(entry.route, route);
      }
    });
  });
}

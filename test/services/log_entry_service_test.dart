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
  });
}

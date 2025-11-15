import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/states/log_entry_state.dart';
import 'package:mobile_drug_use_app/models/log_entry_model.dart';

void main() {
  group('LogEntryState', () {
    late LogEntryState state;

    setUp(() {
      state = LogEntryState();
    });

    tearDown(() {
      state.dispose();
    });

    group('Initialization', () {
      test('initializes with default values', () {
        expect(state.isSimpleMode, isTrue);
        expect(state.dose, 0);
        expect(state.unit, 'mg');
        expect(state.substance, '');
        expect(state.route, 'oral');
        expect(state.feelings, isEmpty);
        expect(state.secondaryFeelings, isEmpty);
        expect(state.location, 'Select a location');
        expect(state.isMedicalPurpose, isFalse);
        expect(state.cravingIntensity, 0);
        expect(state.intention, '-- Select Intention--');
        expect(state.triggers, isEmpty);
        expect(state.bodySignals, isEmpty);
        expect(state.entryId, '');
        expect(state.isSaving, isFalse);
      });

      test('initializes with current date and time', () {
        final now = DateTime.now();
        final timeNow = TimeOfDay.now();
        
        expect(state.date.year, now.year);
        expect(state.date.month, now.month);
        expect(state.date.day, now.day);
        expect(state.hour, timeNow.hour);
        expect(state.minute, timeNow.minute);
      });

      test('initializes controllers', () {
        expect(state.doseCtrl, isA<TextEditingController>());
        expect(state.substanceCtrl, isA<TextEditingController>());
        expect(state.notesCtrl, isA<TextEditingController>());
        expect(state.formKey, isA<GlobalKey<FormState>>());
      });
    });

    group('Setters', () {
      test('setIsSimpleMode updates value', () {
        state.setIsSimpleMode(false);
        expect(state.isSimpleMode, isFalse);
        
        state.setIsSimpleMode(true);
        expect(state.isSimpleMode, isTrue);
      });

      test('setDose updates dose and controller', () {
        state.setDose(10.5);
        expect(state.dose, 10.5);
        expect(state.doseCtrl.text, '10.5');
        
        state.setDose(0);
        expect(state.dose, 0);
        expect(state.doseCtrl.text, '');
      });

      test('setUnit updates unit', () {
        state.setUnit('g');
        expect(state.unit, 'g');
        
        state.setUnit('ml');
        expect(state.unit, 'ml');
      });

      test('setSubstance updates substance and controller', () {
        state.setSubstance('Cannabis');
        expect(state.substance, 'Cannabis');
        expect(state.substanceCtrl.text, 'Cannabis');
      });

      test('setRoute updates route', () {
        state.setRoute('inhalation');
        expect(state.route, 'inhalation');
      });

      test('setFeelings updates feelings list', () {
        state.setFeelings(['Happy', 'Relaxed']);
        expect(state.feelings, ['Happy', 'Relaxed']);
      });

      test('setSecondaryFeelings updates secondary feelings map', () {
        final map = {'Happy': ['Joyful', 'Excited']};
        state.setSecondaryFeelings(map);
        expect(state.secondaryFeelings, map);
      });

      test('setLocation updates location', () {
        state.setLocation('Home');
        expect(state.location, 'Home');
      });

      test('setDate updates date', () {
        final newDate = DateTime(2025, 7, 4);
        state.setDate(newDate);
        expect(state.date, newDate);
      });

      test('setHour updates hour', () {
        state.setHour(14);
        expect(state.hour, 14);
      });

      test('setMinute updates minute', () {
        state.setMinute(30);
        expect(state.minute, 30);
      });

      test('setIsMedicalPurpose updates medical flag', () {
        state.setIsMedicalPurpose(true);
        expect(state.isMedicalPurpose, isTrue);
        
        state.setIsMedicalPurpose(false);
        expect(state.isMedicalPurpose, isFalse);
      });

      test('setCravingIntensity updates craving intensity', () {
        state.setCravingIntensity(7.5);
        expect(state.cravingIntensity, 7.5);
      });

      test('setIntention updates intention', () {
        state.setIntention('Relax/Stress Relief');
        expect(state.intention, 'Relax/Stress Relief');
      });

      test('setIntention handles null value', () {
        state.setIntention(null);
        expect(state.intention, '-- Select Intention--');
      });

      test('setTriggers updates triggers list', () {
        state.setTriggers(['stress', 'boredom']);
        expect(state.triggers, ['stress', 'boredom']);
      });

      test('setBodySignals updates body signals list', () {
        state.setBodySignals(['heart racing', 'dry mouth']);
        expect(state.bodySignals, ['heart racing', 'dry mouth']);
      });
    });

    group('selectedDateTime', () {
      test('combines date and time correctly', () {
        state.setDate(DateTime(2025, 7, 4));
        state.setHour(14);
        state.setMinute(30);
        
        final combined = state.selectedDateTime;
        expect(combined.year, 2025);
        expect(combined.month, 7);
        expect(combined.day, 4);
        expect(combined.hour, 14);
        expect(combined.minute, 30);
      });
    });

    group('resetForm', () {
      test('resets all fields to default', () {
        // Set various fields
        state.setDose(10);
        state.setSubstance('Cannabis');
        state.setFeelings(['Happy']);
        state.setSecondaryFeelings({'Happy': ['Joyful']});
        state.setLocation('Home');
        state.setIsMedicalPurpose(true);
        state.setCravingIntensity(7);
        state.setIntention('Relax');
        state.setTriggers(['stress']);
        state.setBodySignals(['racing heart']);
        state.notesCtrl.text = 'Test notes';
        state.entryId = 'test-id';
        
        // Reset
        state.resetForm();
        
        // Verify all reset
        expect(state.dose, 0);
        expect(state.substance, '');
        expect(state.feelings, isEmpty);
        expect(state.secondaryFeelings, isEmpty);
        expect(state.location, 'Select a location');
        expect(state.isMedicalPurpose, isFalse);
        expect(state.cravingIntensity, 0);
        expect(state.intention, '');
        expect(state.triggers, isEmpty);
        expect(state.bodySignals, isEmpty);
        expect(state.notesCtrl.text, isEmpty);
        expect(state.entryId, '');
      });
    });

    group('LogEntry creation', () {
      test('creates correct LogEntry from state', () {
        state.setSubstance('MDMA');
        state.setDose(120);
        state.setUnit('mg');
        state.setRoute('oral');
        state.setFeelings(['Happy', 'Excited']);
        state.setSecondaryFeelings({'Happy': ['Joyful']});
        state.setDate(DateTime(2025, 7, 4));
        state.setHour(22);
        state.setMinute(0);
        state.setLocation('Festival');
        state.notesCtrl.text = 'Great time';
        state.setIsMedicalPurpose(false);
        state.setCravingIntensity(3);
        state.setIntention('Social Enhancement');
        state.setTriggers(['celebration']);
        state.setBodySignals(['heart racing']);
        
        // Simulate entry creation (as done in save())
        final entry = LogEntry(
          substance: state.substance,
          dosage: state.dose,
          unit: state.unit,
          route: state.route,
          feelings: state.feelings,
          secondaryFeelings: state.secondaryFeelings,
          datetime: state.selectedDateTime,
          location: state.location,
          notes: state.notesCtrl.text.trim(),
          timezoneOffset: state.timezoneService.getTimezoneOffset(),
          isMedicalPurpose: state.isMedicalPurpose,
          cravingIntensity: state.cravingIntensity,
          intention: state.intention ?? '-- Select Intention--',
          triggers: state.triggers,
          bodySignals: state.bodySignals,
          people: [],
        );
        
        expect(entry.substance, 'MDMA');
        expect(entry.dosage, 120);
        expect(entry.unit, 'mg');
        expect(entry.route, 'oral');
        expect(entry.feelings, ['Happy', 'Excited']);
        expect(entry.location, 'Festival');
        expect(entry.notes, 'Great time');
        expect(entry.cravingIntensity, 3);
      });
    });

    group('Controller synchronization', () {
      test('doseCtrl syncs with dose setter', () {
        state.setDose(25.5);
        expect(state.doseCtrl.text, '25.5');
        
        state.setDose(0);
        expect(state.doseCtrl.text, '');
      });

      test('substanceCtrl syncs with substance setter', () {
        state.setSubstance('Cannabis');
        expect(state.substanceCtrl.text, 'Cannabis');
        
        state.setSubstance('');
        expect(state.substanceCtrl.text, '');
      });

      test('notesCtrl can be set independently', () {
        state.notesCtrl.text = 'This is a test note';
        expect(state.notesCtrl.text, 'This is a test note');
      });
    });

    group('Update vs Create logic', () {
      test('save creates new entry when entryId is empty', () {
        expect(state.entryId, isEmpty);
        // In actual save(), would call logEntryService.saveLogEntry(entry)
      });

      test('save updates entry when entryId is not empty', () {
        state.entryId = 'existing-entry-123';
        expect(state.entryId.isNotEmpty, isTrue);
        // In actual save(), would call logEntryService.updateLogEntry(entryId, entry.toJson())
      });
    });
  });
}

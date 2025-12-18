import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_controller.dart';
import 'package:mobile_drug_use_app/models/log_entry_form_data.dart';
import 'package:mobile_drug_use_app/repo/substance_repository.dart';

// Simple Mock for SubstanceRepository
class MockSubstanceRepository implements SubstanceRepository {
  final Map<String, Map<String, dynamic>> _db = {};

  void addSubstance(String name, Map<String, dynamic> details) {
    _db[name] = details;
  }

  @override
  Future<Map<String, dynamic>?> getSubstanceDetails(String name) async {
    return _db[name];
  }

  @override
  List<String> getAvailableROAs(Map<String, dynamic>? details) {
    if (details == null) return [];
    return (details['roas'] as List<dynamic>?)?.cast<String>() ?? [];
  }

  @override
  bool isROAValid(String roa, Map<String, dynamic>? details) {
    if (details == null) return false;
    final roas = getAvailableROAs(details);
    return roas.contains(roa);
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LogEntryController Logic', () {
    late LogEntryController controller;
    late MockSubstanceRepository mockRepo;
    final now = DateTime.now();

    setUp(() {
      mockRepo = MockSubstanceRepository();
      controller = LogEntryController(substanceRepo: mockRepo);
    });

    test('validateSubstance returns error if substance is empty', () async {
      final data = LogEntryFormData(
        substance: '',
        date: now,
        hour: 12,
        minute: 0,
      );
      final result = await controller.validateSubstance(data);
      
      expect(result.isValid, isFalse);
      expect(result.title, 'Missing Substance');
    });

    test('validateSubstance returns error if substance not found in DB', () async {
      final data = LogEntryFormData(
        substance: 'UnknownDrug',
        date: now,
        hour: 12,
        minute: 0,
      );
      final result = await controller.validateSubstance(data);
      
      expect(result.isValid, isFalse);
      expect(result.title, 'Substance Not Found');
    });

    test('validateSubstance returns success if substance exists', () async {
      mockRepo.addSubstance('Caffeine', {'pretty_name': 'Caffeine'});
      
      final data = LogEntryFormData(
        substance: 'Caffeine',
        date: now,
        hour: 12,
        minute: 0,
      );
      final result = await controller.validateSubstance(data);
      
      expect(result.isValid, isTrue);
    });

    test('validateROA returns warning for unvalidated route', () {
      final details = {'pretty_name': 'Caffeine', 'roas': ['oral']};
      final data = LogEntryFormData(
        substance: 'Caffeine',
        route: 'inject',
        substanceDetails: details,
        date: now,
        hour: 12,
        minute: 0,
      );
      
      final result = controller.validateROA(data);
      
      expect(result.needsConfirmation, isTrue);
      expect(result.title, 'Unvalidated Route');
    });

    test('validateROA returns success for validated route', () {
      final details = {'pretty_name': 'Caffeine', 'roas': ['oral']};
      final data = LogEntryFormData(
        substance: 'Caffeine',
        route: 'oral',
        substanceDetails: details,
        date: now,
        hour: 12,
        minute: 0,
      );
      
      final result = controller.validateROA(data);
      
      expect(result.isValid, isTrue);
      expect(result.needsConfirmation, isFalse);
    });

    test('validateEmotions returns warning if empty for non-medical use', () {
      final data = LogEntryFormData(
        isMedicalPurpose: false,
        feelings: [],
        date: now,
        hour: 12,
        minute: 0,
      );
      
      final result = controller.validateEmotions(data);
      
      expect(result.needsConfirmation, isTrue);
      expect(result.title, 'No Emotions Selected');
    });

    test('validateEmotions returns success if medical purpose', () {
      final data = LogEntryFormData(
        isMedicalPurpose: true,
        feelings: [],
        date: now,
        hour: 12,
        minute: 0,
      );
      
      final result = controller.validateEmotions(data);
      
      expect(result.isValid, isTrue);
    });
  });
}

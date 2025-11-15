import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/utils/entry_validation.dart';
import 'package:mobile_drug_use_app/constants/drug_use_catalog.dart';

void main() {
  group('ValidationUtils', () {
    group('validateRequired', () {
      test('returns error for null value', () {
        final result = ValidationUtils.validateRequired(null, 'Field is required');
        expect(result, 'Field is required');
      });

      test('returns error for empty string', () {
        final result = ValidationUtils.validateRequired('', 'Field is required');
        expect(result, 'Field is required');
      });

      test('returns error for whitespace-only string', () {
        final result = ValidationUtils.validateRequired('   ', 'Field is required');
        expect(result, 'Field is required');
      });

      test('returns null for valid string', () {
        final result = ValidationUtils.validateRequired('Valid input', 'Field is required');
        expect(result, isNull);
      });
    });

    group('validateDosage', () {
      test('returns error for null dose', () {
        final result = ValidationUtils.validateDosage(null);
        expect(result, ValidationUtils.emptyDosageError);
      });

      test('returns error for empty dose', () {
        final result = ValidationUtils.validateDosage('');
        expect(result, ValidationUtils.emptyDosageError);
      });

      test('returns error for zero dose', () {
        final result = ValidationUtils.validateDosage('0');
        expect(result, ValidationUtils.invalidDosageError);
      });

      test('returns error for negative dose', () {
        final result = ValidationUtils.validateDosage('-5');
        expect(result, ValidationUtils.invalidDosageError);
      });

      test('returns error for non-numeric dose', () {
        final result = ValidationUtils.validateDosage('abc');
        expect(result, ValidationUtils.invalidDosageError);
      });

      test('returns error for dose over 1000', () {
        final result = ValidationUtils.validateDosage('1001');
        expect(result, ValidationUtils.invalidDosageError);
      });

      test('returns null for valid integer dose', () {
        final result = ValidationUtils.validateDosage('10');
        expect(result, isNull);
      });

      test('returns null for valid decimal dose', () {
        final result = ValidationUtils.validateDosage('2.5');
        expect(result, isNull);
      });

      test('returns null for dose with whitespace', () {
        final result = ValidationUtils.validateDosage('  10  ');
        expect(result, isNull);
      });

      test('accepts maximum valid dose', () {
        final result = ValidationUtils.validateDosage('1000');
        expect(result, isNull);
      });

      test('accepts minimum valid dose', () {
        final result = ValidationUtils.validateDosage('0.01');
        expect(result, isNull);
      });
    });

    group('validateSubstance', () {
      test('returns error for null substance', () {
        final result = ValidationUtils.validateSubstance(null);
        expect(result, ValidationUtils.emptySubstanceError);
      });

      test('returns error for empty substance', () {
        final result = ValidationUtils.validateSubstance('');
        expect(result, ValidationUtils.emptySubstanceError);
      });

      test('returns error for unrecognized substance', () {
        final result = ValidationUtils.validateSubstance('NotARealDrug');
        expect(result, ValidationUtils.unrecognizedSubstanceError);
      });

      test('returns null for valid substance', () {
        final validSubstance = DrugUseCatalog.substances.first;
        final result = ValidationUtils.validateSubstance(validSubstance);
        expect(result, isNull);
      });

      test('validates all catalog substances', () {
        for (final substance in DrugUseCatalog.substances) {
          final result = ValidationUtils.validateSubstance(substance);
          expect(result, isNull, reason: 'Substance $substance should be valid');
        }
      });
    });

    group('isSubstanceValid', () {
      test('returns true for valid substance', () {
        final validSubstance = DrugUseCatalog.substances.first;
        expect(ValidationUtils.isSubstanceValid(validSubstance), isTrue);
      });

      test('returns false for invalid substance', () {
        expect(ValidationUtils.isSubstanceValid('NotARealDrug'), isFalse);
      });

      test('handles whitespace trimming', () {
        final validSubstance = DrugUseCatalog.substances.first;
        expect(ValidationUtils.isSubstanceValid('  $validSubstance  '), isTrue);
      });
    });

    group('validateRoute', () {
      test('returns error for null route', () {
        final result = ValidationUtils.validateRoute(null);
        expect(result, 'Please select a route');
      });

      test('returns error for empty route', () {
        final result = ValidationUtils.validateRoute('');
        expect(result, 'Please select a route');
      });

      test('returns error for invalid route', () {
        final result = ValidationUtils.validateRoute('invalid_route');
        expect(result, 'Invalid route');
      });

      test('returns null for valid route', () {
        final validRoute = DrugUseCatalog.consumptionMethods.first['name'];
        final result = ValidationUtils.validateRoute(validRoute);
        expect(result, isNull);
      });

      test('validates all catalog routes', () {
        for (final method in DrugUseCatalog.consumptionMethods) {
          final route = method['name'];
          final result = ValidationUtils.validateRoute(route);
          expect(result, isNull, reason: 'Route $route should be valid');
        }
      });
    });

    group('validateFeeling', () {
      test('returns error for null feeling', () {
        final result = ValidationUtils.validateFeeling(null);
        expect(result, 'Please select a feeling');
      });

      test('returns error for empty feeling', () {
        final result = ValidationUtils.validateFeeling('');
        expect(result, 'Please select a feeling');
      });

      test('returns error for invalid feeling', () {
        final result = ValidationUtils.validateFeeling('invalid_feeling');
        expect(result, 'Invalid feeling');
      });

      test('returns null for valid feeling', () {
        final validFeeling = DrugUseCatalog.primaryEmotions.first['name'];
        final result = ValidationUtils.validateFeeling(validFeeling);
        expect(result, isNull);
      });

      test('validates all catalog feelings', () {
        for (final emotion in DrugUseCatalog.primaryEmotions) {
          final feeling = emotion['name'];
          final result = ValidationUtils.validateFeeling(feeling);
          expect(result, isNull, reason: 'Feeling $feeling should be valid');
        }
      });

      test('handles whitespace in feeling', () {
        final validFeeling = DrugUseCatalog.primaryEmotions.first['name'];
        final result = ValidationUtils.validateFeeling('  $validFeeling  ');
        expect(result, isNull);
      });
    });

    group('Edge cases', () {
      test('validateDosage handles very small decimals', () {
        final result = ValidationUtils.validateDosage('0.001');
        expect(result, isNull);
      });

      test('validateRoute is case-sensitive', () {
        final validRoute = DrugUseCatalog.consumptionMethods.first['name'];
        final uppercaseRoute = validRoute?.toUpperCase();
        final result = ValidationUtils.validateRoute(uppercaseRoute);
        
        if (validRoute != uppercaseRoute) {
          expect(result, 'Invalid route');
        }
      });

      test('validateFeeling is case-sensitive', () {
        final validFeeling = DrugUseCatalog.primaryEmotions.first['name'];
        final uppercaseFeeling = validFeeling?.toUpperCase();
        final result = ValidationUtils.validateFeeling(uppercaseFeeling);
        
        if (validFeeling != uppercaseFeeling) {
          expect(result, 'Invalid feeling');
        }
      });
    });
  });
}

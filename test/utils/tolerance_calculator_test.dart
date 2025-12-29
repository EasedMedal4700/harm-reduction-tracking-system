import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/utils/tolerance_calculator.dart';
import 'package:mobile_drug_use_app/models/tolerance_model.dart';

void main() {
  group('ToleranceCalculator', () {
    group('classifyState', () {
      test('classifies recovered state (0-20%)', () {
        expect(
          ToleranceCalculator.classifyState(0),
          ToleranceSystemState.recovered,
        );
        expect(
          ToleranceCalculator.classifyState(10),
          ToleranceSystemState.recovered,
        );
        expect(
          ToleranceCalculator.classifyState(19.9),
          ToleranceSystemState.recovered,
        );
      });

      test('classifies light stress state (20-40%)', () {
        expect(
          ToleranceCalculator.classifyState(20),
          ToleranceSystemState.lightStress,
        );
        expect(
          ToleranceCalculator.classifyState(30),
          ToleranceSystemState.lightStress,
        );
        expect(
          ToleranceCalculator.classifyState(39.9),
          ToleranceSystemState.lightStress,
        );
      });

      test('classifies moderate strain state (40-60%)', () {
        expect(
          ToleranceCalculator.classifyState(40),
          ToleranceSystemState.moderateStrain,
        );
        expect(
          ToleranceCalculator.classifyState(50),
          ToleranceSystemState.moderateStrain,
        );
        expect(
          ToleranceCalculator.classifyState(59.9),
          ToleranceSystemState.moderateStrain,
        );
      });

      test('classifies high strain state (60-80%)', () {
        expect(
          ToleranceCalculator.classifyState(60),
          ToleranceSystemState.highStrain,
        );
        expect(
          ToleranceCalculator.classifyState(70),
          ToleranceSystemState.highStrain,
        );
        expect(
          ToleranceCalculator.classifyState(79.9),
          ToleranceSystemState.highStrain,
        );
      });

      test('classifies depleted state (80-100%)', () {
        expect(
          ToleranceCalculator.classifyState(80),
          ToleranceSystemState.depleted,
        );
        expect(
          ToleranceCalculator.classifyState(90),
          ToleranceSystemState.depleted,
        );
        expect(
          ToleranceCalculator.classifyState(100),
          ToleranceSystemState.depleted,
        );
      });
    });

    // NOTE: Other tolerance calculation tests are disabled because they test
    // old static methods that were part of the legacy tolerance engine.
    // The new unified tolerance engine uses ToleranceCalculatorFull.computeToleranceFull
    // which returns a ToleranceResult with all calculated values.
    // Those methods should be tested via integration tests of computeToleranceFull.
  });
}

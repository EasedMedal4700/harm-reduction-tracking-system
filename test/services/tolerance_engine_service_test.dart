import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/tolerance_model.dart';
import 'package:mobile_drug_use_app/services/tolerance_engine_service.dart';
import 'package:mobile_drug_use_app/utils/tolerance_calculator.dart';

void main() {
  group('ToleranceContribution', () {
    test('creates contribution with required fields', () {
      const contribution = ToleranceContribution(
        substanceName: 'Alcohol',
        percentContribution: 75.5,
        rawLoad: 10.2,
      );

      expect(contribution.substanceName, 'Alcohol');
      expect(contribution.percentContribution, 75.5);
      expect(contribution.rawLoad, 10.2);
    });
  });

  group('ToleranceReport', () {
    test('averageTolerance calculates correctly', () {
      final report = ToleranceReport(
        tolerances: {'gaba': 10.0, 'stimulant': 20.0, 'opioid': 30.0},
        states: {},
        timestamp: DateTime.now(),
      );

      expect(report.averageTolerance, 20.0);
    });

    test('averageTolerance returns 0 for empty tolerances', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {},
        timestamp: DateTime.now(),
      );

      expect(report.averageTolerance, 0.0);
    });

    test('highestTolerance returns highest bucket', () {
      final report = ToleranceReport(
        tolerances: {'gaba': 10.0, 'stimulant': 30.0, 'opioid': 20.0},
        states: {},
        timestamp: DateTime.now(),
      );

      final highest = report.highestTolerance;
      expect(highest!.key, 'stimulant');
      expect(highest.value, 30.0);
    });

    test('highestTolerance returns null for empty tolerances', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {},
        timestamp: DateTime.now(),
      );

      expect(report.highestTolerance, null);
    });

    test('stateCounts counts states correctly', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {
          'gaba': ToleranceSystemState.recovered,
          'stimulant': ToleranceSystemState.lightStress,
          'opioid': ToleranceSystemState.moderateStrain,
          'gaba': ToleranceSystemState.recovered, // Duplicate
        },
        timestamp: DateTime.now(),
      );

      final counts = report.stateCounts;
      expect(counts[ToleranceSystemState.recovered], 1);
      expect(counts[ToleranceSystemState.lightStress], 1);
      expect(counts[ToleranceSystemState.moderateStrain], 1);
      expect(counts[ToleranceSystemState.highStrain], 0);
      expect(counts[ToleranceSystemState.depleted], 0);
    });

    test('hasDepletedSystems returns true when depleted systems exist', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {
          'gaba': ToleranceSystemState.recovered,
          'stimulant': ToleranceSystemState.depleted,
        },
        timestamp: DateTime.now(),
      );

      expect(report.hasDepletedSystems, true);
    });

    test('hasDepletedSystems returns false when no depleted systems', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {
          'gaba': ToleranceSystemState.recovered,
          'stimulant': ToleranceSystemState.lightStress,
        },
        timestamp: DateTime.now(),
      );

      expect(report.hasDepletedSystems, false);
    });

    test('hasHighStrain returns true when high strain systems exist', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {
          'gaba': ToleranceSystemState.recovered,
          'stimulant': ToleranceSystemState.highStrain,
        },
        timestamp: DateTime.now(),
      );

      expect(report.hasHighStrain, true);
    });

    test('hasHighStrain returns false when no high strain systems', () {
      final report = ToleranceReport(
        tolerances: {},
        states: {
          'gaba': ToleranceSystemState.recovered,
          'stimulant': ToleranceSystemState.lightStress,
        },
        timestamp: DateTime.now(),
      );

      expect(report.hasHighStrain, false);
    });
  });

  group('ToleranceEngineService - Static Methods', () {
    test('service class exists and has expected static methods', () {
      // Test that the class exists and has the expected static methods
      expect(ToleranceEngineService.computeSystemTolerance, isNotNull);
      expect(ToleranceEngineService.fetchAllToleranceModels, isNotNull);
      expect(ToleranceEngineService.fetchUseLogs, isNotNull);
      expect(ToleranceEngineService.computeUserTolerances, isNotNull);
      expect(ToleranceEngineService.computeUserSystemStates, isNotNull);
      expect(ToleranceEngineService.computePerSubstanceTolerances, isNotNull);
      expect(ToleranceEngineService.getToleranceReport, isNotNull);
      expect(ToleranceEngineService.getBucketBreakdown, isNotNull);
    });

    test('UseLogEntry can be created', () {
      final timestamp = DateTime.now();
      final entry = UseLogEntry(
        substanceSlug: 'alcohol',
        timestamp: timestamp,
        doseUnits: 20.0,
      );

      expect(entry.substanceSlug, 'alcohol');
      expect(entry.timestamp, timestamp);
      expect(entry.doseUnits, 20.0);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/blood_levels/services/decay_service.dart';
import 'package:mobile_drug_use_app/features/blood_levels/services/blood_levels_service.dart';

void main() {
  group('DecayService', () {
    late DecayService service;

    setUp(() {
      service = DecayService();
    });

    test('calculates correct exponential decay', () {
      // Test case: 100mg dose, 3.5h half-life, after 3.5h should be 50mg
      final remaining = service.decayRemaining(100.0, 3.5, 3.5);
      expect(remaining, closeTo(50.0, 0.1));
    });

    test('calculates decay after 2 half-lives', () {
      // After 2 half-lives, should be 25% remaining
      final remaining = service.decayRemaining(100.0, 7.0, 3.5);
      expect(remaining, closeTo(25.0, 0.1));
    });

    test('returns 0 for negative time', () {
      final remaining = service.decayRemaining(100.0, -5.0, 3.5);
      expect(remaining, 0.0);
    });

    test('returns original dose at time 0', () {
      final remaining = service.decayRemaining(100.0, 0.0, 3.5);
      expect(remaining, 100.0);
    });

    test('generates curve with correct number of points', () {
      final dose = DoseEntry(
        dose: 10.0,
        startTime: DateTime.now(),
        remaining: 10.0,
        hoursElapsed: 0.0,
      );

      final curve = service.generateDecayCurveForDose(
        dose: dose,
        halfLife: 3.5,
        referenceTime: DateTime.now(),
        hoursBack: 12,
        hoursForward: 12,
        stepHours: 2.0,
      );

      // Should have points from -12 to +12 in steps of 2 = 13 points
      expect(curve.length, 13);
    });

    test('curve shows decay over time', () {
      final now = DateTime.now();
      final dose = DoseEntry(
        dose: 100.0,
        startTime: now.subtract(const Duration(hours: 4)),
        remaining: 100.0,
        hoursElapsed: 4.0,
      );

      final curve = service.generateDecayCurveForDose(
        dose: dose,
        halfLife: 3.5,
        referenceTime: now,
        hoursBack: 12,
        hoursForward: 12,
        stepHours: 2.0,
      );

      // Point at "now" should show some decay
      final nowPoint = curve.firstWhere((p) => p.hours == 0);
      expect(nowPoint.remainingMg, lessThan(100.0));
      expect(nowPoint.remainingMg, greaterThan(40.0)); // Roughly 50mg after 4h
    });

    test('combined curve sums multiple doses', () {
      final now = DateTime.now();
      final doses = [
        DoseEntry(
          dose: 50.0,
          startTime: now.subtract(const Duration(hours: 2)),
          remaining: 50.0,
          hoursElapsed: 2.0,
        ),
        DoseEntry(
          dose: 50.0,
          startTime: now.subtract(const Duration(hours: 4)),
          remaining: 50.0,
          hoursElapsed: 4.0,
        ),
      ];

      final curve = service.generateCombinedCurve(
        doses: doses,
        halfLife: 3.5,
        referenceTime: now,
        hoursBack: 12,
        hoursForward: 12,
        stepHours: 2.0,
      );

      // At "now", should have sum of both doses' remaining amounts
      final nowPoint = curve.firstWhere((p) => p.hours == 0);
      expect(nowPoint.remainingMg, greaterThan(50.0)); // More than one dose
      expect(
        nowPoint.remainingMg,
        lessThan(100.0),
      ); // But less than both full doses
    });

    test('future points show continued decay', () {
      final now = DateTime.now();
      final dose = DoseEntry(
        dose: 100.0,
        startTime: now,
        remaining: 100.0,
        hoursElapsed: 0.0,
      );

      final curve = service.generateDecayCurveForDose(
        dose: dose,
        halfLife: 3.5,
        referenceTime: now,
        hoursBack: 0,
        hoursForward: 24,
        stepHours: 3.5,
      );

      // Each point should be less than previous
      for (int i = 1; i < curve.length; i++) {
        expect(curve[i].remainingMg, lessThan(curve[i - 1].remainingMg));
      }
    });
  });
}

// Unit test reproduction for tolerance calculations (Correct Models)
// Run with: dart test/unit/tolerance_calc_correct_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
// Import the files actually used by the app logic
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_logic.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

void main() {
  // Mock data extracted from tolerance_neuro_buckets.json (New Format)
  const mockDbJson = r'''
{
  "mdma": {
    "neuro_buckets": {
      "stimulant": { "weight": 0.462, "tolerance_type": "stimulant" },
      "serotonin_release": { "weight": 0.867, "tolerance_type": "serotonin_release" },
      "serotonin_psychedelic": { "weight": 0.264, "tolerance_type": "serotonin_psychedelic" }
    },
    "standard_unit": { "value": 100.0, "unit": "mg" },
    "potency_multiplier": 1.0,
    "tolerance_gain_rate": 1.0,
    "active_threshold": 0.05,
    "half_life_hours": 9.0
  },
  "bupropion": {
    "neuro_buckets": {
      "stimulant": { "weight": 0.463, "tolerance_type": "stimulant" }
    },
    "standard_unit": { "value": 150.0, "unit": "mg" },
    "potency_multiplier": 0.3,
    "tolerance_gain_rate": 0.5,
    "half_life_hours": 12.0
  },
  "caffeine": {
    "neuro_buckets": {
      "stimulant": { "weight": 0.373, "tolerance_type": "stimulant" }
    },
    "standard_unit": { "value": 100.0, "unit": "mg" },
    "potency_multiplier": 0.15,
    "tolerance_gain_rate": 0.4,
    "half_life_hours": 5.0
  }
}
''';

  test('Check tolerance loads with current model implementation', () {
    final dbData = json.decode(mockDbJson) as Map<String, dynamic>;

    // Parse models - this will use ToleranceModel.fromJson from tolerance_models.dart
    final models = dbData.map(
      (k, v) => MapEntry(k, ToleranceModel.fromJson(v)),
    );

    // print('\n--- TOLERANCE MODEL DEBUG ---');
    models.forEach((slug, model) {
      // print('Model: $slug');
      // print('  Standard Unit Mg: ${model.standardUnitMg}');
      // print('  Potency Mult: ${model.potencyMultiplier}');

      // If parsing fails, standardUnitMg will likely be default 10.0
      // Bupropion standard unit is 150.0. If it prints 10.0, that confirms the bug.
    });

    // Simulate 1 standard dose (e.g. 150mg Bupropion)
    final inputs = [
      {'slug': 'mdma', 'dose': 100.0},
      {'slug': 'bupropion', 'dose': 150.0},
      {'slug': 'caffeine', 'dose': 100.0},
    ];

    for (final input in inputs) {
      final slug = input['slug'] as String;
      final dose = input['dose'] as double;

      final result = ToleranceLogic.computeTolerance(
        useLogs: [
          UseLogEntry(
            substanceSlug: slug,
            timestamp: DateTime.now(),
            doseUnits: dose,
          ),
        ],
        toleranceModels: models,
      );

      // print('\nSubstance: $slug (Dose: $dose mg)');
      // print('Percent Tolerances:');
      result.bucketPercents.forEach((bucket, pct) {
        // if (pct > 0) print('  - $bucket: ${pct.toStringAsFixed(2)}%');
      });
    }
  });
}

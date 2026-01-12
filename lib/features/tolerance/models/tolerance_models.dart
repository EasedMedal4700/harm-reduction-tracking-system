// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Migrated tolerance models to Freezed

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tolerance_models.freezed.dart';
part 'tolerance_models.g.dart';

/// Global bucket list for tolerance tracking
const List<String> kToleranceBuckets = [
  'gaba',
  'stimulant',
  'serotonin_release',
  'serotonin_psychedelic',
  'opioid',
  'nmda',
  'cannabinoid',
];

@freezed
abstract class UseLogEntry with _$UseLogEntry {
  const factory UseLogEntry({
    required String substanceSlug,
    required DateTime timestamp,
    required double doseUnits,
  }) = _UseLogEntry;

  factory UseLogEntry.fromJson(Map<String, dynamic> json) =>
      _$UseLogEntryFromJson(json);
}

@freezed
abstract class NeuroBucket with _$NeuroBucket {
  const factory NeuroBucket({
    required String name,
    required double weight,
    String? toleranceType,
  }) = _NeuroBucket;

  factory NeuroBucket.fromJson(Map<String, dynamic> json) {
    return NeuroBucket(
      name: json['name'] as String? ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      toleranceType:
          json['toleranceType'] as String? ?? json['tolerance_type'] as String?,
    );
  }
}

@freezed
abstract class ToleranceModel with _$ToleranceModel {
  const factory ToleranceModel({
    @Default('') String notes,
    required Map<String, NeuroBucket> neuroBuckets,
    @Default(6.0) double halfLifeHours,
    @Default(2.0) double toleranceDecayDays,
    @Default(10.0) double standardUnitMg,
    @Default(1.0) double potencyMultiplier,
    @Default(1.0) double durationMultiplier,
    @Default(1.0) double toleranceGainRate,
    @Default(0.05) double activeThreshold,
  }) = _ToleranceModel;

  factory ToleranceModel.fromJson(Map<String, dynamic> json) {
    final nbRaw = json['neuroBuckets'] ?? json['neuro_buckets'];
    final nbMap = <String, NeuroBucket>{};

    if (nbRaw is Map) {
      nbRaw.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          // Inject key as name if missing
          if (!v.containsKey('name')) {
            v['name'] = k.toString();
          }
          nbMap[k.toString()] = NeuroBucket.fromJson(v);
        }
      });
    }

    // Handle standard_unit extraction
    double stdUnit = 10.0;
    final suRaw =
        json['standardUnitMg'] ??
        json['standard_unit_mg'] ??
        json['standard_unit'];
    if (suRaw is num) {
      stdUnit = suRaw.toDouble();
    } else if (suRaw is Map) {
      // Handle {"value": 150.0, "unit": "mg"}
      final val = suRaw['value'];
      if (val is num) stdUnit = val.toDouble();
    }

    return ToleranceModel(
      notes: json['notes'] as String? ?? '',
      neuroBuckets: nbMap,
      halfLifeHours:
          (json['halfLifeHours'] ?? json['half_life_hours'] as num?)
              ?.toDouble() ??
          6.0,
      toleranceDecayDays:
          (json['toleranceDecayDays'] ?? json['tolerance_decay_days'] as num?)
              ?.toDouble() ??
          2.0,
      standardUnitMg: stdUnit,
      potencyMultiplier:
          (json['potencyMultiplier'] ?? json['potency_multiplier'] as num?)
              ?.toDouble() ??
          1.0,
      durationMultiplier:
          (json['durationMultiplier'] ?? json['duration_multiplier'] as num?)
              ?.toDouble() ??
          1.0,
      toleranceGainRate:
          (json['toleranceGainRate'] ?? json['tolerance_gain_rate'] as num?)
              ?.toDouble() ??
          1.0,
      activeThreshold:
          (json['activeThreshold'] ?? json['active_threshold'] as num?)
              ?.toDouble() ??
          0.05,
    );
  }
}

@freezed
abstract class ToleranceResult with _$ToleranceResult {
  const factory ToleranceResult({
    required Map<String, double> bucketPercents,
    required Map<String, double> bucketRawLoads,
    required double toleranceScore,
    required Map<String, double> daysUntilBaseline,
    required double overallDaysUntilBaseline,
    @Default({}) Map<String, Map<String, double>> substanceContributions,
    @Default({}) Map<String, Map<String, double>> logImpacts,
    @Default({}) Map<String, bool> substanceActiveStates,
    @Default({}) Map<String, List<UseLogEntry>> relevantLogs,
  }) = _ToleranceResult;

  factory ToleranceResult.fromJson(Map<String, dynamic> json) =>
      _$ToleranceResultFromJson(json);
}

enum ToleranceSystemState {
  recovered,
  lightStress,
  moderateStrain,
  highStrain,
  depleted,
}

extension ToleranceSystemStateX on ToleranceSystemState {
  String get displayName {
    switch (this) {
      case ToleranceSystemState.recovered:
        return 'Recovered';
      case ToleranceSystemState.lightStress:
        return 'Light Stress';
      case ToleranceSystemState.moderateStrain:
        return 'Moderate Strain';
      case ToleranceSystemState.highStrain:
        return 'High Strain';
      case ToleranceSystemState.depleted:
        return 'Depleted';
    }
  }
}

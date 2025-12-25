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
class UseLogEntry with _$UseLogEntry {
  const factory UseLogEntry({
    required String substanceSlug,
    required DateTime timestamp,
    required double doseUnits,
  }) = _UseLogEntry;

  factory UseLogEntry.fromJson(Map<String, dynamic> json) =>
      _$UseLogEntryFromJson(json);
}

@freezed
class NeuroBucket with _$NeuroBucket {
  const factory NeuroBucket({
    required String name,
    required double weight,
    String? toleranceType,
  }) = _NeuroBucket;

  factory NeuroBucket.fromJson(Map<String, dynamic> json) =>
      _$NeuroBucketFromJson(json);
}

@freezed
class ToleranceModel with _$ToleranceModel {
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

  factory ToleranceModel.fromJson(Map<String, dynamic> json) =>
      _$ToleranceModelFromJson(json);
}

@freezed
class ToleranceResult with _$ToleranceResult {
  const factory ToleranceResult({
    required Map<String, double> bucketPercents,
    required Map<String, double> bucketRawLoads,
    required double toleranceScore,
    required Map<String, double> daysUntilBaseline,
    required double overallDaysUntilBaseline,
    @Default({}) Map<String, Map<String, double>> substanceContributions,
    @Default({}) Map<String, bool> substanceActiveStates,
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

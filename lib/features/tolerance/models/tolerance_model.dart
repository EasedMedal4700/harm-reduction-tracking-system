// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tolerance_model.freezed.dart';

DateTime _dateTimeFromAny(Object? v) {
  if (v is DateTime) return v;
  if (v is String && v.isNotEmpty) {
    return DateTime.tryParse(v) ?? DateTime.now();
  }
  return DateTime.now();
}

Map<String, NeuroBucket> _neuroBucketsFromJson(Object? v) {
  final bucketsJson = (v as Map?)?.cast<String, dynamic>() ?? const {};
  final buckets = <String, NeuroBucket>{};
  bucketsJson.forEach((key, value) {
    final inner = (value as Map?)?.cast<String, dynamic>() ?? const {};
    buckets[key] = NeuroBucket(
      name: key,
      weight: (inner['weight'] as num?)?.toDouble() ?? 1.0,
      toleranceType: inner['tolerance_type'] as String?,
    );
  });
  return buckets;
}

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

  const UseLogEntry._();

  factory UseLogEntry.fromJson(Map<String, dynamic> json) {
    return UseLogEntry(
      substanceSlug:
          json['substanceSlug']?.toString() ??
          json['substance_slug']?.toString() ??
          '',
      timestamp: _dateTimeFromAny(json['timestamp']),
      doseUnits:
          (json['doseUnits'] as num?)?.toDouble() ??
          (json['dose_units'] as num?)?.toDouble() ??
          0.0,
    );
  }
}

/// Model for tolerance calculation data from Supabase
@freezed
abstract class ToleranceModel with _$ToleranceModel {
  const factory ToleranceModel({
    @Default('') String notes,

    /// Neurotransmitter → bucket data (weight + type)
    @Default({}) Map<String, NeuroBucket> neuroBuckets,

    /// Pharmacokinetic parameters
    @Default(6.0) double halfLifeHours,
    @Default(2.0) double toleranceDecayDays,

    /// Potency normalization
    @Default(10.0) double standardUnitMg,
    @Default(1.0) double potencyMultiplier,
    @Default(1.0) double durationMultiplier,

    /// Tolerance dynamics
    @Default(1.0) double toleranceGainRate,
    @Default(0.05) double activeThreshold,
  }) = _ToleranceModel;

  const ToleranceModel._();

  factory ToleranceModel.fromJson(Map<String, dynamic> json) {
    final neuroBucketsRaw = json['neuro_buckets'] ?? json['neuroBuckets'];

    return ToleranceModel(
      notes: json['notes']?.toString() ?? '',
      neuroBuckets: _neuroBucketsFromJson(neuroBucketsRaw),
      halfLifeHours:
          (json['half_life_hours'] as num?)?.toDouble() ??
          (json['halfLifeHours'] as num?)?.toDouble() ??
          6.0,
      toleranceDecayDays:
          (json['tolerance_decay_days'] as num?)?.toDouble() ??
          (json['toleranceDecayDays'] as num?)?.toDouble() ??
          2.0,
      standardUnitMg:
          (json['standard_unit_mg'] as num?)?.toDouble() ??
          (json['standardUnitMg'] as num?)?.toDouble() ??
          10.0,
      potencyMultiplier:
          (json['potency_multiplier'] as num?)?.toDouble() ??
          (json['potencyMultiplier'] as num?)?.toDouble() ??
          1.0,
      durationMultiplier:
          (json['duration_multiplier'] as num?)?.toDouble() ??
          (json['durationMultiplier'] as num?)?.toDouble() ??
          1.0,
      toleranceGainRate:
          (json['tolerance_gain_rate'] as num?)?.toDouble() ??
          (json['toleranceGainRate'] as num?)?.toDouble() ??
          1.0,
      activeThreshold:
          (json['active_threshold'] as num?)?.toDouble() ??
          (json['activeThreshold'] as num?)?.toDouble() ??
          0.05,
    );
  }
}

/// Neurotransmitter tolerance bucket
@freezed
abstract class NeuroBucket with _$NeuroBucket {
  const factory NeuroBucket({
    required String name,
    @Default(1.0) double weight,
    String? toleranceType,
  }) = _NeuroBucket;

  const NeuroBucket._();

  Map<String, dynamic> toServiceJson() {
    return {
      'weight': weight,
      if (toleranceType != null) 'tolerance_type': toleranceType,
    };
  }

  String get displayName => name.toUpperCase();

  String get description => 'Neurotransmitter system';
}

/// Event data used by tolerance calculation
@freezed
abstract class UseEvent with _$UseEvent {
  const factory UseEvent({
    required DateTime timestamp,
    required double dose,
    required String substanceName,
  }) = _UseEvent;

  const UseEvent._();

  factory UseEvent.fromJson(Map<String, dynamic> json) {
    return UseEvent(
      timestamp: _dateTimeFromAny(json['timestamp']),
      dose: (json['dose'] as num?)?.toDouble() ?? 0.0,
      substanceName:
          json['substanceName']?.toString() ??
          json['substance_name']?.toString() ??
          '',
    );
  }
}

/// System state classification
enum ToleranceSystemState {
  recovered,
  lightStress,
  moderateStrain,
  highStrain,
  depleted,
}

extension ToleranceSystemStateExtension on ToleranceSystemState {
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

/// Data point for graphs
@freezed
abstract class TolerancePoint with _$TolerancePoint {
  const factory TolerancePoint({
    required DateTime time,
    required double score,
  }) = _TolerancePoint;

  const TolerancePoint._();

  factory TolerancePoint.fromJson(Map<String, dynamic> json) {
    return TolerancePoint(
      time: _dateTimeFromAny(json['time']),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

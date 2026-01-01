// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tolerance_bucket.freezed.dart';

Map<String, ToleranceBucket> _toleranceBucketsFromJson(Object? v) {
  final neuroBucketsJson = (v as Map?)?.cast<String, dynamic>() ?? const {};
  final neuroBuckets = <String, ToleranceBucket>{};
  neuroBucketsJson.forEach((key, value) {
    if (value is Map) {
      neuroBuckets[key] = ToleranceBucket.fromServiceJson(
        key,
        value.cast<String, dynamic>(),
      );
    }
  });
  return neuroBuckets;
}

Map<String, dynamic> _toleranceBucketsToJson(Map<String, ToleranceBucket> v) {
  return v.map((key, bucket) => MapEntry(key, bucket.toServiceJson()));
}

/// Represents a neurochemical bucket for tolerance calculation.
///
/// WARNING: These tolerance calculations are NOT medically validated.
/// The values shown are approximations only and cannot predict safety,
/// overdose risk, or health outcomes. Tolerance does NOT equal safety.
/// Use at your own risk.
@freezed
abstract class ToleranceBucket with _$ToleranceBucket {
  const factory ToleranceBucket({
    required String type,
    @Default(1.0) double weight,
    @Default('stimulant') String toleranceType,
    @Default(1.0) double potencyMultiplier,
    @Default(1.0) double durationMultiplier,
  }) = _ToleranceBucket;

  const ToleranceBucket._();

  factory ToleranceBucket.fromJson(Map<String, dynamic> json) {
    return ToleranceBucket(
      type: json['type']?.toString() ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      toleranceType:
          json['tolerance_type']?.toString() ??
          json['toleranceType']?.toString() ??
          'stimulant',
      potencyMultiplier:
          (json['potency_multiplier'] as num?)?.toDouble() ??
          (json['potencyMultiplier'] as num?)?.toDouble() ??
          1.0,
      durationMultiplier:
          (json['duration_multiplier'] as num?)?.toDouble() ??
          (json['durationMultiplier'] as num?)?.toDouble() ??
          1.0,
    );
  }

  factory ToleranceBucket.fromServiceJson(
    String type,
    Map<String, dynamic> json,
  ) {
    return ToleranceBucket.fromJson({...json, 'type': type});
  }

  Map<String, dynamic> toServiceJson() {
    return {
      'weight': weight,
      'tolerance_type': toleranceType,
      'potency_multiplier': potencyMultiplier,
      'duration_multiplier': durationMultiplier,
    };
  }
}

/// Extended tolerance model with bucket support.
///
/// DISCLAIMER: These tolerance estimates are approximations based on
/// general pharmacological principles. They are NOT medically accurate
/// and must not be used to determine safe doses. Real-world risks vary
/// widely. Use at your own risk.
@freezed
abstract class BucketToleranceModel with _$BucketToleranceModel {
  const factory BucketToleranceModel({
    required String substanceName,
    @Default(24.0) double halfLifeHours,
    @Default(0.05) double activeThreshold,
    @Default(1.0) double toleranceGainRate,
    @Default(7.0) double toleranceDecayDays,
    @Default({}) Map<String, ToleranceBucket> neuroBuckets,
    String? notes,
  }) = _BucketToleranceModel;

  const BucketToleranceModel._();

  factory BucketToleranceModel.fromJson(Map<String, dynamic> json) {
    final neuroBucketsRaw = json['neuro_buckets'] ?? json['neuroBuckets'];

    return BucketToleranceModel(
      substanceName:
          json['substanceName']?.toString() ??
          json['substance_name']?.toString() ??
          '',
      halfLifeHours:
          (json['half_life_hours'] as num?)?.toDouble() ??
          (json['halfLifeHours'] as num?)?.toDouble() ??
          24.0,
      activeThreshold:
          (json['active_threshold'] as num?)?.toDouble() ??
          (json['activeThreshold'] as num?)?.toDouble() ??
          0.05,
      toleranceGainRate:
          (json['tolerance_gain_rate'] as num?)?.toDouble() ??
          (json['toleranceGainRate'] as num?)?.toDouble() ??
          1.0,
      toleranceDecayDays:
          (json['tolerance_decay_days'] as num?)?.toDouble() ??
          (json['toleranceDecayDays'] as num?)?.toDouble() ??
          7.0,
      neuroBuckets: _toleranceBucketsFromJson(neuroBucketsRaw),
      notes: json['notes']?.toString(),
    );
  }

  factory BucketToleranceModel.fromServiceJson(
    String substanceName,
    Map<String, dynamic> json,
  ) {
    return BucketToleranceModel.fromJson({
      ...json,
      'substanceName': substanceName,
    });
  }

  Map<String, dynamic> toServiceJson() {
    return {
      'half_life_hours': halfLifeHours,
      'active_threshold': activeThreshold,
      'tolerance_gain_rate': toleranceGainRate,
      'tolerance_decay_days': toleranceDecayDays,
      'neuro_buckets': _toleranceBucketsToJson(neuroBuckets),
      if (notes != null) 'notes': notes,
    };
  }
}

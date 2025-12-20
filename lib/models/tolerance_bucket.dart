/// Represents a neurochemical bucket for tolerance calculation.
///
/// WARNING: These tolerance calculations are NOT medically validated.
/// The values shown are approximations only and cannot predict safety,
/// overdose risk, or health outcomes. Tolerance does NOT equal safety.
/// Use at your own risk.
class ToleranceBucket {
  final String type;
  final double weight;
  final String toleranceType;
  final double potencyMultiplier;
  final double durationMultiplier;

  const ToleranceBucket({
    required this.type,
    required this.weight,
    required this.toleranceType,
    this.potencyMultiplier = 1.0,
    this.durationMultiplier = 1.0,
  });

  factory ToleranceBucket.fromJson(String type, Map<String, dynamic> json) {
    return ToleranceBucket(
      type: type,
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      toleranceType: json['tolerance_type'] as String? ?? 'stimulant',
      potencyMultiplier:
          (json['potency_multiplier'] as num?)?.toDouble() ?? 1.0,
      durationMultiplier:
          (json['duration_multiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'tolerance_type': toleranceType,
      'potency_multiplier': potencyMultiplier,
      'duration_multiplier': durationMultiplier,
    };
  }

  @override
  String toString() {
    return 'ToleranceBucket(type: $type, weight: $weight, toleranceType: $toleranceType)';
  }
}

/// Extended tolerance model with bucket support.
///
/// DISCLAIMER: These tolerance estimates are approximations based on
/// general pharmacological principles. They are NOT medically accurate
/// and must not be used to determine safe doses. Real-world risks vary
/// widely. Use at your own risk.
class BucketToleranceModel {
  final String substanceName;
  final double halfLifeHours;
  final double activeThreshold;
  final double toleranceGainRate;
  final double toleranceDecayDays;
  final Map<String, ToleranceBucket> neuroBuckets;
  final String? notes;

  const BucketToleranceModel({
    required this.substanceName,
    required this.halfLifeHours,
    this.activeThreshold = 0.05,
    this.toleranceGainRate = 1.0,
    required this.toleranceDecayDays,
    required this.neuroBuckets,
    this.notes,
  });

  factory BucketToleranceModel.fromJson(
    String substanceName,
    Map<String, dynamic> json,
  ) {
    final neuroBucketsJson =
        json['neuro_buckets'] as Map<String, dynamic>? ?? {};
    final neuroBuckets = <String, ToleranceBucket>{};

    neuroBucketsJson.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        neuroBuckets[key] = ToleranceBucket.fromJson(key, value);
      }
    });

    return BucketToleranceModel(
      substanceName: substanceName,
      halfLifeHours: (json['half_life_hours'] as num?)?.toDouble() ?? 24.0,
      activeThreshold: (json['active_threshold'] as num?)?.toDouble() ?? 0.05,
      toleranceGainRate:
          (json['tolerance_gain_rate'] as num?)?.toDouble() ?? 1.0,
      toleranceDecayDays:
          (json['tolerance_decay_days'] as num?)?.toDouble() ?? 7.0,
      neuroBuckets: neuroBuckets,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final neuroBucketsJson = <String, dynamic>{};
    neuroBuckets.forEach((key, bucket) {
      neuroBucketsJson[key] = bucket.toJson();
    });

    return {
      'half_life_hours': halfLifeHours,
      'active_threshold': activeThreshold,
      'tolerance_gain_rate': toleranceGainRate,
      'tolerance_decay_days': toleranceDecayDays,
      'neuro_buckets': neuroBucketsJson,
      if (notes != null) 'notes': notes,
    };
  }
}

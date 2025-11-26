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

class UseLogEntry {
  final String substanceSlug;
  final DateTime timestamp;
  final double doseUnits;

  const UseLogEntry({
    required this.substanceSlug,
    required this.timestamp,
    required this.doseUnits,
  });
}

/// Model for tolerance calculation data from Supabase
class ToleranceModel {
  final String notes;

  /// Neurotransmitter → bucket data (weight + type)
  final Map<String, NeuroBucket> neuroBuckets;

  /// Pharmacokinetic parameters
  final double halfLifeHours;
  final double toleranceDecayDays;

  /// Potency normalization
  final double standardUnitMg;        // e.g. 10mg Dex, 20mg MPH, 300mg Bupropion
  final double potencyMultiplier;     // e.g. 1.0 Dex, 0.4 MPH, 0.02 Bupropion
  final double durationMultiplier;    // affects how long tolerance grows

  /// Tolerance dynamics
  final double toleranceGainRate;     // how strongly each use builds tolerance
  final double activeThreshold;       // minimum active level before decay stops

  const ToleranceModel({
    required this.notes,
    required this.neuroBuckets,
    required this.halfLifeHours,
    required this.toleranceDecayDays,
    required this.standardUnitMg,
    required this.potencyMultiplier,
    required this.durationMultiplier,
    required this.toleranceGainRate,
    required this.activeThreshold,
  });

  factory ToleranceModel.fromJson(Map<String, dynamic> json) {
    // Parse neuro_buckets
    final bucketsJson = json['neuro_buckets'] as Map<String, dynamic>? ?? {};
    final buckets = <String, NeuroBucket>{};

    bucketsJson.forEach((key, value) {
      buckets[key] = NeuroBucket.fromJson(key, value as Map<String, dynamic>);
    });

    return ToleranceModel(
      notes: json['notes'] as String? ?? '',
      neuroBuckets: buckets,
      halfLifeHours: (json['half_life_hours'] as num?)?.toDouble() ?? 6.0,
      toleranceDecayDays: (json['tolerance_decay_days'] as num?)?.toDouble() ?? 2.0,

      // 🟢 NEW FIELDS (previously ignored)
      standardUnitMg: (json['standard_unit_mg'] as num?)?.toDouble() ?? 10.0,
      potencyMultiplier: (json['potency_multiplier'] as num?)?.toDouble() ?? 1.0,
      durationMultiplier: (json['duration_multiplier'] as num?)?.toDouble() ?? 1.0,
      toleranceGainRate: (json['tolerance_gain_rate'] as num?)?.toDouble() ?? 1.0,
      activeThreshold: (json['active_threshold'] as num?)?.toDouble() ?? 0.05,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'neuro_buckets': neuroBuckets.map((key, value) => MapEntry(key, value.toJson())),
      'half_life_hours': halfLifeHours,
      'tolerance_decay_days': toleranceDecayDays,

      // 🟢 NEW FIELDS
      'standard_unit_mg': standardUnitMg,
      'potency_multiplier': potencyMultiplier,
      'duration_multiplier': durationMultiplier,
      'tolerance_gain_rate': toleranceGainRate,
      'active_threshold': activeThreshold,
    };
  }
}

/// Neurotransmitter tolerance bucket
class NeuroBucket {
  final String name;
  final double weight;       // How strongly this substance affects the bucket
  final String? toleranceType; // Optional: "stimulant", "gaba", etc.

  const NeuroBucket({
    required this.name,
    required this.weight,
    this.toleranceType,
  });

  factory NeuroBucket.fromJson(String name, Map<String, dynamic> json) {
    return NeuroBucket(
      name: name,
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      toleranceType: json['tolerance_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      if (toleranceType != null) 'tolerance_type': toleranceType,
    };
  }

  String get displayName => name.toUpperCase();
  String get description => 'Neurotransmitter system';
}

/// Event data used by tolerance calculation
class UseEvent {
  final DateTime timestamp;
  final double dose;
  final String substanceName;

  const UseEvent({
    required this.timestamp,
    required this.dose,
    required this.substanceName,
  });
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
      case ToleranceSystemState.recovered: return 'Recovered';
      case ToleranceSystemState.lightStress: return 'Light Stress';
      case ToleranceSystemState.moderateStrain: return 'Moderate Strain';
      case ToleranceSystemState.highStrain: return 'High Strain';
      case ToleranceSystemState.depleted: return 'Depleted';
    }
  }
}

/// Data point for graphs
class TolerancePoint {
  final DateTime time;
  final double score;

  const TolerancePoint({
    required this.time,
    required this.score,
  });
}

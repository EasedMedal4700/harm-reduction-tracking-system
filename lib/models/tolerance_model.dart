/// Global bucket list for tolerance tracking
const List<String> kToleranceBuckets = [
  'gaba',
  'stimulant',
  'serotonin',
  'opioid',
  'nmda',
  'cannabinoid',
];

/// Model for tolerance calculation data from Supabase
class ToleranceModel {
  final String notes;
  final Map<String, NeuroBucket> neuroBuckets;
  final double halfLifeHours;
  final double toleranceDecayDays;

  const ToleranceModel({
    required this.notes,
    required this.neuroBuckets,
    required this.halfLifeHours,
    required this.toleranceDecayDays,
  });

  factory ToleranceModel.fromJson(Map<String, dynamic> json) {
    final bucketsJson = json['neuro_buckets'] as Map<String, dynamic>;
    final buckets = <String, NeuroBucket>{};
    
    bucketsJson.forEach((key, value) {
      buckets[key] = NeuroBucket.fromJson(key, value as Map<String, dynamic>);
    });

    return ToleranceModel(
      notes: json['notes'] as String? ?? '',
      neuroBuckets: buckets,
      halfLifeHours: (json['half_life_hours'] as num).toDouble(),
      toleranceDecayDays: (json['tolerance_decay_days'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'neuro_buckets': neuroBuckets.map((key, value) => MapEntry(key, value.toJson())),
      'half_life_hours': halfLifeHours,
      'tolerance_decay_days': toleranceDecayDays,
    };
  }
}

/// Neurotransmitter bucket with weight
class NeuroBucket {
  final String name;
  final double weight;

  const NeuroBucket({
    required this.name,
    required this.weight,
  });

  factory NeuroBucket.fromJson(String name, Map<String, dynamic> json) {
    return NeuroBucket(
      name: name,
      weight: (json['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
    };
  }

  /// Get display name for the bucket
  String get displayName {
    switch (name.toLowerCase()) {
      case 'gaba':
        return 'GABA-A';
      case 'nmda':
        return 'NMDA';
      case 'serotonin':
        return 'Serotonin';
      case 'dopamine':
        return 'Dopamine';
      case 'opioid':
        return 'Opioid';
      default:
        return name.toUpperCase();
    }
  }

  /// Get description for the bucket
  String get description {
    switch (name.toLowerCase()) {
      case 'gaba':
        return 'Inhibitory neurotransmitter';
      case 'nmda':
        return 'Excitatory glutamate receptor';
      case 'serotonin':
        return 'Mood & sleep regulation';
      case 'dopamine':
        return 'Reward & motivation';
      case 'opioid':
        return 'Pain & pleasure pathways';
      default:
        return 'Neurotransmitter system';
    }
  }
}

/// Use event for tolerance calculation
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

/// Use log entry from database
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

/// System state classification
enum ToleranceSystemState {
  recovered,    // 0-20%
  lightStress,  // 20-40%
  moderateStrain, // 40-60%
  highStrain,   // 60-80%
  depleted,     // 80-100%
}

/// Extension for system state display
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

/// Data point for tolerance graphs
class TolerancePoint {
  final DateTime time;
  final double score;

  const TolerancePoint({
    required this.time,
    required this.score,
  });
}

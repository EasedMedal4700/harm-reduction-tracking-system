import 'dart:math';

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
      notes: json['notes'] as String,
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

/// Tolerance calculation utilities
class ToleranceCalculator {
  /// Calculate effective plasma level at a given time
  /// Uses exponential decay: C(t) = C0 * e^(-kt)
  /// where k = ln(2) / half_life
  static double effectivePlasmaLevel({
    required DateTime useTime,
    required DateTime currentTime,
    required double halfLifeHours,
    required double initialDose,
  }) {
    final hoursSinceUse = currentTime.difference(useTime).inMinutes / 60.0;
    
    if (hoursSinceUse < 0) return 0.0;
    if (halfLifeHours <= 0) return 0.0;
    
    final decayConstant = log(2) / halfLifeHours;
    final plasmaLevel = initialDose * exp(-decayConstant * hoursSinceUse);
    
    return plasmaLevel;
  }

  /// Calculate tolerance score (0-100) based on cumulative use events
  /// Higher overlap of plasma levels = higher tolerance
  static double toleranceScore({
    required List<UseEvent> useEvents,
    required double halfLifeHours,
    required DateTime currentTime,
  }) {
    if (useEvents.isEmpty) return 0.0;
    
    double cumulativePlasma = 0.0;
    
    for (final event in useEvents) {
      final plasma = effectivePlasmaLevel(
        useTime: event.timestamp,
        currentTime: currentTime,
        halfLifeHours: halfLifeHours,
        initialDose: event.dose,
      );
      cumulativePlasma += plasma;
    }
    
    // Normalize to 0-100 scale with logarithmic scaling
    // This prevents extreme values while maintaining sensitivity
    final normalizedScore = (log(cumulativePlasma + 1) / log(100)) * 100;
    
    return normalizedScore.clamp(0.0, 100.0);
  }

  /// Calculate tolerance decay (0-1) based on days since last use
  /// Returns multiplier: 1.0 = full tolerance, 0.0 = baseline
  static double decayFunction({
    required double daysSinceLastUse,
    required double toleranceDecayDays,
  }) {
    if (daysSinceLastUse <= 0) return 1.0;
    if (toleranceDecayDays <= 0) return 0.0;
    
    // Exponential decay: e^(-t/τ) where τ is decay time constant
    final decayRate = 1.0 / toleranceDecayDays;
    final decayMultiplier = exp(-decayRate * daysSinceLastUse);
    
    return decayMultiplier.clamp(0.0, 1.0);
  }

  /// Calculate neuro bucket contribution to overall tolerance
  static double neuroBucketContribution({
    required double bucketWeight,
    required double toleranceScore,
  }) {
    return (bucketWeight * toleranceScore).clamp(0.0, 100.0);
  }

  /// Calculate days until baseline (tolerance < 5%)
  static double daysUntilBaseline({
    required double currentTolerance,
    required double toleranceDecayDays,
  }) {
    if (currentTolerance <= 5.0) return 0.0;
    
    // Solve: current * e^(-t/τ) = 5
    // t = -τ * ln(5/current)
    final timeToBaseline = -toleranceDecayDays * log(5.0 / currentTolerance);
    
    return timeToBaseline.clamp(0.0, 365.0); // Cap at 1 year
  }

  /// Generate tolerance curve data points for graphing
  static List<TolerancePoint> generateToleranceCurve({
    required List<UseEvent> useEvents,
    required double halfLifeHours,
    required double toleranceDecayDays,
    required DateTime startTime,
    required DateTime endTime,
    int dataPoints = 50,
  }) {
    if (useEvents.isEmpty) return [];
    
    final points = <TolerancePoint>[];
    final duration = endTime.difference(startTime);
    final interval = duration ~/ dataPoints;
    
    for (int i = 0; i <= dataPoints; i++) {
      final time = startTime.add(interval * i);
      final score = toleranceScore(
        useEvents: useEvents,
        halfLifeHours: halfLifeHours,
        currentTime: time,
      );
      
      // Apply decay if past last use
      final lastUse = useEvents.map((e) => e.timestamp).reduce((a, b) => a.isAfter(b) ? a : b);
      final daysSinceLast = time.difference(lastUse).inHours / 24.0;
      final decayedScore = score * decayFunction(
        daysSinceLastUse: daysSinceLast,
        toleranceDecayDays: toleranceDecayDays,
      );
      
      points.add(TolerancePoint(time: time, score: decayedScore));
    }
    
    return points;
  }

  /// Generate decay projection curve from current time
  static List<TolerancePoint> generateDecayProjection({
    required double currentTolerance,
    required double toleranceDecayDays,
    required DateTime startTime,
    int durationDays = 14,
    int dataPoints = 50,
  }) {
    final points = <TolerancePoint>[];
    final hoursPerPoint = (durationDays * 24) / dataPoints;
    
    for (int i = 0; i <= dataPoints; i++) {
      final time = startTime.add(Duration(hours: (hoursPerPoint * i).round()));
      final daysSinceStart = i * hoursPerPoint / 24.0;
      
      final score = currentTolerance * decayFunction(
        daysSinceLastUse: daysSinceStart,
        toleranceDecayDays: toleranceDecayDays,
      );
      
      points.add(TolerancePoint(time: time, score: score));
    }
    
    return points;
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

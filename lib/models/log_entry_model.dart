class LogEntry {
  final String substance;
  final double dosage;
  final String unit;
  final String route;
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final DateTime datetime;
  final String location;
  final String notes;
  final double timezoneOffset;
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String intention;
  final List<String> triggers; // Add this
  final List<String> bodySignals; // Add this

  LogEntry({
    required this.substance,
    required this.dosage,
    required this.unit,
    required this.route,
    required this.feelings,
    required this.secondaryFeelings,
    required this.datetime,
    required this.location,
    required this.notes,
    required this.timezoneOffset,
    required this.isMedicalPurpose,
    required this.cravingIntensity,
    required this.intention,
    required this.triggers,
    required this.bodySignals,
  });

  // Convert to JSON (for saving to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'substance': substance,
      'dosage': dosage,
      'unit': unit,
      'route': route,
      'feelings': feelings,
      'secondaryFeelings': secondaryFeelings,
      'datetime': datetime.toIso8601String(),
      'location': location,
      'notes': notes,
      'timezoneOffset': timezoneOffset,
      'isMedicalPurpose': isMedicalPurpose,
      'cravingIntensity': cravingIntensity,
      'intention': intention,
      'triggers': triggers,
      'bodySignals': bodySignals,
    };
  }

  // Create from JSON (for loading from Supabase)
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    // Helper to parse dose string like '10 mg' into number and unit
    final doseString = json['dose'] as String?;
    final doseParts = doseString?.split(' ') ?? ['', ''];
    final parsedDose = double.tryParse(doseParts[0]) ?? 0.0;
    final parsedUnit = doseParts.length > 1 ? doseParts[1] : '';

    return LogEntry(
      substance: json['name'] as String? ?? '',
      dosage: parsedDose,
      unit: parsedUnit,
      route: json['consumption'] as String? ?? '',
      feelings: (json['primary_emotions'] as String?)?.isEmpty ?? true
          ? []
          : (json['primary_emotions'] as String).split(','),
      secondaryFeelings: json['secondary_emotions'] is Map<String, dynamic>
          ? Map<String, List<String>>.from(json['secondary_emotions'])
          : {},
      datetime: DateTime.parse(json['start_time'] as String? ?? DateTime.now().toIso8601String()),
      location: json['place'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      timezoneOffset: (json['timezone'] as num?)?.toDouble() ?? 0.0,
      isMedicalPurpose: json['medical'] as bool? ?? false,
      cravingIntensity: (json['craving_0_10'] as num?)?.toDouble() ?? 0.0,
      intention: json['intention'] as String? ?? '',
      triggers: (json['triggers'] as String?)?.isEmpty ?? true
          ? []
          : (json['triggers'] as String).split(','),
      bodySignals: (json['body_signals'] as String?)?.isEmpty ?? true
          ? []
          : (json['body_signals'] as String).split(','),
    );
  }
}
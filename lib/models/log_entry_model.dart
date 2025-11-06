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
  final List<String> bodySignals;
  final List<String> people; // Add this

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
    required this.people,
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
      'people': people,
    };
  }

  // Create from JSON (for loading from Supabase)
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    // Helper to parse list or fallback to splitting string
    List<String> parseList(dynamic value, {String separator = ';'}) {
      if (value is List) {
        return value.map((e) => e.toString()).toList(); // Already a list
      } else if (value is String && value.isNotEmpty) {
        return value.split(separator).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    // Safely parse dose and unit
    String doseStr = json['dose']?.toString() ?? '';
    List<String> doseParts = doseStr.split(' ');
    double dosage = double.tryParse(doseParts[0]) ?? 0.0;
    String unit = doseParts.length > 1 ? doseParts[1] : '';

    return LogEntry(
      substance: json['name'] ?? '',
      dosage: dosage,
      unit: unit,
      route: json['consumption'] ?? '',
      feelings: parseList(json['primary_emotions'], separator: ';'),
      secondaryFeelings: {}, // Add parsing if needed: parseList(json['secondary_emotions'], separator: ';')
      datetime: DateTime.parse(json['start_time'] ?? DateTime.now().toIso8601String()),
      location: json['place'] ?? '',
      notes: json['notes'] ?? '',
      timezoneOffset: double.tryParse(json['timezone']?.toString() ?? '0') ?? 0.0,
      isMedicalPurpose: json['medical'] == 'true' || json['medical'] == true,
      cravingIntensity: double.tryParse(json['craving_0_10']?.toString() ?? '0') ?? 0.0,
      intention: json['intention'] ?? '',
      triggers: parseList(json['triggers'], separator: ';'),
      bodySignals: parseList(json['body_signals'], separator: ';'),
      people: parseList(json['people'], separator: ' '),
    );
  }
}
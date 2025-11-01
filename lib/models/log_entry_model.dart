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
  });

  // Convert to JSON (for saving to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'substance': substance,
      'dosage': dosage,
      'unit': unit,
      'route': route,
      'feeling': feelings,
      'secondaryFeeling': secondaryFeelings,
      'datetime': datetime.toIso8601String(),
      'location': location,
      'notes': notes,
    };
  }

  // Create from JSON (for loading from Supabase)
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      substance: json['substance'],
      dosage: json['dosage'],
      unit: json['unit'],
      route: json['route'],
      feelings: List<String>.from(json['feelings'] ?? []),
      secondaryFeelings: Map<String, List<String>>.from(json['secondaryFeelings'] ?? {}),
      datetime: DateTime.parse(json['datetime']),
      location: json['location'],
      notes: json['notes'],
    );
  }
}
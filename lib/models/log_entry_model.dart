class LogEntry {
  final String substance;
  final double dosage;
  final String unit;
  final String route;
  final String feeling;
  final DateTime datetime;
  final String location;
  final String notes;

  LogEntry({
    required this.substance,
    required this.dosage,
    required this.unit,
    required this.route,
    required this.feeling,
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
      'feeling': feeling,
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
      feeling: json['feeling'],
      datetime: DateTime.parse(json['datetime']),
      location: json['location'],
      notes: json['notes'],
    );
  }
}
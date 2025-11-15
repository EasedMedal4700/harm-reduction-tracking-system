import 'serialization/log_entry_serializer.dart';

/// Represents a drug use log entry
class LogEntry {
  final String? id; // use_id or id
  final String substance;
  final double dosage;
  final String unit;
  final String route;
  final DateTime datetime;
  final String? notes;
  final int timeDifferenceMinutes;
  final String? timezone; // raw tz value if present
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final List<String> triggers;
  final List<String> bodySignals;
  final String location;
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final double timezoneOffset; // parsed offset (e.g., hours)
  final List<String> people;

  LogEntry({
    this.id,
    required this.substance,
    required this.dosage,
    required this.unit,
    required this.route,
    required this.datetime,
    this.notes,
    this.timeDifferenceMinutes = 0,
    this.timezone,
    this.feelings = const [],
    this.secondaryFeelings = const {},
    this.triggers = const [],
    this.bodySignals = const [],
    this.location = '',
    this.isMedicalPurpose = false,
    this.cravingIntensity = 0.0,
    this.intention,
    this.timezoneOffset = 0.0,
    this.people = const [],
  });

  /// Creates a LogEntry from JSON data
  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      LogEntrySerializer.fromJson(json);

  /// Converts this LogEntry to JSON data
  Map<String, dynamic> toJson() => LogEntrySerializer.toJson(this);
}
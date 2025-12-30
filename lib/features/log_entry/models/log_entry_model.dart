// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'serialization/log_entry_serializer.dart';

part 'log_entry_model.freezed.dart';
part 'log_entry_model.g.dart';

/// Represents a drug use log entry
@freezed
abstract class LogEntry with _$LogEntry {
  const LogEntry._();

  const factory LogEntry({
    String? id, // use_id or id
    required String substance,
    required double dosage,
    required String unit,
    required String route,
    required DateTime datetime,
    String? notes,
    @Default(0) int timeDifferenceMinutes,
    String? timezone, // raw tz value if present
    @Default([]) List<String> feelings,
    @Default({}) Map<String, List<String>> secondaryFeelings,
    @Default([]) List<String> triggers,
    @Default([]) List<String> bodySignals,
    @Default('') String location,
    @Default(false) bool isMedicalPurpose,
    @Default(0.0) double cravingIntensity,
    String? intention,
    @Default(0.0) double timezoneOffset, // parsed offset (e.g., hours)
    @Default([]) List<String> people,
  }) = _LogEntry;

  /// Creates a LogEntry from JSON data
  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      LogEntrySerializer.fromJson(json);

  /// Converts this LogEntry to JSON data
  @override
  Map<String, dynamic> toJson() => LogEntrySerializer.toJson(this);
}

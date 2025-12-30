// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry_form_data.freezed.dart';

/// Pure data class representing log entry form state
/// This is Riverpod-ready - contains only serializable values
/// No UI controllers, no BuildContext, no ChangeNotifier
@freezed
abstract class LogEntryFormData with _$LogEntryFormData {
  const LogEntryFormData._();

  const factory LogEntryFormData({
    @Default(true) bool isSimpleMode,
    @Default(0) double dose,
    @Default('mg') String unit,
    @Default('') String substance,
    @Default('oral') String route,
    @Default([]) List<String> feelings,
    @Default({}) Map<String, List<String>> secondaryFeelings,
    @Default('') String location,
    required DateTime date,
    required int hour,
    required int minute,
    @Default('') String notes,
    @Default(false) bool isMedicalPurpose,
    @Default(0) double cravingIntensity,
    String? intention,
    @Default([]) List<String> triggers,
    @Default([]) List<String> bodySignals,
    @Default('') String entryId,
    // Substance details for ROA validation (loaded from DB)
    Map<String, dynamic>? substanceDetails,
  }) = _LogEntryFormData;

  DateTime get selectedDateTime =>
      DateTime(date.year, date.month, date.day, hour, minute);

  /// Create initial state with current time
  factory LogEntryFormData.initial() {
    final now = DateTime.now();
    return LogEntryFormData(date: now, hour: now.hour, minute: now.minute);
  }

  /// Create empty state for reset
  factory LogEntryFormData.empty() {
    final now = DateTime.now();
    return LogEntryFormData(
      date: now,
      hour: now.hour,
      minute: now.minute,
      intention: '-- Select Intention--',
    );
  }
}

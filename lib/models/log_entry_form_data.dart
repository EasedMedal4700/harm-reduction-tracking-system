/// Pure data class representing log entry form state
/// This is Riverpod-ready - contains only serializable values
/// No UI controllers, no BuildContext, no ChangeNotifier
class LogEntryFormData {
  final bool isSimpleMode;
  final double dose;
  final String unit;
  final String substance;
  final String route;
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final String location;
  final DateTime date;
  final int hour;
  final int minute;
  final String notes;
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final List<String> triggers;
  final List<String> bodySignals;
  final String entryId;
  // Substance details for ROA validation (loaded from DB)
  final Map<String, dynamic>? substanceDetails;
  const LogEntryFormData({
    this.isSimpleMode = true,
    this.dose = 0,
    this.unit = 'mg',
    this.substance = '',
    this.route = 'oral',
    this.feelings = const [],
    this.secondaryFeelings = const {},
    this.location = '',
    required this.date,
    required this.hour,
    required this.minute,
    this.notes = '',
    this.isMedicalPurpose = false,
    this.cravingIntensity = 0,
    this.intention,
    this.triggers = const [],
    this.bodySignals = const [],
    this.entryId = '',
    this.substanceDetails,
  });
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

  /// Riverpod-ready copyWith method
  LogEntryFormData copyWith({
    bool? isSimpleMode,
    double? dose,
    String? unit,
    String? substance,
    String? route,
    List<String>? feelings,
    Map<String, List<String>>? secondaryFeelings,
    String? location,
    DateTime? date,
    int? hour,
    int? minute,
    String? notes,
    bool? isMedicalPurpose,
    double? cravingIntensity,
    String? intention,
    List<String>? triggers,
    List<String>? bodySignals,
    String? entryId,
    Map<String, dynamic>? substanceDetails,
  }) {
    return LogEntryFormData(
      isSimpleMode: isSimpleMode ?? this.isSimpleMode,
      dose: dose ?? this.dose,
      unit: unit ?? this.unit,
      substance: substance ?? this.substance,
      route: route ?? this.route,
      feelings: feelings ?? this.feelings,
      secondaryFeelings: secondaryFeelings ?? this.secondaryFeelings,
      location: location ?? this.location,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      notes: notes ?? this.notes,
      isMedicalPurpose: isMedicalPurpose ?? this.isMedicalPurpose,
      cravingIntensity: cravingIntensity ?? this.cravingIntensity,
      intention: intention ?? this.intention,
      triggers: triggers ?? this.triggers,
      bodySignals: bodySignals ?? this.bodySignals,
      entryId: entryId ?? this.entryId,
      substanceDetails: substanceDetails ?? this.substanceDetails,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogEntryFormData &&
        other.isSimpleMode == isSimpleMode &&
        other.dose == dose &&
        other.unit == unit &&
        other.substance == substance &&
        other.route == route &&
        other.location == location &&
        other.notes == notes &&
        other.isMedicalPurpose == isMedicalPurpose &&
        other.cravingIntensity == cravingIntensity &&
        other.intention == intention &&
        other.entryId == entryId;
  }

  @override
  int get hashCode {
    return Object.hash(
      isSimpleMode,
      dose,
      unit,
      substance,
      route,
      location,
      notes,
      isMedicalPurpose,
      cravingIntensity,
      intention,
      entryId,
    );
  }
}

import 'package:flutter/material.dart';
import '../models/log_entry_form_data.dart';
import '../controllers/log_entry_controller.dart';

/// Riverpod-ready state adapter for Provider
/// This wraps the pure LogEntryFormData with ChangeNotifier for Provider compatibility
/// When migrating to Riverpod, this entire file will be replaced with a StateNotifier/Notifier
/// 
/// MIGRATION NOTE: Replace this with:
/// ```
/// final logEntryProvider = StateNotifierProvider<LogEntryNotifier, LogEntryFormData>((ref) {
///   return LogEntryNotifier(ref.read(logEntryControllerProvider));
/// });
/// ```
class LogEntryState extends ChangeNotifier {
  LogEntryFormData _data = LogEntryFormData.initial();
  final LogEntryController _controller = LogEntryController();

  // Expose pure data (Riverpod will use this directly)
  LogEntryFormData get data => _data;

  // Individual getters for backward compatibility with Provider
  bool get isSimpleMode => _data.isSimpleMode;
  double get dose => _data.dose;
  String get unit => _data.unit;
  String get substance => _data.substance;
  String get route => _data.route;
  List<String> get feelings => _data.feelings;
  Map<String, List<String>> get secondaryFeelings => _data.secondaryFeelings;
  String get location => _data.location;
  DateTime get date => _data.date;
  int get hour => _data.hour;
  int get minute => _data.minute;
  String get notes => _data.notes;
  bool get isMedicalPurpose => _data.isMedicalPurpose;
  double get cravingIntensity => _data.cravingIntensity;
  String? get intention => _data.intention;
  List<String> get triggers => _data.triggers;
  List<String> get bodySignals => _data.bodySignals;
  String get entryId => _data.entryId;
  Map<String, dynamic>? get substanceDetails => _data.substanceDetails;
  DateTime get selectedDateTime => _data.selectedDateTime;

  // Pure business logic methods (delegated to controller)
  List<String> getAvailableROAs() {
    return _controller.getAvailableROAs(_data.substanceDetails);
  }

  bool isROAValidated(String roa) {
    return _controller.isROAValidated(roa, _data.substanceDetails);
  }

  // State mutation methods (Riverpod will replace these with copyWith)
  void setIsSimpleMode(bool value) {
    _data = _data.copyWith(isSimpleMode: value);
    notifyListeners();
  }

  void setDose(double value) {
    _data = _data.copyWith(dose: value);
    notifyListeners();
  }

  void setUnit(String value) {
    _data = _data.copyWith(unit: value);
    notifyListeners();
  }

  void setSubstance(String value) {
    _data = _data.copyWith(substance: value);
    _loadSubstanceDetails(value);
    notifyListeners();
  }

  Future<void> _loadSubstanceDetails(String substanceName) async {
    final details = await _controller.loadSubstanceDetails(substanceName);
    _data = _data.copyWith(substanceDetails: details);
    notifyListeners();
  }

  void setRoute(String value) {
    _data = _data.copyWith(route: value);
    notifyListeners();
  }

  void setFeelings(List<String> value) {
    _data = _data.copyWith(feelings: value);
    notifyListeners();
  }

  void setSecondaryFeelings(Map<String, List<String>> value) {
    _data = _data.copyWith(secondaryFeelings: value);
    notifyListeners();
  }

  void setLocation(String value) {
    _data = _data.copyWith(location: value);
    notifyListeners();
  }

  void setDate(DateTime value) {
    _data = _data.copyWith(date: value);
    notifyListeners();
  }

  void setHour(int value) {
    _data = _data.copyWith(hour: value);
    notifyListeners();
  }

  void setMinute(int value) {
    _data = _data.copyWith(minute: value);
    notifyListeners();
  }

  void setIsMedicalPurpose(bool value) {
    _data = _data.copyWith(isMedicalPurpose: value);
    notifyListeners();
  }

  void setCravingIntensity(double value) {
    _data = _data.copyWith(cravingIntensity: value);
    notifyListeners();
  }

  void setIntention(String? value) {
    _data = _data.copyWith(intention: value ?? '-- Select Intention--');
    notifyListeners();
  }

  void setTriggers(List<String> value) {
    _data = _data.copyWith(triggers: value);
    notifyListeners();
  }

  void setBodySignals(List<String> value) {
    _data = _data.copyWith(bodySignals: value);
    notifyListeners();
  }

  void setNotes(String value) {
    _data = _data.copyWith(notes: value);
    notifyListeners();
  }

  void resetForm() {
    _data = LogEntryFormData.empty();
    notifyListeners();
  }

  // Prefill methods for external usage (e.g., editing existing entry)
  void prefillSubstance(String value) {
    _data = _data.copyWith(substance: value);
    // Don't notify if called before provider is attached
  }

  void prefillDose(double value) {
    _data = _data.copyWith(dose: value);
    notifyListeners();
  }
}

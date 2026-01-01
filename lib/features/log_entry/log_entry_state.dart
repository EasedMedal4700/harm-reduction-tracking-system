// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod Notifier for log entry state.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/log_entry_form_data.dart';
import 'log_entry_controller.dart';

part 'log_entry_state.g.dart';

@riverpod
class LogEntryNotifier extends _$LogEntryNotifier {
  late final LogEntryController _controller;

  @override
  LogEntryFormData build() {
    _controller = LogEntryController();
    return LogEntryFormData.initial();
  }

  List<String> getAvailableROAs() {
    return _controller.getAvailableROAs(state.substanceDetails);
  }

  bool isROAValidated(String roa) {
    return _controller.isROAValidated(roa, state.substanceDetails);
  }

  void setIsSimpleMode(bool value) {
    state = state.copyWith(isSimpleMode: value);
  }

  void setDose(double value) {
    state = state.copyWith(dose: value);
  }

  void setUnit(String value) {
    state = state.copyWith(unit: value);
  }

  void setSubstance(String value) {
    state = state.copyWith(substance: value);
    _loadSubstanceDetails(value);
  }

  Future<void> _loadSubstanceDetails(String substanceName) async {
    final details = await _controller.loadSubstanceDetails(substanceName);
    state = state.copyWith(substanceDetails: details);
  }

  void setRoute(String value) {
    state = state.copyWith(route: value);
  }

  void setFeelings(List<String> value) {
    state = state.copyWith(feelings: value);
  }

  void setSecondaryFeelings(Map<String, List<String>> value) {
    state = state.copyWith(secondaryFeelings: value);
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
  }

  void setDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void setHour(int value) {
    state = state.copyWith(hour: value);
  }

  void setMinute(int value) {
    state = state.copyWith(minute: value);
  }

  void setIsMedicalPurpose(bool value) {
    state = state.copyWith(isMedicalPurpose: value);
  }

  void setCravingIntensity(double value) {
    state = state.copyWith(cravingIntensity: value);
  }

  void setIntention(String? value) {
    state = state.copyWith(intention: value ?? '-- Select Intention--');
  }

  void setTriggers(List<String> value) {
    state = state.copyWith(triggers: value);
  }

  void setBodySignals(List<String> value) {
    state = state.copyWith(bodySignals: value);
  }

  void setNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void resetForm() {
    state = LogEntryFormData.empty();
  }

  void prefillSubstance(String value) {
    state = state.copyWith(substance: value);
  }

  void prefillDose(double value) {
    state = state.copyWith(dose: value);
  }
}

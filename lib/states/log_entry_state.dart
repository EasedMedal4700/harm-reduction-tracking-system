import 'package:flutter/material.dart';
import '../models/log_entry_model.dart';
import '../services/timezone_service.dart';
import '../services/log_entry_service.dart';

class LogEntryState extends ChangeNotifier {
  bool isSimpleMode = true;
  double dose = 0;
  String unit = 'mg';
  String substance = '';
  String route = 'oral';
  List<String> feelings = [];
  Map<String, List<String>> secondaryFeelings = {};
  String location = 'Select a location'; // Set default
  DateTime date = DateTime.now();
  int hour = TimeOfDay.now().hour;
  int minute = TimeOfDay.now().minute;
  final notesCtrl = TextEditingController();
  final TextEditingController doseCtrl = TextEditingController();
  final TextEditingController substanceCtrl = TextEditingController();

  void setSubstance(String value) {
    // don't call substanceCtrl.text = value here — it resets selection/cursor
    substance = value;
    notifyListeners();
  }

  void prefillSubstance(String value) {
    substance = value;
    substanceCtrl.text = value; // only set controller once when pre-filling
    // don't notify here if called before provider is attached, otherwise call notifyListeners()
  }

  final formKey = GlobalKey<FormState>();
  final TimezoneService timezoneService = TimezoneService();
  bool isMedicalPurpose = false;
  double cravingIntensity = 0; // default to 0 now
  String? intention = '-- Select Intention--';
  List<String> triggers = [];
  List<String> bodySignals = [];
  final LogEntryService logEntryService = LogEntryService();
  bool isSaving = false;

  String entryId = ''; // Add this

  DateTime get selectedDateTime => DateTime(date.year, date.month, date.day, hour, minute);

  void dispose() {
    doseCtrl.dispose();
    substanceCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  void resetForm() {
    dose = 0;
    substance = '';
    feelings = [];
    secondaryFeelings = {};
    location = 'Select a location'; // Set default on reset
    isMedicalPurpose = false;
    cravingIntensity = 0;
    intention = '-- Select Intention--'; // Use valid default value
    triggers = [];
    bodySignals = [];
    notesCtrl.clear();
    entryId = ''; // Add this
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix validation errors before saving.')),
      );
      return;
    }
    isSaving = true;
    notifyListeners();

    final entry = LogEntry(
      substance: substance,
      dosage: dose,
      unit: unit,
      route: route,
      feelings: feelings,
      secondaryFeelings: secondaryFeelings,
      datetime: selectedDateTime,
      location: location,
      notes: notesCtrl.text.trim(),
      timezoneOffset: timezoneService.getTimezoneOffset(),
      isMedicalPurpose: isMedicalPurpose,
      cravingIntensity: cravingIntensity,
      intention: intention ?? '-- Select Intention--',
      triggers: triggers,
      bodySignals: bodySignals,
      people: [],
    );

    try {
      if (entryId.isNotEmpty) {
        // Update existing entry
        await logEntryService.updateLogEntry(entryId, entry.toJson());
      } else {
        // Create new entry
        await logEntryService.saveLogEntry(entry);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved successfully!')),
      );
      resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: ${e.toString()}')),
      );
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Add setters for each variable to call notifyListeners()
  void setIsSimpleMode(bool value) {
    isSimpleMode = value;
    notifyListeners();
  }

  void setDose(double value) {
    dose = value; // Fix: assign the double value
    // DON'T update doseCtrl.text here — it resets cursor
    notifyListeners();
  }

  void prefillDose(double value) {
    dose = value;
    doseCtrl.text = (value == 0) ? '' : value.toString();
    notifyListeners();
  }

  void setUnit(String value) {
    unit = value;
    notifyListeners();
  }

  void setRoute(String value) {
    route = value;
    notifyListeners();
  }

  void setFeelings(List<String> value) {
    feelings = value;
    notifyListeners();
  }

  void setSecondaryFeelings(Map<String, List<String>> value) {
    secondaryFeelings = value;
    notifyListeners();
  }

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void setHour(int value) {
    hour = value;
    notifyListeners();
  }

  void setMinute(int value) {
    minute = value;
    notifyListeners();
  }

  void setIsMedicalPurpose(bool value) {
    isMedicalPurpose = value;
    notifyListeners();
  }

  void setCravingIntensity(double value) {
    cravingIntensity = value;
    notifyListeners();
  }

  void setIntention(String? value) { // Change to nullable
    intention = value ?? '-- Select Intention--'; // Fallback
    notifyListeners();
  }

  void setTriggers(List<String> value) {
    triggers = value;
    notifyListeners();
  }

  void setBodySignals(List<String> value) {
    bodySignals = value;
    notifyListeners();
  }
}
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
  String location = 'Home';
  DateTime date = DateTime.now();
  int hour = TimeOfDay.now().hour;
  int minute = TimeOfDay.now().minute;
  final notesCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final TimezoneService timezoneService = TimezoneService();
  bool isMedicalPurpose = false;
  double cravingIntensity = 5;
  String? intention = '-- Select Intention--';
  List<String> triggers = [];
  List<String> bodySignals = [];
  final LogEntryService logEntryService = LogEntryService();
  bool isSaving = false;

  DateTime get selectedDateTime => DateTime(date.year, date.month, date.day, hour, minute);

  void dispose() {
    notesCtrl.dispose();
  }

  void resetForm() {
    dose = 0;
    substance = '';
    feelings = [];
    secondaryFeelings = {};
    location = 'Home';
    isMedicalPurpose = false;
    cravingIntensity = 5;
    intention = '';
    triggers = [];
    bodySignals = [];
    notesCtrl.clear();
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
      await logEntryService.saveLogEntry(entry);
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
    dose = value;
    notifyListeners();
  }

  void setUnit(String value) {
    unit = value;
    notifyListeners();
  }

  void setSubstance(String value) {
    substance = value;
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
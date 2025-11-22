import 'package:flutter/material.dart';
import '../models/log_entry_model.dart';
import '../services/timezone_service.dart';
import '../services/log_entry_service.dart';
import '../repo/substance_repository.dart';

class LogEntryState extends ChangeNotifier {
  bool isSimpleMode = true;
  double dose = 0;
  String unit = 'mg';
  String substance = '';
  String route = 'oral';
  List<String> feelings = [];
  Map<String, List<String>> secondaryFeelings = {};
  String location = ''; // Empty string by default, will show hint text
  DateTime date = DateTime.now();
  int hour = TimeOfDay.now().hour;
  int minute = TimeOfDay.now().minute;
  final notesCtrl = TextEditingController();
  final TextEditingController doseCtrl = TextEditingController();
  final TextEditingController substanceCtrl = TextEditingController();

  // Substance details for ROA validation
  Map<String, dynamic>? substanceDetails;
  final SubstanceRepository _substanceRepo = SubstanceRepository();

  void setSubstance(String value) {
    // don't call substanceCtrl.text = value here — it resets selection/cursor
    substance = value;
    // Load substance details for ROA validation
    _loadSubstanceDetails(value);
    notifyListeners();
  }

  Future<void> _loadSubstanceDetails(String substanceName) async {
    if (substanceName.isEmpty) {
      substanceDetails = null;
      return;
    }
    substanceDetails = await _substanceRepo.getSubstanceDetails(substanceName);
  }

  /// Get available ROAs for current substance (base 4 + substance-specific)
  List<String> getAvailableROAs() {
    const baseROAs = ['oral', 'insufflated', 'inhaled', 'sublingual'];
    final dbROAs = _substanceRepo.getAvailableROAs(substanceDetails);
    
    // Combine and deduplicate
    final allROAs = {...baseROAs, ...dbROAs}.toList();
    return allROAs;
  }

  /// Check if a specific ROA is validated in DB for this substance
  bool isROAValidated(String roa) {
    return _substanceRepo.isROAValid(roa, substanceDetails);
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

  /// Validate substance exists in DB
  Future<bool> validateSubstance(BuildContext context) async {
    if (substance.isEmpty) {
      _showErrorDialog(context, 'Missing Substance', 'Please select a substance before saving.');
      return false;
    }

    // Reload substance details to ensure it exists
    await _loadSubstanceDetails(substance);
    
    if (substanceDetails == null) {
      _showErrorDialog(
        context,
        'Substance Not Found',
        'The substance "$substance" was not found in the database. Please select a valid substance.',
      );
      return false;
    }
    return true;
  }

  /// Validate ROA with user confirmation for unvalidated routes
  Future<bool> validateROA(BuildContext context) async {
    if (!isROAValidated(route)) {
      return await _showConfirmDialog(
        context,
        'Unvalidated Route',
        'The route "$route" is not validated for ${substanceDetails?['pretty_name'] ?? substance}. Are you sure you want to continue?',
      );
    }
    return true;
  }

  /// Validate emotions required for non-medical use
  Future<bool> validateEmotions(BuildContext context) async {
    if (!isMedicalPurpose && feelings.isEmpty) {
      return await _showConfirmDialog(
        context,
        'No Emotions Selected',
        'Are you sure? No emotions selected for non-medical use.',
      );
    }
    return true;
  }

  /// Validate craving required for non-medical detailed mode
  Future<bool> validateCraving(BuildContext context) async {
    if (!isMedicalPurpose && !isSimpleMode && cravingIntensity < 1) {
      return await _showConfirmDialog(
        context,
        'No Craving Intensity',
        'Are you sure? Craving intensity is 0 for non-medical use.',
      );
    }
    return true;
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog
  Future<bool> _showConfirmDialog(BuildContext context, String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

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

    // Validate substance exists in DB
    if (!await validateSubstance(context)) return;

    // Validate ROA with user confirmation
    if (!await validateROA(context)) return;

    // Validate emotions for non-medical use
    if (!await validateEmotions(context)) return;

    // Validate craving for non-medical detailed mode
    if (!await validateCraving(context)) return;

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
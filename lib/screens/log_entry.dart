import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../widgets/drawer_menu.dart';
// import '../constants/drug_use_catalog.dart';
// import '../utils/entry_validation.dart';
import '../models/log_entry_model.dart';
import '../widgets/log_entry/log_entry_form.dart';
import '../services/timezone_service.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage> {
  bool _isSimpleMode = true; 
  double _dose = 0;
  String _unit = 'mg';
  String _substance = '';
  String _route = 'oral';
  List<String> _feelings = [];
  Map<String, List<String>> _secondaryFeelings = {};
  String _location = 'Home';
  DateTime _date = DateTime.now();
  int _hour = TimeOfDay.now().hour;
  int _minute = TimeOfDay.now().minute;
  final _notesCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TimezoneService _timezoneService = TimezoneService(); // Add this
  bool _isMedicalPurpose = false; // Add this
  double _cravingIntensity = 5; // Add this
  String _intention = ''; // Add this
  List<String> _triggers = []; // Add this
  List<String> _bodySignals = []; // Add this


  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  DateTime get selectedDateTime => DateTime(_date.year, _date.month, _date.day, _hour, _minute);

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final entry = LogEntry(
      substance: _substance,
      dosage: _dose,
      unit: _unit,
      route: _route,
      feelings: _feelings,
      secondaryFeelings: _secondaryFeelings,
      datetime: selectedDateTime,
      location: _location,
      notes: _notesCtrl.text.trim(),
      timezoneOffset: _timezoneService.getTimezoneOffset(), // Add this
      isMedicalPurpose: _isMedicalPurpose, // Add this
      cravingIntensity: _cravingIntensity, // Add this
      intention: _intention,
      triggers: _triggers, // Add this
      bodySignals: _bodySignals, // Add this
    );
    print(entry.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Log Entry'),
        actions: [
          const Text('Simple'),
          Switch(
            value: _isSimpleMode,
            onChanged: (val) => setState(() => _isSimpleMode = val),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: LogEntryForm(
        isSimpleMode: _isSimpleMode,
        dose: _dose,
        unit: _unit,
        substance: _substance,
        route: _route,
        feelings: _feelings,
        secondaryFeelings: _secondaryFeelings,
        location: _location,
        date: _date,
        hour: _hour,
        minute: _minute,
        notesCtrl: _notesCtrl,
        formKey: _formKey,
        isMedicalPurpose: _isMedicalPurpose,
        cravingIntensity: _cravingIntensity,
        intention: _intention,
        triggers: _triggers,
        bodySignals: _bodySignals,
        onDoseChanged: (dose) => setState(() => _dose = dose),
        onUnitChanged: (unit) => setState(() => _unit = unit),
        onSubstanceChanged: (substance) => setState(() => _substance = substance),
        onRouteChanged: (route) => setState(() => _route = route),
        onFeelingsChanged: (feelings) => setState(() => _feelings = feelings),
        onSecondaryFeelingsChanged: (secondary) => setState(() => _secondaryFeelings = secondary),
        onLocationChanged: (location) => setState(() => _location = location),
        onDateChanged: (date) => setState(() => _date = date),
        onHourChanged: (hour) => setState(() => _hour = hour),
        onMinuteChanged: (minute) => setState(() => _minute = minute),
        onMedicalPurposeChanged: (value) => setState(() => _isMedicalPurpose = value),
        onCravingIntensityChanged: (value) => setState(() => _cravingIntensity = value),
        onIntentionChanged: (value) => setState(() => _intention = value),
        onTriggersChanged: (triggers) => setState(() => _triggers = triggers),
        onBodySignalsChanged: (bodySignals) => setState(() => _bodySignals = bodySignals),
        onSave: _save,
      ),
    );
  }
}
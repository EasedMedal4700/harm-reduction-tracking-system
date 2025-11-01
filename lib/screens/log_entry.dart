import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../widgets/drawer_menu.dart';
// import '../constants/drug_use_catalog.dart';
// import '../utils/entry_validation.dart';
import '../models/log_entry_model.dart';
import '../widgets/log_entry/dosage_input.dart';
import '../widgets/log_entry/substance_autocomplete.dart';
import '../widgets/log_entry/route_selection.dart';
import '../widgets/log_entry/feeling_selection.dart';
import '../widgets/log_entry/date_selector.dart';
import '../widgets/log_entry/time_selector.dart';
import '../widgets/log_entry/location_dropdown.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage> {
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
    );
    print(entry.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final units = ['μg', 'mg', 'g', 'pills', 'ml'];
    final locations = ['Home', 'Work', 'School', 'Public', 'Vehicle', 'Gym', 'Other'];

    return Scaffold(
      appBar: AppBar(title: const Text('Quick Log Entry')),
      drawer: const DrawerMenu(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DosageInput(
              dose: _dose,
              unit: _unit,
              units: units,
              onDoseChanged: (dose) => setState(() => _dose = dose),
              onUnitChanged: (unit) => setState(() => _unit = unit),
            ),
            const SizedBox(height: 16),

            SubstanceAutocomplete(
              substance: _substance,
              onSubstanceChanged: (substance) => setState(() => _substance = substance),
            ),
            const SizedBox(height: 16),

            const Text('Route of Administration'),
            RouteSelection(
              route: _route,
              onRouteChanged: (route) => setState(() => _route = route),
            ),
            const SizedBox(height: 16),

            FeelingSelection(
              feelings: _feelings,
              secondaryFeelings: _secondaryFeelings,
              onFeelingsChanged: (feelings) => setState(() => _feelings = feelings),
              onSecondaryFeelingsChanged: (secondary) => setState(() => _secondaryFeelings = secondary),
            ),
            const SizedBox(height: 16),

            DateSelector(
              date: _date,
              onDateChanged: (date) => setState(() => _date = date),
            ),
            const SizedBox(height: 16),

            TimeSelector(
              hour: _hour,
              minute: _minute,
              onHourChanged: (hour) => setState(() => _hour = hour),
              onMinuteChanged: (minute) => setState(() => _minute = minute),
            ),
            const SizedBox(height: 16),

            const Text('Location'),
            LocationDropdown(
              location: _location,
              locations: locations,
              onLocationChanged: (location) => setState(() => _location = location),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
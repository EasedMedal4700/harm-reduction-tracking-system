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
import '../services/timezone_service.dart';
import '../widgets/log_entry/craving_slider.dart';
import '../constants/body_and_mind_catalog.dart';

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
    final units = ['μg', 'mg', 'g', 'pills', 'ml'];
    final locations = ['Home', 'Work', 'School', 'Public', 'Vehicle', 'Gym', 'Other'];

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Always show these (simple mode fields)
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

            // Add location and time to simple mode
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

            // Show complex fields only if not simple mode
            if (!_isSimpleMode) ...[
              DropdownButtonFormField<String>(
                value: _intention.isEmpty ? null : _intention,
                decoration: InputDecoration(
                  labelText: _isMedicalPurpose ? 'Intention (optional)' : 'Intention',
                ),
                items: intentions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _intention = value ?? ''),
                validator: (value) => null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('Medical Purpose?'),
                  const Spacer(),
                  Switch(
                    value: _isMedicalPurpose,
                    onChanged: (value) => setState(() => _isMedicalPurpose = value),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CravingSlider(
                value: _cravingIntensity,
                onChanged: (value) => setState(() => _cravingIntensity = value),
              ),
              const SizedBox(height: 16),

              const Text('Triggers'),
              Wrap(
                spacing: 8.0,
                children: triggers.map((trigger) => FilterChip(
                  label: Text(trigger),
                  selected: _triggers.contains(trigger),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _triggers.add(trigger);
                      } else {
                        _triggers.remove(trigger);
                      }
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 16),

              const Text('Body Signals'),
              Wrap(
                spacing: 8.0,
                children: physicalSensations.map((signal) => FilterChip(
                  label: Text(signal),
                  selected: _bodySignals.contains(signal),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _bodySignals.add(signal);
                      } else {
                        _bodySignals.remove(signal);
                      }
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 16),

            ],

            // Always show notes and save
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
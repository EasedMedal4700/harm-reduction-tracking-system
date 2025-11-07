import 'package:flutter/material.dart';
import 'simple_fields.dart';
import 'complex_fields.dart';

class LogEntryForm extends StatelessWidget {
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
  final TextEditingController notesCtrl;
  final GlobalKey<FormState> formKey;
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final List<String> selectedTriggers;
  final List<String> selectedBodySignals;
  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<String> onSubstanceChanged;
  final ValueChanged<String> onRouteChanged;
  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<bool> onMedicalPurposeChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String?> onIntentionChanged;
  final ValueChanged<List<String>> onTriggersChanged;
  final ValueChanged<List<String>> onBodySignalsChanged;
  final VoidCallback onSave;

  const LogEntryForm({
    super.key,
    required this.isSimpleMode,
    required this.dose,
    required this.unit,
    required this.substance,
    required this.route,
    required this.feelings,
    required this.secondaryFeelings,
    required this.location,
    required this.date,
    required this.hour,
    required this.minute,
    required this.notesCtrl,
    required this.formKey,
    required this.isMedicalPurpose,
    required this.cravingIntensity,
    required this.intention,
    required this.selectedTriggers,
    required this.selectedBodySignals,
    required this.onDoseChanged,
    required this.onUnitChanged,
    required this.onSubstanceChanged,
    required this.onRouteChanged,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onMedicalPurposeChanged,
    required this.onCravingIntensityChanged,
    required this.onIntentionChanged,
    required this.onTriggersChanged,
    required this.onBodySignalsChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView( // Add for scrolling if needed
          padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
          child: Column( // Changed from ListView to Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleFields(
                dose: dose,
                unit: unit,
                substance: substance,
                route: route,
                feelings: feelings,
                secondaryFeelings: secondaryFeelings,
                location: location,
                date: date,
                hour: hour,
                minute: minute,
                onDoseChanged: onDoseChanged,
                onUnitChanged: onUnitChanged,
                onSubstanceChanged: onSubstanceChanged,
                onRouteChanged: onRouteChanged,
                onFeelingsChanged: onFeelingsChanged,
                onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
                onLocationChanged: onLocationChanged,
                onDateChanged: onDateChanged,
                onHourChanged: onHourChanged,
                onMinuteChanged: onMinuteChanged,
                onMedicalPurposeChanged: onMedicalPurposeChanged,
                isMedicalPurpose: isMedicalPurpose,
              ),
              if (!isSimpleMode) ComplexFields(
                cravingIntensity: cravingIntensity,
                intention: intention,
                selectedTriggers: selectedTriggers,
                selectedBodySignals: selectedBodySignals,
                onCravingIntensityChanged: onCravingIntensityChanged,
                onIntentionChanged: onIntentionChanged,
                onTriggersChanged: onTriggersChanged,
                onBodySignalsChanged: onBodySignalsChanged,
              ),
              TextFormField(
                controller: notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSave,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
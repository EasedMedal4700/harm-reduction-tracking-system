import 'package:flutter/material.dart';
import 'simple_fields.dart';
import 'complex_fields.dart';

class LogEntryForm extends StatefulWidget {
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
  final String? intention; // Change to nullable
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
  final TextEditingController? doseCtrl;
  final TextEditingController? substanceCtrl;

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
    this.intention, // Make optional or nullable
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
    this.doseCtrl,
    this.substanceCtrl,
  });

  @override
  State<LogEntryForm> createState() => _LogEntryFormState();
}

class _LogEntryFormState extends State<LogEntryForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleFields(
                dose: widget.dose,
                unit: widget.unit,
                substance: widget.substance,
                route: widget.route,
                feelings: widget.feelings,
                secondaryFeelings: widget.secondaryFeelings,
                location: widget.location,
                date: widget.date,
                hour: widget.hour,
                minute: widget.minute,
                onDoseChanged: widget.onDoseChanged,
                onUnitChanged: widget.onUnitChanged,
                onSubstanceChanged: widget.onSubstanceChanged,
                onRouteChanged: widget.onRouteChanged,
                onFeelingsChanged: widget.onFeelingsChanged,
                onSecondaryFeelingsChanged: widget.onSecondaryFeelingsChanged,
                onLocationChanged: widget.onLocationChanged,
                onDateChanged: widget.onDateChanged,
                onHourChanged: widget.onHourChanged,
                onMinuteChanged: widget.onMinuteChanged,
                onMedicalPurposeChanged: widget.onMedicalPurposeChanged,
                isMedicalPurpose: widget.isMedicalPurpose,
              ),
              if (!widget.isSimpleMode)
                ComplexFields(
                  cravingIntensity: widget.cravingIntensity,
                  intention: widget.intention,
                  selectedTriggers: widget.selectedTriggers,
                  selectedBodySignals: widget.selectedBodySignals,
                  onCravingIntensityChanged: widget.onCravingIntensityChanged,
                  onIntentionChanged: widget.onIntentionChanged,
                  onTriggersChanged: widget.onTriggersChanged,
                  onBodySignalsChanged: widget.onBodySignalsChanged,
                ),
              TextFormField(
                controller: widget.notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.onSave,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'craving_slider.dart';
import '../../constants/body_and_mind_catalog.dart';

class ComplexFields extends StatelessWidget {
  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String intention;
  final List<String> selectedTriggers; // Renamed to avoid conflict
  final List<String> selectedBodySignals; // Renamed
  final ValueChanged<bool> onMedicalPurposeChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String> onIntentionChanged;
  final ValueChanged<List<String>> onTriggersChanged;
  final ValueChanged<List<String>> onBodySignalsChanged;

  const ComplexFields({
    super.key,
    required this.isMedicalPurpose,
    required this.cravingIntensity,
    required this.intention,
    required this.selectedTriggers,
    required this.selectedBodySignals,
    required this.onMedicalPurposeChanged,
    required this.onCravingIntensityChanged,
    required this.onIntentionChanged,
    required this.onTriggersChanged,
    required this.onBodySignalsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: intention.isEmpty ? null : intention,
          decoration: InputDecoration(
            labelText: isMedicalPurpose ? 'Intention (optional)' : 'Intention',
          ),
          items: intentions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => onIntentionChanged(value ?? ''),
          validator: (value) => null,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            const Text('Medical Purpose?'),
            const SizedBox(width: 16),
            Switch(
              value: isMedicalPurpose,
              onChanged: onMedicalPurposeChanged,
            ),
          ],
        ),
        const SizedBox(height: 16),

        CravingSlider(
          value: cravingIntensity,
          onChanged: onCravingIntensityChanged,
        ),
        const SizedBox(height: 16),

        const Text('Triggers'),
        Wrap(
          spacing: 8.0,
          children: triggers.map((trigger) => FilterChip( // Map over catalog triggers
            label: Text(trigger),
            selected: selectedTriggers.contains(trigger), // Check against renamed parameter
            onSelected: (selected) {
              final newTriggers = List<String>.from(selectedTriggers);
              if (selected) {
                newTriggers.add(trigger);
              } else {
                newTriggers.remove(trigger);
              }
              onTriggersChanged(newTriggers);
            },
          )).toList(),
        ),
        const SizedBox(height: 16),

        const Text('Body Signals'),
        Wrap(
          spacing: 8.0,
          children: physicalSensations.map((signal) => FilterChip(
            label: Text(signal),
            selected: selectedBodySignals.contains(signal), // Updated
            onSelected: (selected) {
              final newBodySignals = List<String>.from(selectedBodySignals);
              if (selected) {
                newBodySignals.add(signal);
              } else {
                newBodySignals.remove(signal);
              }
              onBodySignalsChanged(newBodySignals);
            },
          )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
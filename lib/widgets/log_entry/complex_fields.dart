import 'package:flutter/material.dart';
import '../../common/old_common/craving_slider.dart';
import '../../constants/data/body_and_mind_catalog.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../common/text/common_section_header.dart';

class ComplexFields extends StatelessWidget {
  final double cravingIntensity;
  final String? intention;
  final List<String> selectedTriggers; 
  final List<String> selectedBodySignals;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String?> onIntentionChanged; // Change to nullable
  final ValueChanged<List<String>> onTriggersChanged;
  final ValueChanged<List<String>> onBodySignalsChanged;

  const ComplexFields({
    super.key,
    required this.cravingIntensity,
    required this.intention,
    required this.selectedTriggers,
    required this.selectedBodySignals,
    required this.onCravingIntensityChanged,
    required this.onIntentionChanged,
    required this.onTriggersChanged,
    required this.onBodySignalsChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the current intention value exists in the list, or use null
    final validIntention = intentions.contains(intention) ? intention : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Intention'),
          value: validIntention,
          items: intentions.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onIntentionChanged, // Single, matches
        ),
        SizedBox(height: AppThemeConstants.spaceMd),

        CravingSlider(
          value: cravingIntensity,
          onChanged: onCravingIntensityChanged,
        ),
        const SizedBox(height: AppThemeConstants.spaceLg),

        const CommonSectionHeader(title: 'Triggers'),
        Wrap(
          spacing: AppThemeConstants.spaceSm,
          children: triggers.map((trigger) => FilterChip(
            label: Text(trigger),
            selected: selectedTriggers.contains(trigger),
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
        const SizedBox(height: AppThemeConstants.spaceLg),

        const Text('Body Signals'),
        Wrap(
          spacing: AppThemeConstants.spaceSm,
          children: physicalSensations.map((signal) => FilterChip(
            label: Text(signal),
            selected: selectedBodySignals.contains(signal),
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
        const SizedBox(height: AppThemeConstants.spaceLg),
      ],
    );
  }
}

// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme/common usage, not fully migrated.
import 'package:flutter/material.dart';
import '../../common/old_common/craving_slider.dart';
import '../../constants/data/body_and_mind_catalog.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../common/text/common_section_header.dart';
import '../../common/cards/common_card.dart';

class ComplexFields extends StatelessWidget {
  final double cravingIntensity;
  final String? intention;
  final List<String> selectedTriggers;
  final List<String> selectedBodySignals;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String?> onIntentionChanged;
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
    final validIntention = intentions.contains(intention) ? intention : null;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // -------------------------------
          // INTENTION
          // -------------------------------
          const CommonSectionHeader(title: "Intention"),
          SizedBox(height: AppThemeConstants.spaceMd),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Why are you using?",
            ),
            value: validIntention,
            items: intentions
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: onIntentionChanged,
          ),

          SizedBox(height: AppThemeConstants.spaceLg),

          // -------------------------------
          // CRAVING SLIDER
          // -------------------------------
          const CommonSectionHeader(title: "Craving Intensity"),
          SizedBox(height: AppThemeConstants.spaceMd),

          CravingSlider(
            value: cravingIntensity,
            onChanged: onCravingIntensityChanged,
          ),

          SizedBox(height: AppThemeConstants.spaceLg),

          // -------------------------------
          // TRIGGERS
          // -------------------------------
          const CommonSectionHeader(title: "Triggers"),
          SizedBox(height: AppThemeConstants.spaceSm),

          Wrap(
            spacing: AppThemeConstants.spaceSm,
            runSpacing: AppThemeConstants.spaceSm,
            children: triggers.map((trigger) {
              final selected = selectedTriggers.contains(trigger);

              return FilterChip(
                label: Text(trigger),
                selected: selected,
                onSelected: (isSelected) {
                  final updated = List<String>.from(selectedTriggers);
                  isSelected ? updated.add(trigger) : updated.remove(trigger);
                  onTriggersChanged(updated);
                },
              );
            }).toList(),
          ),

          SizedBox(height: AppThemeConstants.spaceLg),

          // -------------------------------
          // BODY SIGNALS
          // -------------------------------
          const CommonSectionHeader(title: "Body Signals"),
          SizedBox(height: AppThemeConstants.spaceSm),

          Wrap(
            spacing: AppThemeConstants.spaceSm,
            runSpacing: AppThemeConstants.spaceSm,
            children: physicalSensations.map((signal) {
              final selected = selectedBodySignals.contains(signal);

              return FilterChip(
                label: Text(signal),
                selected: selected,
                onSelected: (isSelected) {
                  final updated = List<String>.from(selectedBodySignals);
                  isSelected ? updated.add(signal) : updated.remove(signal);
                  onBodySignalsChanged(updated);
                },
              );
            }).toList(),
          ),

          SizedBox(height: AppThemeConstants.spaceLg),
        ],
      ),
    );
  }
}

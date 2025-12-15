import 'package:flutter/material.dart';
import '../../common/app_theme.dart';
import '../../constants/data/body_and_mind_catalog.dart';

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
    final t = AppTheme.of(context);
    final validIntention = intentions.contains(intention) ? intention : null;

    return Container(
      padding: EdgeInsets.all(t.spacing.m),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        border: Border.all(color: t.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // -------------------------------
          // INTENTION
          // -------------------------------
          Text(
            "Intention",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: t.spacing.m),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Why are you using?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
              ),
            ),
            value: validIntention,
            items: intentions
                .map((i) => DropdownMenuItem(value: i, child: Text(i, style: t.typography.bodyLarge)))
                .toList(),
            onChanged: onIntentionChanged,
            style: t.typography.bodyLarge.copyWith(color: t.colors.onSurface),
            dropdownColor: t.colors.surfaceContainer,
          ),

          SizedBox(height: t.spacing.l),

          // -------------------------------
          // CRAVING SLIDER
          // -------------------------------
          Text(
            "Craving Intensity",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: t.spacing.m),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0", style: t.typography.bodySmall),
                  Text(cravingIntensity.round().toString(), style: t.typography.titleLarge.copyWith(color: t.colors.primary)),
                  Text("10", style: t.typography.bodySmall),
                ],
              ),
              Slider(
                value: cravingIntensity,
                min: 0,
                max: 10,
                divisions: 10,
                label: cravingIntensity.round().toString(),
                onChanged: onCravingIntensityChanged,
                activeColor: t.colors.primary,
                inactiveColor: t.colors.surfaceContainerHighest,
              ),
            ],
          ),

          SizedBox(height: t.spacing.l),

          // -------------------------------
          // TRIGGERS
          // -------------------------------
          Text(
            "Triggers",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: t.spacing.s),

          Wrap(
            spacing: t.spacing.s,
            runSpacing: t.spacing.s,
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
                selectedColor: t.colors.primaryContainer,
                checkmarkColor: t.colors.onPrimaryContainer,
                labelStyle: t.typography.bodyMedium.copyWith(
                  color: selected ? t.colors.onPrimaryContainer : t.colors.onSurface,
                ),
                backgroundColor: t.colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusS),
                  side: BorderSide(
                    color: selected ? Colors.transparent : t.colors.outline,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: t.spacing.l),

          // -------------------------------
          // BODY SIGNALS
          // -------------------------------
          Text(
            "Body Signals",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: t.spacing.s),

          Wrap(
            spacing: t.spacing.s,
            runSpacing: t.spacing.s,
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
                selectedColor: t.colors.primaryContainer,
                checkmarkColor: t.colors.onPrimaryContainer,
                labelStyle: t.typography.bodyMedium.copyWith(
                  color: selected ? t.colors.onPrimaryContainer : t.colors.onSurface,
                ),
                backgroundColor: t.colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusS),
                  side: BorderSide(
                    color: selected ? Colors.transparent : t.colors.outline,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: t.spacing.l),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../common/app_theme.dart';

class BodyMindSignalsSection extends StatelessWidget {
  final List<String> sensations;
  final List<String> selectedSensations;
  final ValueChanged<List<String>> onSensationsChanged;

  const BodyMindSignalsSection({
    super.key,
    required this.sensations,
    required this.selectedSensations,
    required this.onSensationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    
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
          Row(
            children: [
              Icon(Icons.self_improvement, color: t.colors.primary),
              SizedBox(width: t.spacing.s),
              Text(
                'Body & Mind Signals',
                style: t.typography.titleMedium.copyWith(
                  color: t.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.m),
          Wrap(
            spacing: t.spacing.s,
            runSpacing: t.spacing.s,
            children: sensations.map((sensation) {
              final isSelected = selectedSensations.contains(sensation);
              return FilterChip(
                label: Text(sensation),
                selected: isSelected,
                onSelected: (selected) => onSensationsChanged(
                  selected
                    ? [...selectedSensations, sensation]
                    : selectedSensations.where((s) => s != sensation).toList(),
                ),
                selectedColor: t.colors.primaryContainer,
                checkmarkColor: t.colors.onPrimaryContainer,
                labelStyle: t.typography.bodyMedium.copyWith(
                  color: isSelected ? t.colors.onPrimaryContainer : t.colors.onSurface,
                ),
                backgroundColor: t.colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusS),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : t.colors.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Section for selecting body/mind signals.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';


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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.self_improvement, color: a.primary),
              SizedBox(width: sp.sm),
              Text(
                'Body & Mind Signals',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          Wrap(
            spacing: sp.sm,
            runSpacing: sp.sm,
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
                selectedColor: a.primary.withValues(alpha: 0.2),
                checkmarkColor: a.primary,
                labelStyle: t.typography.body.copyWith(
                  color: isSelected ? a.primary : c.textPrimary,
                ),
                backgroundColor: c.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : c.border,
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


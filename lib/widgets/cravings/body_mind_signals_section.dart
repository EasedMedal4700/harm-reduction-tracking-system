import 'package:flutter/material.dart';
import '../common/modern_form_card.dart';
import '../../constants/deprecated/ui_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ModernFormCard(
      title: 'Body & Mind Signals',
      icon: Icons.self_improvement,
      accentColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
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
            selectedColor: (isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen).withValues(alpha: 0.3),
            checkmarkColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
          );
        }).toList(),
      ),
    );
  }
}
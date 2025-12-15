import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Slider for numeric input (e.g., craving intensity)
class CommonSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showValueLabel;

  const CommonSlider({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 10.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.showValueLabel = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final defaultActiveColor = t.accent.primary;
    final defaultInactiveColor = t.colors.surfaceVariant.withOpacity(0.5);
    
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: activeColor ?? defaultActiveColor,
        inactiveTrackColor: inactiveColor ?? defaultInactiveColor,
        thumbColor: activeColor ?? defaultActiveColor,
        overlayColor: (activeColor ?? defaultActiveColor).withOpacity(0.2),
        valueIndicatorColor: activeColor ?? defaultActiveColor,
        valueIndicatorTextStyle: t.text.bodySmall.copyWith(
          color: t.colors.textInverse,
          fontWeight: FontWeight.w500,
        ),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10.0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 20.0,
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: showValueLabel ? (label ?? value.toStringAsFixed(1)) : null,
        onChanged: onChanged,
      ),
    );
  }
}

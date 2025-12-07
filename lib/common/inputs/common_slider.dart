import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultActiveColor = isDark 
        ? UIColors.darkNeonCyan
        : UIColors.lightAccentBlue;
    final defaultInactiveColor = isDark 
        ? const Color(0x1AFFFFFF)
        : Colors.grey.shade300;
    
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: activeColor ?? defaultActiveColor,
        inactiveTrackColor: inactiveColor ?? defaultInactiveColor,
        thumbColor: activeColor ?? defaultActiveColor,
        overlayColor: (activeColor ?? defaultActiveColor).withOpacity(0.2),
        valueIndicatorColor: activeColor ?? defaultActiveColor,
        valueIndicatorTextStyle: TextStyle(
          color: isDark ? UIColors.darkBackground : Colors.white,
          fontSize: ThemeConstants.fontSmall,
          fontWeight: ThemeConstants.fontMediumWeight,
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

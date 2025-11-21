import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

class TimeSelector extends StatelessWidget {
  final int hour;
  final int minute;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const TimeSelector({
    super.key,
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Time',
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            fontWeight: ThemeConstants.fontSemiBold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        const SizedBox(height: ThemeConstants.space8),
        Row(
          children: [
            const Text('Hour:'),
            const SizedBox(width: ThemeConstants.space8),
            Expanded(
              child: Slider(
                value: hour.toDouble(),
                min: 0,
                max: 23,
                divisions: 23,
                label: hour.toString().padLeft(2, '0'),
                activeColor: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                onChanged: (v) => onHourChanged(v.toInt()),
              ),
            ),
            const SizedBox(width: ThemeConstants.space8),
            Text(hour.toString().padLeft(2, '0')),
          ],
        ),
        Row(
          children: [
            const Text('Minute:'),
            const SizedBox(width: ThemeConstants.space8),
            Expanded(
              child: Slider(
                value: minute.toDouble(),
                min: 0,
                max: 59,
                divisions: 59,
                label: minute.toString().padLeft(2, '0'),
                activeColor: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                onChanged: (v) => onMinuteChanged(v.toInt()),
              ),
            ),
            const SizedBox(width: ThemeConstants.space8),
            Text(minute.toString().padLeft(2, '0')),
          ],
        ),
        const SizedBox(height: ThemeConstants.space12),
        Text(
          'Selected time: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
      ],
    );
  }
}
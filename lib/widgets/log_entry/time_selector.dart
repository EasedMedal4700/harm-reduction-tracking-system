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
        const SizedBox(height: ThemeConstants.space12),
        InkWell(
          onTap: () => _showTimePicker(context),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space24,
              vertical: ThemeConstants.space20,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x14FFFFFF) : const Color(0x0A000000),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(
                color: isDark ? UIColors.darkNeonBlue.withOpacity(0.3) : UIColors.lightAccentBlue.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                  size: 28,
                ),
                const SizedBox(width: ThemeConstants.space16),
                Text(
                  '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space16),
                Icon(
                  Icons.edit_outlined,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: ThemeConstants.space8),
        Text(
          'Tap to change time',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay(hour: hour, minute: minute);
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A1A1A)
                  : Colors.white,
              hourMinuteTextColor: Theme.of(context).brightness == Brightness.dark
                  ? UIColors.darkText
                  : UIColors.lightText,
              dayPeriodTextColor: Theme.of(context).brightness == Brightness.dark
                  ? UIColors.darkText
                  : UIColors.lightText,
              dialHandColor: Theme.of(context).brightness == Brightness.dark
                  ? UIColors.darkNeonBlue
                  : UIColors.lightAccentBlue,
              dialBackgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF5F5F5),
              hourMinuteColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF5F5F5),
              hourMinuteTextStyle: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onHourChanged(picked.hour);
      onMinuteChanged(picked.minute);
    }
  }
}
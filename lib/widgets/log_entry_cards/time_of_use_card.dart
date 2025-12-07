import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../log_entry/time_selector.dart';

/// Time of use card (date + time)
class TimeOfUseCard extends StatelessWidget {
  final DateTime date;
  final int hour;
  final int minute;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const TimeOfUseCard({
    required this.date,
    required this.hour,
    required this.minute,
    required this.onDateChanged,
    required this.onHourChanged,
    required this.onMinuteChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Time of Use',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Date picker
          _buildDatePicker(context, isDark),
          
          const SizedBox(height: ThemeConstants.space12),
          
          // Time picker (slider)
          _buildTimePicker(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x08FFFFFF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          border: Border.all(
            color: isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
            ),
            const SizedBox(width: ThemeConstants.space12),
            Text(
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isDark) {
    return TimeSelector(
      hour: hour,
      minute: minute,
      onHourChanged: onHourChanged,
      onMinuteChanged: onMinuteChanged,
    );
  }

  // Number pickers removed in favor of a slider-based TimeSelector

  BoxDecoration _buildDecoration(bool isDark) {
    if (isDark) {
      return BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 1,
        ),
      );
    } else {
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}


// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../log_entry/time_selector.dart';

class TimeOfUseCard extends StatelessWidget {
  final DateTime date;
  final int hour;
  final int minute;

  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const TimeOfUseCard({
    super.key,
    required this.date,
    required this.hour,
    required this.minute,
    required this.onDateChanged,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Time of Use",
            subtitle: "When did you use the substance?",
          ),

          const CommonSpacer.vertical(ThemeConstants.space16),

          _buildDatePicker(context, isDark),

          const CommonSpacer.vertical(ThemeConstants.space16),

          TimeSelector(
            hour: hour,
            minute: minute,
            onHourChanged: onHourChanged,
            onMinuteChanged: onMinuteChanged,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // DATE PICKER
  // ----------------------------------------------------------------------

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    final accent = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return InkWell(
      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );

        if (picked != null) onDateChanged(picked);
      },
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
            Icon(Icons.calendar_today, size: 20, color: accent),

            const CommonSpacer.horizontal(ThemeConstants.space12),

            Text(
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),

            const Spacer(),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

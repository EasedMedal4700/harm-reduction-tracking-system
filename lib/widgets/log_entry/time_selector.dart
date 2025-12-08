// filepath: lib/widgets/log_entry/time_selector.dart
import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../constants/theme/app_theme_constants.dart';

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

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay initial = TimeOfDay(hour: hour, minute: minute);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      onHourChanged(picked.hour);
      onMinuteChanged(picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(title: "Time"),

          const SizedBox(height: AppThemeConstants.spaceMd),

          InkWell(
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            onTap: () => _pickTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeConstants.spaceLg,
                vertical: AppThemeConstants.spaceMd,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: AppThemeConstants.iconLg,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: AppThemeConstants.spaceMd),

                  Expanded(
                    child: Text(
                      timeStr,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ),

                  Icon(
                    Icons.edit_outlined,
                    size: AppThemeConstants.iconSm,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppThemeConstants.spaceSm),

          Center(
            child: Text(
              "Tap to change time",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

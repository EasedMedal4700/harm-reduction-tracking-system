import 'package:flutter/material.dart';
import '../../common/app_theme.dart';

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
    final t = AppTheme.of(context);
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

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
          Text(
            "Time",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: t.spacing.m),

          InkWell(
            borderRadius: BorderRadius.circular(t.shapes.radiusM),
            onTap: () => _pickTime(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.l,
                vertical: t.spacing.m,
              ),
              decoration: BoxDecoration(
                color: t.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 24,
                    color: t.colors.primary,
                  ),

                  SizedBox(width: t.spacing.m),

                  Expanded(
                    child: Text(
                      timeStr,
                      style: t.typography.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: t.colors.onSurface,
                          ),
                    ),
                  ),

                  Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: t.colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: t.spacing.s),

          Center(
            child: Text(
              "Tap to change time",
              style: t.typography.bodySmall.copyWith(
                    color: t.colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

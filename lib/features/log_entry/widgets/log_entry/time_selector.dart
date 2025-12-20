// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class TimeSelector extends StatelessWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(sh.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sp.sm, horizontal: sp.md),
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(sh.radiusMd),
          color: c.surface,
        ),
        child: Row(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(
              Icons.access_time,
              size: context.sizes.iconSm,
              color: acc.primary,
            ),
            SizedBox(width: sp.sm),
            Text(
              selectedTime.format(context),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: text.bodyMedium.fontWeight,
                color: c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

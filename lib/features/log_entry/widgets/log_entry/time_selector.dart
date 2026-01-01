// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Time selector widget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final th = context.theme;
    final c = th.c;
    final tx = th.text;
    final ac = th.accent;
    final sh = th.shapes;
    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(sh.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: th.sp.sm, horizontal: th.sp.md),
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(sh.radiusMd),
          color: c.surface,
        ),
        child: Row(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(Icons.access_time, size: th.sizes.iconSm, color: ac.primary),
            SizedBox(width: th.sp.sm),
            Text(
              selectedTime.format(context),
              style: tx.bodyMedium.copyWith(color: c.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

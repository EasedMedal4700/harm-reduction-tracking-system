// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Combined date + time selector (EU 24h format).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    final updated = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );

    onDateChanged(updated);
  }

  String _relativeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (target == today.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.c;
    final t = th.text;
    final sh = th.shapes;

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(sh.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: th.sp.lg, vertical: th.sp.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: c.textTertiary),
            SizedBox(width: th.sp.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(selectedDate),
                  style: t.bodyMedium.copyWith(color: c.textPrimary),
                ),
                Text(
                  _relativeLabel(selectedDate),
                  style: t.bodySmall.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

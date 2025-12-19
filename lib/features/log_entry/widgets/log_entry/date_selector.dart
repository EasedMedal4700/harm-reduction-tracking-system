// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final t = context.theme;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return InkWell(
      onTap: () => _selectDate(context),
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
            Icon(Icons.calendar_today, size: context.sizes.iconSm, color: acc.primary),
            SizedBox(width: sp.sm),
            Text(
              DateFormat('MMM d, y').format(selectedDate),
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

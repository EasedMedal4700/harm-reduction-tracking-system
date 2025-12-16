import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateSelector extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  const DateSelector({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

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
            "Date",
            style: t.typography.titleMedium.copyWith(
              color: t.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: t.spacing.m),

          InkWell(
            onTap: () => _pickDate(context),
            borderRadius: BorderRadius.circular(t.shapes.radiusM),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.m,
                vertical: t.spacing.m,
              ),
              decoration: BoxDecoration(
                color: t.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(t.shapes.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 24,
                    color: t.colors.primary,
                  ),

                  SizedBox(width: t.spacing.m),

                  Expanded(
                    child: Text(
                      formattedDate,
                      style: t.typography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}


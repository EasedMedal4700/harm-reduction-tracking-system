// filepath: lib/widgets/log_entry/date_selector.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';

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
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(title: "Date"),

          const SizedBox(height: AppThemeConstants.spaceMd),

          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppThemeConstants.iconMd,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(width: AppThemeConstants.spaceMd),

              Expanded(
                child: Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              TextButton(
                onPressed: () => _pickDate(context),
                child: const Text("Change"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

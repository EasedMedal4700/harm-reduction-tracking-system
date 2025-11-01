// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\date_selector.dart
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Select Date'),
      subtitle: Text(DateFormat('yyyy-MM-dd').format(date)),
      trailing: TextButton(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) onDateChanged(picked);
        },
        child: const Text('Change'),
      ),
    );
  }
}
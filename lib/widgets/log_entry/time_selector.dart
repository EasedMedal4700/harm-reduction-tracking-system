// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\time_selector.dart
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Time'),
        Row(
          children: [
            const Text('Hour:'),
            Expanded(
              child: Slider(
                value: hour.toDouble(),
                min: 0,
                max: 23,
                divisions: 23,
                label: hour.toString(),
                onChanged: (v) => onHourChanged(v.toInt()),
              ),
            ),
            Text(hour.toString().padLeft(2, '0')),
          ],
        ),
        Row(
          children: [
            const Text('Minute:'),
            Expanded(
              child: Slider(
                value: minute.toDouble(),
                min: 0,
                max: 59,
                divisions: 59,
                label: minute.toString(),
                onChanged: (v) => onMinuteChanged(v.toInt()),
              ),
            ),
            Text(minute.toString().padLeft(2, '0')),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Selected time: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
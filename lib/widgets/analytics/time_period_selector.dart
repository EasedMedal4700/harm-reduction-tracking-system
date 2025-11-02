import 'package:flutter/material.dart';
import '../../screens/analytics_page.dart'; // For TimePeriod enum

class TimePeriodSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: TimePeriod.values.map((period) {
        final isSelected = selectedPeriod == period;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black,
          ),
          onPressed: () => onPeriodChanged(period),
          child: Text(
            period == TimePeriod.all ? 'All Time' :
            period == TimePeriod.last7Days ? 'Last 7 Days' :
            period == TimePeriod.last7Weeks ? 'Last 7 Weeks' : 'Last 7 Months',
          ),
        );
      }).toList(),
    );
  }
}
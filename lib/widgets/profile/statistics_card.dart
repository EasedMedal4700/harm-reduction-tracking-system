import 'package:flutter/material.dart';
import 'stat_item.dart';

class StatisticsCard extends StatelessWidget {
  final Map<String, int> statistics;

  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.medication,
                  label: 'Total Entries',
                  value: statistics['total_entries'].toString(),
                  color: Colors.blue,
                ),
                StatItem(
                  icon: Icons.calendar_today,
                  label: 'Last 7 Days',
                  value: statistics['last_7_days'].toString(),
                  color: Colors.green,
                ),
                StatItem(
                  icon: Icons.calendar_month,
                  label: 'Last 30 Days',
                  value: statistics['last_30_days'].toString(),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

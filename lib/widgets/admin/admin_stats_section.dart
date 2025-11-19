import 'package:flutter/material.dart';
import 'admin_stat_card.dart';

/// Quick Stats section for admin dashboard
class AdminStatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;

  const AdminStatsSection({
    required this.stats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            AdminStatCard(
              title: 'Total Entries',
              value: stats['total_entries']?.toString() ?? '0',
              icon: Icons.analytics,
              color: Colors.blue,
            ),
            AdminStatCard(
              title: 'Active Users',
              value: stats['active_users']?.toString() ?? '0',
              icon: Icons.people,
              color: Colors.green,
            ),
            AdminStatCard(
              title: 'Cache Hit Rate',
              value: '${(stats['cache_hit_rate'] ?? 0.0).toStringAsFixed(1)}%',
              icon: Icons.memory,
              color: Colors.orange,
            ),
            AdminStatCard(
              title: 'Avg Response',
              value: '${(stats['avg_response_time'] ?? 0.0).toStringAsFixed(0)}ms',
              icon: Icons.speed,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

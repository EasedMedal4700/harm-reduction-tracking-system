import 'package:flutter/material.dart';
import 'admin_stat_card.dart';

/// Quick Stats section for admin dashboard
class AdminStatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final Map<String, dynamic> perfStats;
  final Map<String, dynamic> cacheStats;

  const AdminStatsSection({
    required this.stats,
    required this.perfStats,
    required this.cacheStats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cache hit rate from perfStats
    final cacheHitRate = perfStats['cache_hit_rate'] ?? 0.0;
    final avgResponseTime = perfStats['avg_response_time'] ?? 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Use 1 column if width < 500, otherwise 2 columns
            final crossAxisCount = constraints.maxWidth < 500 ? 1 : 2;
            final aspectRatio = constraints.maxWidth < 500 ? 3.5 : 1.6;
            
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
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
              value: '${cacheHitRate.toStringAsFixed(1)}%',
              icon: Icons.memory,
              color: Colors.orange,
              subtitle: '${perfStats['cache_hits'] ?? 0} hits',
            ),
            AdminStatCard(
              title: 'Avg Response',
              value: '${avgResponseTime.toStringAsFixed(0)}ms',
              icon: Icons.speed,
              color: Colors.purple,
              subtitle: '${perfStats['total_samples'] ?? 0} samples',
            ),
          ],
            );
          },
        ),
      ],
    );
  }
}

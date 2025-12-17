
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
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
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    final t = context.theme;

    // Extract stats safely
    final cacheHitRate = (perfStats['cache_hit_rate'] ?? 0.0).toDouble();
    final avgResponseTime =
        (perfStats['avg_response_time'] ?? 0.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Quick Stats',
          style: text.heading3.copyWith(color: c.textPrimary),
        ),

        SizedBox(height: sp.lg),

        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 500;
            final crossAxisCount = isNarrow ? 1 : 2;
            final aspectRatio = isNarrow ? 3.5 : 1.6;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: sp.md,
              crossAxisSpacing: sp.md,
              childAspectRatio: aspectRatio,
              children: [
                AdminStatCard(
                  title: 'Total Entries',
                  value: stats['total_entries']?.toString() ?? '0',
                  icon: Icons.analytics,
                  color: c.info, // replaced hardcoded blue
                ),
                AdminStatCard(
                  title: 'Active Users',
                  value: stats['active_users']?.toString() ?? '0',
                  icon: Icons.people,
                  color: c.success, // replaced green
                ),
                AdminStatCard(
                  title: 'Cache Hit Rate',
                  value: '${cacheHitRate.toStringAsFixed(1)}%',
                  icon: Icons.memory,
                  color: c.warning, // replaced orange
                  subtitle: '${perfStats['cache_hits'] ?? 0} hits',
                ),
                AdminStatCard(
                  title: 'Avg Response',
                  value: '${avgResponseTime.toStringAsFixed(0)}ms',
                  icon: Icons.speed,
                  color: t.accent.secondary, // replaced purple
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

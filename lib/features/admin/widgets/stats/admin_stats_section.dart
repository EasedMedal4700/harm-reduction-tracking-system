// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import '../../models/admin_performance_stats.dart';
import '../../models/admin_system_stats.dart';
import 'admin_stat_card.dart';

/// Quick Stats section for admin dashboard
class AdminStatsSection extends StatelessWidget {
  final AdminSystemStats stats;
  final AdminPerformanceStats perfStats;
  const AdminStatsSection({
    required this.stats,
    required this.perfStats,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final cacheHitRate = perfStats.cacheHitRate;
    final avgResponseTime = perfStats.avgResponseTimeMs;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        // Header
        Text('Quick Stats', style: tx.heading3.copyWith(color: c.textPrimary)),
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
                  value: stats.totalEntries.toString(),
                  icon: Icons.analytics,
                  color: c.info, // replaced hardcoded blue
                ),
                AdminStatCard(
                  title: 'Active Users',
                  value: stats.activeUsers.toString(),
                  icon: Icons.people,
                  color: c.success, // replaced green
                ),
                AdminStatCard(
                  title: 'Cache Hit Rate',
                  value: '${cacheHitRate.toStringAsFixed(1)}%',
                  icon: Icons.memory,
                  color: c.warning, // replaced orange
                  subtitle: '${perfStats.cacheHits} hits',
                ),
                AdminStatCard(
                  title: 'Avg Response',
                  value: '${avgResponseTime.toStringAsFixed(0)}ms',
                  icon: Icons.speed,
                  color: th.accent.secondary, // replaced purple
                  subtitle: '${perfStats.totalSamples} samples',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

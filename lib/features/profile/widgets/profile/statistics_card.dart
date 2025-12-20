// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme system. No deprecated constants remain.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'stat_item.dart';

class StatisticsCard extends StatelessWidget {
  final Map<String, int> statistics;

  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Activity Statistics',
            style: t.text.heading3,
          ),
          SizedBox(height: t.spacing.lg),

          Row(
            mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceAround,
            children: [
              StatItem(
                icon: Icons.medication,
                label: 'Total Entries',
                value: statistics['total_entries'].toString(),
                accent: t.accent.primary, // Accent from theme
              ),
              StatItem(
                icon: Icons.calendar_today,
                label: 'Last 7 Days',
                value: statistics['last_7_days'].toString(),
                accent: t.colors.success, // Green from palette
              ),
              StatItem(
                icon: Icons.calendar_month,
                label: 'Last 30 Days',
                value: statistics['last_30_days'].toString(),
                accent: t.colors.warning, // Orange from palette
              ),
            ],
          ),
        ],
      ),
    );
  }
}

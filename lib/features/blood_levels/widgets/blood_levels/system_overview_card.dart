// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new AppTheme system.

import 'package:flutter/material.dart';
import '../../../../services/blood_levels_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// System overview card showing global PK state metrics.
class SystemOverviewCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;
  final Map<String, DrugLevel> allLevels;

  const SystemOverviewCard({
    required this.levels,
    required this.allLevels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final acc = context.accent;

    final activeCount = levels.length;
    final strongEffects =
        levels.values.where((l) => l.percentage > 20).length;
    final totalDose =
        levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);

    // Recent doses within 24h (from full dataset)
    final now = DateTime.now();
    final recentCount = allLevels.values.fold<int>(0, (sum, level) {
      final count = level.doses
          .where((dose) => now.difference(dose.startTime).inHours < 24)
          .length;
      return sum + count;
    });

    return Container(
      margin: EdgeInsets.all(sp.lg),
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border, width: 1),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Row(
            children: [
              Icon(Icons.analytics, size: 20, color: acc.primary),
              SizedBox(width: sp.sm),
              Text('System Overview', style: text.heading4),
            ],
          ),

          SizedBox(height: sp.lg),

          // FOUR STAT CARDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                label: 'Active\nSubstances',
                value: '$activeCount',
                color: c.info,
                icon: Icons.science,
                context: context,
              ),
              _buildStatCard(
                label: 'Strong\nEffects',
                value: '$strongEffects',
                color: c.warning,
                icon: Icons.warning_amber,
                context: context,
              ),
              _buildStatCard(
                label: 'Recent\nDoses',
                value: '$recentCount',
                color: acc.secondary,
                icon: Icons.schedule,
                context: context,
              ),
              _buildStatCard(
                label: 'Total\nDose',
                value: '${totalDose.toStringAsFixed(1)}u',
                color: c.error,
                icon: Icons.scale,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) {
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(sh.radiusSm),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: sp.sm),
        Text(
          value,
          style: text.heading3.copyWith(color: color),
        ),
        SizedBox(height: sp.xs),
        Text(
          label,
          style: text.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../models/blood_levels_models.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';

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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final ac = context.accent;
    final activeCount = levels.length;
    final strongEffects = levels.values.where((l) => l.percentage > 20).length;
    final totalDose = levels.values.fold<double>(
      0.0,
      (sum, l) => sum + l.totalRemaining,
    );
    // Recent doses within 24h (from full dataset)
    final now = DateTime.now();
    final recentCount = allLevels.values.fold<int>(0, (sum, level) {
      final count = level.doses
          .where((dose) => now.difference(dose.startTime).inHours < 24)
          .length;
      return sum + count;
    });
    return Padding(
      padding: EdgeInsets.all(sp.lg),
      child: CommonCard(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            // HEADER ROW
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  size: context.sizes.iconSm,
                  color: ac.primary,
                ),
                SizedBox(width: sp.sm),
                Text('System Overview', style: tx.heading4),
              ],
            ),
            SizedBox(height: sp.lg),
            // FOUR STAT CARDS
            Row(
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceAround,
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
                  color: ac.secondary,
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
    final tx = context.text;
    final sp = context.spacing;

    final sh = context.shapes;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(sh.radiusSm),
          ),
          child: Icon(icon, color: color, size: context.sizes.iconSm),
        ),
        SizedBox(height: sp.sm),
        Text(value, style: tx.heading3.copyWith(color: color)),
        SizedBox(height: sp.xs),
        Text(label, style: tx.caption, textAlign: AppLayout.textAlignCenter),
      ],
    );
  }
}

// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/theme/app_theme_extension.dart';

/// System overview card showing key metrics
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
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.theme;
    final acc = context.accent;
    
    final activeCount = levels.length;
    final strongEffects = levels.values.where((l) => l.percentage > 20).length;
    final totalDose = levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);
    
    // Get recent doses (24h) from full dataset
    final now = DateTime.now();
    final recentCount = allLevels.values.fold<int>(0, (sum, level) {
      return sum + level.doses.where((dose) => 
        now.difference(dose.startTime).inHours < 24
      ).length;
    });

    return Container(
      margin: EdgeInsets.all(sp.lg),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                size: 20,
                color: acc.primary,
              ),
              SizedBox(width: sp.sm),
              Text(
                'System Overview',
                style: context.text.heading4,
              ),
            ],
          ),
          SizedBox(height: sp.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Active\nSubstances', '$activeCount', c.info, Icons.science, context),
              _buildStatCard('Strong\nEffects', '$strongEffects', c.warning, Icons.warning_amber, context),
              _buildStatCard('Recent\nDoses', '$recentCount', acc.secondary, Icons.schedule, context),
              _buildStatCard('Total\nDose', '${totalDose.toStringAsFixed(1)}u', c.error, Icons.scale, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon, BuildContext context) {
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

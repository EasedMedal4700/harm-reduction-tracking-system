import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../models/tolerance_model.dart';

class ToleranceStatsCard extends StatelessWidget {
  final ToleranceModel toleranceModel;
  final double daysUntilBaseline;
  final int recentUseCount;

  const ToleranceStatsCard({
    required this.toleranceModel,
    required this.daysUntilBaseline,
    required this.recentUseCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.cardPadding),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key metrics',
            style: t.typography.heading4.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          SizedBox(height: t.spacing.lg),

          // TWO COLUMN GRID
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricItem(
                      context,
                      label: 'Half-life',
                      value: '${toleranceModel.halfLifeHours}h',
                      icon: Icons.timelapse,
                    ),
                    SizedBox(height: t.spacing.lg),
                    _metricItem(
                      context,
                      label: 'Days to baseline',
                      value: daysUntilBaseline <= 0
                          ? 'Baseline'
                          : '${daysUntilBaseline.toStringAsFixed(1)} days',
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),

              // DIVIDER
              Container(
                width: 1,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: t.spacing.lg),
                color: t.colors.divider,
              ),

              // RIGHT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricItem(
                      context,
                      label: 'Tolerance decay',
                      value: '${toleranceModel.toleranceDecayDays} days',
                      icon: Icons.trending_down,
                    ),
                    SizedBox(height: t.spacing.lg),
                    _metricItem(
                      context,
                      label: 'Recent uses',
                      value: '$recentUseCount',
                      icon: Icons.history,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // METRIC ROW BUILDER
  // ---------------------------------------------------------------------------
  Widget _metricItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final t = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: t.colors.textSecondary),
            SizedBox(width: t.spacing.xs),
            Text(
              label,
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 22),
          child: Text(
            value,
            style: t.typography.bodyBold.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

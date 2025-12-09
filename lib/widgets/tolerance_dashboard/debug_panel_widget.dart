// MIGRATION
import 'package:flutter/material.dart';

import '../../models/bucket_definitions.dart';
import '../../utils/tolerance_calculator.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme_constants.dart';

class DebugPanelWidget extends StatelessWidget {
  final ToleranceResult? systemTolerance;
  final ToleranceResult? substanceTolerance;
  final String? selectedSubstance;
  final bool isDark;

  const DebugPanelWidget({
    super.key,
    required this.systemTolerance,
    required this.substanceTolerance,
    required this.selectedSubstance,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final system = systemTolerance;
    final substance = substanceTolerance;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        border: Border.all(
          color: t.colors.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Tolerance engine debug',
            style: t.typography.heading4.copyWith(
              color: t.colors.textPrimary,
            ),
          ),

          SizedBox(height: t.spacing.sm),

          // System line
          if (system != null)
            Text(
              'System → score: ${system.toleranceScore.toStringAsFixed(1)} • baseline: ${system.overallDaysUntilBaseline} days',
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
              ),
            ),

          // Substance line
          if (substance != null && selectedSubstance != null) ...[
            SizedBox(height: t.spacing.xs),
            Text(
              'Substance "$selectedSubstance" → score: ${substance.toleranceScore.toStringAsFixed(1)} • baseline: ${substance.overallDaysUntilBaseline} days',
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
          ],

          SizedBox(height: t.spacing.md),

          // Bucket title
          Text(
            'Bucket percents:',
            style: t.typography.bodyBold.copyWith(
              color: t.colors.textPrimary,
            ),
          ),

          SizedBox(height: t.spacing.xs),

          // Bucket list
          if (system != null)
            Wrap(
              spacing: t.spacing.sm,
              runSpacing: 4,
              children: [
                for (final bucket in BucketDefinitions.orderedBuckets)
                  Text(
                    '$bucket: ${(system.bucketPercents[bucket] ?? 0).toStringAsFixed(1)}%',
                    style: t.typography.caption.copyWith(
                      color: t.colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

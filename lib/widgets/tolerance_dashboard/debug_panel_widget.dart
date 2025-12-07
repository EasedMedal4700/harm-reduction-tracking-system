import 'package:flutter/material.dart';

import '../../models/bucket_definitions.dart';
import '../../utils/tolerance_calculator.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

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
    final system = systemTolerance;
    final substance = substanceTolerance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tolerance engine debug',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          if (system != null) ...[
            Text(
              'System: score=${system.toleranceScore.toStringAsFixed(1)} • daysToBaseline=${system.overallDaysUntilBaseline}',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ],
          if (substance != null && selectedSubstance != null) ...[
            const SizedBox(height: ThemeConstants.space4),
            Text(
              'Substance $selectedSubstance: score=${substance.toleranceScore.toStringAsFixed(1)} • daysToBaseline=${substance.overallDaysUntilBaseline}',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ],
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'Bucket percents:',
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: 4),
          if (system != null)
            Wrap(
              spacing: ThemeConstants.space8,
              runSpacing: 4,
              children: [
                for (final bucket in BucketDefinitions.orderedBuckets)
                  Text(
                    '$bucket: ${(system.bucketPercents[bucket] ?? 0).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
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

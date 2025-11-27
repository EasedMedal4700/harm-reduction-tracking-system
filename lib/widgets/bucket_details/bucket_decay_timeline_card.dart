import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import 'bucket_utils.dart';

/// Card showing the decay timeline with a visual progress bar
class BucketDecayTimelineCard extends StatelessWidget {
  final double tolerancePercent;
  final bool isDark;

  const BucketDecayTimelineCard({
    super.key,
    required this.tolerancePercent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Decay Timeline',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          _buildDecayBar(),
          SizedBox(height: ThemeConstants.space12),
          Text(
            tolerancePercent > 0.1
                ? 'Substance is currently active in your system. Tolerance will continue to build.'
                : 'Substance is no longer active. Tolerance is decaying naturally.',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecayBar() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: tolerancePercent.round().clamp(0, 100),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color:
                      BucketUtils.getColorForTolerance(tolerancePercent / 100.0),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(ThemeConstants.radiusSmall),
                    right: tolerancePercent >= 100.0
                        ? Radius.circular(ThemeConstants.radiusSmall)
                        : Radius.zero,
                  ),
                ),
              ),
            ),
            if (tolerancePercent < 100.0)
              Expanded(
                flex: (100.0 - tolerancePercent).round().clamp(0, 100),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(ThemeConstants.radiusSmall),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ThemeConstants.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import 'bucket_utils.dart';

/// Card listing recent uses that contribute to current tolerance
class BucketContributingUsesCard extends StatelessWidget {
  final List<UseLogEntry> contributingUses;
  final bool isDark;

  const BucketContributingUsesCard({
    super.key,
    required this.contributingUses,
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
            'Contributing Uses',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          ...contributingUses.take(10).map((use) {
            final timeAgo = DateTime.now().difference(use.timestamp);
            return Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BucketUtils.formatTimeAgo(timeAgo),
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '${use.doseUnits.toStringAsFixed(1)} units',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: ThemeConstants.fontMediumWeight,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (contributingUses.length > 10)
            Text(
              '...and ${contributingUses.length - 10} more',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
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
}

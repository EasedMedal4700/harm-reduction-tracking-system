import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import 'bucket_utils.dart';

/// Header card showing bucket icon, name, and current tolerance level
class BucketHeaderCard extends StatelessWidget {
  final String bucketType;
  final double tolerancePercent;
  final bool isDark;

  const BucketHeaderCard({
    super.key,
    required this.bucketType,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ThemeConstants.space12),
            decoration: BoxDecoration(
              color: BucketUtils.getColorForTolerance(tolerancePercent / 100.0)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            ),
            child: Icon(
              BucketUtils.getBucketIcon(bucketType),
              color: BucketUtils.getColorForTolerance(tolerancePercent / 100.0),
              size: 32,
            ),
          ),
          SizedBox(width: ThemeConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BucketDefinitions.getDisplayName(bucketType),
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Text(
                  '${tolerancePercent.toStringAsFixed(1)}% Tolerance',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: BucketUtils.getColorForTolerance(
                        tolerancePercent / 100.0),
                  ),
                ),
              ],
            ),
          ),
          if (tolerancePercent > 0.1)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space12,
                vertical: ThemeConstants.space8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              ),
              child: Text(
                'ACTIVE',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontBold,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

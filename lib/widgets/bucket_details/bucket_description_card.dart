import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Card displaying information about the bucket system
class BucketDescriptionCard extends StatelessWidget {
  final String bucketType;
  final bool isDark;

  const BucketDescriptionCard({
    super.key,
    required this.bucketType,
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
            'About This System',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

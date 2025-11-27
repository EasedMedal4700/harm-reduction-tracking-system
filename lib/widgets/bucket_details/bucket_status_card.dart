import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Card displaying current bucket status with various metrics
class BucketStatusCard extends StatelessWidget {
  final NeuroBucket bucket;
  final double tolerancePercent;
  final double rawLoad;
  final bool isDark;

  const BucketStatusCard({
    super.key,
    required this.bucket,
    required this.tolerancePercent,
    required this.rawLoad,
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
            'Current Status',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          _buildStatRow('Tolerance Level',
              '${tolerancePercent.toStringAsFixed(1)}%'),
          _buildStatRow('Raw Load', rawLoad.toStringAsFixed(4)),
          _buildStatRow('Bucket Weight', bucket.weight.toStringAsFixed(2)),
          _buildStatRow('Tolerance Type', bucket.toleranceType ?? 'unknown'),
          _buildStatRow('Status', tolerancePercent > 0.1 ? 'Active' : 'Inactive'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeConstants.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

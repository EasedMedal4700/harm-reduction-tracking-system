import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

/// Card widget displaying a single neurochemical bucket's system-wide tolerance
/// 
/// Shows:
/// - Bucket icon and name (e.g., "Stimulant", "GABA")
/// - Current tolerance percentage (system-wide across all substances)
/// - Status badge (Recovered, Light Stress, Moderate, High, Depleted)
/// - Active indicator if any substance is currently active in this bucket
class SystemBucketCard extends StatelessWidget {
  final String bucketType;
  final double tolerancePercent;
  final ToleranceSystemState state;
  final bool isActive;
  final bool isSelected;
  final VoidCallback onTap;

  const SystemBucketCard({
    super.key,
    required this.bucketType,
    required this.tolerancePercent,
    required this.state,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  Color _getStateColor(ToleranceSystemState state) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return Colors.green;
      case ToleranceSystemState.lightStress:
        return Colors.blue;
      case ToleranceSystemState.moderateStrain:
        return Colors.orange;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrange;
      case ToleranceSystemState.depleted:
        return Colors.red;
    }
  }

  IconData _getBucketIcon() {
    final iconName = BucketDefinitions.getIconName(bucketType);
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'bolt':
        return Icons.bolt;
      case 'favorite':
        return Icons.favorite;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'sentiment_satisfied_alt':
        return Icons.sentiment_satisfied_alt;
      case 'medication':
        return Icons.medication;
      case 'blur_on':
        return Icons.blur_on;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.science;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stateColor = _getStateColor(state);

    return Card(
      elevation: isSelected ? 4 : 1,
      margin: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space8,
        vertical: ThemeConstants.space4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        side: BorderSide(
          color: isSelected
              ? stateColor
              : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        child: Container(
          padding: EdgeInsets.all(ThemeConstants.space12),
          width: 140,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                _getBucketIcon(),
                size: 32,
                color: stateColor,
              ),
              SizedBox(height: ThemeConstants.space8),

              // Bucket name
              Text(
                BucketDefinitions.getDisplayName(bucketType),
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ThemeConstants.space8),

              // Tolerance percentage
              Text(
                '${tolerancePercent.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontBold,
                  color: stateColor,
                ),
              ),
              SizedBox(height: ThemeConstants.space8),

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space8,
                  vertical: ThemeConstants.space4,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: stateColor.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  state.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: ThemeConstants.fontMediumWeight,
                    color: stateColor,
                  ),
                ),
              ),

              // Active indicator
              if (isActive) ...[
                SizedBox(height: ThemeConstants.space4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: ThemeConstants.fontBold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

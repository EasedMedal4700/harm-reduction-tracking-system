// MIGRATION
import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme.dart';

/// Card widget displaying a single neurochemical bucket's system-wide tolerance
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

  // NEW: State → color
  Color _getStateColor(ToleranceSystemState state, ColorPalette c) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return c.success;
      case ToleranceSystemState.lightStress:
        return c.info;
      case ToleranceSystemState.moderateStrain:
        return c.warning;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrangeAccent;
      case ToleranceSystemState.depleted:
        return c.error;
    }
  }

  IconData _getBucketIcon() {
    switch (BucketDefinitions.getIconName(bucketType)) {
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
    final t = context.theme;
    final c = context.colors;

    final stateColor = _getStateColor(state, c);

    return Container(
      width: 145,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(
          color: isSelected ? stateColor : c.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? t.cardShadowHovered : t.cardShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(t.spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getBucketIcon(), size: 32, color: stateColor),
              SizedBox(height: t.spacing.sm),

              // Bucket name
              Text(
                BucketDefinitions.getDisplayName(bucketType),
                style: t.typography.bodyBold.copyWith(
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: t.spacing.sm),

              // Tolerance percentage
              Text(
                '${tolerancePercent.toStringAsFixed(1)}%',
                style: t.typography.heading3.copyWith(
                  color: stateColor,
                ),
              ),

              SizedBox(height: t.spacing.sm),

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: t.spacing.sm,
                  vertical: t.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: stateColor.withOpacity(0.35),
                    width: 1,
                  ),
                ),
                child: Text(
                  state.displayName,
                  style: t.typography.captionBold.copyWith(
                    color: stateColor,
                  ),
                ),
              ),

              if (isActive) ...[
                SizedBox(height: t.spacing.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: t.spacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.info.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: t.typography.captionBold.copyWith(
                      color: c.info,
                      fontSize: 10,
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

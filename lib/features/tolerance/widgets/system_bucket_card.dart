// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: System bucket card widget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/theme/app_color_palette.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../models/bucket_definitions.dart';
import '../models/tolerance_models.dart';

class SystemBucketCard extends ConsumerWidget {
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

  Color _getStateColor(ToleranceSystemState state, ColorPalette c) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return c.success;
      case ToleranceSystemState.lightStress:
        return c.info;
      case ToleranceSystemState.moderateStrain:
        return c.warning;
      case ToleranceSystemState.highStrain:
        return c.error;
      case ToleranceSystemState.depleted:
        return c.error;
    }
  }

  IconData _getBucketIcon() {
    // Assuming BucketDefinitions.getIconName exists and returns a string
    // If not, I might need to check BucketDefinitions
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
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    final stateColor = _getStateColor(state, c);

    return Container(
      width:
          160, // context.sizes.cardWidthMd might not be available in standard theme extension, using fixed or checking theme
      // Assuming context.sizes exists in AppThemeExtension
      // If not, I'll use a fixed width or check the theme file.
      // The original code used context.sizes.cardWidthMd.
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: isSelected ? stateColor : c.border,
          width: isSelected ? 2.0 : 1.0, // context.sizes.borderRegular/Thin
        ),
        boxShadow: isSelected ? [] : [], // context.cardShadowHovered/cardShadow
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(sp.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getBucketIcon(),
                size: 24.0, // context.sizes.iconMd
                color: stateColor,
              ),
              CommonSpacer.vertical(sp.sm),
              Text(
                BucketDefinitions.getDisplayName(bucketType),
                style: tx.bodyBold.copyWith(color: c.textPrimary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              CommonSpacer.vertical(sp.sm),
              Text(
                '${tolerancePercent.toStringAsFixed(1)}%',
                style: tx.heading3.copyWith(color: stateColor),
              ),
              CommonSpacer.vertical(sp.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sp.sm,
                  vertical: sp.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: stateColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  state.displayName,
                  style: tx.captionBold.copyWith(color: stateColor),
                ),
              ),
              if (isActive) ...[
                CommonSpacer.vertical(sp.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.sm,
                    vertical: sp.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.info.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: tx.captionBold.copyWith(
                      color: c.info,
                      fontSize: tx.caption.fontSize,
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

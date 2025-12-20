// System Bucket Card Widget
// 
// Created: 2024-11-10
// Last Modified: 2025-12-14
// 
// Purpose:
// Displays a single neurochemical bucket's tolerance state in a compact card format.
// Shows tolerance percentage, system state, active status, and provides tap interaction.
// Used in horizontal scrolling lists to show all bucket states at once.
// 
// Features:
// - Visual state indicators with color-coding
// - Tolerance percentage display
// - Active substance indicator
// - Selection highlighting
// - Icon representation for each bucket type
// - Tap-to-select interaction

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../models/tolerance_model.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/theme/app_color_palette.dart';
import '../../../../common/layout/common_spacer.dart';


/// Card widget displaying a single neurochemical bucket's system-wide tolerance
/// 
/// Visual compact representation of a bucket's current state including:
/// - Tolerance percentage
/// - Color-coded system state
/// - Active/inactive status
/// - Selection state
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
        return c.error;
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
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    final stateColor = _getStateColor(state, colors);

    return Container(
      width: context.sizes.cardWidthMd,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(
          color: isSelected ? stateColor : colors.border,
          width: isSelected ? context.sizes.borderRegular : context.sizes.borderThin,
        ),
        boxShadow: isSelected ? context.cardShadowHovered : context.cardShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(spacing.sm),
          child: Column(
            mainAxisSize: AppLayout.mainAxisSizeMin,
            children: [
              // Bucket icon with state color
              Icon(_getBucketIcon(), size: context.sizes.iconMd, color: stateColor),
              CommonSpacer.vertical(spacing.sm),

              // Bucket name
              Text(
                BucketDefinitions.getDisplayName(bucketType),
                style: typography.bodyBold.copyWith(
                  color: colors.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
                maxLines: 2,
                overflow: AppLayout.textOverflowEllipsis,
              ),

              CommonSpacer.vertical(spacing.sm),

              // Tolerance percentage with state color
              Text(
                '${tolerancePercent.toStringAsFixed(1)}%',
                style: typography.heading3.copyWith(
                  color: stateColor,
                ),
              ),

              CommonSpacer.vertical(spacing.sm),

              // Status badge showing current system state
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(radii.radiusMd),
                  border: Border.all(
                    color: stateColor.withValues(alpha: 0.35),
                    width: context.sizes.borderThin,
                  ),
                ),
                child: Text(
                  state.displayName,
                  style: typography.captionBold.copyWith(
                    color: stateColor,
                  ),
                ),
              ),

              // Active indicator badge (shown when substances are actively affecting this bucket)
              if (isActive) ...[
                CommonSpacer.vertical(spacing.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.info.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(radii.radiusSm),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: typography.captionBold.copyWith(
                      color: colors.info,
                      fontSize: context.text.caption.fontSize,
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


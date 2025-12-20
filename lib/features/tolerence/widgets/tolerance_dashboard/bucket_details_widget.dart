// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../utils/tolerance_calculator.dart';
import '../bucket_details/bucket_utils.dart';

class BucketDetailsWidget extends ConsumerWidget {
  final String bucketType;
  final double tolerancePercent;
  final Map<String, double> substanceContributions;
  final VoidCallback onClose;

  const BucketDetailsWidget({
    super.key,
    required this.bucketType,
    required this.tolerancePercent,
    required this.substanceContributions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    final bucketName = BucketDefinitions.getDisplayName(bucketType);
    final state = ToleranceCalculator.classifyState(tolerancePercent);
    final stateColor = BucketUtils.toleranceColor(
      context,
      tolerancePercent / 100.0,
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(color: colors.border),
      ),
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          // HEADER with close button
          Row(
            children: [
              Icon(
                BucketUtils.getBucketIcon(bucketType),
                color: context.accent.primary,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(spacing.sm),
              Expanded(
                child: Text(
                  bucketName,
                  style: typography.heading3.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          CommonSpacer.vertical(spacing.md),

          // TOLERANCE LEVEL
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(radii.radiusSm),
              border: Border.all(color: stateColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                    children: [
                      Text(
                        'Tolerance Level',
                        style: typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      CommonSpacer.vertical(spacing.xs),
                      Text(
                        '${tolerancePercent.toStringAsFixed(1)}%',
                        style: typography.heading2.copyWith(
                          color: stateColor,
                          fontWeight: context.text.bodyBold.fontWeight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: stateColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(radii.radiusXs),
                  ),
                  child: Text(
                    state.name.toUpperCase(),
                    style: typography.label.copyWith(
                      color: stateColor,
                      fontWeight: context.text.bodyBold.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          CommonSpacer.vertical(spacing.lg),

          // SUBSTANCE CONTRIBUTIONS
          Text(
            'Active Substances',
            style: typography.bodyLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: context.text.bodyBold.fontWeight,
            ),
          ),

          CommonSpacer.vertical(spacing.sm),

          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Text(
                'No active substances in this system',
                style: typography.body.copyWith(
                  color: colors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...substanceContributions.entries.map((entry) {
              final percentage = (entry.value * 100).clamp(0.0, 100.0);
              return Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: _SubstanceContributionRow(
                  substanceName: entry.key,
                  percentage: percentage,
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _SubstanceContributionRow extends ConsumerWidget {
  final String substanceName;
  final double percentage;

  const _SubstanceContributionRow({
    required this.substanceName,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(radii.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  substanceName,
                  style: typography.body.copyWith(color: colors.textPrimary),
                ),
                CommonSpacer.vertical(spacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radii.radiusXs),
                  child: LinearProgressIndicator(
                    value: percentage / 100.0,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.accent.primary,
                    ),
                    minHeight: 6.0,
                  ),
                ),
              ],
            ),
          ),
          CommonSpacer.horizontal(spacing.sm),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: typography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: context.text.bodyBold.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    final bucketName = BucketDefinitions.getDisplayName(bucketType);
    final state = ToleranceCalculator.classifyState(tolerancePercent);
    final stateColor = BucketUtils.toleranceColor(
      context,
      tolerancePercent / 100.0,
    );
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border),
      ),
      padding: EdgeInsets.all(sp.lg),
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
              CommonSpacer.horizontal(sp.sm),
              Expanded(
                child: Text(
                  bucketName,
                  style: tx.heading3.copyWith(color: c.textPrimary),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: c.textSecondary),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          // TOLERANCE LEVEL
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: c.surfaceVariant,
              borderRadius: BorderRadius.circular(sh.radiusSm),
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
                        style: tx.bodySmall.copyWith(color: c.textSecondary),
                      ),
                      CommonSpacer.vertical(sp.xs),
                      Text(
                        '${tolerancePercent.toStringAsFixed(1)}%',
                        style: tx.heading2.copyWith(
                          color: stateColor,
                          fontWeight: tx.bodyBold.fontWeight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.sm,
                    vertical: sp.xs,
                  ),
                  decoration: BoxDecoration(
                    color: stateColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(sh.radiusXs),
                  ),
                  child: Text(
                    state.name.toUpperCase(),
                    style: tx.label.copyWith(
                      color: stateColor,
                      fontWeight: tx.bodyBold.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(sp.lg),
          // SUBSTANCE CONTRIBUTIONS
          Text(
            'Active Substances',
            style: tx.bodyLarge.copyWith(
              color: c.textPrimary,
              fontWeight: tx.bodyBold.fontWeight,
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.all(sp.md),
              child: Text(
                'No active substances in this system',
                style: tx.body.copyWith(
                  color: c.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...substanceContributions.entries.map((entry) {
              final percentage = (entry.value * 100).clamp(0.0, 100.0);
              return Padding(
                padding: EdgeInsets.only(bottom: sp.sm),
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.sm),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(sh.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  substanceName,
                  style: tx.body.copyWith(color: c.textPrimary),
                ),
                CommonSpacer.vertical(sp.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(sh.radiusXs),
                  child: LinearProgressIndicator(
                    value: percentage / 100.0,
                    backgroundColor: c.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.accent.primary,
                    ),
                    minHeight: 6.0,
                  ),
                ),
              ],
            ),
          ),
          CommonSpacer.horizontal(sp.sm),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: tx.body.copyWith(
              color: c.textPrimary,
              fontWeight: tx.bodyBold.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

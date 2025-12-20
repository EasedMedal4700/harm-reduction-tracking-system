// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import '../../../../models/bucket_definitions.dart';
import 'bucket_utils.dart';

/// Header card showing bucket icon, name, and current tolerance level
class BucketHeaderCard extends StatelessWidget {
  final String bucketType;
  final double tolerancePercent;

  const BucketHeaderCard({
    super.key,
    required this.bucketType,
    required this.tolerancePercent,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final bucketColor = BucketUtils.getColorForTolerance(
      context,
      tolerancePercent / 100,
    );
    final isActive = tolerancePercent > 0.1;

    return CommonCard(
      child: Row(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(sp.sm),
            decoration: BoxDecoration(
              color: bucketColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            child: Icon(
              BucketUtils.getBucketIcon(bucketType),
              color: bucketColor,
              size: context.sizes.iconXl,
            ),
          ),

          CommonSpacer.horizontal(sp.md),

          // Title + tolerance display
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  BucketDefinitions.getDisplayName(bucketType),
                  style: text.titleSmall.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                ),

                CommonSpacer.vertical(sp.xs),

                Text(
                  '${tolerancePercent.toStringAsFixed(1)}% Tolerance',
                  style: text.body.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                    color: bucketColor,
                  ),
                ),
              ],
            ),
          ),

          // ACTIVE badge (theme-aware)
          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(sh.radiusSm),
              ),
              child: Text(
                'ACTIVE',
                style: text.bodySmall.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.warning,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

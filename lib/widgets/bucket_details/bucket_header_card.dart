
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../models/bucket_definitions.dart';
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

    final bucketColor = BucketUtils.getColorForTolerance(context, tolerancePercent / 100);
    final isActive = tolerancePercent > 0.1;

    return CommonCard(
      child: Row(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(sp.sm),
            decoration: BoxDecoration(
              color: bucketColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(sp.radiusMd),
            ),
            child: Icon(
              BucketUtils.getBucketIcon(bucketType),
              color: bucketColor,
              size: 32,
            ),
          ),

          SizedBox(width: sp.md),

          // Title + tolerance display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BucketDefinitions.getDisplayName(bucketType),
                  style: text.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: c.text,
                  ),
                ),

                SizedBox(height: sp.xs),

                Text(
                  '${tolerancePercent.toStringAsFixed(1)}% Tolerance',
                  style: text.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: bucketColor,
                  ),
                ),
              ],
            ),
          ),

          // ACTIVE badge (theme-aware)
          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sp.sm,
                vertical: sp.xs,
              ),
              decoration: BoxDecoration(
                color: c.warning.withOpacity(0.18),
                borderRadius: BorderRadius.circular(sp.radiusSm),
              ),
              child: Text(
                'ACTIVE',
                style: text.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.warning,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


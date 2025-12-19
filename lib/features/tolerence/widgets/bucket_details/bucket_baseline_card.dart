
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Card showing days until tolerance returns to baseline
class BucketBaselineCard extends StatelessWidget {
  final double daysToBaseline;

  const BucketBaselineCard({
    super.key,
    required this.daysToBaseline,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Row(
        children: [
          Icon(Icons.schedule, color: c.textSecondary, size: context.sizes.iconMd),

          CommonSpacer.horizontal(sp.sm),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Days to Baseline',
                  style: text.bodySmall.copyWith(color: c.textSecondary),
                ),

                CommonSpacer.vertical(sp.xs),

                Text(
                  daysToBaseline < 0.1
                      ? 'At baseline'
                      : '${daysToBaseline.toStringAsFixed(1)} days',
                  style: text.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


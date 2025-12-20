// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'bucket_utils.dart';

/// Card showing the decay timeline with a visual progress bar
class BucketDecayTimelineCard extends StatelessWidget {
  final double tolerancePercent; // 0–100

  const BucketDecayTimelineCard({super.key, required this.tolerancePercent});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Decay Timeline',
            style: text.body.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),

          CommonSpacer.vertical(sp.md),

          _buildDecayBar(context),

          CommonSpacer.vertical(sp.sm),

          Text(
            tolerancePercent > 0.1
                ? 'Substance is currently active in your system. Tolerance will continue to build.'
                : 'Substance is no longer active. Tolerance is decaying naturally.',
            style: text.bodySmall.copyWith(
              color: c.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Progress bar + labels
  Widget _buildDecayBar(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sh = context.shapes;
    final sp = context.spacing;

    final activeFlex = tolerancePercent.round().clamp(0, 100);
    final remainingFlex = (100 - tolerancePercent).round().clamp(0, 100);

    return Column(
      children: [
        // Progress bar
        Row(
          children: [
            // ACTIVE PART
            Expanded(
              flex: activeFlex,
              child: Container(
                height: sp.md,
                decoration: BoxDecoration(
                  color: BucketUtils.getColorForTolerance(
                    context,
                    tolerancePercent / 100,
                  ),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(sh.radiusSm),
                    right: tolerancePercent >= 100
                        ? Radius.circular(sh.radiusSm)
                        : Radius.zero,
                  ),
                ),
              ),
            ),

            // REMAINING PART
            if (remainingFlex > 0)
              Expanded(
                flex: remainingFlex,
                child: Container(
                  height: sp.md,
                  decoration: BoxDecoration(
                    color: c.border, // matches theme border color
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(sh.radiusSm),
                    ),
                  ),
                ),
              ),
          ],
        ),

        CommonSpacer.vertical(sp.xs),

        // Percentage labels
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text('0%', style: text.overline.copyWith(color: c.textSecondary)),
            Text('100%', style: text.overline.copyWith(color: c.textSecondary)),
          ],
        ),
      ],
    );
  }
}

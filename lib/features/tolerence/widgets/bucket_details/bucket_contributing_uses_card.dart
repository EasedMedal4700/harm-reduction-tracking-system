// MIGRATION:
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: UI-only card. Displays aggregated tolerance contributions per substance.
//        Uses ToleranceContribution instead of raw UseLogEntry.

import 'package:flutter/material.dart';

import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import '../../services/tolerance_engine_service.dart';

/// Card listing substances contributing to the current bucket tolerance.
///
/// IMPORTANT:
/// - This widget is UI-only
/// - It must NOT receive raw use logs
/// - All aggregation happens in the controller / engine
class BucketContributingUsesCard extends StatelessWidget {
  final List<ToleranceContribution> contributions;

  const BucketContributingUsesCard({super.key, required this.contributions});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Contributing Substances',
            style: tx.body.copyWith(
              fontWeight: tx.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.sm),

          ...contributions.take(10).map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: sp.xs),
              child: Row(
                mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                children: [
                  Text(
                    item.substanceName,
                    style: tx.bodySmall.copyWith(color: c.textSecondary),
                  ),
                  Text(
                    '${item.percentContribution.toStringAsFixed(1)}%',
                    style: tx.bodySmall.copyWith(
                      fontWeight: tx.bodyBold.fontWeight,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),

          if (contributions.length > 10)
            Text(
              '...and ${contributions.length - 10} more',
              style: tx.overline.copyWith(
                color: c.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

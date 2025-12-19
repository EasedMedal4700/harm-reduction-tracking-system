// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../models/tolerance_model.dart';
import 'bucket_utils.dart';

/// Card listing recent uses that contribute to current tolerance
class BucketContributingUsesCard extends StatelessWidget {
  final List<UseLogEntry> contributingUses;

  const BucketContributingUsesCard({
    super.key,
    required this.contributingUses,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contributing Uses',
            style: text.body.copyWith(
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),

          CommonSpacer.vertical(sp.sm),

          ...contributingUses.take(10).map((use) {
            final timeAgo = DateTime.now().difference(use.timestamp);

            return Padding(
              padding: EdgeInsets.only(bottom: sp.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BucketUtils.formatTimeAgo(timeAgo),
                    style: text.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  Text(
                    '${use.doseUnits.toStringAsFixed(1)} units',
                    style: text.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),

          if (contributingUses.length > 10)
            Text(
              '...and ${contributingUses.length - 10} more',
              style: text.bodySmall.copyWith(
                color: c.textSecondary,
                fontStyle: FontStyle.italic,
                fontSize: text.bodySmall.fontSize! - 2,
              ),
            ),
        ],
      ),
    );
  }
}


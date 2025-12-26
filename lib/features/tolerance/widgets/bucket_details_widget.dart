// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Bucket details widget

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/buttons/common_icon_button.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../models/bucket_definitions.dart';
import '../controllers/tolerance_logic.dart';
import '../models/tolerance_models.dart';
import 'bucket_utils.dart';

class BucketDetailsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.colors;
    final sp = th.sp;
    final tx = th.text;
    final sh = th.shapes;

    final bucketName = BucketDefinitions.getDisplayName(bucketType);
    final state = ToleranceLogic.classifyState(tolerancePercent);
    final stateColor = BucketUtils.toleranceColor(
      context,
      tolerancePercent / 100.0,
    );

    return CommonCard(
      borderRadius: sh.radiusMd,
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                BucketUtils.getBucketIcon(bucketType),
                color: stateColor,
                size: th.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Expanded(
                child: Text(
                  bucketName,
                  style: tx.heading3.copyWith(color: c.textPrimary),
                ),
              ),
              CommonIconButton(
                icon: Icons.close,
                color: c.textSecondary,
                tooltip: 'Close',
                onPressed: onClose,
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          Container(
            padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: th.opacities.overlay),
              borderRadius: BorderRadius.circular(sh.radiusSm),
              border: Border.all(
                color: stateColor.withValues(alpha: th.opacities.medium),
              ),
            ),
            child: Text(
              state.displayName,
              style: tx.bodyBold.copyWith(color: stateColor),
            ),
          ),
          CommonSpacer.vertical(sp.md),
          if (substanceContributions.isNotEmpty) ...[
            Text(
              'Contributing Substances',
              style: tx.bodyBold.copyWith(color: c.textPrimary),
            ),
            CommonSpacer.vertical(sp.sm),
            ...substanceContributions.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: sp.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: tx.bodyMedium.copyWith(color: c.textSecondary),
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: tx.bodyBold.copyWith(color: c.textPrimary),
                    ),
                  ],
                ),
              );
            }),
          ] else
            Text(
              'No active contributions',
              style: tx.bodyMedium.copyWith(color: c.textSecondary),
            ),
        ],
      ),
    );
  }
}

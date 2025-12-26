// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: System bucket card widget

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../models/bucket_definitions.dart';
import '../models/tolerance_models.dart';
import 'bucket_utils.dart';

class SystemBucketCard extends StatelessWidget {
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

  Color _getStateColor(ToleranceSystemState state, BuildContext context) {
    final th = context.theme;
    final c = th.colors;
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

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.colors;
    final sp = th.sp;
    final tx = th.text;
    final sh = th.shapes;
    final stateColor = _getStateColor(state, context);
    final shadows = isSelected ? context.cardShadowHovered : context.cardShadow;

    return SizedBox(
      width: th.sizes.cardWidthMd,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(
            color: isSelected ? stateColor : c.border,
            width: isSelected ? th.sizes.borderRegular : th.sizes.borderThin,
          ),
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(sp.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    BucketUtils.getBucketIcon(bucketType),
                    size: th.sizes.iconMd,
                    color: stateColor,
                  ),
                  CommonSpacer.vertical(sp.sm),
                  Text(
                    BucketDefinitions.getDisplayName(bucketType),
                    style: tx.bodyBold.copyWith(color: c.textPrimary),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CommonSpacer.vertical(sp.sm),
                  Text(
                    '${tolerancePercent.toStringAsFixed(1)}%',
                    style: tx.heading3.copyWith(color: stateColor),
                  ),
                  CommonSpacer.vertical(sp.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sp.sm,
                      vertical: sp.xs,
                    ),
                    decoration: BoxDecoration(
                      color: stateColor.withValues(alpha: th.opacities.veryLow),
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                      border: Border.all(
                        color: stateColor.withValues(
                          alpha: th.opacities.border,
                        ),
                        width: th.sizes.borderThin,
                      ),
                    ),
                    child: Text(
                      state.displayName,
                      style: tx.captionBold.copyWith(color: stateColor),
                    ),
                  ),
                  if (isActive) ...[
                    CommonSpacer.vertical(sp.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sp.sm,
                        vertical: sp.xs,
                      ),
                      decoration: BoxDecoration(
                        color: c.info.withValues(alpha: th.opacities.selected),
                        borderRadius: BorderRadius.circular(sh.radiusSm),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: tx.captionBold.copyWith(color: c.info),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

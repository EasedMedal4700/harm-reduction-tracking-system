// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Bucket details widget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../models/bucket_definitions.dart';
import '../controllers/tolerance_logic.dart';
import '../models/tolerance_models.dart';
import 'bucket_utils.dart';

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
    final state = ToleranceLogic.classifyState(tolerancePercent);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER with close button
          Row(
            children: [
              Icon(
                BucketUtils.getBucketIcon(bucketType),
                color: stateColor,
                size: 24,
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
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),

          // STATE
          Container(
            padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(sh.radiusSm),
              border: Border.all(color: stateColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              state.displayName,
              style: tx.bodyBold.copyWith(color: stateColor),
            ),
          ),
          CommonSpacer.vertical(sp.md),

          // CONTRIBUTIONS
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
                      entry.key, // Substance slug, ideally mapped to name
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

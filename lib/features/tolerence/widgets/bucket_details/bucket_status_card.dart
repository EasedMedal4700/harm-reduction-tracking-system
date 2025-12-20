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
import '../../../../models/tolerance_model.dart';

/// Card displaying current bucket status with various metrics
class BucketStatusCard extends StatelessWidget {
  final NeuroBucket bucket;
  final double tolerancePercent;
  final double rawLoad;

  const BucketStatusCard({
    super.key,
    required this.bucket,
    required this.tolerancePercent,
    required this.rawLoad,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Title
          Text(
            'Current Status',
            style: text.body.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),

          CommonSpacer.vertical(sp.md),

          // Stats
          _buildStatRow(
            context,
            'Tolerance Level',
            '${tolerancePercent.toStringAsFixed(1)}%',
          ),

          _buildStatRow(context, 'Raw Load', rawLoad.toStringAsFixed(4)),

          _buildStatRow(
            context,
            'Bucket Weight',
            bucket.weight.toStringAsFixed(2),
          ),

          _buildStatRow(
            context,
            'Tolerance Type',
            bucket.toleranceType ?? 'unknown',
          ),

          _buildStatRow(
            context,
            'Status',
            tolerancePercent > 0.1 ? 'Active' : 'Inactive',
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    final sp = context.spacing;
    final text = context.text;
    final c = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: sp.sm),
      child: Row(
        mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
        children: [
          // Label
          Text(label, style: text.bodySmall.copyWith(color: c.textSecondary)),

          // Value
          Text(
            value,
            style: text.bodySmall.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../models/bucket_definitions.dart';

/// Card displaying information about the bucket system
class BucketDescriptionCard extends StatelessWidget {
  final String bucketType;

  const BucketDescriptionCard({
    super.key,
    required this.bucketType,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This System',
            style: text.body.copyWith(
              fontWeight: FontWeight.w600,
              color: c.text,
            ),
          ),

          SizedBox(height: sp.sm),

          Text(
            BucketDefinitions.getDescription(bucketType),
            style: text.bodySmall.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


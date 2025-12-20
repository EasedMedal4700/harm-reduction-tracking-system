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

/// Card displaying substance-specific notes or information
class BucketNotesCard extends StatelessWidget {
  final String substanceNotes;

  const BucketNotesCard({super.key, required this.substanceNotes});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: context.sizes.iconMd,
                color: c.textSecondary,
              ),

              CommonSpacer.horizontal(sp.sm),

              Text(
                'Notes',
                style: text.body.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),

          CommonSpacer.vertical(sp.sm),

          // Notes text
          Text(
            substanceNotes,
            style: text.bodySmall.copyWith(color: c.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

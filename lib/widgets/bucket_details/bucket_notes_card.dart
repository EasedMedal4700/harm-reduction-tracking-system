
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Updated to CommonCard and new theme system. No Riverpod.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Card displaying substance-specific notes or information
class BucketNotesCard extends StatelessWidget {
  final String substanceNotes;

  const BucketNotesCard({
    super.key,
    required this.substanceNotes,
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
          // Header row
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: c.textSecondary,
              ),

              SizedBox(width: sp.sm),

              Text(
                'Notes',
                style: text.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.text,
                ),
              ),
            ],
          ),

          SizedBox(height: sp.sm),

          // Notes text
          Text(
            substanceNotes,
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


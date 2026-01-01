// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';

class ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const ReadOnlyField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sz = context.sizes;
    return CommonCard(
      padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(icon, size: sz.iconSm, color: c.textSecondary),
              CommonSpacer.horizontal(sp.sm),
              Text(
                label,
                style: tx.bodySmall.copyWith(
                  color: c.textSecondary,
                  fontWeight: tx.bodyMedium.fontWeight,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            value,
            style: tx.body.copyWith(
              color: c.textPrimary,
              fontWeight: tx.bodyBold.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

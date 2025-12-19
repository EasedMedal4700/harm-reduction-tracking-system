// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/buttons/common_icon_button.dart';

class SubstanceHeaderCard extends StatelessWidget {
  final String substanceName;
  final String? roa;
  final VoidCallback? onEdit;

  const SubstanceHeaderCard({
    super.key,
    required this.substanceName,
    this.roa,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;

    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: acc.primary.withValues(alpha: 0.1),
              shape: context.shapes.boxShapeCircle,
            ),
            child: Icon(
              Icons.science,
              color: acc.primary,
              size: context.sizes.iconMd,
            ),
          ),
          CommonSpacer.horizontal(sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  substanceName,
                  style: t.text.heading3,
                ),
                if (roa != null) ...[
                  CommonSpacer.vertical(sp.xs),
                  Text(
                    roa!,
                    style: t.text.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onEdit != null)
            CommonIconButton(
              icon: Icons.edit,
              color: c.textSecondary,
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

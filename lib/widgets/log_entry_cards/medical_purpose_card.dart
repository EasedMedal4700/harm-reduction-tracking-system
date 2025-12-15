import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/theme/app_theme_extension.dart';

class MedicalPurposeCard extends StatelessWidget {
  final bool isMedicalPurpose;
  final ValueChanged<bool> onChanged;

  const MedicalPurposeCard({
    super.key,
    required this.isMedicalPurpose,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final accent = t.colors.success;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Purpose",
            subtitle: "Prescribed or therapeutic use",
          ),

          CommonSpacer.vertical(t.spacing.md),

          Container(
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(t.spacing.radiusMd),
              border: Border.all(
                color: isMedicalPurpose ? accent : t.colors.border,
                width: isMedicalPurpose ? 2 : 1,
              ),
            ),
            child: SwitchListTile(
              value: isMedicalPurpose,
              onChanged: onChanged,
              activeThumbColor: accent,
              title: Text(
                "Medical Purpose",
                style: t.typography.body.copyWith(
                  fontWeight: isMedicalPurpose
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: t.colors.textPrimary,
                ),
              ),
              subtitle: Text(
                "Prescribed or therapeutic use",
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

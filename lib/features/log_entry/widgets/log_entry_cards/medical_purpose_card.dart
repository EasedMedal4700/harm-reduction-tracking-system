// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/inputs/switch_tile.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Purpose",
            subtitle: "Prescribed or therapeutic use",
          ),
          CommonSpacer.vertical(th.spacing.md),
          CommonSwitchTile(
            title: "Medical Purpose",
            subtitle: "Prescribed or therapeutic use",
            value: isMedicalPurpose,
            onChanged: onChanged,
            highlighted: isMedicalPurpose,
          ),
        ],
      ),
    );
  }
}

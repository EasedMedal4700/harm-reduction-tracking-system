import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Purpose",
            subtitle: "Prescribed or therapeutic use",
          ),

          const CommonSpacer.vertical(ThemeConstants.space12),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0x08FFFFFF) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(
                color: isMedicalPurpose ? accent : (isDark
                    ? const Color(0x14FFFFFF)
                    : UIColors.lightBorder),
                width: isMedicalPurpose ? 2 : 1,
              ),
            ),
            child: SwitchListTile(
              value: isMedicalPurpose,
              onChanged: onChanged,
              activeColor: accent,
              title: Text(
                "Medical Purpose",
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: isMedicalPurpose
                      ? ThemeConstants.fontSemiBold
                      : ThemeConstants.fontRegular,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              subtitle: Text(
                "Prescribed or therapeutic use",
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: isDark
                      ? UIColors.darkTextSecondary
                      : UIColors.lightTextSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

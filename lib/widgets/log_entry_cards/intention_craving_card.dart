import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/data/body_and_mind_catalog.dart';

import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/inputs/common_dropdown.dart';
import '../../common/inputs/common_slider.dart';
import '../../common/layout/common_spacer.dart';

class IntentionCravingCard extends StatelessWidget {
  final String? intention;
  final double cravingIntensity;
  final bool isMedicalPurpose;

  final ValueChanged<String?> onIntentionChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<bool> onMedicalPurposeChanged;

  const IntentionCravingCard({
    super.key,
    required this.intention,
    required this.cravingIntensity,
    required this.isMedicalPurpose,
    required this.onIntentionChanged,
    required this.onCravingIntensityChanged,
    required this.onMedicalPurposeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final validIntention =
        intentions.contains(intention) ? intention : null;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Intention & Purpose",
            subtitle: "Why did you use this substance?",
          ),

          const CommonSpacer.vertical(ThemeConstants.space16),

          /// ⭐ MEDICAL PURPOSE SWITCH
          _buildMedicalToggle(isDark),

          const CommonSpacer.vertical(ThemeConstants.space20),

          /// ⭐ INTENTION DROPDOWN
          CommonDropdown<String>(
            value: validIntention ?? intentions.first,
            items: intentions,
            onChanged: onIntentionChanged,
            itemLabel: (v) => v,
          ),


          const CommonSpacer.vertical(ThemeConstants.space20),

          /// ⭐ CRAVING SLIDER
          _buildCravingSection(context, isDark),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MEDICAL PURPOSE SWITCH
  // ----------------------------------------------------------

  Widget _buildMedicalToggle(bool isDark) {
    final accent =
        isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen;

    return Container(
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
        onChanged: onMedicalPurposeChanged,
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
    );
  }

  // ----------------------------------------------------------
  // CRAVING SLIDER
  // ----------------------------------------------------------

  Widget _buildCravingSection(BuildContext context, bool isDark) {
    final accent =
        isDark ? UIColors.darkNeonOrange : UIColors.lightAccentOrange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Craving Intensity",
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),

        const CommonSpacer.vertical(ThemeConstants.space8),

        Row(
          children: [
            /// Slider (your CommonSlider)
            Expanded(
              child: CommonSlider(
                value: cravingIntensity,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: onCravingIntensityChanged,
              ),
            ),

            const CommonSpacer.horizontal(ThemeConstants.space12),

            /// Value indicator box
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space12,
                vertical: ThemeConstants.space8,
              ),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(ThemeConstants.radiusMedium),
                border: Border.all(color: accent),
              ),
              child: Text(
                cravingIntensity.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

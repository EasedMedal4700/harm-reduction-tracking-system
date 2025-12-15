import 'package:flutter/material.dart';

import '../../constants/data/body_and_mind_catalog.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/inputs/dropdown.dart';
import '../../common/inputs/slider.dart';
import '../../common/layout/common_spacer.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
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

          CommonSpacer.vertical(t.spacing.md),

          ///  MEDICAL PURPOSE SWITCH
          _buildMedicalToggle(context),

          CommonSpacer.vertical(t.spacing.lg),

          ///  INTENTION DROPDOWN
          CommonDropdown<String>(
            value: validIntention ?? intentions.first,
            items: intentions,
            onChanged: onIntentionChanged,
            itemLabel: (v) => v,
          ),

          CommonSpacer.vertical(t.spacing.lg),

          ///  CRAVING SLIDER
          _buildCravingSection(context),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MEDICAL PURPOSE SWITCH
  // ----------------------------------------------------------

  Widget _buildMedicalToggle(BuildContext context) {
    final t = context.theme;
    final accent = t.colors.success;

    return Container(
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
        onChanged: onMedicalPurposeChanged,
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
    );
  }

  // ----------------------------------------------------------
  // CRAVING SLIDER
  // ----------------------------------------------------------

  Widget _buildCravingSection(BuildContext context) {
    final t = context.theme;
    final accent = t.colors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Craving Intensity",
          style: t.typography.body.copyWith(
            color: t.colors.textPrimary,
          ),
        ),

        CommonSpacer.vertical(t.spacing.sm),

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

            CommonSpacer.horizontal(t.spacing.md),

            /// Value indicator box
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.md,
                vertical: t.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(t.spacing.radiusMd),
                border: Border.all(color: accent),
              ),
              child: Text(
                cravingIntensity.toStringAsFixed(0),
                style: t.typography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: t.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

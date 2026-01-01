// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Intention and craving card.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/data/body_and_mind_catalog.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/inputs/dropdown.dart';
import '../../../../common/inputs/slider.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    final validIntention = intentions.contains(intention) ? intention : null;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Intention & Purpose",
            subtitle: "Why did you use this substance?",
          ),
          CommonSpacer.vertical(th.sp.md),

          ///  MEDICAL PURPOSE SWITCH
          _buildMedicalToggle(context),
          CommonSpacer.vertical(th.sp.lg),

          ///  INTENTION DROPDOWN
          CommonDropdown<String>(
            value: validIntention ?? intentions.first,
            items: intentions,
            onChanged: onIntentionChanged,
            itemLabel: (v) => v,
          ),
          CommonSpacer.vertical(th.sp.lg),

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
    final th = context.theme;
    final tx = th.text;
    final c = th.c;
    final sh = th.shapes;
    final accent = c.success;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: isMedicalPurpose ? accent : c.border,
          width: isMedicalPurpose ? th.borders.medium : th.borders.thin,
        ),
      ),
      child: SwitchListTile(
        value: isMedicalPurpose,
        onChanged: onMedicalPurposeChanged,
        activeTrackColor: accent,
        title: Text(
          "Medical Purpose",
          style: tx.body.copyWith(
            fontWeight: isMedicalPurpose
                ? tx.bodyBold.fontWeight
                : tx.body.fontWeight,
            color: c.textPrimary,
          ),
        ),
        subtitle: Text(
          "Prescribed or therapeutic use",
          style: tx.bodySmall.copyWith(color: c.textSecondary),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CRAVING SLIDER
  // ----------------------------------------------------------
  Widget _buildCravingSection(BuildContext context) {
    final th = context.theme;
    final c = th.c;
    final tx = th.text;
    final sh = th.shapes;

    final accent = c.warning;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          "Craving Intensity",
          style: tx.body.copyWith(color: c.textPrimary),
        ),
        CommonSpacer.vertical(th.sp.sm),
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
            CommonSpacer.horizontal(th.sp.md),

            /// Value indicator box
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: th.sp.md,
                vertical: th.sp.sm,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: th.opacities.overlay),
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: accent),
              ),
              child: Text(
                cravingIntensity.toStringAsFixed(0),
                style: tx.body.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

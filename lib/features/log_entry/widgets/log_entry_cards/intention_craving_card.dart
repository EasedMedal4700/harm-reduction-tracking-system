// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
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
    final sp = context.spacing;
    final validIntention = intentions.contains(intention) ? intention : null;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Intention & Purpose",
            subtitle: "Why did you use this substance?",
          ),
          CommonSpacer.vertical(sp.md),

          ///  MEDICAL PURPOSE SWITCH
          _buildMedicalToggle(context),
          CommonSpacer.vertical(sp.lg),

          ///  INTENTION DROPDOWN
          CommonDropdown<String>(
            value: validIntention ?? intentions.first,
            items: intentions,
            onChanged: onIntentionChanged,
            itemLabel: (v) => v,
          ),
          CommonSpacer.vertical(sp.lg),

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
    final tx = context.text;
    final c = context.colors;
    final sh = context.shapes;
    final accent = c.success;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: isMedicalPurpose ? accent : c.border,
          width: isMedicalPurpose ? 2 : 1,
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final accent = c.warning;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          "Craving Intensity",
          style: tx.body.copyWith(color: c.textPrimary),
        ),
        CommonSpacer.vertical(sp.sm),
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
            CommonSpacer.horizontal(sp.md),

            /// Value indicator box
            Container(
              padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
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

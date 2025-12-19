// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';

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
    final s = context.spacing;
    final validIntention =
        intentions.contains(intention) ? intention : null;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Intention & Purpose",
            subtitle: "Why did you use this substance?",
          ),

          CommonSpacer.vertical(s.md),

          ///  MEDICAL PURPOSE SWITCH
          _buildMedicalToggle(context),

          CommonSpacer.vertical(s.lg),

          ///  INTENTION DROPDOWN
          CommonDropdown<String>(
            value: validIntention ?? intentions.first,
            items: intentions,
            onChanged: onIntentionChanged,
            itemLabel: (v) => v,
          ),

          CommonSpacer.vertical(s.lg),

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
    final text = context.text;
    final c = context.colors;
    final sh = context.shapes;
    final c = context.colors;
    final sh = context.shapes;
    final text = context.text;
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
          style: text.body.copyWith(
            fontWeight: isMedicalPurpose
                ? text.bodyBold.fontWeight
                : text.body.fontWeight,
            color: c.textPrimary,
          ),
        ),
        subtitle: Text(
          "Prescribed or therapeutic use",
          style: text.bodySmall.copyWith(
            color: c.textSecondary,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CRAVING SLIDER
  // ----------------------------------------------------------

  Widget _buildCravingSection(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sh = context.shapes;
    final c = context.colors;
    final s = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    final accent = c.warning;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          "Craving Intensity",
          style: text.body.copyWith(
            color: c.textPrimary,
          ),
        ),

        CommonSpacer.vertical(s.sm),

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

            CommonSpacer.horizontal(s.md),

            /// Value indicator box
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: s.md,
                vertical: s.sm,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: accent),
              ),
              child: Text(
                cravingIntensity.toStringAsFixed(0),
                style: text.body.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
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

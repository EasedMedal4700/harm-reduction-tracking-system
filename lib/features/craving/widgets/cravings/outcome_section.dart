// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard, CommonInputField, and CommonSwitchTile.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/inputs/input_field.dart';
import '../../../../common/inputs/switch_tile.dart';
import '../../../../common/layout/common_spacer.dart';

class OutcomeSection extends StatelessWidget {
  final String? whatDidYouDo;
  final ValueChanged<String> onWhatDidYouDoChanged;
  final bool actedOnCraving;
  final ValueChanged<bool> onActedOnCravingChanged;

  const OutcomeSection({
    super.key,
    required this.whatDidYouDo,
    required this.onWhatDidYouDoChanged,
    required this.actedOnCraving,
    required this.onActedOnCravingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    
    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: a.primary, size: t.sizes.iconMd),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Outcome',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          
          CommonInputField(
            initialValue: whatDidYouDo,
            onChanged: onWhatDidYouDoChanged,
            maxLines: 3,
            labelText: 'What did you do?',
            hintText: 'Describe your actions...',
          ),
          
          CommonSpacer.vertical(sp.md),
          
          CommonSwitchTile(
            title: 'Acted on craving?',
            value: actedOnCraving,
            onChanged: onActedOnCravingChanged,
          ),
        ],
      ),
    );
  }
}


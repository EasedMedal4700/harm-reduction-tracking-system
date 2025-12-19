// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonInputField.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/buttons/common_chip_group.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/inputs/input_field.dart';
import '../../../../common/layout/common_spacer.dart';

class EmotionalStateSection extends StatelessWidget {
  final List<String> selectedEmotions;
  final Map<String, List<String>> secondaryEmotions;
  final ValueChanged<List<String>> onEmotionsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryEmotionsChanged;
  final String? thoughts;
  final ValueChanged<String> onThoughtsChanged;

  const EmotionalStateSection({
    super.key,
    required this.selectedEmotions,
    required this.secondaryEmotions,
    required this.onEmotionsChanged,
    required this.onSecondaryEmotionsChanged,
    required this.thoughts,
    required this.onThoughtsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;
    final a = context.accent;
    final sp = context.spacing;
    
    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: a.primary, size: t.sizes.iconMd),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Emotional State',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: text.bodyBold.fontWeight,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          
          CommonChipGroup(
            title: 'Feelings',
            options: const ['Happy', 'Sad', 'Anxious', 'Angry', 'Neutral', 'Excited', 'Tired'],
            selected: selectedEmotions,
            onChanged: onEmotionsChanged,
            allowMultiple: true,
          ),
          
          CommonSpacer.vertical(sp.lg),
          
          CommonInputField(
            initialValue: thoughts,
            onChanged: onThoughtsChanged,
            maxLines: 3,
            labelText: 'Thoughts',
            hintText: 'What are you thinking?',
          ),
        ],
      ),
    );
  }
}


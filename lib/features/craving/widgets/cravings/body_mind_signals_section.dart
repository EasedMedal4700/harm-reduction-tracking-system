// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonChipGroup.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/buttons/common_chip_group.dart';
import '../../../../common/layout/common_spacer.dart';

class BodyMindSignalsSection extends StatelessWidget {
  final List<String> sensations;
  final List<String> selectedSensations;
  final ValueChanged<List<String>> onSensationsChanged;

  const BodyMindSignalsSection({
    super.key,
    required this.sensations,
    required this.selectedSensations,
    required this.onSensationsChanged,
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
              Icon(Icons.self_improvement, color: a.primary, size: t.sizes.iconMd),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Body & Mind Signals',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          
          CommonChipGroup(
            title: 'Body Sensations',
            options: sensations,
            selected: selectedSensations,
            onChanged: onSensationsChanged,
            allowMultiple: true,
          ),
        ],
      ),
    );
  }
}


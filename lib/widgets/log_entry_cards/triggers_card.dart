
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/buttons/common_chip.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/data/body_and_mind_catalog.dart';

class TriggersCard extends StatelessWidget {
  final List<String> selectedTriggers;
  final ValueChanged<List<String>> onTriggersChanged;

  const TriggersCard({
    super.key,
    required this.selectedTriggers,
    required this.onTriggersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? UIColors.darkNeonViolet
        : UIColors.lightAccentPurple;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Triggers",
            subtitle: "What prompted this use?",
          ),

          const CommonSpacer.vertical(ThemeConstants.space12),

          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: triggers.map((trigger) {
              final isSelected = selectedTriggers.contains(trigger);

              return CommonChip(
                label: trigger,
                isSelected: isSelected,
                onTap: () {
                  final updated = List<String>.from(selectedTriggers);
                  isSelected ? updated.remove(trigger) : updated.add(trigger);
                  onTriggersChanged(updated);
                },
                showGlow: true,
                selectedColor: accent,
                selectedBorderColor: accent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

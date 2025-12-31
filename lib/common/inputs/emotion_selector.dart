// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../common/buttons/common_chip_group.dart';

class EmotionSelector extends StatelessWidget {
  final List<String> selectedEmotions;
  final List<String> availableEmotions;
  final ValueChanged<String> onEmotionToggled;
  final Color? accentColor;
  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.availableEmotions,
    required this.onEmotionToggled,
    this.accentColor,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final accent = accentColor ?? th.accent.primary;
    return CommonChipGroup(
      title: "Emotions",
      subtitle: "More specific feelings",
      options: availableEmotions,
      selected: selectedEmotions,
      allowMultiple: true,
      onChanged: (list) {
        // Find which was toggled
        for (final emotion in availableEmotions) {
          final wasSelected = selectedEmotions.contains(emotion);
          final isSelectedNow = list.contains(emotion);
          if (wasSelected != isSelectedNow) {
            onEmotionToggled(emotion);
          }
        }
      },
      selectedColor: accent,
      selectedBorderColor: accent,
      showGlow: th.isDark,
    );
  }
}

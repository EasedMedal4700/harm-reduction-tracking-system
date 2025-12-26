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
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.
class EmotionSelector extends StatelessWidget {
  final List<String> selectedEmotions;
  final List<String> availableEmotions;
  final ValueChanged<String> onEmotionToggled;
  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.availableEmotions,
    required this.onEmotionToggled,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
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
      selectedColor: th.accent.primary,
      selectedBorderColor: th.accent.primary,
      showGlow: th.isDark,
    );
  }
}

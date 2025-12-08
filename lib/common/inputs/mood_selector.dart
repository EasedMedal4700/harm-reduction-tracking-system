import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../common/buttons/common_chip_group.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final List<String> availableMoods;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.availableMoods,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return CommonChipGroup(
      title: "Mood",
      subtitle: "How do you feel overall?",
      options: availableMoods,
      selected: selectedMood == null ? [] : [selectedMood!],
      allowMultiple: false,
      onChanged: (list) {
        if (list.isNotEmpty) {
          onMoodSelected(list.first);
        }
      },

      selectedColor: t.accent.primary,
      selectedBorderColor: t.accent.primary,
      showGlow: t.isDark,
    );
  }
}

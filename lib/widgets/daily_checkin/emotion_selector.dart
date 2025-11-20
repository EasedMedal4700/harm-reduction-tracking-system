import 'package:flutter/material.dart';

/// Widget for selecting multiple emotions
class EmotionSelector extends StatelessWidget {
  final List<String> selectedEmotions;
  final List<String> availableEmotions;
  final Function(String) onEmotionToggled;

  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.availableEmotions,
    required this.onEmotionToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your emotions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableEmotions.map((emotion) {
            final isSelected = selectedEmotions.contains(emotion);
            return FilterChip(
              label: Text(emotion),
              selected: isSelected,
              onSelected: (_) => onEmotionToggled(emotion),
            );
          }).toList(),
        ),
      ],
    );
  }
}

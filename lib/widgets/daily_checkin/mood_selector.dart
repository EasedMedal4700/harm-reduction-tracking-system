import 'package:flutter/material.dart';

/// Widget for selecting mood from available options
class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final List<String> availableMoods;
  final Function(String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.availableMoods,
    required this.onMoodSelected,
  });

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Great':
        return Colors.green.shade200;
      case 'Good':
        return Colors.lightGreen.shade200;
      case 'Okay':
        return Colors.yellow.shade200;
      case 'Struggling':
        return Colors.orange.shade200;
      case 'Poor':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableMoods.map((mood) {
            final isSelected = selectedMood == mood;
            return ChoiceChip(
              label: Text(mood),
              selected: isSelected,
              onSelected: (_) => onMoodSelected(mood),
              selectedColor: _getMoodColor(mood),
            );
          }).toList(),
        ),
      ],
    );
  }
}

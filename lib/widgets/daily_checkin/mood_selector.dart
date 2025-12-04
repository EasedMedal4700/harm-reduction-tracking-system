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
    // Reverse mapping: first mood ('Poor') -> 1.0 (left), last mood ('Great') -> max (right)
    final moodToValue = {
      for (int i = 0; i < availableMoods.length; i++)
        availableMoods[i]: (availableMoods.length - i).toDouble()
    };
    final valueToMood = {
      for (int i = 0; i < availableMoods.length; i++)
        (availableMoods.length - i).toDouble(): availableMoods[i]
    };

    // Get current slider value (default to first mood if none selected)
    final currentValue =
        selectedMood != null ? moodToValue[selectedMood]! : 1.0;

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
        Slider(
          value: currentValue,
          min: 1.0,
          max: availableMoods.length.toDouble(),
          divisions: availableMoods.length - 1,
          label: selectedMood ?? availableMoods.last, // Default to last mood ('Great')
          onChanged: (value) {
            final mood = valueToMood[value]!;
            onMoodSelected(mood);
          },
          activeColor: _getMoodColor(selectedMood ?? availableMoods.last),
        ),
        // Reversed labels: poor on left, great on right
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: availableMoods
              .reversed
              .map((mood) => Text(mood, style: TextStyle(fontSize: 12)))
              .toList(),
        ),
      ],
    );
  }
}

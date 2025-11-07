import 'package:flutter/material.dart';
import '../common/feeling_selection.dart';

class EmotionalStateSection extends StatelessWidget {
  final List<String> selectedEmotions;
  final ValueChanged<List<String>> onEmotionsChanged;
  final String? thoughts;
  final ValueChanged<String> onThoughtsChanged;

  const EmotionalStateSection({
    super.key,
    required this.selectedEmotions,
    required this.onEmotionsChanged,
    required this.thoughts,
    required this.onThoughtsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Emotional State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FeelingSelection(
          feelings: selectedEmotions,
          onFeelingsChanged: onEmotionsChanged,
          secondaryFeelings: <String, List<String>>{},
          onSecondaryFeelingsChanged: (_) {},
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Thoughts'),
          maxLines: 3,
          initialValue: thoughts,
          onChanged: onThoughtsChanged,
        ),
      ],
    );
  }
}
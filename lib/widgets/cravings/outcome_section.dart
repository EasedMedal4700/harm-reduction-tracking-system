import 'package:flutter/material.dart';

class OutcomeSection extends StatelessWidget {
  final String? whatDidYouDo;
  final ValueChanged<String> onWhatDidYouDoChanged;
  final bool actedOnCraving;
  final ValueChanged<bool> onActedOnCravingChanged;

  const OutcomeSection({
    super.key,
    required this.whatDidYouDo,
    required this.onWhatDidYouDoChanged,
    required this.actedOnCraving,
    required this.onActedOnCravingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Outcome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'What did you do?'),
          maxLines: 3,
          initialValue: whatDidYouDo,
          onChanged: onWhatDidYouDoChanged,
        ),
        SwitchListTile(
          title: const Text('Acted on craving?'),
          value: actedOnCraving,
          onChanged: onActedOnCravingChanged,
        ),
      ],
    );
  }
}
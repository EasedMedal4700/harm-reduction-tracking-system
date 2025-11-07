import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Body & Mind Signals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Wrap(
          children: sensations.map((sensation) {
            return FilterChip(
              label: Text(sensation),
              selected: selectedSensations.contains(sensation),
              onSelected: (selected) => onSensationsChanged(
                selected
                  ? [...selectedSensations, sensation]
                  : selectedSensations.where((s) => s != sensation).toList(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
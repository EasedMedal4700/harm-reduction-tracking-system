import 'package:flutter/material.dart';

class CravingSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CravingSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Craving Intensity (0-10)'),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        Text('Current: ${value.round()}'),
      ],
    );
  }
}
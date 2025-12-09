// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';

/// Displays the time context in the app bar
class BloodLevelsTimeDisplay extends StatelessWidget {
  final DateTime selectedTime;

  const BloodLevelsTimeDisplay({
    super.key,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final isNow = selectedTime.difference(DateTime.now()).abs().inMinutes < 5;
    
    if (isNow) {
      return const Text('Blood Levels');
    }
    
    final diff = selectedTime.difference(DateTime.now());
    final hoursAgo = (diff.inMinutes / 60.0).abs().round();
    final label = diff.isNegative ? '$hoursAgo hours ago' : '$hoursAgo hours future';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blood Levels', style: TextStyle(fontSize: 16)),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}

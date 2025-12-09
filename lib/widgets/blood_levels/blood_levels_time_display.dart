// MIGRATION
// Theme: COMPLETE
// Common: N/A
// Riverpod: TODO
// Notes: Fully migrated to theme system. Removed hardcoded text styles.

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Displays the time context in the app bar
class BloodLevelsTimeDisplay extends StatelessWidget {
  final DateTime selectedTime;

  const BloodLevelsTimeDisplay({
    super.key,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    final now = DateTime.now();
    final diff = selectedTime.difference(now);
    final isNow = diff.abs().inMinutes < 5;

    if (isNow) {
      return Text(
        'Blood Levels',
        style: t.typography.heading4.copyWith(color: c.textPrimary),
      );
    }

    final hours = (diff.inMinutes / 60.0).abs().round();
    final label = diff.isNegative ? '$hours hours ago' : '$hours hours future';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Levels',
          style: t.typography.heading4.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: sp.xs),
        Text(
          label,
          style: t.typography.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

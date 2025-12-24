// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

/// Displays the time context in the app bar
class BloodLevelsTimeDisplay extends StatelessWidget {
  final DateTime selectedTime;
  const BloodLevelsTimeDisplay({super.key, required this.selectedTime});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final now = DateTime.now();
    final diff = selectedTime.difference(now);
    final isNow = diff.abs().inMinutes < 5;
    if (isNow) {
      return Text(
        'Blood Levels',
        style: th.typography.heading4.copyWith(color: c.textPrimary),
      );
    }
    final hours = (diff.inMinutes / 60.0).abs().round();
    final label = diff.isNegative ? '$hours hours ago' : '$hours hours future';
    return Column(
      mainAxisSize: AppLayout.mainAxisSizeMin,
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          'Blood Levels',
          style: th.typography.heading4.copyWith(color: c.textPrimary),
        ),
        const CommonSpacer.vertical(4),
        Text(
          label,
          style: th.typography.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

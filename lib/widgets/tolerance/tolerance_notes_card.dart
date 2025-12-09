import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Card displaying additional notes about the substance tolerance
class ToleranceNotesCard extends StatelessWidget {
  final String notes;

  const ToleranceNotesCard({
    required this.notes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: t.typography.heading4.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          SizedBox(height: t.spacing.md),
          Text(
            notes,
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

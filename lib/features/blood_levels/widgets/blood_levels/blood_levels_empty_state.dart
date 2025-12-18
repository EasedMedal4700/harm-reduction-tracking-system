// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new theme system. No deprecated constants remain.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Empty state shown when no substances have active blood levels,
/// or when filters hide all visible data.
class BloodLevelsEmptyState extends StatelessWidget {
  final bool hasActiveFilters;

  const BloodLevelsEmptyState({
    super.key,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;    // color palette
    final sp = context.spacing;  // spacing
    final text = context.text;   // typography

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.science_outlined,
            size: 64,
            color: c.textTertiary,
          ),
          SizedBox(height: sp.lg),

          Text(
            'No active substances',
            style: text.heading4.copyWith(
              color: c.textSecondary,
            ),
          ),

          if (hasActiveFilters) ...[
            SizedBox(height: sp.sm),
            Text(
              'Try adjusting filters',
              style: text.bodySmall.copyWith(
                color: c.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

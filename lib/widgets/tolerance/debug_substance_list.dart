
// MIGRATION
// Theme: PARTIAL
// Common: TODO
// Riverpod: TODO
// Notes: Uses Theme.of(context) and Colors directly; needs migration to AppTheme/context extensions.

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_colors.dart';
import '../../constants/theme/app_theme_constants.dart';

/// Debug widget showing per-substance tolerance percentages
class DebugSubstanceList extends StatelessWidget {
  final Map<String, double> perSubstanceTolerances;
  final bool isLoading;

  const DebugSubstanceList({
    required this.perSubstanceTolerances,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;     // typography, spacing, radius, etc.
    final c = context.palette;   // colors

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        border: Border.all(color: t.colors.border),
      ),
      padding: EdgeInsets.all(t.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DEBUG: Per-substance tolerance',
            style: t.typography.heading4.copyWith(
              fontSize: t.typography.body.fontSize! + 1,
            ),
          ),
          SizedBox(height: t.spacing.sm),

          if (isLoading)
            const Center(child: CircularProgressIndicator())

          else if (perSubstanceTolerances.isEmpty)
            Text(
              'No data',
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textSecondary,
              ),
            )

          else
            ...perSubstanceTolerances.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: t.typography.body,
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: t.typography.bodyBold.copyWith(
                        color: t.accent.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

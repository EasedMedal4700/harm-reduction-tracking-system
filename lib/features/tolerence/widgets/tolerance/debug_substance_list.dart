// Debug Substance List Widget
// 
// Created: 2024-11-15
// Last Modified: 2025-12-14
// 
// Purpose:
// Development/debug widget that displays per-substance tolerance percentages in a simple
// list format. Useful for verifying tolerance calculations and debugging tolerance engine
// behavior. Should be hidden in production unless debug mode is enabled.
// 
// Features:
// - Lists all substances with their tolerance percentages
// - Loading state indicator
// - Empty state handling
// - Highlighted tolerance values with accent color
// - Debug label to indicate this is for development

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/feedback/common_loader.dart';

/// Debug widget showing per-substance tolerance percentages
/// 
/// Development tool for displaying and verifying tolerance calculations.
/// Intended for debug builds or when explicitly enabled by user.
class DebugSubstanceList extends ConsumerWidget {
  /// Map of substance names to their tolerance percentages
  final Map<String, double> perSubstanceTolerances;
  
  /// Whether data is currently loading
  final bool isLoading;

  const DebugSubstanceList({
    required this.perSubstanceTolerances,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(color: colors.border),
      ),
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Debug header with distinctive styling
          Text(
            'DEBUG: Per-substance tolerance',
            style: typography.heading4.copyWith(
              fontSize: typography.body.fontSize! + 1,
            ),
          ),
          CommonSpacer.vertical(spacing.sm),

          // LOADING STATE
          if (isLoading)
            const Center(child: CommonLoader())

          // EMPTY STATE
          else if (perSubstanceTolerances.isEmpty)
            Text(
              'No data',
              style: typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            )

          // LIST OF SUBSTANCES WITH TOLERANCE PERCENTAGES
          else
            ...perSubstanceTolerances.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xs),
                child: Row(
                  mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                  children: [
                    // Substance name
                    Text(
                      entry.key,
                      style: typography.body,
                    ),
                    // Tolerance percentage (highlighted with accent color)
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: typography.bodyBold.copyWith(
                        color: context.accent.primary,
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


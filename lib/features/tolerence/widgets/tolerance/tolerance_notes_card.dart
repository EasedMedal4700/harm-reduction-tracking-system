// Tolerance Notes Card Widget
// 
// Created: 2024-11-10
// Last Modified: 2025-12-14
// 
// Purpose:
// Displays additional contextual notes about substance tolerance. Provides a dedicated
// space for extra information, warnings, or explanations that don't fit in other cards.
// Automatically hides if no notes are provided.
// 
// Features:
// - Conditionally renders (hidden when notes are empty)
// - Clean card design matching other tolerance widgets
// - Proper text formatting with line height for readability
// - Theme-aware styling

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Card displaying additional notes about the substance tolerance
/// 
/// Conditionally rendered widget that shows contextual information when available.
class ToleranceNotesCard extends ConsumerWidget {
  /// Note text to display
  final String notes;

  const ToleranceNotesCard({
    required this.notes,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hide widget if no notes provided
    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

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
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(spacing.lg),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Section header
          Text(
            'Notes',
            style: typography.heading4.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.md),
          // Notes content with enhanced readability
          Text(
            notes,
            style: typography.body.copyWith(
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}


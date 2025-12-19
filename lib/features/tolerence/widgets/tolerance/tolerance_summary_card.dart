// Tolerance Summary Card Widget
// 
// Created: 2024-11-10
// Last Modified: 2025-12-14
// 
// Purpose:
// Displays the current tolerance percentage as a large visual indicator with a progress bar
// and color-coded status label. Primary summary card for tolerance information.
// 
// Features:
// - Large tolerance percentage display
// - Color-coded progress bar (green to red based on tolerance level)
// - Status label with background color matching tolerance level
// - Responsive to theme changes (light/dark mode)
// - Clean, card-based design with proper spacing

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/theme/app_color_palette.dart';
import '../../../../common/layout/common_spacer.dart';


/// Card displaying current tolerance percentage with color indicator and progress bar
/// 
/// Shows a prominent percentage value, visual progress bar, and text label
/// indicating the tolerance level (Baseline, Low, Moderate, High, Very High).
class ToleranceSummaryCard extends ConsumerWidget {
  final double currentTolerance;

  const ToleranceSummaryCard({
    required this.currentTolerance,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    // Calculate tolerance label and color based on percentage
    final label = _toleranceLabel(currentTolerance);
    final color = _toleranceColor(currentTolerance, colors);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusLg),
        border: Border.all(color: colors.border),
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(spacing.xl),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label text
          Text(
            'Current tolerance',
            style: typography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),

          CommonSpacer(height: spacing.md),

          // Large tolerance percentage display
          Text(
            '${currentTolerance.toStringAsFixed(1)}%',
            style: typography.heading1.copyWith(
              color: colors.textPrimary,
              height: 1.0,
              letterSpacing: -1.0,
            ),
          ),

          CommonSpacer(height: spacing.xl),

          // Visual progress bar showing tolerance level
          ClipRRect(
            borderRadius: BorderRadius.circular(radii.radiusSm),
            child: LinearProgressIndicator(
              value: (currentTolerance / 100).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),

          CommonSpacer(height: spacing.md),

          // Status label chip with color-coded background
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(radii.radiusSm),
            ),
            child: Text(
              label,
              style: typography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LABEL LOGIC
  // ---------------------------------------------------------------------------

  String _toleranceLabel(double tolerance) {
    if (tolerance < 10) return 'Baseline';
    if (tolerance < 30) return 'Low';
    if (tolerance < 50) return 'Moderate';
    if (tolerance < 70) return 'High';
    return 'Very high';
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS
  // ---------------------------------------------------------------------------

  /// Returns color based on tolerance percentage
  /// - < 10%: Success (green)
  /// - < 30%: Info (blue)
  /// - < 50%: Warning (yellow)
  /// - < 70%: Deep orange
  /// - >= 70%: Error (red)
  Color _toleranceColor(double tolerance, ColorPalette colors) {
    if (tolerance < 10) return colors.success;
    if (tolerance < 30) return colors.info;
    if (tolerance < 50) return colors.warning;
    if (tolerance < 70) return Colors.deepOrange;
    return colors.error;
  }
}


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
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
  const ToleranceSummaryCard({required this.currentTolerance, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    // Calculate tolerance label and color based on percentage
    final label = _toleranceLabel(currentTolerance);
    final color = _toleranceColor(currentTolerance, c);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border),
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(sp.xl),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Label text
          Text(
            'Current tolerance',
            style: tx.bodySmall.copyWith(color: c.textSecondary),
          ),
          CommonSpacer(height: sp.md),
          // Large tolerance percentage display
          Text(
            '${currentTolerance.toStringAsFixed(1)}%',
            style: tx.heading1.copyWith(
              color: c.textPrimary,
              height: 1.0,
              letterSpacing: -1.0,
            ),
          ),
          CommonSpacer(height: sp.xl),
          // Visual progress bar showing tolerance level
          ClipRRect(
            borderRadius: BorderRadius.circular(sh.radiusSm),
            child: LinearProgressIndicator(
              value: (currentTolerance / 100).clamp(0.0, 1.0),
              minHeight: sp.md,
              backgroundColor: c.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          CommonSpacer(height: sp.md),
          // Status label chip with color-coded background
          Container(
            padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            child: Text(
              label,
              style: tx.bodySmall.copyWith(
                color: color,
                fontWeight: tx.bodyBold.fontWeight,
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
    if (tolerance < 70) return colors.error;
    return colors.error;
  }
}

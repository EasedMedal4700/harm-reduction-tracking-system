// Tolerance Stats Card Widget
// 
// Created: 2024-11-10
// Last Modified: 2025-12-14
// 
// Purpose:
// Displays key tolerance metrics in a two-column grid layout including half-life,
// days to baseline, tolerance decay period, and recent use count. Provides at-a-glance
// understanding of substance tolerance characteristics.
// 
// Features:
// - Two-column grid layout for efficient space usage
// - Icons for each metric type
// - Divider between columns for visual separation
// - Calculates and displays days until tolerance returns to baseline
// - Shows tolerance model parameters (half-life, decay days)

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../models/tolerance_model.dart';

/// Card displaying key tolerance metrics in a grid layout
/// 
/// Shows important tolerance information including pharmacological parameters
/// and usage statistics in an easy-to-scan format.
class ToleranceStatsCard extends ConsumerWidget {
  final ToleranceModel toleranceModel;
  final double daysUntilBaseline;
  final int recentUseCount;

  const ToleranceStatsCard({
    required this.toleranceModel,
    required this.daysUntilBaseline,
    required this.recentUseCount,
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
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(spacing.cardPadding),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Key metrics',
            style: typography.heading4.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.lg),

          // TWO COLUMN GRID
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricItem(
                      context,
                      label: 'Half-life',
                      value: '${toleranceModel.halfLifeHours}h',
                      icon: Icons.timelapse,
                    ),
                    SizedBox(height: spacing.lg),
                    _metricItem(
                      context,
                      label: 'Days to baseline',
                      value: daysUntilBaseline <= 0
                          ? 'Baseline'
                          : '${daysUntilBaseline.toStringAsFixed(1)} days',
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),

              // Vertical divider between columns
              Container(
                width: 1,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: spacing.lg),
                color: colors.divider,
              ),

              // RIGHT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricItem(
                      context,
                      label: 'Tolerance decay',
                      value: '${toleranceModel.toleranceDecayDays} days',
                      icon: Icons.trending_down,
                    ),
                    SizedBox(height: spacing.lg),
                    _metricItem(
                      context,
                      label: 'Recent uses',
                      value: '$recentUseCount',
                      icon: Icons.history,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER METHODS
  // ---------------------------------------------------------------------------

  /// Builds a single metric item with icon, label, and value
  /// 
  /// Used to display individual statistics in a consistent format.
  Widget _metricItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon and label row
        Row(
          children: [
            Icon(icon, size: 16, color: colors.textSecondary),
            SizedBox(width: spacing.xs),
            Text(
              label,
              style: typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        // Value text (indented to align with label)
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            value,
            style: typography.bodyBold.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

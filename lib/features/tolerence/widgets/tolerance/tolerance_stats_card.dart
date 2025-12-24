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
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border),
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(sp.cardPadding),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Section header
          Text(
            'Key metrics',
            style: tx.heading4.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.lg),
          // TWO COLUMN GRID
          Row(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              // LEFT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    _metricItem(
                      context,
                      label: 'Half-life',
                      value: '${toleranceModel.halfLifeHours}h',
                      icon: Icons.timelapse,
                    ),
                    SizedBox(height: sp.lg),
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
                width: context.sizes.borderThin,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: sp.lg),
                color: c.divider,
              ),
              // RIGHT COLUMN
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    _metricItem(
                      context,
                      label: 'Tolerance decay',
                      value: '${toleranceModel.toleranceDecayDays} days',
                      icon: Icons.trending_down,
                    ),
                    SizedBox(height: sp.lg),
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        // Icon and label row
        Row(
          children: [
            Icon(icon, size: context.sizes.iconSm, color: c.textSecondary),
            SizedBox(width: sp.xs),
            Text(label, style: tx.bodySmall.copyWith(color: c.textSecondary)),
          ],
        ),
        SizedBox(height: 4),
        // Value text (indented to align with label)
        Padding(
          padding: EdgeInsets.only(left: context.sizes.iconSm + sp.xs),
          child: Text(value, style: tx.bodyBold.copyWith(color: c.textPrimary)),
        ),
      ],
    );
  }
}

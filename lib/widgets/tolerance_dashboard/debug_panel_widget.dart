// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../utils/tolerance_calculator.dart';

class DebugPanelWidget extends ConsumerWidget {
  final ToleranceResult? systemTolerance;
  final Map<String, bool> substanceActiveStates;
  final Map<String, Map<String, double>> substanceContributions;

  const DebugPanelWidget({
    super.key,
    required this.systemTolerance,
    required this.substanceActiveStates,
    required this.substanceContributions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    return Container(
      margin: EdgeInsets.all(spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusSm),
        border: Border.all(color: colors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Icon(
                Icons.bug_report,
                color: colors.warning,
                size: 20.0,
              ),
              SizedBox(width: spacing.xs),
              Text(
                'Debug Panel',
                style: typography.bodyLarge.copyWith(
                  color: colors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.md),

          // SYSTEM TOLERANCE DATA
          _DebugSection(
            title: 'System Tolerance',
            content: systemTolerance?.bucketPercents.entries
                .map((e) => '${e.key}: ${e.value.toStringAsFixed(1)}%')
                .join('\n') ?? 'No data',
          ),

          SizedBox(height: spacing.sm),

          // ACTIVE SUBSTANCES
          _DebugSection(
            title: 'Active Substances',
            content: substanceActiveStates.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .join(', ').isEmpty ? 'None' : substanceActiveStates.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .join(', '),
          ),

          SizedBox(height: spacing.sm),

          // SUBSTANCE CONTRIBUTIONS
          _DebugSection(
            title: 'Contributions by Bucket',
            content: substanceContributions.entries
                .map((bucket) {
                  final contribs = bucket.value.entries
                      .map((e) => '  ${e.key}: ${(e.value * 100).toStringAsFixed(0)}%')
                      .join('\n');
                  return '${bucket.key}:\n$contribs';
                })
                .join('\n\n'),
          ),
        ],
      ),
    );
  }
}

class _DebugSection extends ConsumerWidget {
  final String title;
  final String content;

  const _DebugSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: typography.bodySmall.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.sm),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(radii.radiusXs),
          ),
          child: Text(
            content,
            style: typography.bodySmall.copyWith(
              color: colors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
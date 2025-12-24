// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/theme/app_typography.dart';
import '../../../../utils/tolerance_calculator.dart';

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
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    return Container(
      margin: EdgeInsets.all(sp.md),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusSm),
        border: Border.all(color: c.warning),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER
          Row(
            children: [
              Icon(
                Icons.bug_report,
                color: c.warning,
                size: context.sizes.iconSm,
              ),
              SizedBox(width: sp.xs),
              Text(
                'Debug Panel',
                style: tx.bodyLarge.copyWith(
                  color: c.warning,
                  fontWeight: tx.bodyBold.fontWeight,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          // SYSTEM TOLERANCE DATA
          _DebugSection(
            title: 'System Tolerance',
            content:
                systemTolerance?.bucketPercents.entries
                    .map((e) => '${e.key}: ${e.value.toStringAsFixed(1)}%')
                    .join('\n') ??
                'No data',
          ),
          SizedBox(height: sp.sm),
          // ACTIVE SUBSTANCES
          _DebugSection(
            title: 'Active Substances',
            content:
                substanceActiveStates.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .join(', ')
                    .isEmpty
                ? 'None'
                : substanceActiveStates.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .join(', '),
          ),
          SizedBox(height: sp.sm),
          // SUBSTANCE CONTRIBUTIONS
          _DebugSection(
            title: 'Contributions by Bucket',
            content: substanceContributions.entries
                .map((bucket) {
                  final contribs = bucket.value.entries
                      .map(
                        (e) =>
                            '  ${e.key}: ${(e.value * 100).toStringAsFixed(0)}%',
                      )
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
  const _DebugSection({required this.title, required this.content});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          title,
          style: tx.bodySmall.copyWith(
            color: c.textSecondary,
            fontWeight: tx.bodyBold.fontWeight,
          ),
        ),
        SizedBox(height: sp.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: c.surfaceVariant,
            borderRadius: BorderRadius.circular(sh.radiusXs),
          ),
          child: Text(
            content,
            style: tx.bodySmall.copyWith(
              color: c.textPrimary,
              fontFamily: AppTypographyConstants.fontFamilyMonospace,
            ),
          ),
        ),
      ],
    );
  }
}

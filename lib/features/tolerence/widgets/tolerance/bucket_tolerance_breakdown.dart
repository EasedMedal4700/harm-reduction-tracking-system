// Bucket Tolerance Breakdown Widget
//
// Created: 2024-03-15
// Last Modified: 2025-01-23
//
// Purpose:
// Displays a comprehensive breakdown of tolerance levels across all neurochemical
// buckets (systems). Shows active status, percentage, progress bars, and metadata
// for each bucket defined in the tolerance model.
//
// Features:
// - Displays all neurochemical buckets with tolerance percentages
// - Color-coded progress bars based on tolerance level (green/yellow/orange/red)
// - Active bucket indicators with badge
// - Bucket descriptions and metadata (weight, type, active level)
// - Tap interaction for detailed bucket view (coming soon)
// - Conditional notes display
// - Empty state handling (auto-hides when no buckets)
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully modernized with granular theme API and ConsumerWidget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/tolerance_bucket.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../utils/bucket_tolerance_calculator.dart';
// NEW THEME SYSTEM
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

/// Modern bucket tolerance breakdown widget using the NEW theme system.
///
/// Displays all neurochemical buckets with their current tolerance levels,
/// active states, and metadata. Uses color-coded progress bars for quick
/// visual assessment of tolerance states across systems.
class BucketToleranceBreakdown extends ConsumerWidget {
  final Map<String, BucketToleranceResult> bucketResults;
  final BucketToleranceModel model;
  const BucketToleranceBreakdown({
    super.key,
    required this.bucketResults,
    required this.model,
  });

  /// Returns color based on tolerance level (0-1 scale).
  /// <0.25: success, <0.50: warning, <0.75: orange, >=0.75: error
  Color _getColorForTolerance(double value, BuildContext context) {
    final c = context.colors;
    if (value < 0.25) return c.success;
    if (value < 0.50) return c.warning;
    if (value < 0.75) return c.warning;
    return c.error;
  }

  String _getBucketDisplayName(String type) {
    return BucketDefinitions.getDisplayName(type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    // THEME ACCESS
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    final ac = context.accent;
    // EMPTY STATE - Auto-hide when no bucket data
    if (bucketResults.isEmpty) {
      return const SizedBox.shrink();
    }
    // MAIN CONTAINER
    return Container(
      margin: EdgeInsets.all(sp.lg),
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(
          color: c.border.withValues(alpha: 0.6),
          width: context.sizes.borderThin,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER - Section title with analytics icon
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: ac.primary,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Text('Neurochemical Tolerance Breakdown', style: tx.heading3),
            ],
          ),
          CommonSpacer.vertical(sp.lg),
          // BUCKET CARDS - Display each bucket defined in the model
          // Only show buckets that exist in both neuroBuckets and bucketResults
          ...BucketDefinitions.orderedBuckets
              .where((bucketType) {
                return model.neuroBuckets.containsKey(bucketType) &&
                    bucketResults.containsKey(bucketType);
              })
              .map((bucketType) {
                final bucket = model.neuroBuckets[bucketType]!;
                final result = bucketResults[bucketType]!;
                final toleranceColor = _getColorForTolerance(
                  result.tolerance,
                  context,
                );
                return Padding(
                  padding: EdgeInsets.only(bottom: sp.lg),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Bucket details page coming soon',
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(sp.md),
                      decoration: BoxDecoration(
                        color: c.surfaceVariant,
                        borderRadius: BorderRadius.circular(sh.radiusMd),
                        border: Border.all(
                          color: c.border,
                          width: context.sizes.borderThin,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          // BUCKET HEADER - Name, description, and status
                          Row(
                            mainAxisAlignment:
                                AppLayout.mainAxisAlignmentSpaceBetween,
                            children: [
                              // Bucket name and description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      AppLayout.crossAxisAlignmentStart,
                                  children: [
                                    Text(
                                      _getBucketDisplayName(bucketType),
                                      style: tx.bodyBold,
                                    ),
                                    CommonSpacer.vertical(sp.xs),
                                    Text(
                                      BucketDefinitions.getDescription(
                                        bucketType,
                                      ),
                                      style: tx.caption,
                                    ),
                                  ],
                                ),
                              ),
                              // Active badge and tolerance percentage
                              Row(
                                children: [
                                  if (result.isActive)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: sp.sm,
                                        vertical: sp.xs / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ac.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          sh.radiusSm,
                                        ),
                                      ),
                                      child: Text(
                                        'ACTIVE',
                                        style: tx.captionBold.copyWith(
                                          color: ac.primary,
                                          fontSize: tx.caption.fontSize,
                                        ),
                                      ),
                                    ),
                                  CommonSpacer.horizontal(sp.sm),
                                  // Tolerance percentage with color coding
                                  Text(
                                    '${(result.tolerance * 100).toStringAsFixed(1)}%',
                                    style: tx.bodyBold.copyWith(
                                      color: toleranceColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CommonSpacer.vertical(sp.sm),
                          // PROGRESS BAR - Visual tolerance indicator
                          ClipRRect(
                            borderRadius: BorderRadius.circular(sh.radiusSm),
                            child: LinearProgressIndicator(
                              value: result.tolerance > 1
                                  ? 1
                                  : result.tolerance,
                              minHeight: sp.sm,
                              backgroundColor: c.border.withValues(alpha: 0.4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                toleranceColor,
                              ),
                            ),
                          ),
                          CommonSpacer.vertical(sp.xs),
                          // METADATA - Bucket weight, type, and active level
                          Row(
                            mainAxisAlignment:
                                AppLayout.mainAxisAlignmentSpaceBetween,
                            children: [
                              Text(
                                'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                                style: tx.caption,
                              ),
                              Text(
                                'Active: ${(result.activeLevel * 100).toStringAsFixed(1)}%',
                                style: tx.captionBold.copyWith(
                                  color: result.isActive
                                      ? ac.primary
                                      : c.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          // NOTES - Additional tolerance model notes if present
          if (model.notes != null) ...[
            Divider(color: c.border, height: sp.xl),
            Row(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Icon(
                  Icons.info_outline,
                  size: context.sizes.iconSm,
                  color: c.textSecondary,
                ),
                CommonSpacer.horizontal(sp.sm),
                Expanded(
                  child: Text(
                    model.notes!,
                    style: tx.caption.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

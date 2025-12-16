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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tolerance_bucket.dart';
import '../../models/bucket_definitions.dart';
import '../../utils/bucket_tolerance_calculator.dart';

// NEW THEME SYSTEM
import '../../constants/theme/app_theme_extension.dart';

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
    final colors = context.colors;
    if (value < 0.25) return colors.success;
    if (value < 0.50) return colors.warning;
    if (value < 0.75) return Colors.orangeAccent;
    return colors.error;
  }

  String _getBucketDisplayName(String type) {
    return BucketDefinitions.getDisplayName(type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // THEME ACCESS
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;
    final accent = context.accent;

    // EMPTY STATE - Auto-hide when no bucket data
    if (bucketResults.isEmpty) {
      return const SizedBox.shrink();
    }

    // MAIN CONTAINER
    return Container(
      margin: EdgeInsets.all(spacing.lg),
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusLg),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER - Section title with analytics icon
          Row(
            children: [
              Icon(Icons.analytics_outlined,
                  color: accent.primary, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Neurochemical Tolerance Breakdown',
                style: typography.heading3,
              ),
            ],
          ),

          SizedBox(height: spacing.lg),

          // BUCKET CARDS - Display each bucket defined in the model
          // Only show buckets that exist in both neuroBuckets and bucketResults
          ...BucketDefinitions.orderedBuckets.where((bucketType) {
            return model.neuroBuckets.containsKey(bucketType) &&
                bucketResults.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = model.neuroBuckets[bucketType]!;
            final result = bucketResults[bucketType]!;
            final toleranceColor = _getColorForTolerance(result.tolerance, context);

            return Padding(
              padding: EdgeInsets.only(bottom: spacing.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(radii.radiusMd),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bucket details page coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(radii.radiusMd),
                    border: Border.all(
                      color: colors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BUCKET HEADER - Name, description, and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bucket name and description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getBucketDisplayName(bucketType),
                                  style: typography.bodyBold,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  BucketDefinitions.getDescription(bucketType),
                                  style: typography.caption,
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
                                    horizontal: spacing.sm,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: typography.captionBold.copyWith(
                                      color: accent.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              SizedBox(width: spacing.sm),

                              // Tolerance percentage with color coding
                              Text(
                                '${(result.tolerance * 100).toStringAsFixed(1)}%',
                                style: typography.bodyBold.copyWith(
                                  color: toleranceColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: spacing.sm),

                      // PROGRESS BAR - Visual tolerance indicator
                      ClipRRect(
                        borderRadius: BorderRadius.circular(radii.radiusSm),
                        child: LinearProgressIndicator(
                          value: result.tolerance > 1 ? 1 : result.tolerance,
                          minHeight: 8,
                          backgroundColor: colors.border.withValues(alpha: 0.4),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(toleranceColor),
                        ),
                      ),

                      SizedBox(height: spacing.xs),

                      // METADATA - Bucket weight, type, and active level
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                            style: typography.caption,
                          ),
                          Text(
                            'Active: ${(result.activeLevel * 100).toStringAsFixed(1)}%',
                            style: typography.captionBold.copyWith(
                              color: result.isActive
                                  ? accent.primary
                                  : colors.textSecondary,
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
            Divider(color: colors.border, height: spacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: colors.textSecondary),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    model.notes!,
                    style: typography.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}

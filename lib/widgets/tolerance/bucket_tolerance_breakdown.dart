// MIGRATION

import 'package:flutter/material.dart';

import '../../models/tolerance_bucket.dart';
import '../../models/bucket_definitions.dart';
import '../../utils/bucket_tolerance_calculator.dart';

// NEW THEME SYSTEM
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/theme/app_theme.dart';

/// Modern bucket tolerance breakdown widget using the NEW theme system
class BucketToleranceBreakdown extends StatelessWidget {
  final Map<String, BucketToleranceResult> bucketResults;
  final BucketToleranceModel model;

  const BucketToleranceBreakdown({
    super.key,
    required this.bucketResults,
    required this.model,
  });

  Color _getColorForTolerance(double value, AppTheme t) {
    if (value < 0.25) return t.colors.success;
    if (value < 0.50) return t.colors.warning;
    if (value < 0.75) return Colors.orangeAccent;
    return t.colors.error;
  }

  String _getBucketDisplayName(String type) {
    return BucketDefinitions.getDisplayName(type);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    if (bucketResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(t.spacing.lg),
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
        border: Border.all(
          color: t.colors.border.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.analytics_outlined,
                  color: t.accent.primary, size: 20),
              SizedBox(width: t.spacing.sm),
              Text(
                'Neurochemical Tolerance Breakdown',
                style: t.typography.heading3,
              ),
            ],
          ),

          SizedBox(height: t.spacing.lg),

          // Buckets — only the ones *defined in the model*
          ...BucketDefinitions.orderedBuckets.where((bucketType) {
            return model.neuroBuckets.containsKey(bucketType) &&
                bucketResults.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = model.neuroBuckets[bucketType]!;
            final result = bucketResults[bucketType]!;
            final toleranceColor = _getColorForTolerance(result.tolerance, t);

            return Padding(
              padding: EdgeInsets.only(bottom: t.spacing.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bucket details page coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(t.spacing.md),
                  decoration: BoxDecoration(
                    color: t.colors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppThemeConstants.radiusMd),
                    border: Border.all(
                      color: t.colors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name + description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getBucketDisplayName(bucketType),
                                  style: t.typography.bodyBold,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  BucketDefinitions.getDescription(bucketType),
                                  style: t.typography.caption,
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              if (result.isActive)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: t.spacing.sm,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: t.accent.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: t.typography.captionBold.copyWith(
                                      color: t.accent.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              SizedBox(width: t.spacing.sm),

                              // Percentage
                              Text(
                                '${(result.tolerance * 100).toStringAsFixed(1)}%',
                                style: t.typography.bodyBold.copyWith(
                                  color: toleranceColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: t.spacing.sm),

                      // Progress bar
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppThemeConstants.radiusSm),
                        child: LinearProgressIndicator(
                          value:
                              result.tolerance > 1 ? 1 : result.tolerance,
                          minHeight: 8,
                          backgroundColor: t.colors.border.withOpacity(0.4),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(toleranceColor),
                        ),
                      ),

                      SizedBox(height: t.spacing.xs),

                      // Extra metadata
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                            style: t.typography.caption,
                          ),
                          Text(
                            'Active: ${(result.activeLevel * 100).toStringAsFixed(1)}%',
                            style: t.typography.captionBold.copyWith(
                              color: result.isActive
                                  ? t.accent.primary
                                  : t.colors.textSecondary,
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

          // Notes
          if (model.notes != null) ...[
            Divider(color: t.colors.border, height: t.spacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: t.colors.textSecondary),
                SizedBox(width: t.spacing.sm),
                Expanded(
                  child: Text(
                    model.notes!,
                    style: t.typography.caption.copyWith(
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

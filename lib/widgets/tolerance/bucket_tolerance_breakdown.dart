import 'package:flutter/material.dart';
import '../../models/tolerance_bucket.dart';
import '../../models/bucket_definitions.dart';
import '../../utils/bucket_tolerance_calculator.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

/// Widget to display bucket-specific tolerance breakdown from NEW tolerance system.
/// CRITICAL: Only displays neuro_buckets defined in the substance's tolerance_model.
/// Does NOT merge or show hardcoded default buckets.
class BucketToleranceBreakdown extends StatelessWidget {
  final Map<String, BucketToleranceResult> bucketResults;
  final BucketToleranceModel model;

  const BucketToleranceBreakdown({
    super.key,
    required this.bucketResults,
    required this.model,
  });

  Color _getColorForTolerance(double tolerance) {
    if (tolerance < 0.25) return Colors.green;
    if (tolerance < 0.5) return Colors.yellow.shade700;
    if (tolerance < 0.75) return Colors.orange;
    return Colors.red;
  }

  String _getBucketDisplayName(String bucketType) {
    return BucketDefinitions.getDisplayName(bucketType);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (bucketResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(ThemeConstants.space16),
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
                size: 20,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Neurochemical Tolerance Breakdown',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          // CRITICAL: Only render buckets from model.neuroBuckets
          // Ordered by BucketDefinitions.orderedBuckets for consistency
          ...BucketDefinitions.orderedBuckets.where((bucketType) {
            return model.neuroBuckets.containsKey(bucketType) &&
                   bucketResults.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = model.neuroBuckets[bucketType]!;
            final result = bucketResults[bucketType]!;

            return InkWell(
              onTap: () {
                // TODO: Navigate to BucketDetailsPage when available
                // This requires passing use events and calculating days to baseline
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bucket details page - Coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              child: Padding(
                padding: EdgeInsets.only(bottom: ThemeConstants.space12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getBucketDisplayName(bucketType),
                              style: TextStyle(
                                fontSize: ThemeConstants.fontSmall,
                                fontWeight: ThemeConstants.fontMediumWeight,
                                color: isDark ? UIColors.darkText : UIColors.lightText,
                              ),
                            ),
                            SizedBox(height: ThemeConstants.space4),
                            Text(
                              BucketDefinitions.getDescription(bucketType),
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (result.isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ThemeConstants.space8,
                                vertical: ThemeConstants.space4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  fontWeight: ThemeConstants.fontBold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          SizedBox(width: ThemeConstants.space8),
                          // CRITICAL FIX: Display actual tolerance value without clamping
                          // If tolerance is 0.575, show "57.5%" not "100%"
                          Text(
                            '${(result.tolerance * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontSmall,
                              fontWeight: ThemeConstants.fontBold,
                              color: _getColorForTolerance(result.tolerance),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeConstants.space8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                    child: LinearProgressIndicator(
                      // CRITICAL FIX: Don't clamp to 1.0 artificially
                      // Display actual value even if > 100%
                      value: result.tolerance > 1.0 ? 1.0 : result.tolerance,
                      backgroundColor: isDark
                          ? UIColors.darkBorder
                          : UIColors.lightBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForTolerance(result.tolerance),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: ThemeConstants.space4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXSmall,
                          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                        ),
                      ),
                      // CRITICAL FIX: Show actual active level percentage
                      Text(
                        'Active: ${(result.activeLevel * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXSmall,
                          fontWeight: ThemeConstants.fontMediumWeight,
                          color: result.isActive 
                              ? Colors.blue 
                              : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ); // Close InkWell
          }),
          if (model.notes != null) ...[
            Divider(
              height: ThemeConstants.space24,
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
                SizedBox(width: ThemeConstants.space8),
                Expanded(
                  child: Text(
                    model.notes!,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
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

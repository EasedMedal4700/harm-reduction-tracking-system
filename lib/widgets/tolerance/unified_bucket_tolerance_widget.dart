import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../utils/tolerance_calculator.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Unified widget that combines System Tolerance and Substance-Specific Breakdown
/// Shows both overall bucket state AND per-substance contributions in one view
class UnifiedBucketToleranceWidget extends StatefulWidget {
  final ToleranceModel toleranceModel;
  final ToleranceResult toleranceResult;
  final String substanceName;

  const UnifiedBucketToleranceWidget({
    super.key,
    required this.toleranceModel,
    required this.toleranceResult,
    required this.substanceName,
  });

  @override
  State<UnifiedBucketToleranceWidget> createState() => _UnifiedBucketToleranceWidgetState();
}

class _UnifiedBucketToleranceWidgetState extends State<UnifiedBucketToleranceWidget> {
  bool _showDebug = false;
  String? _expandedBucket;

  Color _getColorForTolerance(double tolerance) {
    if (tolerance < 0.25) return Colors.green;
    if (tolerance < 0.5) return Colors.yellow.shade700;
    if (tolerance < 0.75) return Colors.orange;
    return Colors.red;
  }

  Color _getStateColor(ToleranceSystemState state) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return Colors.green;
      case ToleranceSystemState.lightStress:
        return Colors.blue;
      case ToleranceSystemState.moderateStrain:
        return Colors.orange;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrange;
      case ToleranceSystemState.depleted:
        return Colors.red;
    }
  }

  IconData _getBucketIcon(String bucket) {
    final iconName = BucketDefinitions.getIconName(bucket);
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'bolt':
        return Icons.bolt;
      case 'favorite':
        return Icons.favorite;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'sentiment_satisfied_alt':
        return Icons.sentiment_satisfied_alt;
      case 'medication':
        return Icons.medication;
      case 'blur_on':
        return Icons.blur_on;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.science;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // Header with debug toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'Neurochemical Tolerance',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontMedium,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _showDebug = !_showDebug);
                    },
                    tooltip: 'Toggle debug calculations',
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          
          if (_showDebug) ...[
            SizedBox(height: ThemeConstants.space8),
            Container(
              padding: EdgeInsets.all(ThemeConstants.space8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber),
                  SizedBox(width: ThemeConstants.space8),
                  Expanded(
                    child: Text(
                      'Debug mode: Tap any bucket to see calculation details',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontXSmall,
                        color: isDark ? UIColors.darkText : UIColors.lightText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: ThemeConstants.space16),

          // Render all buckets from this substance's model
          ...BucketDefinitions.orderedBuckets.where((bucketType) {
            return widget.toleranceModel.neuroBuckets.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = widget.toleranceModel.neuroBuckets[bucketType]!;
            final percent = widget.toleranceResult.bucketPercents[bucketType] ?? 0.0;
            final state = ToleranceCalculator.classifyState(percent);

            final isExpanded = _expandedBucket == bucketType;

            return _buildBucketCard(
              context,
              bucketType,
              bucket,
              percent,
              state,
              isExpanded,
              isDark,
            );
          }),

          // Notes section (only if notes are non-empty)
          if (widget.toleranceModel.notes.isNotEmpty) ...[
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
                    widget.toleranceModel.notes,
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

  Widget _buildBucketCard(
    BuildContext context,
    String bucketType,
    NeuroBucket bucket,
    double bucketPercent,
    ToleranceSystemState state,
    bool isExpanded,
    bool isDark,
  ) {
    final substanceTolerance = bucketPercent / 100.0;
    final isActive = bucketPercent > 0.1;

    return Card(
      margin: EdgeInsets.only(bottom: ThemeConstants.space12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        side: BorderSide(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (_showDebug) {
            setState(() {
              _expandedBucket = isExpanded ? null : bucketType;
            });
          }
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        child: Padding(
          padding: EdgeInsets.all(ThemeConstants.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(
                    _getBucketIcon(bucketType),
                    size: 24,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                  SizedBox(width: ThemeConstants.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          BucketDefinitions.getDisplayName(bucketType),
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSmall,
                            fontWeight: ThemeConstants.fontSemiBold,
                            color: isDark ? UIColors.darkText : UIColors.lightText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          BucketDefinitions.getDescription(bucketType),
                          style: TextStyle(
                            fontSize: ThemeConstants.fontXSmall,
                            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: ThemeConstants.space8),
                  if (isActive)
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
                ],
              ),
              
              SizedBox(height: ThemeConstants.space12),

              // System-wide tolerance (ALL substances combined)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System-wide (all substances):',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${bucketPercent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          fontWeight: ThemeConstants.fontBold,
                          color: _getColorForTolerance(substanceTolerance),
                        ),
                      ),
                      SizedBox(width: ThemeConstants.space8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStateColor(state).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStateColor(state).withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          state.displayName,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: ThemeConstants.fontMediumWeight,
                            color: _getStateColor(state),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ThemeConstants.space8),

              // This substance's contribution
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.substanceName} contribution:',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      fontWeight: ThemeConstants.fontMediumWeight,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                  Text(
                    '${(substanceTolerance * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: ThemeConstants.fontBold,
                      color: _getColorForTolerance(substanceTolerance),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ThemeConstants.space8),

              // Progress bar for this substance
              ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                child: LinearProgressIndicator(
                  value: substanceTolerance > 1.0 ? 1.0 : substanceTolerance,
                  backgroundColor: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForTolerance(substanceTolerance),
                  ),
                  minHeight: 8,
                ),
              ),

              SizedBox(height: ThemeConstants.space8),

              // Stats row
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
                  Text(
                    'Active: ${isActive ? 'Yes' : 'No'}',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      fontWeight: ThemeConstants.fontMediumWeight,
                      color: isActive 
                          ? Colors.blue 
                          : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),

              // Debug section (expanded)
              if (_showDebug && isExpanded) ...[
                SizedBox(height: ThemeConstants.space12),
                Divider(color: isDark ? UIColors.darkBorder : UIColors.lightBorder),
                SizedBox(height: ThemeConstants.space8),
                _buildDebugSection(bucketType, bucket, state, bucketPercent, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebugSection(String bucketType, NeuroBucket bucket, ToleranceSystemState state, double bucketPercent, bool isDark) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space12),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.grey.shade900.withOpacity(0.5)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🐛 CALCULATION DEBUG',
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              fontWeight: ThemeConstants.fontBold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          
          _debugRow('Bucket Type', bucketType, isDark),
          _debugRow('Weight', bucket.weight.toStringAsFixed(3), isDark),
          _debugRow('Tolerance Type', bucket.toleranceType ?? 'unknown', isDark),
          
          Divider(height: 16, color: Colors.grey),
          
          _debugRow('Half-life (hours)', widget.toleranceModel.halfLifeHours.toStringAsFixed(1), isDark),
          _debugRow('Active Threshold', widget.toleranceModel.activeThreshold.toStringAsFixed(3), isDark),
          _debugRow('Tolerance Gain Rate', widget.toleranceModel.toleranceGainRate.toStringAsFixed(3), isDark),
          _debugRow('Decay Days', widget.toleranceModel.toleranceDecayDays.toStringAsFixed(1), isDark),
          
          Divider(height: 16, color: Colors.grey),
          
          _debugRow('Current Tolerance %', bucketPercent.toStringAsFixed(2), isDark),
          _debugRow('Raw Load', (widget.toleranceResult.bucketRawLoads[bucketType] ?? 0).toStringAsFixed(4), isDark),
          _debugRow('State', state.displayName, isDark),

          SizedBox(height: ThemeConstants.space12),
          
          Text(
            'FORMULA EXPLANATION:',
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              fontWeight: ThemeConstants.fontBold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'NEW PER-EVENT TOLERANCE CALCULATION:\n'
            '1. Active Level = e^(-hours_since_use / half_life)\n'
            '2. Dose Normalized = dose_mg / standard_unit_mg\n'
            '3. For EACH use event:\n'
            '   base_contribution = dose_norm × weight × potency × gain_rate × 0.08\n'
            '4. Apply decay to EACH event individually:\n'
            '   if active_level > threshold: NO DECAY (pause)\n'
            '   else: decay_factor = e^(-hours / (decay_days × 24))\n'
            '5. event_tolerance = base_contribution × decay_factor\n'
            '6. Total tolerance = SUM of all event_tolerance values\n\n'
            'KEY: Tolerance added ONCE per use, not on every recalc!\n'
            'Example: 8×5mg over 4 days → 20-40% tolerance',
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall - 1,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _debugRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label + ':',
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // Note: days-to-baseline is computed at the engine level (ToleranceResult.overallDaysUntilBaseline)
}

import 'package:flutter/material.dart';
import '../../models/tolerance_bucket.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../utils/bucket_tolerance_calculator.dart' as bucket_calc;
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import '../../screens/bucket_details_page.dart';

/// Unified widget that combines System Tolerance and Substance-Specific Breakdown
/// Shows both overall bucket state AND per-substance contributions in one view
class UnifiedBucketToleranceWidget extends StatefulWidget {
  final Map<String, bucket_calc.BucketToleranceResult> bucketResults;
  final BucketToleranceModel model;
  final String substanceName;
  final List<bucket_calc.UseEvent> useEvents;
  final Map<String, double>? systemTolerances; // Overall system tolerance per bucket
  final Map<String, ToleranceSystemState>? systemStates;

  const UnifiedBucketToleranceWidget({
    super.key,
    required this.bucketResults,
    required this.model,
    required this.substanceName,
    required this.useEvents,
    this.systemTolerances,
    this.systemStates,
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
            return widget.model.neuroBuckets.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = widget.model.neuroBuckets[bucketType]!;
            final result = widget.bucketResults[bucketType];
            final systemTolerance = widget.systemTolerances?[bucketType] ?? 0.0;
            final systemState = widget.systemStates?[bucketType] ?? ToleranceSystemState.recovered;
            
            final isExpanded = _expandedBucket == bucketType;

            return _buildBucketCard(
              context,
              bucketType,
              bucket,
              result,
              systemTolerance,
              systemState,
              isExpanded,
              isDark,
            );
          }),

          // Notes section
          if (widget.model.notes != null) ...[
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
                    widget.model.notes!,
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
    ToleranceBucket bucket,
    bucket_calc.BucketToleranceResult? result,
    double systemTolerance,
    ToleranceSystemState systemState,
    bool isExpanded,
    bool isDark,
  ) {
    final substanceTolerance = result?.tolerance ?? 0.0;
    final activeLevel = result?.activeLevel ?? 0.0;
    final isActive = result?.isActive ?? false;

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
            // Toggle expand for debug view
            setState(() {
              _expandedBucket = isExpanded ? null : bucketType;
            });
          } else {
            // Navigate to details page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BucketDetailsPage(
                  bucketType: bucketType,
                  result: result ?? bucket_calc.BucketToleranceResult(
                    bucketType: bucketType,
                    tolerance: 0.0,
                    activeLevel: 0.0,
                    isActive: false,
                  ),
                  bucket: bucket,
                  contributingUses: widget.useEvents,
                  daysToBaseline: _estimateDaysToBaseline(substanceTolerance, widget.model.toleranceDecayDays),
                  substanceNotes: widget.model.notes,
                ),
              ),
            );
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
                        '${systemTolerance.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          fontWeight: ThemeConstants.fontBold,
                          color: _getColorForTolerance(systemTolerance / 100),
                        ),
                      ),
                      SizedBox(width: ThemeConstants.space8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStateColor(systemState).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStateColor(systemState).withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          systemState.displayName,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: ThemeConstants.fontMediumWeight,
                            color: _getStateColor(systemState),
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
                    'Active: ${(activeLevel * 100).toStringAsFixed(1)}%',
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
                _buildDebugSection(bucket, result, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebugSection(ToleranceBucket bucket, bucket_calc.BucketToleranceResult? result, bool isDark) {
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
          
          _debugRow('Bucket Type', bucket.type, isDark),
          _debugRow('Weight', bucket.weight.toStringAsFixed(3), isDark),
          _debugRow('Tolerance Type', bucket.toleranceType, isDark),
          _debugRow('Potency Multiplier', bucket.potencyMultiplier.toStringAsFixed(2), isDark),
          _debugRow('Duration Multiplier', bucket.durationMultiplier.toStringAsFixed(2), isDark),
          
          Divider(height: 16, color: Colors.grey),
          
          _debugRow('Half-life (hours)', widget.model.halfLifeHours.toStringAsFixed(1), isDark),
          _debugRow('Active Threshold', widget.model.activeThreshold.toStringAsFixed(3), isDark),
          _debugRow('Tolerance Gain Rate', widget.model.toleranceGainRate.toStringAsFixed(3), isDark),
          _debugRow('Decay Days', widget.model.toleranceDecayDays.toStringAsFixed(1), isDark),
          
          Divider(height: 16, color: Colors.grey),
          
          _debugRow('Current Tolerance', result != null ? (result.tolerance * 100).toStringAsFixed(2) + '%' : 'N/A', isDark),
          _debugRow('Active Level', result != null ? (result.activeLevel * 100).toStringAsFixed(2) + '%' : 'N/A', isDark),
          _debugRow('Is Active?', result?.isActive == true ? 'YES' : 'NO', isDark),
          _debugRow('Recent Uses', widget.useEvents.length.toString(), isDark),
          
          if (widget.useEvents.isNotEmpty) ...[
            Divider(height: 16, color: Colors.grey),
            Text(
              'Recent Use Events:',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            SizedBox(height: 4),
            ...widget.useEvents.take(5).map((event) {
              final hoursAgo = DateTime.now().difference(event.timestamp).inHours;
              return Padding(
                padding: EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  '• ${event.doseMg.toStringAsFixed(1)}mg - ${hoursAgo}h ago',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }),
          ],

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

  double _estimateDaysToBaseline(double tolerance, double decayDays) {
    if (tolerance <= 0.01) return 0;
    // Assuming baseline is ~5% tolerance
    final baselineThreshold = 0.05;
    if (tolerance <= baselineThreshold) return 0;
    
    // Exponential decay: tolerance = initial × e^(-days / decay_days)
    // Solving for days: days = -decay_days × ln(baseline / current)
    final days = -decayDays * (baselineThreshold / tolerance).abs().clamp(0.001, 1.0);
    return days > 0 ? days : 0;
  }
}

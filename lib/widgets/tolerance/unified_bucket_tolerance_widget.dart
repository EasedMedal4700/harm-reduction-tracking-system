/**
 * Unified Bucket Tolerance Widget
 * 
 * Created: 2024-03-15
 * Last Modified: 2025-01-23
 * 
 * Purpose:
 * Displays comprehensive tolerance information combining system-wide bucket states
 * with substance-specific contributions. Shows per-neurochemical system breakdown
 * with detailed metrics, state classification, and optional debug calculations.
 * 
 * Features:
 * - System-wide tolerance percentages for all neurochemical buckets
 * - Per-substance contribution breakdown for each bucket
 * - Color-coded tolerance levels (green/blue/yellow/orange/red)
 * - State classification badges (Recovered/Light Stress/Moderate Strain/etc.)
 * - Active bucket indicators
 * - Visual progress bars for tolerance levels
 * - Expandable debug mode showing calculation formulas and raw values
 * - Bucket metadata (weight, tolerance type, half-life, decay days)
 * - Optional notes section
 * - Dark/light theme support with neon borders
 */

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: StatefulWidget kept for expand/collapse state. Fully modernized theme API.

import 'package:flutter/material.dart';


import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../utils/tolerance_calculator.dart';

import '../../constants/theme/app_theme_extension.dart';


/// Unified widget combining system tolerance and substance-specific breakdown.
/// 
/// Displays neurochemical bucket states with both:
/// 1. System-wide tolerance (all substances combined)
/// 2. Individual substance contribution to each bucket
/// 
/// Includes expandable debug mode for calculation transparency.
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
  State<UnifiedBucketToleranceWidget> createState() =>
      _UnifiedBucketToleranceWidgetState();
}

class _UnifiedBucketToleranceWidgetState
    extends State<UnifiedBucketToleranceWidget> {
  bool _showDebug = false;
  String? _expandedBucket;

  /// Returns color based on tolerance level (0-1 scale).
  /// <0.25: success, <0.50: info, <0.75: warning, >=0.75: error
  Color _getColorForTolerance(double value, BuildContext context) {
    final colors = context.colors;

    if (value < 0.25) return colors.success;
    if (value < 0.50) return colors.info;
    if (value < 0.75) return colors.warning;
    return colors.error;
  }

  /// Returns color for tolerance state classification.
  Color _getStateColor(ToleranceSystemState state, BuildContext context) {
    final colors = context.colors;

    switch (state) {
      case ToleranceSystemState.recovered:
        return colors.success;
      case ToleranceSystemState.lightStress:
        return colors.info;
      case ToleranceSystemState.moderateStrain:
        return colors.warning;
      case ToleranceSystemState.highStrain:
        // More urgent than normal warning
        return Colors.deepOrangeAccent;
      case ToleranceSystemState.depleted:
        return colors.error;
    }
  }

  /// Maps bucket type to appropriate icon using BucketDefinitions.
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
    // THEME ACCESS
    final theme = context.theme;
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final accent = context.accent;

    // MAIN CONTAINER
    return Container(
      margin: EdgeInsets.all(spacing.lg),
      padding: EdgeInsets.all(spacing.lg),
      decoration: theme.cardDecoration(
        neonBorder: theme.isDark,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER - Title with debug toggle button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: accent.primary,
                    size: AppThemeConstants.iconMd,
                  ),
                  SizedBox(width: spacing.sm),
                  Text(
                    'Neurochemical Tolerance',
                    style: typography.heading4.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
                  size: AppThemeConstants.iconSm,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  setState(() => _showDebug = !_showDebug);
                },
                tooltip: 'Toggle debug calculations',
              ),
            ],
          ),

          // DEBUG BANNER - Shows when debug mode active
          if (_showDebug) ...[
            SizedBox(height: spacing.sm),
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: context.theme.isDark ? 0.15 : 0.10),
                borderRadius:
                    BorderRadius.circular(AppThemeConstants.radiusSm),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: Colors.amber),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      'Debug mode: tap any bucket to see calculation details.',
                      style: typography.caption.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: spacing.lg),

          // BUCKET CARDS - Render all buckets defined in this substance's model
          ...BucketDefinitions.orderedBuckets.where((bucketType) {
            return widget.toleranceModel.neuroBuckets.containsKey(bucketType);
          }).map((bucketType) {
            final bucket = widget.toleranceModel.neuroBuckets[bucketType]!;
            final percent =
                widget.toleranceResult.bucketPercents[bucketType] ?? 0.0;
            final state = ToleranceCalculator.classifyState(percent);
            final isExpanded = _expandedBucket == bucketType;

            return _buildBucketCard(
              context: context,
              bucketType: bucketType,
              bucket: bucket,
              bucketPercent: percent,
              state: state,
              isExpanded: isExpanded,
            );
          }),

          // NOTES - Optional tolerance model notes
          if (widget.toleranceModel.notes.isNotEmpty) ...[
            SizedBox(height: spacing.lg),
            Divider(color: colors.divider),
            SizedBox(height: spacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colors.textSecondary,
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    widget.toleranceModel.notes,
                    style: typography.caption.copyWith(
                      color: colors.textSecondary,
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

  /// Builds a card for a single neurochemical bucket showing system-wide
  /// tolerance and this substance's contribution.
  Widget _buildBucketCard({
    required BuildContext context,
    required String bucketType,
    required NeuroBucket bucket,
    required double bucketPercent,
    required ToleranceSystemState state,
    required bool isExpanded,
  }) {
    // THEME ACCESS
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;

    final substanceTolerance = bucketPercent / 100.0;
    final isActive = bucketPercent > 0.1;

    // BUCKET CARD
    return Card(
      margin: EdgeInsets.only(bottom: spacing.md),
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
        side: BorderSide(
          color: colors.border,
          width: 1,
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
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW - Bucket icon, name, description, active badge
              Row(
                children: [
                  Icon(
                    _getBucketIcon(bucketType),
                    size: AppThemeConstants.iconMd,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          BucketDefinitions.getDisplayName(bucketType),
                          style: typography.bodyBold.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          BucketDefinitions.getDescription(bucketType),
                          style: typography.caption.copyWith(
                            color: colors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.info.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                            AppThemeConstants.radiusSm),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: typography.captionBold.copyWith(
                          fontSize: typography.caption.fontSize,
                          color: colors.info,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: spacing.md),

              // SYSTEM-WIDE TOLERANCE - Combined load from all substances
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System-wide (all substances):',
                    style: typography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${bucketPercent.toStringAsFixed(1)}%',
                        style: typography.bodyBold.copyWith(
                          color: _getColorForTolerance(
                            substanceTolerance,
                            context,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStateColor(state, context)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStateColor(state, context)
                                .withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          state.displayName,
                          style: typography.captionBold.copyWith(
                            fontSize: 10,
                            color: _getStateColor(state, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: spacing.sm),

              // SUBSTANCE CONTRIBUTION - This substance's impact on bucket
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.substanceName} contribution:',
                    style: typography.captionBold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(substanceTolerance * 100).toStringAsFixed(1)}%',
                    style: typography.bodyBold.copyWith(
                      color:
                          _getColorForTolerance(substanceTolerance, context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: spacing.sm),

              // PROGRESS BAR - Visual indicator of substance contribution
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppThemeConstants.radiusSm),
                child: LinearProgressIndicator(
                  value: substanceTolerance > 1.0 ? 1.0 : substanceTolerance,
                  backgroundColor: colors.border.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForTolerance(substanceTolerance, context),
                  ),
                  minHeight: 8,
                ),
              ),

              SizedBox(height: spacing.sm),

              // STATS ROW - Bucket metadata
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                    style: typography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    'Active: ${isActive ? 'Yes' : 'No'}',
                    style: typography.captionBold.copyWith(
                      color: isActive
                          ? colors.info
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),

              // DEBUG SECTION - Expandable calculation details
              if (_showDebug && isExpanded) ...[
                SizedBox(height: spacing.md),
                Divider(color: colors.divider),
                SizedBox(height: spacing.sm),
                _buildDebugSection(
                  context: context,
                  bucketType: bucketType,
                  bucket: bucket,
                  state: state,
                  bucketPercent: bucketPercent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds debug section showing calculation formulas and raw values.
  Widget _buildDebugSection({
    required BuildContext context,
    required String bucketType,
    required NeuroBucket bucket,
    required ToleranceSystemState state,
    required double bucketPercent,
  }) {
    // THEME ACCESS
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;

    // DEBUG CONTAINER
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: context.theme.isDark
            ? colors.surfaceVariant.withValues(alpha: 0.7)
            : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Debug header
          Text(
            '🐛 CALCULATION DEBUG',
            style: typography.captionBold.copyWith(
              color: Colors.amber,
            ),
          ),
          SizedBox(height: spacing.sm),

          _debugRow(context, 'Bucket Type', bucketType),
          _debugRow(context, 'Weight', bucket.weight.toStringAsFixed(3)),
          _debugRow(
              context, 'Tolerance Type', bucket.toleranceType ?? 'unknown'),

          Divider(height: spacing.lg, color: colors.divider),

          _debugRow(
            context,
            'Half-life (hours)',
            widget.toleranceModel.halfLifeHours.toStringAsFixed(1),
          ),
          _debugRow(
            context,
            'Active Threshold',
            widget.toleranceModel.activeThreshold.toStringAsFixed(3),
          ),
          _debugRow(
            context,
            'Tolerance Gain Rate',
            widget.toleranceModel.toleranceGainRate.toStringAsFixed(3),
          ),
          _debugRow(
            context,
            'Decay Days',
            widget.toleranceModel.toleranceDecayDays.toStringAsFixed(1),
          ),

          Divider(height: spacing.lg, color: colors.divider),

          _debugRow(
            context,
            'Current Tolerance %',
            bucketPercent.toStringAsFixed(2),
          ),
          _debugRow(
            context,
            'Raw Load',
            (widget.toleranceResult.bucketRawLoads[bucketType] ?? 0)
                .toStringAsFixed(4),
          ),
          _debugRow(context, 'State', state.displayName),

          SizedBox(height: spacing.md),

          // Formula explanation
          Text(
            'FORMULA EXPLANATION:',
            style: typography.captionBold.copyWith(
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
            'Example: 8×5mg over 4 days → 20–40% tolerance',
            style: typography.caption.copyWith(
              color: colors.textSecondary,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single debug row showing label and value.
  Widget _debugRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final colors = context.colors;
    final typography = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: typography.caption.copyWith(
              color: colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: typography.captionBold.copyWith(
              color: colors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}




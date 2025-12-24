// Unified Bucket Tolerance Widget
//
// Created: 2024-03-15
// Last Modified: 2025-01-23
//
// Purpose:
// Displays comprehensive tolerance information combining system-wide bucket states
// with substance-specific contributions. Shows per-neurochemical system breakdown
// with detailed metrics, state classification, and optional debug calculations.
//
// Features:
// - System-wide tolerance percentages for all neurochemical buckets
// - Per-substance contribution breakdown for each bucket
// - Color-coded tolerance levels (green/blue/yellow/orange/red)
// - State classification badges (Recovered/Light Stress/Moderate Strain/etc.)
// - Active bucket indicators
// - Visual progress bars for tolerance levels
// - Expandable debug mode showing calculation formulas and raw values
// - Bucket metadata (weight, tolerance type, half-life, decay days)
// - Optional notes section
// - Dark/light theme support with neon borders
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: StatefulWidget kept for expand/collapse state. Fully modernized theme API.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../models/tolerance_model.dart';
import '../../../../utils/tolerance_calculator.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/theme/app_typography.dart';

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
    final c = context.colors;
    if (value < 0.25) return c.success;
    if (value < 0.50) return c.info;
    if (value < 0.75) return c.warning;
    return c.error;
  }

  /// Returns color for tolerance state classification.
  Color _getStateColor(ToleranceSystemState state, BuildContext context) {
    final c = context.colors;

    switch (state) {
      case ToleranceSystemState.recovered:
        return c.success;
      case ToleranceSystemState.lightStress:
        return c.info;
      case ToleranceSystemState.moderateStrain:
        return c.warning;
      case ToleranceSystemState.highStrain:
        // More urgent than normal warning
        return c.error;
      case ToleranceSystemState.depleted:
        return c.error;
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
    final c = context.colors;

    // THEME ACCESS
    final th = context.theme;
    final sp = context.spacing;
    final tx = context.text;
    final ac = context.accent;
    // MAIN CONTAINER
    return Container(
      margin: EdgeInsets.all(sp.lg),
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: th.c.surface,
        borderRadius: BorderRadius.circular(context.shapes.radiusLg),
        boxShadow: th.cardShadow,
        border: th.isDark
            ? Border.all(color: th.ac.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER - Title with debug toggle button
          Row(
            mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: ac.primary,
                    size: context.sizes.iconMd,
                  ),
                  SizedBox(width: sp.sm),
                  Text(
                    'Neurochemical Tolerance',
                    style: tx.heading4.copyWith(color: c.textPrimary),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
                  size: context.sizes.iconSm,
                  color: c.textSecondary,
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
            SizedBox(height: sp.sm),
            Container(
              padding: EdgeInsets.all(sp.sm),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: th.isDark ? 0.15 : 0.10),
                borderRadius: BorderRadius.circular(context.shapes.radiusSm),
                border: Border.all(
                  color: c.warning.withValues(alpha: 0.4),
                  width: context.sizes.borderThin,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: context.sizes.iconSm,
                    color: c.warning,
                  ),
                  SizedBox(width: sp.sm),
                  Expanded(
                    child: Text(
                      'Debug mode: tap any bucket to see calculation details.',
                      style: tx.caption.copyWith(color: c.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: sp.lg),
          // BUCKET CARDS - Render all buckets defined in this substance's model
          ...BucketDefinitions.orderedBuckets
              .where((bucketType) {
                return widget.toleranceModel.neuroBuckets.containsKey(
                  bucketType,
                );
              })
              .map((bucketType) {
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
            SizedBox(height: sp.lg),
            Divider(color: c.divider),
            SizedBox(height: sp.sm),
            Row(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Icon(
                  Icons.info_outline,
                  size: context.sizes.iconSm,
                  color: c.textSecondary,
                ),
                SizedBox(width: sp.sm),
                Expanded(
                  child: Text(
                    widget.toleranceModel.notes,
                    style: tx.caption.copyWith(
                      color: c.textSecondary,
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
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    // THEME ACCESS
    final substanceTolerance = bucketPercent / 100.0;
    final isActive = bucketPercent > 0.1;
    // BUCKET CARD
    return Card(
      margin: EdgeInsets.only(bottom: sp.md),
      color: c.surface,
      elevation: context.sizes.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.shapes.radiusSm),
        side: BorderSide(color: c.border, width: context.sizes.borderThin),
      ),
      child: InkWell(
        onTap: () {
          if (_showDebug) {
            setState(() {
              _expandedBucket = isExpanded ? null : bucketType;
            });
          }
        },
        borderRadius: BorderRadius.circular(context.shapes.radiusSm),
        child: Padding(
          padding: EdgeInsets.all(sp.md),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              // HEADER ROW - Bucket icon, name, description, active badge
              Row(
                children: [
                  Icon(
                    _getBucketIcon(bucketType),
                    size: context.sizes.iconMd,
                    color: c.textSecondary,
                  ),
                  SizedBox(width: sp.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                      children: [
                        Text(
                          BucketDefinitions.getDisplayName(bucketType),
                          style: tx.bodyBold.copyWith(color: c.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          BucketDefinitions.getDescription(bucketType),
                          style: tx.caption.copyWith(
                            color: c.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: sp.sm),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sp.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c.info.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          context.shapes.radiusSm,
                        ),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: tx.captionBold.copyWith(
                          fontSize: tx.caption.fontSize,
                          color: c.info,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: sp.md),
              // SYSTEM-WIDE TOLERANCE - Combined load from all substances
              Row(
                mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                children: [
                  Text(
                    'System-wide (all substances):',
                    style: tx.caption.copyWith(color: c.textSecondary),
                  ),
                  Row(
                    children: [
                      Text(
                        '${bucketPercent.toStringAsFixed(1)}%',
                        style: tx.bodyBold.copyWith(
                          color: _getColorForTolerance(
                            substanceTolerance,
                            context,
                          ),
                        ),
                      ),
                      SizedBox(width: sp.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStateColor(
                            state,
                            context,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            context.shapes.radiusMd,
                          ),
                          border: Border.all(
                            color: _getStateColor(
                              state,
                              context,
                            ).withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          state.displayName,
                          style: tx.captionBold.copyWith(
                            fontSize: tx.caption.fontSize,
                            color: _getStateColor(state, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: sp.sm),
              // SUBSTANCE CONTRIBUTION - This substance's impact on bucket
              Row(
                mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                children: [
                  Text(
                    '${widget.substanceName} contribution:',
                    style: tx.captionBold.copyWith(color: c.textPrimary),
                  ),
                  Text(
                    '${(substanceTolerance * 100).toStringAsFixed(1)}%',
                    style: tx.bodyBold.copyWith(
                      color: _getColorForTolerance(substanceTolerance, context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sp.sm),
              // PROGRESS BAR - Visual indicator of substance contribution
              ClipRRect(
                borderRadius: BorderRadius.circular(context.shapes.radiusSm),
                child: LinearProgressIndicator(
                  value: substanceTolerance > 1.0 ? 1.0 : substanceTolerance,
                  backgroundColor: c.border.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForTolerance(substanceTolerance, context),
                  ),
                  minHeight: 8,
                ),
              ),
              SizedBox(height: sp.sm),
              // STATS ROW - Bucket metadata
              Row(
                mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                children: [
                  Text(
                    'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                    style: tx.caption.copyWith(color: c.textSecondary),
                  ),
                  Text(
                    'Active: ${isActive ? 'Yes' : 'No'}',
                    style: tx.captionBold.copyWith(
                      color: isActive ? c.info : c.textSecondary,
                    ),
                  ),
                ],
              ),
              // DEBUG SECTION - Expandable calculation details
              if (_showDebug && isExpanded) ...[
                SizedBox(height: sp.md),
                Divider(color: c.divider),
                SizedBox(height: sp.sm),
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
    final th = context.theme;
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    // THEME ACCESS
    // DEBUG CONTAINER
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: th.isDark
            ? c.surfaceVariant.withValues(alpha: 0.7)
            : c.surfaceVariant,
        borderRadius: BorderRadius.circular(context.shapes.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Debug header
          Text(
            '🐛 CALCULATION DEBUG',
            style: tx.captionBold.copyWith(color: c.warning),
          ),
          SizedBox(height: sp.sm),
          _debugRow(context, 'Bucket Type', bucketType),
          _debugRow(context, 'Weight', bucket.weight.toStringAsFixed(3)),
          _debugRow(
            context,
            'Tolerance Type',
            bucket.toleranceType ?? 'unknown',
          ),
          Divider(height: sp.lg, color: c.divider),
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
          Divider(height: sp.lg, color: c.divider),
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
          SizedBox(height: sp.md),
          // Formula explanation
          Text(
            'FORMULA EXPLANATION:',
            style: tx.captionBold.copyWith(color: c.warning),
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
            style: tx.caption.copyWith(
              color: c.textSecondary,
              fontFamily: AppTypographyConstants.fontFamilyMonospace,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single debug row showing label and value.
  Widget _debugRow(BuildContext context, String label, String value) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs / 2),
      child: Row(
        mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
        children: [
          Text('$label:', style: tx.caption.copyWith(color: c.textSecondary)),
          Text(
            value,
            style: tx.captionBold.copyWith(
              color: c.textPrimary,
              fontFamily: AppTypographyConstants.fontFamilyMonospace,
            ),
          ),
        ],
      ),
    );
  }
}

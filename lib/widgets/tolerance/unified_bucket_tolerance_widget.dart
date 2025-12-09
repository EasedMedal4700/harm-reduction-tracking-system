// MIGRATION
import 'package:flutter/material.dart';

import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../utils/tolerance_calculator.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme_constants.dart';

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
  State<UnifiedBucketToleranceWidget> createState() =>
      _UnifiedBucketToleranceWidgetState();
}

class _UnifiedBucketToleranceWidgetState
    extends State<UnifiedBucketToleranceWidget> {
  bool _showDebug = false;
  String? _expandedBucket;

  Color _getColorForTolerance(double value, BuildContext context) {
    final t = context.theme;

    if (value < 0.25) return t.colors.success;
    if (value < 0.50) return t.colors.info;
    if (value < 0.75) return t.colors.warning;
    return t.colors.error;
  }

  Color _getStateColor(ToleranceSystemState state, BuildContext context) {
    final t = context.theme;

    switch (state) {
      case ToleranceSystemState.recovered:
        return t.colors.success;
      case ToleranceSystemState.lightStress:
        return t.colors.info;
      case ToleranceSystemState.moderateStrain:
        return t.colors.warning;
      case ToleranceSystemState.highStrain:
        // a bit more “urgent” than normal warning
        return Colors.deepOrangeAccent;
      case ToleranceSystemState.depleted:
        return t.colors.error;
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
    final t = context.theme;

    return Container(
      margin: EdgeInsets.all(t.spacing.lg),
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: t.cardDecoration(
        neonBorder: t.isDark,
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
                    color: t.accent.primary,
                    size: AppThemeConstants.iconMd,
                  ),
                  SizedBox(width: t.spacing.sm),
                  Text(
                    'Neurochemical Tolerance',
                    style: t.typography.heading4.copyWith(
                      color: t.colors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
                  size: AppThemeConstants.iconSm,
                  color: t.colors.textSecondary,
                ),
                onPressed: () {
                  setState(() => _showDebug = !_showDebug);
                },
                tooltip: 'Toggle debug calculations',
              ),
            ],
          ),

          if (_showDebug) ...[
            SizedBox(height: t.spacing.sm),
            Container(
              padding: EdgeInsets.all(t.spacing.sm),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(t.isDark ? 0.15 : 0.10),
                borderRadius:
                    BorderRadius.circular(AppThemeConstants.radiusSm),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: Colors.amber),
                  SizedBox(width: t.spacing.sm),
                  Expanded(
                    child: Text(
                      'Debug mode: tap any bucket to see calculation details.',
                      style: t.typography.caption.copyWith(
                        color: t.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: t.spacing.lg),

          // Render all buckets from this substance's model
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

          // Notes section (only if notes are non-empty)
          if (widget.toleranceModel.notes.isNotEmpty) ...[
            SizedBox(height: t.spacing.lg),
            Divider(color: t.colors.divider),
            SizedBox(height: t.spacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: t.colors.textSecondary,
                ),
                SizedBox(width: t.spacing.sm),
                Expanded(
                  child: Text(
                    widget.toleranceModel.notes,
                    style: t.typography.caption.copyWith(
                      color: t.colors.textSecondary,
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

  Widget _buildBucketCard({
    required BuildContext context,
    required String bucketType,
    required NeuroBucket bucket,
    required double bucketPercent,
    required ToleranceSystemState state,
    required bool isExpanded,
  }) {
    final t = context.theme;
    final substanceTolerance = bucketPercent / 100.0;
    final isActive = bucketPercent > 0.1;

    return Card(
      margin: EdgeInsets.only(bottom: t.spacing.md),
      color: t.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
        side: BorderSide(
          color: t.colors.border,
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
          padding: EdgeInsets.all(t.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(
                    _getBucketIcon(bucketType),
                    size: AppThemeConstants.iconMd,
                    color: t.colors.textSecondary,
                  ),
                  SizedBox(width: t.spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          BucketDefinitions.getDisplayName(bucketType),
                          style: t.typography.bodyBold.copyWith(
                            color: t.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          BucketDefinitions.getDescription(bucketType),
                          style: t.typography.caption.copyWith(
                            color: t.colors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: t.spacing.sm),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: t.spacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: t.colors.info.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                            AppThemeConstants.radiusSm),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: t.typography.captionBold.copyWith(
                          fontSize: t.typography.caption.fontSize,
                          color: t.colors.info,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: t.spacing.md),

              // System-wide tolerance (ALL substances combined)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System-wide (all substances):',
                    style: t.typography.caption.copyWith(
                      color: t.colors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${bucketPercent.toStringAsFixed(1)}%',
                        style: t.typography.bodyBold.copyWith(
                          color: _getColorForTolerance(
                            substanceTolerance,
                            context,
                          ),
                        ),
                      ),
                      SizedBox(width: t.spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStateColor(state, context)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStateColor(state, context)
                                .withOpacity(0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          state.displayName,
                          style: t.typography.captionBold.copyWith(
                            fontSize: 10,
                            color: _getStateColor(state, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: t.spacing.sm),

              // This substance's contribution
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.substanceName} contribution:',
                    style: t.typography.captionBold.copyWith(
                      color: t.colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(substanceTolerance * 100).toStringAsFixed(1)}%',
                    style: t.typography.bodyBold.copyWith(
                      color:
                          _getColorForTolerance(substanceTolerance, context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: t.spacing.sm),

              // Progress bar for this substance
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppThemeConstants.radiusSm),
                child: LinearProgressIndicator(
                  value: substanceTolerance > 1.0 ? 1.0 : substanceTolerance,
                  backgroundColor: t.colors.border.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForTolerance(substanceTolerance, context),
                  ),
                  minHeight: 8,
                ),
              ),

              SizedBox(height: t.spacing.sm),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight: ${bucket.weight.toStringAsFixed(2)} • Type: ${bucket.toleranceType}',
                    style: t.typography.caption.copyWith(
                      color: t.colors.textSecondary,
                    ),
                  ),
                  Text(
                    'Active: ${isActive ? 'Yes' : 'No'}',
                    style: t.typography.captionBold.copyWith(
                      color: isActive
                          ? t.colors.info
                          : t.colors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Debug section (expanded)
              if (_showDebug && isExpanded) ...[
                SizedBox(height: t.spacing.md),
                Divider(color: t.colors.divider),
                SizedBox(height: t.spacing.sm),
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

  Widget _buildDebugSection({
    required BuildContext context,
    required String bucketType,
    required NeuroBucket bucket,
    required ToleranceSystemState state,
    required double bucketPercent,
  }) {
    final t = context.theme;

    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: t.isDark
            ? t.colors.surfaceVariant.withOpacity(0.7)
            : t.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🐛 CALCULATION DEBUG',
            style: t.typography.captionBold.copyWith(
              color: Colors.amber,
            ),
          ),
          SizedBox(height: t.spacing.sm),

          _debugRow(context, 'Bucket Type', bucketType),
          _debugRow(context, 'Weight', bucket.weight.toStringAsFixed(3)),
          _debugRow(
              context, 'Tolerance Type', bucket.toleranceType ?? 'unknown'),

          Divider(height: t.spacing.lg, color: t.colors.divider),

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

          Divider(height: t.spacing.lg, color: t.colors.divider),

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

          SizedBox(height: t.spacing.md),

          Text(
            'FORMULA EXPLANATION:',
            style: t.typography.captionBold.copyWith(
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
            style: t.typography.caption.copyWith(
              color: t.colors.textSecondary,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _debugRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: t.typography.caption.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: t.typography.captionBold.copyWith(
              color: t.colors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

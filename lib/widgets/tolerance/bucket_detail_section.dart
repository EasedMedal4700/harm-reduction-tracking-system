//MIGRTAED FILE

import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/theme/app_theme.dart';

/// Detailed view for a selected neurochemical bucket
class BucketDetailSection extends StatelessWidget {
  final String bucketType;
  final double systemTolerancePercent;
  final ToleranceSystemState state;
  final Map<String, double> substanceContributions;
  final Map<String, bool> substanceActiveStates;
  final String? selectedSubstance;
  final Function(String) onSubstanceSelected;

  const BucketDetailSection({
    super.key,
    required this.bucketType,
    required this.systemTolerancePercent,
    required this.state,
    required this.substanceContributions,
    required this.substanceActiveStates,
    this.selectedSubstance,
    required this.onSubstanceSelected,
  });

  Color _getStateColor(ToleranceSystemState state, ColorPalette c) {
    switch (state) {
      case ToleranceSystemState.recovered:
        return c.success;
      case ToleranceSystemState.lightStress:
        return c.info;
      case ToleranceSystemState.moderateStrain:
        return c.warning;
      case ToleranceSystemState.highStrain:
        return Colors.deepOrangeAccent;
      case ToleranceSystemState.depleted:
        return c.error;
    }
  }

  Color _getToleranceColor(double percent, ColorPalette c) {
    if (percent < 25) return c.success;
    if (percent < 50) return c.warning;
    if (percent < 75) return Colors.orange;
    return c.error;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = t.colors;
    final s = t.spacing;
    final stateColor = _getStateColor(state, c);

    return Container(
      margin: EdgeInsets.all(s.md),
      padding: EdgeInsets.all(s.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        border: Border.all(color: c.border, width: AppThemeConstants.borderThin),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: stateColor, size: 24),
              SizedBox(width: s.sm),
              Expanded(
                child: Text(
                  '${BucketDefinitions.getDisplayName(bucketType)} Tolerance',
                  style: t.typography.heading3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: s.sm,
                  vertical: s.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: stateColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${systemTolerancePercent.toStringAsFixed(1)}%',
                  style: t.typography.bodyBold.copyWith(color: stateColor),
                ),
              ),
            ],
          ),

          SizedBox(height: s.md),

          // DESCRIPTION
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: t.typography.bodySmall,
          ),

          SizedBox(height: s.md),
          Divider(color: c.divider),
          SizedBox(height: s.md),

          // SUBSTANCES HEADER
          Text(
            'Contributing Substances',
            style: t.typography.heading4,
          ),
          SizedBox(height: s.sm),

          // EMPTY STATE
          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: s.md),
              child: Text(
                'No active substances for this bucket',
                style: t.typography.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            )

          // LIST OF SUBSTANCES
          else
            ...substanceContributions.entries.map((entry) {
              final substanceName = entry.key;
              final contribution = entry.value;
              final isActive = substanceActiveStates[substanceName] ?? false;
              final isSelected = selectedSubstance == substanceName;

              final tolColor = _getToleranceColor(contribution, c);

              return Container(
                margin: EdgeInsets.only(bottom: s.sm),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
                  border: Border.all(
                    color: isSelected ? t.accent.primary : c.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
                  onTap: () => onSubstanceSelected(substanceName),
                  child: Padding(
                    padding: EdgeInsets.all(s.sm),
                    child: Row(
                      children: [
                        // SUBSTANCE NAME + TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(substanceName, style: t.typography.bodyBold),
                              SizedBox(height: 2),
                              Text(
                                'Contribution: ${contribution.toStringAsFixed(1)}%',
                                style: t.typography.caption,
                              ),
                            ],
                          ),
                        ),

                        // % BADGE
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: s.xs,
                            vertical: s.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: tolColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${contribution.toStringAsFixed(1)}%',
                            style: t.typography.captionBold.copyWith(
                              color: tolColor,
                            ),
                          ),
                        ),

                        // ACTIVE BADGE
                        if (isActive) ...[
                          SizedBox(width: s.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: s.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: t.accent.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: t.typography.captionBold.copyWith(
                                color: t.accent.secondary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],

                        SizedBox(width: s.sm),
                        Icon(Icons.chevron_right, color: c.textSecondary, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

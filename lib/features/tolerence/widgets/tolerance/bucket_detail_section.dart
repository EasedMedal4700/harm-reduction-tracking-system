// Bucket Detail Section Widget
// 
// Displays comprehensive details for a selected neurochemical bucket including system
// tolerance percentage, state indicators, bucket description, and list of contributing
// substances. Provides tap interaction to view individual substance details.

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../models/tolerance_model.dart';
import '../../../../constants/theme/app_color_palette.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';


/// Detailed view for a selected neurochemical bucket
/// 
/// Shows bucket-level tolerance information and breaks down contributions
/// from individual substances affecting this neurochemical system.
class BucketDetailSection extends ConsumerWidget {
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
        return c.error;
      case ToleranceSystemState.depleted:
        return c.error;
    }
  }

  Color _getToleranceColor(double percent, ColorPalette c) {
    if (percent < 25) return c.success;
    if (percent < 50) return c.warning;
    if (percent < 75) return c.warning;
    return c.error;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;
    
    // Get color based on current system state
    final stateColor = _getStateColor(state, colors);

    return Container(
      margin: EdgeInsets.all(spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(color: colors.border, width: context.sizes.borderThin),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER with bucket name and tolerance percentage
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: stateColor, size: context.sizes.iconMd),
              CommonSpacer.horizontal(spacing.sm),
              Expanded(
                child: Text(
                  '${BucketDefinitions.getDisplayName(bucketType)} Tolerance',
                  style: typography.heading3,
                ),
              ),
              // Tolerance percentage badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radii.radiusLg),
                  border: Border.all(
                    color: stateColor.withValues(alpha: 0.3),
                    width: context.sizes.borderThin,
                  ),
                ),
                child: Text(
                  '${systemTolerancePercent.toStringAsFixed(1)}%',
                  style: typography.bodyBold.copyWith(color: stateColor),
                ),
              ),
            ],
          ),

          CommonSpacer.vertical(spacing.md),

          // BUCKET DESCRIPTION
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: typography.bodySmall,
          ),

          CommonSpacer.vertical(spacing.md),
          Divider(color: colors.divider),
          CommonSpacer.vertical(spacing.md),

          // SUBSTANCES SECTION HEADER
          Text(
            'Contributing Substances',
            style: typography.heading4,
          ),
          CommonSpacer.vertical(spacing.sm),

          // EMPTY STATE when no substances contribute to this bucket
          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: Text(
                'No active substances for this bucket',
                style: typography.bodySmall.copyWith(
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

              final tolColor = _getToleranceColor(contribution, colors);

              return Container(
                margin: EdgeInsets.only(bottom: spacing.sm),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(radii.radiusSm),
                  border: Border.all(
                    color: isSelected ? context.accent.primary : colors.border,
                    width: isSelected ? context.sizes.borderRegular : context.sizes.borderThin,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radii.radiusSm),
                  onTap: () => onSubstanceSelected(substanceName),
                  child: Padding(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Row(
                      children: [
                        // SUBSTANCE NAME + TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                            children: [
                              // Substance name
                              Text(substanceName, style: typography.bodyBold),
                              CommonSpacer.vertical(spacing.xs / 2),
                              // Contribution percentage label
                              Text(
                                'Contribution: ${contribution.toStringAsFixed(1)}%',
                                style: typography.caption,
                              ),
                            ],
                          ),
                        ),

                        // Contribution percentage badge with color coding
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.xs,
                            vertical: spacing.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: tolColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(radii.radiusMd),
                          ),
                          child: Text(
                            '${contribution.toStringAsFixed(1)}%',
                            style: typography.captionBold.copyWith(
                              color: tolColor,
                            ),
                          ),
                        ),

                        // ACTIVE indicator badge (shown when substance is currently active)
                        if (isActive) ...[
                          CommonSpacer.horizontal(spacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.xs,
                              vertical: spacing.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.accent.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(radii.radiusSm),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: typography.captionBold.copyWith(
                                color: context.accent.secondary,
                                fontSize: context.text.caption.fontSize,
                              ),
                            ),
                          ),
                        ],

                        CommonSpacer.horizontal(spacing.sm),
                        // Chevron indicating tappable item
                        Icon(Icons.chevron_right, color: colors.textSecondary, size: context.sizes.iconMd),
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


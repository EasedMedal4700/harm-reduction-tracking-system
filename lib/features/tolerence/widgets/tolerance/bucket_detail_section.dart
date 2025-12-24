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
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    // Get color based on current system state
    final stateColor = _getStateColor(state, c);
    return Container(
      margin: EdgeInsets.all(sp.md),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border, width: context.sizes.borderThin),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER with bucket name and tolerance percentage
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: stateColor,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Expanded(
                child: Text(
                  '${BucketDefinitions.getDisplayName(bucketType)} Tolerance',
                  style: tx.heading3,
                ),
              ),
              // Tolerance percentage badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sp.sm,
                  vertical: sp.xs,
                ),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(sh.radiusLg),
                  border: Border.all(
                    color: stateColor.withValues(alpha: 0.3),
                    width: context.sizes.borderThin,
                  ),
                ),
                child: Text(
                  '${systemTolerancePercent.toStringAsFixed(1)}%',
                  style: tx.bodyBold.copyWith(color: stateColor),
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          // BUCKET DESCRIPTION
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: tx.bodySmall,
          ),
          CommonSpacer.vertical(sp.md),
          Divider(color: c.divider),
          CommonSpacer.vertical(sp.md),
          // SUBSTANCES SECTION HEADER
          Text('Contributing Substances', style: tx.heading4),
          CommonSpacer.vertical(sp.sm),
          // EMPTY STATE when no substances contribute to this bucket
          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: sp.md),
              child: Text(
                'No active substances for this bucket',
                style: tx.bodySmall.copyWith(fontStyle: FontStyle.italic),
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
                margin: EdgeInsets.only(bottom: sp.sm),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  border: Border.all(
                    color: isSelected ? context.accent.primary : c.border,
                    width: isSelected
                        ? context.sizes.borderRegular
                        : context.sizes.borderThin,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  onTap: () => onSubstanceSelected(substanceName),
                  child: Padding(
                    padding: EdgeInsets.all(sp.sm),
                    child: Row(
                      children: [
                        // SUBSTANCE NAME + TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                AppLayout.crossAxisAlignmentStart,
                            children: [
                              // Substance name
                              Text(substanceName, style: tx.bodyBold),
                              CommonSpacer.vertical(sp.xs / 2),
                              // Contribution percentage label
                              Text(
                                'Contribution: ${contribution.toStringAsFixed(1)}%',
                                style: tx.caption,
                              ),
                            ],
                          ),
                        ),
                        // Contribution percentage badge with color coding
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sp.xs,
                            vertical: sp.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: tolColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(sh.radiusMd),
                          ),
                          child: Text(
                            '${contribution.toStringAsFixed(1)}%',
                            style: tx.captionBold.copyWith(color: tolColor),
                          ),
                        ),
                        // ACTIVE indicator badge (shown when substance is currently active)
                        if (isActive) ...[
                          CommonSpacer.horizontal(sp.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sp.xs,
                              vertical: sp.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.accent.secondary.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(sh.radiusSm),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: tx.captionBold.copyWith(
                                color: context.accent.secondary,
                                fontSize: tx.caption.fontSize,
                              ),
                            ),
                          ),
                        ],
                        CommonSpacer.horizontal(sp.sm),
                        // Chevron indicating tappable item
                        Icon(
                          Icons.chevron_right,
                          color: c.textSecondary,
                          size: context.sizes.iconMd,
                        ),
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

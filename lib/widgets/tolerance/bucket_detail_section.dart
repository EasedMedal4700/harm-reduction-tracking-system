import 'package:flutter/material.dart';
import '../../models/bucket_definitions.dart';
import '../../models/tolerance_model.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Detailed view for a selected neurochemical bucket
/// 
/// Shows:
/// - Bucket name and description
/// - System-wide tolerance for this bucket
/// - List of substances contributing to this bucket with their individual contributions
/// - Allows selecting a substance for detailed view
class BucketDetailSection extends StatelessWidget {
  final String bucketType;
  final double systemTolerancePercent;
  final ToleranceSystemState state;
  final Map<String, double> substanceContributions; // substance name -> tolerance %
  final Map<String, bool> substanceActiveStates; // substance name -> is active
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

  Color _getToleranceColor(double percent) {
    if (percent < 25) return Colors.green;
    if (percent < 50) return Colors.yellow.shade700;
    if (percent < 75) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stateColor = _getStateColor(state);

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
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: stateColor,
                size: 24,
              ),
              SizedBox(width: ThemeConstants.space12),
              Expanded(
                child: Text(
                  '${BucketDefinitions.getDisplayName(bucketType)} Tolerance',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space12,
                  vertical: ThemeConstants.space8,
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
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontBold,
                    color: stateColor,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: ThemeConstants.space12),

          // Description
          Text(
            BucketDefinitions.getDescription(bucketType),
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              height: 1.4,
            ),
          ),

          SizedBox(height: ThemeConstants.space16),
          Divider(color: isDark ? UIColors.darkBorder : UIColors.lightBorder),
          SizedBox(height: ThemeConstants.space16),

          // Substances contributing header
          Text(
            'Contributing Substances',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),

          // List of substances
          if (substanceContributions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
              child: Text(
                'No active substances for this bucket',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...substanceContributions.entries.map((entry) {
              final substanceName = entry.key;
              final contribution = entry.value;
              final isActive = substanceActiveStates[substanceName] ?? false;
              final isSelected = substanceName == selectedSubstance;

              return Card(
                margin: EdgeInsets.only(bottom: ThemeConstants.space8),
                elevation: isSelected ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  side: BorderSide(
                    color: isSelected
                        ? (isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue)
                        : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => onSubstanceSelected(substanceName),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  child: Padding(
                    padding: EdgeInsets.all(ThemeConstants.space12),
                    child: Row(
                      children: [
                        // Substance name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                substanceName,
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontSmall,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: isDark ? UIColors.darkText : UIColors.lightText,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Contribution: ${contribution.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Percentage badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space8,
                            vertical: ThemeConstants.space4,
                          ),
                          decoration: BoxDecoration(
                            color: _getToleranceColor(contribution).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${contribution.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontXSmall,
                              fontWeight: ThemeConstants.fontBold,
                              color: _getToleranceColor(contribution),
                            ),
                          ),
                        ),

                        // Active badge
                        if (isActive) ...[
                          SizedBox(width: ThemeConstants.space8),
                          Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: ThemeConstants.fontBold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],

                        // Selection arrow
                        SizedBox(width: ThemeConstants.space8),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
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

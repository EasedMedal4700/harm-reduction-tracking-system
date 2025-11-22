import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// System overview card showing key metrics
class SystemOverviewCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;
  final Map<String, DrugLevel> allLevels;

  const SystemOverviewCard({
    required this.levels,
    required this.allLevels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;
    
    final activeCount = levels.length;
    final strongEffects = levels.values.where((l) => l.percentage > 20).length;
    final totalDose = levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);
    
    // Get recent doses (24h) from full dataset
    final now = DateTime.now();
    final recentCount = allLevels.values.fold<int>(0, (sum, level) {
      return sum + level.doses.where((dose) => 
        now.difference(dose.startTime).inHours < 24
      ).length;
    });

    return Container(
      margin: EdgeInsets.all(ThemeConstants.space16),
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                size: 20,
                color: accentColor,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'System Overview',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Active\nSubstances', '$activeCount', Colors.cyan, Icons.science, isDark),
              _buildStatCard('Strong\nEffects', '$strongEffects', Colors.amber, Icons.warning_amber, isDark),
              _buildStatCard('Recent\nDoses', '$recentCount', Colors.purple, Icons.schedule, isDark),
              _buildStatCard('Total\nDose', '${totalDose.toStringAsFixed(1)}u', Colors.red, Icons.scale, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon, bool isDark) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ThemeConstants.space8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.2 : 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: ThemeConstants.space8),
        Text(
          value,
          style: TextStyle(
            fontSize: ThemeConstants.fontLarge,
            fontWeight: ThemeConstants.fontBold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

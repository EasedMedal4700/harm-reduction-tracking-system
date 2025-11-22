import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../services/pharmacokinetics_service.dart';

class CurrentStatusCard extends StatelessWidget {
  final String substanceName;
  final DoseTier currentTier;
  final double currentPercentage;
  final double? timeToNextTier; // hours
  final Color substanceColor;

  const CurrentStatusCard({
    super.key,
    required this.substanceName,
    required this.currentTier,
    required this.currentPercentage,
    this.timeToNextTier,
    required this.substanceColor,
  });

  String _formatTime(double hours) {
    if (hours < 1) {
      return '${(hours * 60).toStringAsFixed(0)}m';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)}h';
    } else {
      final days = hours / 24;
      return '${days.toStringAsFixed(1)}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;
    final tierColor = Color(PharmacokineticsService.getTierColorValue(currentTier));

    return Container(
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
              Container(
                padding: EdgeInsets.all(ThemeConstants.space8),
                decoration: BoxDecoration(
                  color: substanceColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.monitor_heart,
                  color: substanceColor,
                  size: 20,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      substanceName,
                      style: TextStyle(
                        fontSize: ThemeConstants.fontMedium,
                        fontWeight: ThemeConstants.fontSemiBold,
                        color: isDark ? UIColors.darkText : UIColors.lightText,
                      ),
                    ),
                    Text(
                      'Current Status',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontXSmall,
                        color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Current Level',
                  '${currentPercentage.toStringAsFixed(1)}%',
                  tierColor,
                  isDark,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Dose Tier',
                  PharmacokineticsService.getTierName(currentTier),
                  tierColor,
                  isDark,
                ),
              ),
            ],
          ),
          if (timeToNextTier != null) ...[
            SizedBox(height: ThemeConstants.space12),
            _buildInfoBox(
              context,
              'Time to Next Tier',
              _formatTime(timeToNextTier!),
              accentColor,
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    BuildContext context,
    String label,
    String value,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: ThemeConstants.space4),
          Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

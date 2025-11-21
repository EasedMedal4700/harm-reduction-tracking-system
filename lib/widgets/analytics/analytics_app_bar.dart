import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/time_period.dart';

class AnalyticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;
  final VoidCallback? onExport;

  const AnalyticsAppBar({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onExport,
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + ThemeConstants.space8,
        left: ThemeConstants.space16,
        right: ThemeConstants.space16,
        bottom: ThemeConstants.space12,
      ),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            width: ThemeConstants.borderThin,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Navigation + Export
          Row(
            children: [
              // Navigation icon with neon glow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  boxShadow: isDark ? UIColors.createNeonGlow(accentColor) : null,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: accentColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const Spacer(),
              // Export button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  boxShadow: isDark ? UIColors.createNeonGlow(accentColor, intensity: 0.1) : null,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: accentColor,
                  ),
                  onPressed: onExport,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space8),
          // Title and subtitle
          Text(
            'DRUG USE ANALYTICS',
            style: TextStyle(
              fontSize: ThemeConstants.font2XLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: ThemeConstants.space4),
          Text(
            'Analyze and visualize your pharmacological activity over time',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              fontWeight: ThemeConstants.fontRegular,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          // Segment buttons
          Row(
            children: [
              _buildSegmentButton(context, TimePeriod.last7Days, '7d', isDark, accentColor),
              SizedBox(width: ThemeConstants.space8),
              _buildSegmentButton(context, TimePeriod.last7Weeks, '30d', isDark, accentColor),
              SizedBox(width: ThemeConstants.space8),
              _buildSegmentButton(context, TimePeriod.last7Months, '90d', isDark, accentColor),
              SizedBox(width: ThemeConstants.space8),
              _buildSegmentButton(context, TimePeriod.all, 'All', isDark, accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    BuildContext context,
    TimePeriod period,
    String label,
    bool isDark,
    Color accentColor,
  ) {
    final isSelected = selectedPeriod == period;

    return Expanded(
      child: AnimatedContainer(
        duration: ThemeConstants.animationNormal,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          border: Border.all(
            color: isSelected
                ? accentColor
                : isDark
                    ? UIColors.darkBorder
                    : UIColors.lightBorder,
            width: isSelected ? ThemeConstants.borderMedium : ThemeConstants.borderThin,
          ),
          boxShadow: isSelected && isDark ? UIColors.createNeonGlow(accentColor, intensity: 0.15) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onPeriodChanged(period),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConstants.space8),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    fontWeight: isSelected ? ThemeConstants.fontSemiBold : ThemeConstants.fontMediumWeight,
                    color: isSelected
                        ? accentColor
                        : isDark
                            ? UIColors.darkTextSecondary
                            : UIColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

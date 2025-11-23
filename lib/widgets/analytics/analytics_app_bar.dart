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
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + ThemeConstants.space8,
        left: ThemeConstants.space16,
        right: ThemeConstants.space16,
        bottom: ThemeConstants.space8,
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
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                      size: 20,
                    ),
                    padding: EdgeInsets.all(ThemeConstants.space8),
                    constraints: const BoxConstraints(),
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
                      size: 20,
                    ),
                    padding: EdgeInsets.all(ThemeConstants.space8),
                    constraints: const BoxConstraints(),
                    onPressed: onExport,
                  ),
                ),
              ],
            ),
            SizedBox(height: ThemeConstants.space4),
            // Title and subtitle
            Text(
              'DRUG USE ANALYTICS',
              style: TextStyle(
                fontSize: ThemeConstants.fontLarge,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
                letterSpacing: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ThemeConstants.space4),
            Text(
              'Analyze your pharmacological activity',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                fontWeight: ThemeConstants.fontRegular,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/emus/time_period.dart';

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
            // Top row with hamburger menu
            Row(
              children: [
                // Hamburger menu icon
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                    boxShadow: isDark ? UIColors.createNeonGlow(accentColor, intensity: 0.15) : null,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: accentColor,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(ThemeConstants.space8),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                SizedBox(width: ThemeConstants.space12),
                // Title
                Expanded(
                  child: Text(
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
                ),
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
            SizedBox(height: ThemeConstants.space8),
            // Subtitle
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

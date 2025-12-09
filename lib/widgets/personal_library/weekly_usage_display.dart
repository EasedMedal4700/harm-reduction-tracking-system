
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../models/drug_catalog_entry.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class WeeklyUsageDisplay extends StatelessWidget {
  final DrugCatalogEntry entry;
  final Color categoryColor;
  final Function(String, int, String, bool, Color) onDayTap;

  const WeeklyUsageDisplay({
    super.key,
    required this.entry,
    required this.categoryColor,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final counts = entry.weekdayUsage.counts;
    final maxUses = counts.isEmpty
        ? 1
        : counts.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Pattern',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: ThemeConstants.fontSemiBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            Text(
              '(Tap to see times)',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final count = counts.isNotEmpty && index < counts.length
                ? counts[index]
                : 0;
            final intensity = maxUses > 0 ? count / maxUses : 0.0;
            final accentColor = categoryColor;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space4 / 2),
                child: InkWell(
                  onTap: count > 0
                      ? () => onDayTap(entry.name, index, days[index], isDark, accentColor)
                      : null,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? accentColor.withValues(alpha: 0.2 + (intensity * 0.6))
                          : (isDark
                              ? UIColors.darkBackground.withValues(alpha: 0.3)
                              : UIColors.lightBackground),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                      border: Border.all(
                        color: count > 0
                            ? accentColor.withValues(alpha: 0.5 + (intensity * 0.5))
                            : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
                        width: count > 0 ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: ThemeConstants.fontXSmall,
                            fontWeight: count > 0
                                ? ThemeConstants.fontBold
                                : FontWeight.normal,
                            color: count > 0
                                ? accentColor
                                : (isDark
                                    ? UIColors.darkTextSecondary
                                    : UIColors.lightTextSecondary),
                          ),
                        ),
                        if (count > 0) ...[
                          SizedBox(height: ThemeConstants.space4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space4,
                              vertical: ThemeConstants.space4 / 2,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                fontWeight: ThemeConstants.fontBold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

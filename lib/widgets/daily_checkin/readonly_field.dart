
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ReadOnlyField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final labelColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: labelColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontMediumWeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
        ],
      ),
    );
  }
}

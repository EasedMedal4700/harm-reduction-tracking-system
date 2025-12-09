
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class LogEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSimpleMode;
  final ValueChanged<bool> onSimpleModeChanged;

  const LogEntryAppBar({
    super.key,
    required this.isSimpleMode,
    required this.onSimpleModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF14141A) : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black87;
    final accent = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      foregroundColor: iconColor,
      centerTitle: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Log Entry",
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: iconColor,
            ),
          ),
          Text(
            "Add a new substance record",
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
        ],
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: ThemeConstants.space16,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space12,
              vertical: ThemeConstants.space4,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x11FFFFFF) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(
                color: isDark
                    ? const Color(0x22FFFFFF)
                    : UIColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Simple",
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space8),
                Switch(
                  value: isSimpleMode,
                  onChanged: onSimpleModeChanged,
                  activeColor: accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

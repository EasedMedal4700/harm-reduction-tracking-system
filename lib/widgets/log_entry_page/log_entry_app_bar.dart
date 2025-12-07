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
    
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Entry',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
            ),
          ),
          Text(
            'Add a new substance record',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
        ],
      ),
      actions: [
        // Simple/Detailed mode toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space8),
          child: Row(
            children: [
              Text(
                'Simple',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
              ),
              Switch(
                value: isSimpleMode,
                onChanged: onSimpleModeChanged,
                activeColor: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

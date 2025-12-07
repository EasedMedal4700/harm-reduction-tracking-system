import 'package:flutter/material.dart';
import '../../states/log_entry_state.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class EditLogEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final LogEntryState state;
  final VoidCallback onDelete;

  const EditLogEntryAppBar({
    super.key,
    required this.isDark,
    required this.state,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      elevation: 0,
      title: const Text('Edit Drug Use'),
      actions: [
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: onDelete,
          tooltip: 'Delete Entry',
        ),
        // Simple/Detailed mode toggle
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space8,
          ),
          child: Row(
            children: [
              Text(
                'Simple',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: isDark
                      ? UIColors.darkTextSecondary
                      : UIColors.lightTextSecondary,
                ),
              ),
              Switch(
                value: state.isSimpleMode,
                onChanged: state.setIsSimpleMode,
                activeColor: isDark
                    ? UIColors.darkNeonBlue
                    : UIColors.lightAccentBlue,
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

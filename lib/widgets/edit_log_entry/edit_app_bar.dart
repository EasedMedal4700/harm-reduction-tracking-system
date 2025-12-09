// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: COMPLETE
// Notes: Initial migration header added. Some theme/common usage, Riverpod ready.
import 'package:flutter/material.dart';
import '../../models/log_entry_form_data.dart';
import '../../constants/colors/app_colors_dark.dart';
import '../../constants/colors/app_colors_light.dart';

/// Riverpod-ready Edit Log Entry AppBar
/// Accepts data and callback instead of state
class EditLogEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final LogEntryFormData formData;
  final VoidCallback onDelete;
  final ValueChanged<bool>? onSimpleModeChanged;

  const EditLogEntryAppBar({
    super.key,
    required this.isDark,
    required this.formData,
    required this.onDelete,
    this.onSimpleModeChanged,
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                'Simple',
                style: TextStyle(
                  fontSize: 14.0,
                  color: isDark
                      ? AppColorsDark.textSecondary
                      : AppColorsLight.textSecondary,
                ),
              ),
              Switch(
                value: formData.isSimpleMode,
                onChanged: onSimpleModeChanged,
                activeColor: isDark
                    ? AppColorsDark.accentBlue
                    : AppColorsLight.accentPrimary,
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


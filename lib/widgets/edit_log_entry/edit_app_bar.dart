// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: COMPLETE
// Notes: Initial migration header added. Some theme/common usage, Riverpod ready.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../models/log_entry_form_data.dart';

/// Riverpod-ready Edit Log Entry AppBar
/// Accepts data and callback instead of state
class EditLogEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LogEntryFormData formData;
  final VoidCallback onDelete;
  final ValueChanged<bool>? onSimpleModeChanged;

  const EditLogEntryAppBar({
    super.key,
    required this.formData,
    required this.onDelete,
    this.onSimpleModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.theme;
    final sp = context.spacing;

    return AppBar(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      title: Text('Edit Drug Use', style: t.text.heading3),
      actions: [
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: c.error,
          onPressed: onDelete,
          tooltip: 'Delete Entry',
        ),
        // Simple/Detailed mode toggle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sp.sm),
          child: Row(
            children: [
              Text(
                'Simple',
                style: t.text.body.copyWith(
                  color: c.textSecondary,
                ),
              ),
              Switch(
                value: formData.isSimpleMode,
                onChanged: onSimpleModeChanged,
                activeThumbColor: context.accent.primary,
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


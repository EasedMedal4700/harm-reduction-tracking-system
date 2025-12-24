// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: AppBar for editing log entries. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../models/log_entry_form_data.dart';
import '../../../../common/buttons/common_icon_button.dart';
import '../../../../common/layout/common_spacer.dart';

/// Riverpod-ready Edit Log Entry AppBar
/// Accepts data and callback instead of state
class EditLogEntryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
    final tx = context.text;
    final c = context.colors;
    final th = context.theme;
    final sp = context.spacing;
    return AppBar(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: th.sizes.elevationNone,
      title: Text('Edit Drug Use', style: th.tx.heading3),
      actions: [
        // Delete button
        CommonIconButton(
          icon: Icons.delete_outline,
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
                style: th.tx.body.copyWith(color: c.textSecondary),
              ),
              CommonSpacer.horizontal(sp.sm),
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

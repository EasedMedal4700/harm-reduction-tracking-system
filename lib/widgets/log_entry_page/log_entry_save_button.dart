
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and existing common components. No logic or state changes.
import 'package:flutter/material.dart';
import '../../common/buttons/common_primary_button.dart';
import '../../constants/theme/app_theme_extension.dart';

class LogEntrySaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const LogEntrySaveButton({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        border: Border(
          top: BorderSide(
            color: t.colors.border,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: t.colors.text.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CommonPrimaryButton(
        label: "Save Entry",
        icon: Icons.save,
        onPressed: onSave,
        width: double.infinity,
      ),
    );
  }
}

// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Log entry save button.
import 'package:flutter/material.dart';
import '../../../../common/buttons/common_primary_button.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class LogEntrySaveButton extends StatelessWidget {
  final VoidCallback onSave;
  const LogEntrySaveButton({super.key, required this.onSave});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Container(
      padding: EdgeInsets.all(th.spacing.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        border: Border(top: BorderSide(color: th.colors.border)),
        boxShadow: [
          BoxShadow(
            color: th.colors.textPrimary.withValues(alpha: 0.08),
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

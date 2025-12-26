// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Dialog for confirming deletion. Fully theme-compliant.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/buttons/common_primary_button.dart';

class ActivityDeleteDialog extends StatelessWidget {
  final String entryType;
  const ActivityDeleteDialog({super.key, required this.entryType});
  static Future<bool> show(BuildContext context, String entryType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ActivityDeleteDialog(entryType: entryType),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sh = context.shapes;
    return AlertDialog(
      backgroundColor: c.surface,
      elevation: context.sizes.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
        side: BorderSide(color: c.border),
      ),
      title: Text(
        'Delete Entry?',
        style: tx.heading3.copyWith(color: c.textPrimary),
      ),
      content: Text(
        'Are you sure you want to delete this $entryType entry? This action cannot be undone.',
        style: tx.body.copyWith(color: c.textSecondary),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => context.pop(false),
          child: Text('Cancel', style: tx.body.copyWith(color: c.textPrimary)),
        ),
        // Delete Button
        CommonPrimaryButton(
          label: 'Delete',
          onPressed: () => context.pop(true),
          backgroundColor: c.error,
          textColor: c.textInverse,
        ),
      ],
    );
  }
}

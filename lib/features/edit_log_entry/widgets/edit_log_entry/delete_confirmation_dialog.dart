// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Dialog for deleting entries. No hardcoded values.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/buttons/common_primary_button.dart';

import '../../../log_entry/log_entry_state.dart';
import '../../../log_entry/log_entry_service.dart';

class DeleteConfirmationDialog {
  static Future<void> show(BuildContext context, LogEntryState state) async {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(
          'Delete Entry?',
          style: t.text.heading3.copyWith(color: c.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this drug use entry? This action cannot be undone.',
          style: t.text.body.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: t.text.labelLarge.copyWith(color: a.primary),
            ),
          ),
          CommonPrimaryButton(
            onPressed: () => Navigator.pop(context, true),
            label: 'Delete',
            backgroundColor: c.error,
            textColor: c.textInverse,
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final service = LogEntryService();
        await service.deleteLogEntry(state.entryId);

        if (context.mounted) {
          Navigator.pop(context); // Close edit page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Entry deleted successfully'),
              backgroundColor: c.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete entry: $e'),
              backgroundColor: c.error,
            ),
          );
        }
      }
    }
  }
}

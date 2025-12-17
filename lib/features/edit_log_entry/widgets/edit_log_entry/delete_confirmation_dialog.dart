import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';

import '../../../../states/log_entry_state.dart';
import '../../../../services/log_entry_service.dart';


class DeleteConfirmationDialog {
  static Future<void> show(
    BuildContext context,
    LogEntryState state,
  ) async {
    final c = context.colors;
    final t = context.theme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(
          'Delete Entry?',
          style: t.text.heading3.copyWith(
            color: c.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this drug use entry? This action cannot be undone.',
          style: t.text.body.copyWith(
            color: c.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: context.accent.primary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
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
            const SnackBar(
              content: Text('Entry deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete entry: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}




// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../states/log_entry_state.dart';
import '../../services/log_entry_service.dart';
import '../../constants/deprecated/ui_colors.dart';

class DeleteConfirmationDialog {
  static Future<void> show(
    BuildContext context,
    LogEntryState state,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        title: Text(
          'Delete Entry?',
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this drug use entry? This action cannot be undone.',
          style: TextStyle(
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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

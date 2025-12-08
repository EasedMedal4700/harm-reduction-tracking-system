// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// A confirmation dialog for deleting activity entries.
/// Fully migrated to AppTheme.
class ActivityDeleteDialog extends StatelessWidget {
  final String entryType;

  const ActivityDeleteDialog({
    super.key,
    required this.entryType,
  });

  /// Shows the delete confirmation dialog and returns true if confirmed.
  static Future<bool> show(BuildContext context, String entryType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ActivityDeleteDialog(entryType: entryType),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return AlertDialog(
      backgroundColor: t.colors.surface,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.spacing.md),
        side: BorderSide(color: t.colors.border),
      ),
      title: Text(
        'Delete Entry?',
        style: t.typography.heading3.copyWith(
          color: t.colors.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this $entryType entry? This action cannot be undone.',
        style: t.typography.body.copyWith(
          color: t.colors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: t.colors.textPrimary,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: t.colors.error,
            foregroundColor: t.colors.textInverse,
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.lg,
              vertical: t.spacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(t.spacing.sm),
            ),
            shadowColor: t.colors.overlayHeavy,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

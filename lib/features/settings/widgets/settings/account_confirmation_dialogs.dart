// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'account_dialogs.dart';

/// Shows confirmation dialog for delete data operation
void showDeleteDataConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onDownloadFirst,
  required VoidCallback onConfirmDelete,
}) {
  final colors = context.colors;
  final spacing = context.spacing;
  final radii = context.shapes;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber, color: colors.warning, size: spacing.xl * 2),
          SizedBox(width: spacing.md),
          const Expanded(child: Text('Are You Sure?')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This will permanently delete:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacing.md),
          WarningItem('All your drug use logs'),
          WarningItem('All your reflections'),
          WarningItem('All your cravings data'),
          WarningItem('All your tolerance data'),
          WarningItem('All your stockpile entries'),
          SizedBox(height: spacing.lg),
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: colors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radii.radiusSm),
              border: Border.all(
                color: colors.info,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.info),
                SizedBox(width: spacing.sm),
                const Expanded(
                  child: Text(
                    'Consider downloading your data first!',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            'Your account will remain active, but all your data will be gone forever.',
            style: TextStyle(color: colors.error, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDownloadFirst();
          },
          style: TextButton.styleFrom(foregroundColor: colors.info),
          child: const Text('Download Data First'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmDelete();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.warning,
            foregroundColor: colors.surface,
          ),
          child: const Text('Yes, Delete My Data'),
        ),
      ],
    ),
  );
}

/// Shows final typed confirmation for data deletion
void showFinalDeleteDataConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onConfirmDelete,
}) {
  final colors = context.colors;
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => TypedConfirmationDialog(
      title: 'Final Confirmation',
      confirmText: 'DELETE MY DATA',
      description: 'Type "DELETE MY DATA" to confirm:',
      buttonColor: colors.warning,
      onConfirmed: () {
        Navigator.pop(context);
        onConfirmDelete();
      },
    ),
  );
}

/// Shows confirmation dialog for delete account operation
void showDeleteAccountConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onDownloadFirst,
  required VoidCallback onContinue,
}) {
  final colors = context.colors;
  final spacing = context.spacing;
  final radii = context.shapes;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: colors.error.withValues(alpha: 0.1),
      title: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error, size: spacing.xl * 2),
          SizedBox(width: spacing.md),
          const Expanded(child: Text('⚠️ DELETE ACCOUNT')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This will PERMANENTLY delete:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.error,
            ),
          ),
          SizedBox(height: spacing.md),
          WarningItem('All your data and logs', isRed: true),
          WarningItem('All your settings and profile',
              isRed: true),
          WarningItem('Your account record', isRed: true),
          SizedBox(height: spacing.sm),
          WarningItem(
            '⚠️ Login credentials remain (contact support to delete)',
          ),
          SizedBox(height: spacing.lg),
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radii.radiusSm),
              border: Border.all(
                color: colors.warning,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.download,
                    color: colors.warning),
                SizedBox(width: spacing.sm),
                const Expanded(
                  child: Text(
                    'Download your data first so you can always come back!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            'This action CANNOT be reversed. Your data will be gone forever.',
            style: context.text.bodySmall.copyWith(
              color: colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDownloadFirst();
          },
          style: TextButton.styleFrom(foregroundColor: colors.info),
          child: const Text('Download Data First'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onContinue();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.surface,
          ),
          child: const Text('I Understand, Continue'),
        ),
      ],
    ),
  );
}

/// Shows final typed confirmation for account deletion
void showFinalDeleteAccountConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onConfirmDelete,
}) {
  final colors = context.colors;
  final spacing = context.spacing;
  bool userConfirmed = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: colors.error.withValues(alpha: 0.1),
        title: Row(
          children: [
            Icon(Icons.warning,
                color: colors.error,
                size: spacing.xl * 2),
            SizedBox(width: spacing.sm),
            const Expanded(child: Text('FINAL CONFIRMATION')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Type "DELETE MY ACCOUNT" to confirm account deletion:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.error,
              ),
            ),
            SizedBox(height: spacing.md),
            TextField(
              decoration: InputDecoration(
                hintText: 'DELETE MY ACCOUNT',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.error,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  userConfirmed = value.trim() == 'DELETE MY ACCOUNT';
                });
              },
            ),
            SizedBox(height: spacing.lg),
            Text(
              '⚠️ This is your last chance to cancel!',
              style: TextStyle(
                color: colors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: userConfirmed
                ? () {
                    Navigator.pop(context);
                    onConfirmDelete();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.surface,
              disabledBackgroundColor: colors.textSecondary.withValues(alpha: 0.3),
            ),
            child: const Text('DELETE MY ACCOUNT FOREVER'),
          ),
        ],
      ),
    ),
  );
}

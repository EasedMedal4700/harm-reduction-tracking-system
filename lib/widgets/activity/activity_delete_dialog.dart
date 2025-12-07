import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';

/// A confirmation dialog for deleting activity entries.
class ActivityDeleteDialog extends StatelessWidget {
  final bool isDark;
  final String entryType;

  const ActivityDeleteDialog({
    super.key,
    required this.isDark,
    required this.entryType,
  });

  /// Shows the delete confirmation dialog and returns true if confirmed.
  static Future<bool> show(BuildContext context, String entryType) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ActivityDeleteDialog(
        isDark: isDark,
        entryType: entryType,
      ),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
      title: Text(
        'Delete Entry?',
        style: TextStyle(
          color: isDark ? UIColors.darkText : UIColors.lightText,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this $entryType entry? This action cannot be undone.',
        style: TextStyle(
          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
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
    );
  }
}

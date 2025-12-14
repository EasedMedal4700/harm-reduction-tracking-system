// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: N/A
import 'package:flutter/material.dart';
import 'account_dialogs.dart';

/// Shows confirmation dialog for delete data operation
void showDeleteDataConfirmation(
  BuildContext context,
  String password, {
  required VoidCallback onDownloadFirst,
  required VoidCallback onConfirmDelete,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 32),
          const SizedBox(width: 12),
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
          const SizedBox(height: 12),
          WarningItem('All your drug use logs', isDark: isDark),
          WarningItem('All your reflections', isDark: isDark),
          WarningItem('All your cravings data', isDark: isDark),
          WarningItem('All your tolerance data', isDark: isDark),
          WarningItem('All your stockpile entries', isDark: isDark),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.blue.shade400 : Colors.blue.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Consider downloading your data first!',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your account will remain active, but all your data will be gone forever.',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
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
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text('Download Data First'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmDelete();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
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
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => TypedConfirmationDialog(
      title: 'Final Confirmation',
      confirmText: 'DELETE MY DATA',
      description: 'Type "DELETE MY DATA" to confirm:',
      buttonColor: Colors.orange,
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
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.red.shade50,
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 32),
          const SizedBox(width: 12),
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
              color: isDark ? Colors.red.shade300 : Colors.red.shade900,
            ),
          ),
          const SizedBox(height: 12),
          WarningItem('All your data and logs', isRed: true, isDark: isDark),
          WarningItem('All your settings and profile',
              isRed: true, isDark: isDark),
          WarningItem('Your account record', isRed: true, isDark: isDark),
          const SizedBox(height: 8),
          WarningItem(
            '⚠️ Login credentials remain (contact support to delete)',
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.amber.withOpacity(0.2) : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.amber.shade600 : Colors.amber.shade700,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.download,
                    color:
                        isDark ? Colors.amber.shade400 : Colors.amber.shade900),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Download your data first so you can always come back!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This action CANNOT be reversed. Your data will be gone forever.',
            style: TextStyle(
              color: isDark ? Colors.red.shade300 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
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
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text('Download Data First'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onContinue();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  bool userConfirmed = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.red.shade50,
        title: Row(
          children: [
            Icon(Icons.warning,
                color: isDark ? Colors.red.shade400 : Colors.red.shade900,
                size: 32),
            const SizedBox(width: 8),
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
                color: isDark ? Colors.red.shade300 : Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'DELETE MY ACCOUNT',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Colors.red.shade400 : Colors.red.shade700,
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
            const SizedBox(height: 16),
            Text(
              '⚠️ This is your last chance to cancel!',
              style: TextStyle(
                color: isDark ? Colors.red.shade300 : Colors.red.shade900,
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
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            child: const Text('DELETE MY ACCOUNT FOREVER'),
          ),
        ],
      ),
    ),
  );
}

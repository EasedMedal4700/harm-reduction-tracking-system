import 'package:flutter/material.dart';

/// Central error handler for the application
class ErrorHandler {
  /// Show error dialog with details
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? details,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (details != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  details,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: duration,
      ),
    );
  }

  /// Log error to console with context
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    print('❌ ERROR [$context]: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  /// Log warning to console
  static void logWarning(String context, String message) {
    print('⚠️  WARNING [$context]: $message');
  }

  /// Log info to console
  static void logInfo(String context, String message) {
    print('ℹ️  INFO [$context]: $message');
  }

  /// Log debug to console
  static void logDebug(String context, String message, [dynamic data]) {
    print('🔍 DEBUG [$context]: $message');
    if (data != null) {
      print('   Data: $data');
    }
  }
}

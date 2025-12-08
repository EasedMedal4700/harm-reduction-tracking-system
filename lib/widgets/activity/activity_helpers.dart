// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import 'package:intl/intl.dart';


/// Helper functions for activity-related UI components.
class ActivityHelpers {
  /// Returns a human-readable label for craving intensity.
  static String getIntensityLabel(int intensity) {
    if (intensity <= 2) return 'Mild';
    if (intensity <= 4) return 'Moderate';
    if (intensity <= 7) return 'Strong';
    return 'Severe';
  }

  /// Returns a color representing the craving intensity level (theme-aware).
  static Color getCravingColor(int intensity, BuildContext context) {
    final t = context.theme;

    if (intensity <= 2) return t.colors.success;        // Green → theme success
    if (intensity <= 4) return t.colors.warning;        // Yellow → theme warning
    if (intensity <= 7) return t.colors.warning;        // Orange → same category
    return t.colors.error;                              // Red → theme error
  }

  /// Formats a timestamp into a detailed, user-friendly string with relative time.
  static String formatDetailTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final dt = DateTime.parse(timestamp.toString()).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dt);

      String relativeTime;
      if (difference.inMinutes < 1) {
        relativeTime = 'Just now';
      } else if (difference.inHours < 1) {
        relativeTime = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        relativeTime = '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        relativeTime = '${difference.inDays}d ago';
      } else {
        relativeTime = DateFormat('MMM d, y').format(dt);
      }

      final timeStr = DateFormat('h:mm a').format(dt);
      final formattedDate = DateFormat('EEEE, MMMM d, y').format(dt);

      return '$relativeTime\n$formattedDate at $timeStr';
    } catch (_) {
      return 'Unknown';
    }
  }

  /// Returns the correct ID column name for a given service/table.
  static String getIdColumn(String serviceName) {
    switch (serviceName) {
      case 'drug_use':
        return 'use_id';
      case 'cravings':
        return 'craving_id';
      case 'reflections':
        return 'reflection_id';
      default:
        return 'id';
    }
  }
}

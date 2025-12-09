// MIGRATION — Updated BucketUtils to use theme-based tolerance colors

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../models/bucket_definitions.dart';

/// Utility functions for bucket details widgets
class BucketUtils {
  /// Get the appropriate icon for a bucket type
  static IconData getBucketIcon(String bucketType) {
    final iconName = BucketDefinitions.getIconName(bucketType);

    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'bolt':
        return Icons.bolt;
      case 'favorite':
        return Icons.favorite;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'sentiment_satisfied_alt':
        return Icons.sentiment_satisfied_alt;
      case 'medication':
        return Icons.medication;
      case 'blur_on':
        return Icons.blur_on;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.science;
    }
  }

  /// Theme-aware tolerance color (0.0 to 1.0)
  static Color toleranceColor(BuildContext context, double tolerance) {
    final c = context.colors;

    if (tolerance < 0.25) return c.success;        // Green-safe
    if (tolerance < 0.5) return c.warning;         // Yellow-warning
    if (tolerance < 0.75) return c.warningDark;    // Darker orange
    return c.danger;                               // Red-danger
  }

  /// Former API compatibility: returns a color without requiring BuildContext
  /// BUT theme colors won't apply without context, so this should be avoided.
  static Color getColorForToleranceFallback(double tolerance) {
    if (tolerance < 0.25) return Colors.green;
    if (tolerance < 0.5) return Colors.yellow.shade700;
    if (tolerance < 0.75) return Colors.orange;
    return Colors.red;
  }

  /// Always prefer this instead of getColorForToleranceFallback
  static Color getColorForTolerance(BuildContext context, double tolerance) {
    return toleranceColor(context, tolerance);
  }

  /// Format a duration into a human-readable "time ago" string
  static String formatTimeAgo(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}


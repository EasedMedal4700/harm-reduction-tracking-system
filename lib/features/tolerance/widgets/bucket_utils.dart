// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Bucket utils

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../models/bucket_definitions.dart';

class BucketUtils {
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

  static Color toleranceColor(BuildContext context, double tolerance) {
    final th = context.theme;
    final c = th.colors;
    if (tolerance < 0.25) return c.success;
    if (tolerance < 0.5) return c.warning;
    if (tolerance < 0.75) return c.warning;
    return c.error;
  }

  static Color getColorForTolerance(BuildContext context, double tolerance) {
    return toleranceColor(context, tolerance);
  }

  static String formatTimeAgo(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else {
      return '${duration.inMinutes}m ago';
    }
  }
}

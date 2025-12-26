// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Helper functions for activity UI. Fully theme-compliant.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
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

  /// Returns a theme-aware color based on craving intensity.
  /// (Helper must NOT access typography/spacing/shapes — only colors.)
  static Color getCravingColor(int intensity, BuildContext context) {
    final c = context.colors;
    if (intensity <= 2) return c.success; // green
    if (intensity <= 4) return c.warning; // yellow
    if (intensity <= 7) return c.warning; // orange (preferred)
    return c.error; // red
  }

  /// Formats a timestamp into a friendly, detailed string.
  static String formatDetailTimestamp(Object? timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final dt = timestamp is DateTime
          ? timestamp.toLocal()
          : DateTime.parse(timestamp.toString()).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      String relative;
      if (diff.inMinutes < 1) {
        relative = 'Just now';
      } else if (diff.inHours < 1) {
        relative = '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        relative = '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        relative = '${diff.inDays}d ago';
      } else {
        relative = DateFormat('MMM d, y').format(dt);
      }
      final timeStr = DateFormat('h:mm a').format(dt);
      final fullDate = DateFormat('EEEE, MMMM d, y').format(dt);
      return '$relative\n$fullDate at $timeStr';
    } catch (_) {
      return 'Unknown';
    }
  }

  /// Returns the ID column name used in each service table.
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

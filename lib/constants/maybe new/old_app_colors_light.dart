// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: N/A
// Notes: Theme colors (green-accent variant).

import 'package:flutter/material.dart';

/// Light theme colors - Wellness-focused, inviting, soft pastels
/// Green-accent variant aligned with TrackYourDrugs branding
class AppColorsLight {
  AppColorsLight._();

  // ============================================================================
  // BASE COLORS (unchanged)
  // ============================================================================
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F8);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEEEFF3);

  // ============================================================================
  // TEXT COLORS (unchanged)
  // ============================================================================
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ============================================================================
  // ACCENT COLORS (GREEN-BRANDED)
  // ============================================================================
  /// Primary accent – brand green (replaces indigo)
  static const Color accentPrimary = Color(0xFF16C784);
  static const Color accentPrimaryVariant = Color(0xFF12B76A);

  /// Secondary accent – softer mint
  static const Color accentSecondary = Color(0xFF6EE7B7);

  // Complementary accents (kept)
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentPink = Color(0xFFEC4899);

  // ============================================================================
  // GRADIENTS
  // ============================================================================
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF34D399), // light green
      Color(0xFF16C784), // brand green
      Color(0xFF12B76A), // deeper green
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FC), Color(0xFFF3F4F8)],
  );

  // ============================================================================
  // STATUS COLORS (semantic – unchanged meaning)
  // ============================================================================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ============================================================================
  // OVERLAY COLORS (unchanged)
  // ============================================================================
  static const Color overlay = Color(0x0D000000);
  static const Color overlayHeavy = Color(0x26000000);
}

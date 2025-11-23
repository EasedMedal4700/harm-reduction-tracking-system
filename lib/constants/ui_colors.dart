import 'package:flutter/material.dart';

/// Central UI color system for the entire app
/// Defines colors for both Light (wellness) and Dark (futuristic) themes
class UIColors {
  UIColors._();

  // ============================================================================
  // LIGHT THEME COLORS (Wellness / Apple Health Style)
  // ============================================================================

  static const Color lightBackground = Color(0xFFF8F9FF); // Very light pastel
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightText = Color(
    0xFF374151,
  ); // Softer dark gray (improved readability)
  static const Color lightTextSecondary = Color(
    0xFF9CA3AF,
  ); // Lighter gray (reduced contrast)
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFF3F4F6);

  // Light theme shadows
  static const Color lightShadowColor = Color(0x1A000000);

  // Light theme FAB
  static const Color lightFab = Color(0xFF3F7CFF); // Bright blue

  // ============================================================================
  // DARK THEME COLORS (Professional Medical Dashboard)
  // ============================================================================

  static const Color darkBackground = Color(0xFF020408); // Deep, almost black
  static const Color darkSurface = Color(0xFF131B2E); // Distinct deep blue-grey
  static const Color darkSurfaceLight = Color(0xFF1E2945); // Elevated surface
  static const Color darkText = Color(0xFFE2E8F0); // Professional light
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted gray
  static const Color darkBorder = Color(
    0x29FFFFFF,
  ); // 16% opacity for clearer definition
  static const Color darkDivider = Color(0xFF1F2937);

  // Dark theme shadows
  static const Color darkShadowColor = Color(0x33000000);

  // Dark theme FAB gradient colors
  static const Color darkFabStart = Color(0xFF3B82F6); // Calm blue
  static const Color darkFabEnd = Color(0xFFA855F7); // Subtle purple

  // ============================================================================
  // LIGHT THEME ACCENT COLORS (Unique per Quick Action)
  // ============================================================================

  static const Color lightAccentGreen = Color(0xFF2ECC71); // Log Usage
  static const Color lightAccentAmber = Color(0xFFF5A623); // Cravings
  static const Color lightAccentPurple = Color(0xFF9B59B6); // Reflection
  static const Color lightAccentTeal = Color(0xFF1ABC9C); // Edit Entries
  static const Color lightAccentBlue = Color(0xFF3498DB); // Analytics
  static const Color lightAccentRed = Color(0xFFE74C3C); // Blood Levels
  static const Color lightAccentGray = Color(0xFF7F8C8D); // Settings
  static const Color lightAccentIndigo = Color(0xFF5C6BC0); // Substance Catalog
  static const Color lightAccentOrange = Color(0xFFF39C12); // Recent Activity
  static const Color lightAccentSoftBlue = Color(
    0xFF5DADE2,
  ); // Personal Catalog

  // ============================================================================
  // DARK THEME NEON ACCENT COLORS (Subtle professional accents)
  // ============================================================================

  static const Color darkNeonCyan = Color(0xFF3B82F6); // Log Entry - calm blue
  static const Color darkNeonPurple = Color(
    0xFFA855F7,
  ); // Reflection - subtle purple
  static const Color darkNeonBlue = Color(0xFF3B82F6); // Analytics - blue
  static const Color darkNeonOrange = Color(0xFFFF6B35); // Cravings - orange
  static const Color darkNeonEmerald = Color(
    0xFF10B981,
  ); // Activity Feed - emerald
  static const Color darkNeonTeal = Color(0xFF14B8A6); // Blood Levels - teal
  static const Color darkNeonViolet = Color(0xFFA855F7); // Database - violet
  static const Color darkNeonPink = Color(
    0xFFEC4899,
  ); // Personal Library - pink
  static const Color darkNeonGreen = Color(0xFF10B981); // Physiology - green
  static const Color darkNeonLavender = Color(
    0xFFA78BFA,
  ); // Interactions - lavender

  // ============================================================================
  // ACCENT COLOR MAPS FOR QUICK ACTIONS
  // ============================================================================

  /// Returns accent color for a Quick Action in LIGHT theme
  static Color getLightAccent(String actionKey) {
    switch (actionKey) {
      case 'log_usage':
        return lightAccentGreen;
      case 'cravings':
        return lightAccentAmber;
      case 'reflection':
        return lightAccentPurple;
      case 'edit_entries':
        return lightAccentTeal;
      case 'analytics':
        return lightAccentBlue;
      case 'blood_levels':
        return lightAccentRed;
      case 'settings':
        return lightAccentGray;
      case 'catalog':
        return lightAccentIndigo;
      case 'activity':
        return lightAccentOrange;
      case 'library':
        return lightAccentSoftBlue;
      case 'tolerance':
        return lightAccentPurple;
      default:
        return lightAccentBlue;
    }
  }

  /// Returns neon accent color for a Quick Action in DARK theme
  static Color getDarkAccent(String actionKey) {
    switch (actionKey) {
      case 'log_usage':
        return darkNeonCyan; // Cyan/Blue-green
      case 'cravings':
        return darkNeonOrange; // Orange
      case 'reflection':
        return darkNeonPurple; // Purple
      case 'edit_entries':
        return darkNeonTeal; // Teal
      case 'analytics':
        return darkNeonViolet; // Violet
      case 'blood_levels':
        return darkNeonPink; // Pink
      case 'settings':
        return darkNeonLavender; // Lavender
      case 'catalog':
        return darkNeonEmerald; // Emerald/Green
      case 'activity':
        return darkNeonTeal; // Teal (changed from green to avoid duplicate)
      case 'library':
        return darkNeonLavender; // Lavender (changed from orange to avoid duplicate)
      case 'tolerance':
        return darkNeonGreen; // Green
      default:
        return darkNeonCyan;
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Creates a neon glow effect for dark theme (subtle professional version)
  static List<BoxShadow> createNeonGlow(Color color, {double intensity = 0.2}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ];
  }

  /// Creates glassmorphism effect for dark theme cards
  static BoxDecoration createGlassmorphism({
    Color? accentColor,
    double radius = 16.0,
  }) {
    return BoxDecoration(
      color: const Color(0x1AFFFFFF), // Increased opacity for better visibility
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: const Color(0x29FFFFFF), // Increased border opacity
        width: 1,
      ),
      boxShadow: accentColor != null
          ? createNeonGlow(accentColor, intensity: 0.15)
          : null,
    );
  }

  /// Creates a soft shadow for light theme
  static List<BoxShadow> createSoftShadow() {
    return [
      BoxShadow(
        color: lightShadowColor,
        blurRadius: 20,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: lightShadowColor.withValues(alpha: 0.05),
        blurRadius: 40,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ];
  }

  /// Creates gradient for dark theme cards
  static LinearGradient createDarkGradient(Color accentColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkSurface,
        darkSurfaceLight,
        accentColor.withValues(alpha: 0.1),
      ],
    );
  }

  /// Creates gradient for light theme headers
  static LinearGradient createLightHeaderGradient(Color accentColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        accentColor.withValues(alpha: 0.1),
        accentColor.withValues(alpha: 0.05),
        Colors.white,
      ],
    );
  }
}

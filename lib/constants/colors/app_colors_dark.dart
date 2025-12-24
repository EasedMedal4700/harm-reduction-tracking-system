import 'package:flutter/material.dart';

/// Dark theme colors - Futuristic, neon-accented, cyberpunk-inspired
/// Features glowing accents, deep backgrounds, and high contrast
class AppColorsDark {
  AppColorsDark._();
  // ============================================================================
  // BASE COLORS
  // ============================================================================
  static const Color background = Color(0xFF0A0E1A); // Deep navy-black
  static const Color surface = Color(0xFF141B2D); // Card background
  static const Color surfaceVariant = Color(0xFF1A2235); // Elevated surface
  static const Color border = Color(0xFF2A3547); // Subtle border
  static const Color divider = Color(0xFF1F2937);
  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  static const Color textPrimary = Color(0xFFE5E7EB);
  static const Color textSecondary = Color(0xFFB0B8C8);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textInverse = Color(0xFF0A0E1A);
  // ============================================================================
  // NEON ACCENT COLORS (Built-in - NOT user-configurable)
  // ============================================================================
  // Primary neon - cyan/electric blue
  static const Color accentPrimary = Color(0xFF00E5FF); // Neon cyan
  static const Color accentPrimaryVariant = Color(0xFF00B8CC);
  static const Color accentSecondary = Color(0xFFBF00FF); // Neon purple
  // Complementary neon colors for variety
  static const Color accentMagenta = Color(0xFFFF00E5);
  static const Color accentBlue = Color(0xFF0080FF);
  static const Color accentTeal = Color(0xFF00D4AA);
  static const Color accentPink = Color(0xFFFF66F0);
  // Neon gradient for hero sections and glow effects
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00E5FF), // Cyan
      Color(0xFF0080FF), // Blue
      Color(0xFFBF00FF), // Purple
    ],
  );
  // Alternative pink/magenta gradient
  static const LinearGradient accentGradientAlt = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF00E5), // Magenta
      Color(0xFFBF00FF), // Purple
      Color(0xFF00E5FF), // Cyan
    ],
  );
  // Subtle surface gradient
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2235), Color(0xFF141B2D)],
  );
  // ============================================================================
  // STATUS COLORS (More vibrant for dark theme)
  // ============================================================================
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);
  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================
  static const Color overlay = Color(0x1AFFFFFF);
  static const Color overlayHeavy = Color(0x33FFFFFF);
  // ============================================================================
  // GLOW COLORS (For neon effects)
  // ============================================================================
  /// Creates a neon glow effect with the primary accent color
  static BoxShadow neonGlowPrimary({double intensity = 0.4}) {
    return BoxShadow(
      color: accentPrimary.withValues(alpha: intensity),
      blurRadius: 20,
      spreadRadius: 0,
    );
  }

  /// Creates an intense neon glow effect
  static BoxShadow neonGlowIntense({double intensity = 0.6}) {
    return BoxShadow(
      color: accentPrimary.withValues(alpha: intensity),
      blurRadius: 30,
      spreadRadius: 2,
    );
  }

  /// Creates a neon glow with custom color
  static BoxShadow neonGlowCustom(Color color, {double intensity = 0.4}) {
    return BoxShadow(
      color: color.withValues(alpha: intensity),
      blurRadius: 20,
      spreadRadius: 0,
    );
  }
}

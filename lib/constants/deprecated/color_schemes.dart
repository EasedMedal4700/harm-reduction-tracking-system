import 'package:flutter/material.dart';

/// DEPRECATED: This file is no longer used for theme colors.
/// The app now uses a simplified light/dark theme system.
/// 
/// Theme colors are now defined in:
/// - app_colors_light.dart (Light theme - wellness-focused)
/// - app_colors_dark.dart (Dark theme - futuristic/neon)
/// 
/// Users can no longer select different theme colors.
/// The theme is determined solely by the Dark Mode toggle.
@Deprecated('Use AppColorsLight and AppColorsDark instead')
class AppColorSchemes {
  AppColorSchemes._();

  // ============================================================================
  // LIGHT THEME COLORS
  // ============================================================================
  
  /// Light theme - Wellness/Inviting style
  static const Color lightBackground = Color(0xFFF8F9FC); // Soft gray-blue
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F8);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFEEEFF3);

  // Text colors
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightTextInverse = Color(0xFFFFFFFF);

  // Status colors
  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightInfo = Color(0xFF3B82F6);

  // Overlay colors
  static const Color lightOverlay = Color(0x0D000000);
  static const Color lightOverlayHeavy = Color(0x26000000);

  // ============================================================================
  // DARK THEME COLORS (Cyberpunk/Futuristic)
  // ============================================================================
  
  /// Dark theme - Futuristic/Neon style
  static const Color darkBackground = Color(0xFF0A0E1A); // Deep navy-black
  static const Color darkSurface = Color(0xFF141B2D); // Card background
  static const Color darkSurfaceVariant = Color(0xFF1A2235); // Elevated surface
  static const Color darkBorder = Color(0xFF2A3547); // Subtle border
  static const Color darkDivider = Color(0xFF1F2937);

  // Text colors
  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFFB0B8C8);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkTextInverse = Color(0xFF0A0E1A);

  // Status colors (more vibrant for dark)
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkInfo = Color(0xFF60A5FA);

  // Overlay colors
  static const Color darkOverlay = Color(0x1AFFFFFF);
  static const Color darkOverlayHeavy = Color(0x33FFFFFF);

  // Neon accents (for cyberpunk style)
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonMagenta = Color(0xFFFF00E5);
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonBlue = Color(0xFF0080FF);

  // ============================================================================
  // ACCENT COLORS (User-selectable theme colors)
  // ============================================================================

  /// Get accent colors based on theme color name
  static AccentColors getAccentColors(String themeColor, bool isDark) {
    switch (themeColor.toLowerCase()) {
      case 'blue':
        return isDark ? _blueDark : _blueLight;
      case 'purple':
        return isDark ? _purpleDark : _purpleLight;
      case 'teal':
        return isDark ? _tealDark : _tealLight;
      case 'pink':
        return isDark ? _pinkDark : _pinkLight;
      case 'cyan':
        return isDark ? _cyanDark : _cyanLight;
      default:
        return isDark ? _blueDark : _blueLight;
    }
  }

  // Light theme accent variations
  static const AccentColors _blueLight = AccentColors(
    primary: Color(0xFF3B82F6),
    primaryVariant: Color(0xFF2563EB),
    secondary: Color(0xFF60A5FA),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF2563EB)],
    ),
  );

  static const AccentColors _purpleLight = AccentColors(
    primary: Color(0xFF8B5CF6),
    primaryVariant: Color(0xFF7C3AED),
    secondary: Color(0xFFA78BFA),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ),
  );

  static const AccentColors _tealLight = AccentColors(
    primary: Color(0xFF14B8A6),
    primaryVariant: Color(0xFF0D9488),
    secondary: Color(0xFF2DD4BF),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF5EEAD4), Color(0xFF14B8A6), Color(0xFF0D9488)],
    ),
  );

  static const AccentColors _pinkLight = AccentColors(
    primary: Color(0xFFEC4899),
    primaryVariant: Color(0xFFDB2777),
    secondary: Color(0xFFF472B6),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF472B6), Color(0xFFEC4899), Color(0xFFDB2777)],
    ),
  );

  static const AccentColors _cyanLight = AccentColors(
    primary: Color(0xFF06B6D4),
    primaryVariant: Color(0xFF0891B2),
    secondary: Color(0xFF22D3EE),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF67E8F9), Color(0xFF06B6D4), Color(0xFF0891B2)],
    ),
  );

  // Dark theme accent variations (more vibrant/neon)
  static const AccentColors _blueDark = AccentColors(
    primary: Color(0xFF0080FF),
    primaryVariant: Color(0xFF0066CC),
    secondary: Color(0xFF60A5FA),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF60A5FA), Color(0xFF0080FF), Color(0xFF0066CC)],
    ),
  );

  static const AccentColors _purpleDark = AccentColors(
    primary: Color(0xFFBF00FF),
    primaryVariant: Color(0xFF9C00CC),
    secondary: Color(0xFFD98BFF),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD98BFF), Color(0xFFBF00FF), Color(0xFF9C00CC)],
    ),
  );

  static const AccentColors _tealDark = AccentColors(
    primary: Color(0xFF00D4AA),
    primaryVariant: Color(0xFF00A885),
    secondary: Color(0xFF5EEAD4),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF5EEAD4), Color(0xFF00D4AA), Color(0xFF00A885)],
    ),
  );

  static const AccentColors _pinkDark = AccentColors(
    primary: Color(0xFFFF00E5),
    primaryVariant: Color(0xFFCC00B8),
    secondary: Color(0xFFFF66F0),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF66F0), Color(0xFFFF00E5), Color(0xFFCC00B8)],
    ),
  );

  static const AccentColors _cyanDark = AccentColors(
    primary: Color(0xFF00E5FF),
    primaryVariant: Color(0xFF00B8CC),
    secondary: Color(0xFF67E8F9),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF67E8F9), Color(0xFF00E5FF), Color(0xFF00B8CC)],
    ),
  );
}

/// Accent color set for a theme
class AccentColors {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final LinearGradient gradient;

  const AccentColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.gradient,
  });
}

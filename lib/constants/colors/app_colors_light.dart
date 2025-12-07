import 'package:flutter/material.dart';

/// Light theme colors - Wellness-focused, inviting, soft pastels
/// Inspired by Apple Health and modern wellness apps
class AppColorsLight {
  AppColorsLight._();

  // ============================================================================
  // BASE COLORS
  // ============================================================================
  
  static const Color background = Color(0xFFF8F9FC); // Soft gray-blue
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F8);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEEEFF3);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ============================================================================
  // ACCENT COLORS (Built-in - NOT user-configurable)
  // ============================================================================
  
  // Primary accent - soft blue/purple blend
  static const Color accentPrimary = Color(0xFF6366F1); // Indigo
  static const Color accentPrimaryVariant = Color(0xFF4F46E5);
  static const Color accentSecondary = Color(0xFF8B5CF6); // Purple
  
  // Complementary accent colors for variety
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentPink = Color(0xFFEC4899);

  // Gradient for hero sections
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF818CF8), // Light indigo
      Color(0xFF6366F1), // Indigo
      Color(0xFF8B5CF6), // Purple
    ],
  );

  // Subtle background gradient option
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8F9FC),
      Color(0xFFF3F4F8),
    ],
  );

  // ============================================================================
  // STATUS COLORS
  // ============================================================================
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================
  
  static const Color overlay = Color(0x0D000000);
  static const Color overlayHeavy = Color(0x26000000);
}

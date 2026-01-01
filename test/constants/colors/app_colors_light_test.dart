import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/colors/app_colors_light.dart';

void main() {
  group('AppColorsLight', () {
    test('background has correct value', () {
      expect(AppColorsLight.background, const Color(0xFFF8F9FC));
    });

    test('surface has correct value', () {
      expect(AppColorsLight.surface, const Color(0xFFFFFFFF));
    });

    test('surfaceVariant has correct value', () {
      expect(AppColorsLight.surfaceVariant, const Color(0xFFF3F4F8));
    });

    test('border has correct value', () {
      expect(AppColorsLight.border, const Color(0xFFE5E7EB));
    });

    test('divider has correct value', () {
      expect(AppColorsLight.divider, const Color(0xFFEEEFF3));
    });

    test('textPrimary has correct value', () {
      expect(AppColorsLight.textPrimary, const Color(0xFF1F2937));
    });

    test('textSecondary has correct value', () {
      expect(AppColorsLight.textSecondary, const Color(0xFF6B7280));
    });

    test('textTertiary has correct value', () {
      expect(AppColorsLight.textTertiary, const Color(0xFF9CA3AF));
    });

    test('textInverse has correct value', () {
      expect(AppColorsLight.textInverse, const Color(0xFFFFFFFF));
    });

    test('accentPrimary has correct value', () {
      expect(AppColorsLight.accentPrimary, const Color(0xFF6366F1));
    });

    test('accentPrimaryVariant has correct value', () {
      expect(AppColorsLight.accentPrimaryVariant, const Color(0xFF4F46E5));
    });

    test('accentSecondary has correct value', () {
      expect(AppColorsLight.accentSecondary, const Color(0xFF8B5CF6));
    });

    test('accentTeal has correct value', () {
      expect(AppColorsLight.accentTeal, const Color(0xFF14B8A6));
    });

    test('accentGreen has correct value', () {
      expect(AppColorsLight.accentGreen, const Color(0xFF10B981));
    });

    test('accentPink has correct value', () {
      expect(AppColorsLight.accentPink, const Color(0xFFEC4899));
    });

    test('success has correct value', () {
      expect(AppColorsLight.success, const Color(0xFF10B981));
    });

    test('warning has correct value', () {
      expect(AppColorsLight.warning, const Color(0xFFF59E0B));
    });

    test('error has correct value', () {
      expect(AppColorsLight.error, const Color(0xFFEF4444));
    });

    test('info has correct value', () {
      expect(AppColorsLight.info, const Color(0xFF3B82F6));
    });

    test('overlay has correct value', () {
      expect(AppColorsLight.overlay, const Color(0x0D000000));
    });

    test('overlayHeavy has correct value', () {
      expect(AppColorsLight.overlayHeavy, const Color(0x26000000));
    });
  });
}

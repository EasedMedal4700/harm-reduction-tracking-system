import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/colors/app_colors_dark.dart';

void main() {
  group('AppColorsDark', () {
    test('background has correct value', () {
      expect(AppColorsDark.background, const Color(0xFF0A0E1A));
    });

    test('surface has correct value', () {
      expect(AppColorsDark.surface, const Color(0xFF141B2D));
    });

    test('surfaceVariant has correct value', () {
      expect(AppColorsDark.surfaceVariant, const Color(0xFF1A2235));
    });

    test('border has correct value', () {
      expect(AppColorsDark.border, const Color(0xFF2A3547));
    });

    test('divider has correct value', () {
      expect(AppColorsDark.divider, const Color(0xFF1F2937));
    });

    test('textPrimary has correct value', () {
      expect(AppColorsDark.textPrimary, const Color(0xFFE5E7EB));
    });

    test('textSecondary has correct value', () {
      expect(AppColorsDark.textSecondary, const Color(0xFFB0B8C8));
    });

    test('textTertiary has correct value', () {
      expect(AppColorsDark.textTertiary, const Color(0xFF6B7280));
    });

    test('textInverse has correct value', () {
      expect(AppColorsDark.textInverse, const Color(0xFF0A0E1A));
    });

    test('accentPrimary has correct value', () {
      expect(AppColorsDark.accentPrimary, const Color(0xFF00E5FF));
    });

    test('accentPrimaryVariant has correct value', () {
      expect(AppColorsDark.accentPrimaryVariant, const Color(0xFF00B8CC));
    });

    test('accentSecondary has correct value', () {
      expect(AppColorsDark.accentSecondary, const Color(0xFFBF00FF));
    });

    test('accentMagenta has correct value', () {
      expect(AppColorsDark.accentMagenta, const Color(0xFFFF00E5));
    });

    test('accentBlue has correct value', () {
      expect(AppColorsDark.accentBlue, const Color(0xFF0080FF));
    });

    test('accentTeal has correct value', () {
      expect(AppColorsDark.accentTeal, const Color(0xFF00D4AA));
    });

    test('accentPink has correct value', () {
      expect(AppColorsDark.accentPink, const Color(0xFFFF66F0));
    });

    test('success has correct value', () {
      expect(AppColorsDark.success, const Color(0xFF34D399));
    });

    test('warning has correct value', () {
      expect(AppColorsDark.warning, const Color(0xFFFBBF24));
    });

    test('error has correct value', () {
      expect(AppColorsDark.error, const Color(0xFFF87171));
    });

    test('info has correct value', () {
      expect(AppColorsDark.info, const Color(0xFF60A5FA));
    });

    test('overlay has correct value', () {
      expect(AppColorsDark.overlay, const Color(0x1AFFFFFF));
    });

    test('overlayHeavy has correct value', () {
      expect(AppColorsDark.overlayHeavy, const Color(0x33FFFFFF));
    });

    test('neonGlowPrimary returns correct BoxShadow', () {
      final shadow = AppColorsDark.neonGlowPrimary();
      expect(shadow.color, const Color(0x6600E5FF)); // 0.4 opacity
      expect(shadow.blurRadius, 20);
      expect(shadow.spreadRadius, 0);
    });

    test('neonGlowIntense returns correct BoxShadow', () {
      final shadow = AppColorsDark.neonGlowIntense();
      expect(shadow.color, const Color(0x9900E5FF)); // 0.6 opacity
      expect(shadow.blurRadius, 30);
      expect(shadow.spreadRadius, 2);
    });

    test('neonGlowCustom returns correct BoxShadow', () {
      const customColor = Colors.red;
      final shadow = AppColorsDark.neonGlowCustom(customColor);
      expect(shadow.color, customColor.withValues(alpha: 0.4));
      expect(shadow.blurRadius, 20);
      expect(shadow.spreadRadius, 0);
    });
  });
}
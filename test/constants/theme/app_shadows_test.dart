import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/theme/app_shadows.dart';

void main() {
  group('AppShadowConstants', () {
    test('shadowLight color is correct', () {
      expect(AppShadowConstants.shadowLight, const Color(0x1A000000));
    });

    test('shadowDark color is correct', () {
      expect(AppShadowConstants.shadowDark, const Color(0x66000000));
    });

    test('blurLight value is correct', () {
      expect(AppShadowConstants.blurLight, 10.0);
    });

    test('blurMedium value is correct', () {
      expect(AppShadowConstants.blurMedium, 20.0);
    });

    test('blurHeavy value is correct', () {
      expect(AppShadowConstants.blurHeavy, 40.0);
    });

    test('glowSpread value is correct', () {
      expect(AppShadowConstants.glowSpread, 0.0);
    });

    test('glowBlur value is correct', () {
      expect(AppShadowConstants.glowBlur, 8.0);
    });

    test('glowBlurIntense value is correct', () {
      expect(AppShadowConstants.glowBlurIntense, 16.0);
    });
  });

  group('LightShadows', () {
    test('card shadow is correct', () {
      expect(LightShadows.card, const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ]);
    });

    test('cardHovered shadow is correct', () {
      expect(LightShadows.cardHovered, const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 12,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ]);
    });

    test('softShadow is correct', () {
      expect(LightShadows.softShadow, const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
          spreadRadius: 0,
        ),
      ]);
    });

    test('button shadow is correct', () {
      expect(LightShadows.button, const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ]);
    });
  });

  group('DarkShadows', () {
    test('card shadow is correct', () {
      expect(DarkShadows.card, const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 12,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ]);
    });

    test('cardHovered shadow is correct', () {
      expect(DarkShadows.cardHovered, const [
        BoxShadow(
          color: Color(0x60000000),
          blurRadius: 16,
          offset: Offset(0, 6),
          spreadRadius: 0,
        ),
      ]);
    });

    test('softShadow is correct', () {
      expect(DarkShadows.softShadow, const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 8,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ]);
    });

    test('button shadow is correct', () {
      expect(DarkShadows.button, const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 8,
          offset: Offset(0, 3),
          spreadRadius: 0,
        ),
      ]);
    });

    test('neonGlow returns correct shadows', () {
      const testColor = Color(0xFFFF0000);
      final shadows = DarkShadows.neonGlow(testColor);
      expect(shadows, [
        BoxShadow(
          color: testColor.withValues(alpha: 0.4),
          blurRadius: AppShadowConstants.glowBlur,
          offset: Offset.zero,
          spreadRadius: AppShadowConstants.glowSpread,
        ),
      ]);
    });

    test('neonGlowIntense returns correct shadows', () {
      const testColor = Color(0xFFFF0000);
      final shadows = DarkShadows.neonGlowIntense(testColor);
      expect(shadows, [
        BoxShadow(
          color: testColor.withValues(alpha: 0.6),
          blurRadius: AppShadowConstants.glowBlurIntense,
          offset: Offset.zero,
          spreadRadius: AppShadowConstants.glowSpread,
        ),
      ]);
    });
  });
}

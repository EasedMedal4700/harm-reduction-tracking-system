Constants Directory

This directory contains application-wide constants, configuration, and internal theme infrastructure.

It is NOT a widget-facing API.

⚠️ CRITICAL RULE — READ FIRST
🚫 Widgets, screens, and features MUST NOT import constants directly

The ONLY allowed theme import for widgets, screens, and features is:

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';


Direct imports of any other theme-related files are FORBIDDEN in:

lib/features/**

lib/widgets/**

lib/screens/**

lib/common/**

This rule is enforced to guarantee:

Theme consistency

Dark/light safety

Centralized control

Migration stability

Directory Structure
theme/ (INTERNAL — DO NOT IMPORT DIRECTLY)

This folder contains theme infrastructure used to assemble AppTheme.

These files are not public APIs.

app_theme.dart – Composes the full AppTheme

app_theme_provider.dart – Provides AppTheme to the widget tree

app_theme_extension.dart ✅ ONLY PUBLIC ENTRY POINT

app_theme_constants.dart – Internal tokens (spacing, radii, opacity, animation)

app_spacing.dart – Spacing model

app_typography.dart – Typography definitions

app_shapes.dart – Border radius model

app_colors.dart / palettes – Internal color sources

app_accent_colors.dart – Accent color sets

app_shadows.dart – Shadow & glow definitions

📌 Widgets must access everything via BuildContext extensions only:

final c = context.colors;
final sp = context.spacing;
final t = context.text;
final sh = context.shapes;
final a = context.accent;

data/

Static, non-theme data used across the app:

Substance catalogs

Emotion lists

Body/mind signals

Reflection options

Craving constants

These may be imported directly where needed.

config/

Application configuration and feature flags:

feature_flags.dart

Used to gate features and experiments.

enums/

Typed enumerations for:

Mood

Time periods

States

Used for type safety and clarity.

deprecated/

⚠️ DO NOT USE IN NEW CODE

Legacy constants preserved only for migration reference:

ui_colors.dart

theme_constants.dart

drug_theme.dart

Old color schemes

Any usage found outside migration cleanup is a bug.

✅ Correct Theme Usage (Widgets & Features)
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

final c = context.colors;
final sp = context.spacing;
final t = context.text;

Container(
  padding: EdgeInsets.all(sp.md),
  decoration: BoxDecoration(
    color: c.surface,
    borderRadius: BorderRadius.circular(context.shapes.radiusMd),
  ),
);

❌ Forbidden Patterns

The following are not allowed in widgets/features:

import 'app_theme_constants.dart';
import 'app_colors_dark.dart';
import 'ui_colors.dart';

Colors.blue
Color(0xFF123456)
ThemeConstants.space24
UIColors.darkText

Migration Notes

Theme access is context-driven only

AppThemeConstants is internal infrastructure

If a token is missing → extend the theme system, do not bypass it

Common UI patterns should be extracted to /common/

MVP Policy

This structure prioritizes:

Shipping safely

Predictable theming

Easy post-MVP cleanup

Full bottom-up audits and perfection passes can happen after MVP.

Summary

If you remember one rule:

Widgets talk to the theme only through BuildContext.
Everything else is internal.
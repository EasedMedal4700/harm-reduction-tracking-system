# Constants Directory

This directory contains application-wide constants, configuration, and theme infrastructure for the mobile drug use tracking app.

## Overview

The constants directory is organized into logical subfolders to keep related functionality together. It provides:

- **Theme system** for consistent UI styling
- **Static data** for app content (substances, emotions, etc.)
- **Configuration** for feature flags and app settings
- **Type definitions** for enums and constants
- **Color schemes** for light and dark themes

## Directory Structure

### 🎨 `theme/` - Theme System

The theme folder contains the complete theming infrastructure. Most components should access theme values through the context extensions.

**Key Files:**
- `app_theme.dart` - Main theme composition
- `app_theme_provider.dart` - Theme provider for the widget tree
- `app_theme_extension.dart` - **PRIMARY ENTRY POINT** for widgets
- `app_spacing.dart` - Spacing and sizing constants
- `app_typography.dart` - Text styles and fonts
- `app_colors.dart` / `app_color_palette.dart` - Color definitions
- `app_shapes.dart` - Border radius and shapes
- `app_shadows.dart` - Shadow and elevation definitions
- `app_animations.dart` - Animation durations and curves
- `app_layout.dart` - Layout constants
- `app_sizes.dart` - Size tokens
- `app_borders.dart` - Border styles
- `app_radius.dart` - Border radius values
- `app_opacities.dart` - Opacity values

**Usage in Widgets:**
```dart
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// Access theme through BuildContext
final theme = Theme.of(context);
final colors = context.colors;
final spacing = context.spacing;
final text = context.text;

Container(
  padding: EdgeInsets.all(spacing.md),
  decoration: BoxDecoration(
    color: colors.surface,
    borderRadius: BorderRadius.circular(context.shapes.radiusMd),
    boxShadow: [context.shadows.sm],
  ),
  child: Text('Hello', style: text.body),
);
```

### 📊 `data/` - Static Application Data

Contains static data used throughout the app, such as catalogs, options, and predefined content.

**Files:**
- `drug_use_catalog.dart` - Substance and drug information
- `body_and_mind_catalog.dart` - Body and mind signal definitions
- `reflection_options.dart` - Reflection and journaling options
- `craving_consatnts.dart` - Craving-related constants
- `drug_categories.dart` - Drug categorization data
- `refelction_constants.dart` - Reflection constants
- `base_substances.json` - Base substance data (JSON format)

**Usage:**
```dart
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';
import 'package:mobile_drug_use_app/constants/data/body_and_mind_catalog.dart';

// Direct import is fine for data constants
final substances = DrugUseCatalog.substances;
final bodySignals = BodyAndMindCatalog.bodySignals;
```

### ⚙️ `config/` - Configuration & Feature Flags

Application configuration and feature gating.

**Files:**
- `feature_flags.dart` - Feature flags for A/B testing and gradual rollouts

**Usage:**
```dart
import 'package:mobile_drug_use_app/constants/config/feature_flags.dart';

// Check if a feature is enabled
if (FeatureFlags.isEnabled(Feature.analytics)) {
  // Enable analytics
}
```

### 🏷️ `enums/` - Type Definitions

Typed enumerations for type safety and consistency.

**Files:**
- `app_mood.dart` - Mood states and values
- `time_period.dart` - Time period definitions

**Usage:**
```dart
import 'package:mobile_drug_use_app/constants/enums/app_mood.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';

// Use typed enums instead of strings
final mood = AppMood.happy;
final period = TimePeriod.daily;
```

### 🎨 `colors/` - Color Schemes

Light and dark theme color definitions.

**Files:**
- `app_colors_light.dart` - Light theme colors
- `app_colors_dark.dart` - Dark theme colors

**Note:** These are typically accessed through the theme system rather than imported directly.

## Usage Guidelines

### ✅ Recommended Patterns

1. **Theme Access**: Use `context` extensions for theme values in widgets
2. **Data Constants**: Import data files directly where needed
3. **Feature Flags**: Check feature availability through the config system
4. **Enums**: Use typed enums for state and configuration values

### ⚠️ Best Practices

- **Theme Consistency**: Always use theme values instead of hardcoded colors/sizes
- **Type Safety**: Prefer enums over string constants
- **Feature Gating**: Use feature flags for experimental features
- **Data Separation**: Keep UI data separate from business logic

### ❌ Avoid These Patterns

- Hardcoded colors: `Color(0xFF123456)` or `Colors.blue`
- Magic numbers: `SizedBox(height: 24)` → `SizedBox(height: context.spacing.xl)`
- String literals for states: `'happy'` → `AppMood.happy`
- Direct theme imports in widgets (except `app_theme_extension.dart`)

## Migration & Development

### For New Features

1. Check if the needed constant exists in the theme system
2. If missing, extend the theme system rather than adding direct constants
3. Use enums for any new state or configuration values
4. Add feature flags for experimental features

### For Existing Code

- Gradually migrate hardcoded values to theme constants
- Replace string literals with enums where appropriate
- Update imports to use the recommended patterns

## Architecture Notes

This structure supports:
- **Theme Consistency**: Centralized theming prevents visual inconsistencies
- **Maintainability**: Clear organization makes updates easier
- **Type Safety**: Enums prevent typos and invalid states
- **Feature Control**: Feature flags enable safe rollouts
- **Data Management**: Static data is versioned and testable

The theme system is designed to be context-aware, automatically adapting to light/dark modes and providing consistent spacing, colors, and typography across the entire app.
# Constants Directory

This directory contains all application-wide constants, configuration, and data assets organized by category.

## Directory Structure

### `colors/`
Theme-aware color definitions for light and dark modes.
- `app_colors_dark.dart` - Dark theme color palette
- `app_colors_light.dart` - Light theme color palette

### `config/`
Application configuration and feature flags.
- `feature_flags.dart` - Feature toggles and experimental settings

### `data/`
Static data assets and catalogs used throughout the application.
- `base_substances.json` - Core substance database
- `body_and_mind_catalog.dart` - Body and mind state definitions
- `craving_consatnts.dart` - Craving intensity definitions
- `drug_categories.dart` - Drug classification categories
- `drug_use_catalog.dart` - Drug use patterns and definitions
- `refelction_constants.dart` - Reflection and journaling constants
- `reflection_options.dart` - Available reflection options

### `deprecated/`
Legacy constants that are no longer used but kept for reference during migration.
- `color_schemes.dart` - Old color scheme definitions
- `drug_theme.dart` - Legacy theme constants
- `theme_constants.dart` - Old theme constants (replaced by theme/)
- `ui_colors.dart` - Old UI color definitions (replaced by colors/)

### `emus/`
Enumeration definitions for type-safe constants.
- `app_mood.dart` - Mood state enumerations
- `time_period.dart` - Time period enumerations

### `theme/`
Comprehensive theme system with spacing, typography, colors, and extensions.
- `app_colors.dart` - Unified color system
- `app_radius.dart` - Border radius constants
- `app_spacing.dart` - Spacing and padding constants
- `app_theme_constants.dart` - Core theme constants
- `app_theme_extension.dart` - Theme extension utilities
- `app_theme_provider.dart` - Theme provider implementation
- `app_theme.dart` - Main theme definitions
- `app_typography.dart` - Typography and font constants

## Usage Guidelines

### Importing Constants
```dart
// Import specific constants
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:mobile_drug_use_app/constants/colors/app_colors_dark.dart';

// Import data assets
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';
```

### Theme Constants
Use the theme constants from `theme/` for consistent styling:
```dart
// Spacing
padding: EdgeInsets.all(AppThemeConstants.cardPadding),

// Colors (theme-aware)
color: isDark ? AppColorsDark.primary : AppColorsLight.primary,

// Typography
style: AppTypography.headlineMedium,
```

### Data Constants
Access static data through the data constants:
```dart
// Get drug categories
final categories = DrugCategories.all;

// Access substance data
final substances = await SubstanceRepository.loadBaseSubstances();
```

## Migration Notes

### From Deprecated Constants
The `deprecated/` folder contains old constants that have been replaced:

- `theme_constants.dart` → `theme/app_theme_constants.dart`
- `ui_colors.dart` → `colors/app_colors_*.dart`
- `color_schemes.dart` → `theme/app_colors.dart`

### Feature Flags
Use `config/feature_flags.dart` to control experimental features:
```dart
if (FeatureFlags.analyticsPage) {
  // Enable analytics feature
}
```

## Architecture

This constants structure supports:
- **Theme Consistency**: Unified theming across light/dark modes
- **Type Safety**: Enums for compile-time safety
- **Maintainability**: Centralized configuration management
- **Scalability**: Organized by concern for easy extension
- **Migration Safety**: Deprecated folder preserves old code during transitions

## Adding New Constants

1. **Choose appropriate subfolder** based on the constant type
2. **Follow naming conventions** (PascalCase for classes, camelCase for instances)
3. **Add documentation** for all public constants
4. **Update this README** when adding new subfolders or major changes</content>
<parameter name="filePath">c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\constants\README.md
# Constants Refactoring Migration Guide

## ⚠️ IMPORTANT: Read Before Making Changes

This guide provides the complete migration path from the old constants structure to the new design system.

---

## 📋 Migration Overview

**Status**: ✅ New structure created | ⏳ Imports need updating | ⏳ Old files need deletion

**Total files affected**: ~200+ import statements across the codebase

**Estimated migration time**: 30-60 minutes (with find/replace)

---

## 🔄 Import Replacement Map

### Theme Constants

| Old Import | New Import | Notes |
|------------|------------|-------|
| `import '../constants/ui_colors.dart';` | `import '../constants/theme/app_colors.dart';` | Use `AppColors.light` or `AppColors.dark` |
| `import '../constants/app_colors_light.dart';` | `import '../constants/theme/app_colors.dart';` | Access via `AppColors.light` |
| `import '../constants/app_colors_dark.dart';` | `import '../constants/theme/app_colors.dart';` | Access via `AppColors.dark` |
| `import '../constants/theme_constants.dart';` | `import '../constants/theme/app_spacing.dart';`<br>`import '../constants/theme/app_radii.dart';` | Split into spacing + radii |
| `import '../constants/app_theme_constants.dart';` | `import '../constants/theme/app_spacing.dart';`<br>`import '../constants/theme/app_shadows.dart';` | Split into spacing + shadows |

### Domain Constants

| Old Import | New Import | Notes |
|------------|------------|-------|
| `import '../constants/drug_categories.dart';` | `import '../constants/domain/categories.dart';` | All category logic consolidated |
| `import '../constants/craving_consatnts.dart';` | `import '../constants/domain/categories.dart';` | Merged into categories (typo fixed) |
| `import '../constants/refelction_constants.dart';` | `import '../constants/domain/reflection_constants.dart';` | Typo fixed |
| `import '../constants/app_mood.dart';` | `import '../constants/domain/mood_emojis.dart';` | Renamed for clarity |
| `import '../constants/drug_theme.dart';` | `import '../constants/domain/drug_category_colors.dart';` | Renamed for clarity |

### New Theme Files (for widgets needing these)

| New Import | Purpose |
|------------|---------|
| `import '../constants/theme/app_typography.dart';` | Text styles that scale with user preferences |
| `import '../constants/theme/app_animation.dart';` | Standardized animation durations and curves |

---

## 🛠️ Step-by-Step Migration Instructions

### Step 1: Run the Smoke Test (Verify Compilation)

Before making any changes, ensure all new constant files compile:

```bash
flutter test test/constants_smoke_test.dart
```

**Expected Result**: All tests should PASS. If any fail, the constant files have syntax errors that must be fixed first.

---

### Step 2: Update Imports (Automated Find/Replace)

Use VS Code's global find/replace (`Ctrl+Shift+H`) with the following patterns:

#### Pattern 1: ui_colors.dart
```
Find:    import '([./]*)constants/ui_colors.dart';
Replace: import '$1constants/theme/app_colors.dart';
```

#### Pattern 2: theme_constants.dart
```
Find:    import '([./]*)constants/theme_constants.dart';
Replace: import '$1constants/theme/app_spacing.dart';\nimport '$1constants/theme/app_radii.dart';
```

#### Pattern 3: app_theme_constants.dart
```
Find:    import '([./]*)constants/app_theme_constants.dart';
Replace: import '$1constants/theme/app_spacing.dart';\nimport '$1constants/theme/app_shadows.dart';
```

#### Pattern 4: app_colors_light.dart & app_colors_dark.dart
```
Find:    import '([./]*)constants/app_colors_(light|dark).dart';
Replace: import '$1constants/theme/app_colors.dart';
```

#### Pattern 5: drug_categories.dart
```
Find:    import '([./]*)constants/drug_categories.dart';
Replace: import '$1constants/domain/categories.dart';
```

#### Pattern 6: craving_consatnts.dart (typo in old file)
```
Find:    import '([./]*)constants/craving_consatnts.dart';
Replace: import '$1constants/domain/categories.dart';
```

#### Pattern 7: refelction_constants.dart (typo in old file)
```
Find:    import '([./]*)constants/refelction_constants.dart';
Replace: import '$1constants/domain/reflection_constants.dart';
```

#### Pattern 8: app_mood.dart
```
Find:    import '([./]*)constants/app_mood.dart';
Replace: import '$1constants/domain/mood_emojis.dart';
```

#### Pattern 9: drug_theme.dart
```
Find:    import '([./]*)constants/drug_theme.dart';
Replace: import '$1constants/domain/drug_category_colors.dart';
```

---

### Step 3: Update Code References (Manual Review Required)

Some code may reference old class names or patterns. Review and update:

#### Old Pattern → New Pattern

```dart
// OLD: ui_colors.dart
UIColors.lightBackground → AppColors.light.background
UIColors.darkBackground → AppColors.dark.background
UIColors.accentColor → AppColors.light.accentPrimary (or .dark)

// OLD: theme_constants.dart
ThemeConstants.spacing8 → AppSpacing.sm
ThemeConstants.spacing12 → AppSpacing.md
ThemeConstants.spacing16 → AppSpacing.lg
ThemeConstants.borderRadius8 → AppRadii.sm
ThemeConstants.borderRadius12 → AppRadii.md

// OLD: app_theme_constants.dart
AppThemeConstants.cardShadow → AppShadows.light.cardShadow (or .dark)
AppThemeConstants.spacing → AppSpacing.md

// OLD: drug_categories.dart
DrugCategories.categoryList → Categories.categoryPriority
DrugCategories.iconMap → Categories.categoryIconMap

// OLD: drug_theme.dart
DrugTheme.colorForCategory('stimulant') → DrugCategoryColors.colorFor('stimulant')

// OLD: app_mood.dart
AppMood.moodEmojis['Great'] → MoodEmojis.getEmoji('Great')
```

---

### Step 4: Test Compilation

After replacing imports, run:

```bash
flutter analyze
```

Fix any remaining errors (usually just missing imports or renamed constants).

---

### Step 5: Run Full Test Suite

```bash
flutter test
```

Ensure no regressions were introduced.

---

### Step 6: Delete Old Files

⚠️ **ONLY after verifying the app runs correctly**, delete these old files:

```
lib/constants/ui_colors.dart
lib/constants/theme_constants.dart
lib/constants/app_theme_constants.dart
lib/constants/app_colors_light.dart
lib/constants/app_colors_dark.dart
lib/constants/drug_categories.dart
lib/constants/craving_consatnts.dart
lib/constants/refelction_constants.dart
lib/constants/app_mood.dart
lib/constants/drug_theme.dart
```

**PowerShell Command to Delete (run from project root):**
```powershell
Remove-Item lib/constants/ui_colors.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/theme_constants.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/app_theme_constants.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/app_colors_light.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/app_colors_dark.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/drug_categories.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/craving_consatnts.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/refelction_constants.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/app_mood.dart -ErrorAction SilentlyContinue
Remove-Item lib/constants/drug_theme.dart -ErrorAction SilentlyContinue
```

---

## 📊 Files Requiring Import Updates

### High Priority (Core UI Files)

- `lib/styles/app_theme.dart` - Main theme configuration
- `lib/theme/app_theme.dart` - Theme provider
- All files in `lib/screens/` (80+ files)
- All files in `lib/widgets/` (120+ files)

### Affected File Count by Category

| Category | File Count | Import Pattern |
|----------|------------|----------------|
| Screens | ~30 files | `../constants/...` |
| Widgets | ~120 files | `../../constants/...` |
| Common Components | ~10 files | `../../constants/...` |
| Theme/Styles | ~2 files | `../constants/...` |

---

## 🧪 Validation Checklist

- [ ] Smoke test passes (`flutter test test/constants_smoke_test.dart`)
- [ ] No compile errors (`flutter analyze`)
- [ ] All screens render correctly in light mode
- [ ] All screens render correctly in dark mode
- [ ] No hardcoded colors remain in widget files
- [ ] Spacing is consistent across components
- [ ] Shadows/elevation work correctly
- [ ] Typography scales with user font size setting
- [ ] Old constant files deleted
- [ ] Git commit created with clear message

---

## 🚨 Common Migration Issues

### Issue 1: Missing Class Access

**Error**: `Undefined name 'UIColors'`

**Fix**: Replace `UIColors.lightBackground` with `AppColors.light.background`

---

### Issue 2: Multiple Imports for Same Constant

**Error**: Duplicate imports after find/replace

**Fix**: Consolidate to single import:
```dart
// ❌ DON'T
import '../constants/theme/app_spacing.dart';
import '../constants/theme/app_spacing.dart';

// ✅ DO
import '../constants/theme/app_spacing.dart';
```

---

### Issue 3: Relative Import Path Wrong

**Error**: `Target of URI doesn't exist`

**Fix**: Check folder depth. Most widgets use `../../constants/`, screens use `../constants/`

---

## 📦 Rollback Plan

If migration causes critical issues:

1. **Revert Git Changes**:
   ```bash
   git checkout lib/
   ```

2. **Keep new constants folder** and revert old files:
   ```bash
   git checkout lib/constants/ui_colors.dart
   git checkout lib/constants/theme_constants.dart
   # ... etc for other files
   ```

3. **Report errors** to the team before retrying

---

## 🎯 Post-Migration Tasks

- [ ] Update team documentation
- [ ] Add linting rules to prevent magic numbers
- [ ] Create common components that use new constants
- [ ] Plan component library architecture
- [ ] Set up design token documentation site (optional)

---

## 📞 Support

If you encounter issues during migration:

1. Check the `lib/constants/README.md` for design system documentation
2. Run `flutter analyze` for detailed error messages
3. Review this guide's "Common Migration Issues" section
4. Consult the smoke test file for correct usage examples

---

**Migration Author**: System  
**Last Updated**: December 7, 2025  
**Estimated Completion**: 1 hour

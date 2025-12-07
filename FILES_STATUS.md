# Files Status & Action Required

## ✅ New Files (Created & Ready)

All these files are in their correct locations and ready to use:

### Theme Files
- `lib/constants/theme/app_colors.dart` ✅
- `lib/constants/theme/app_spacing.dart` ✅
- `lib/constants/theme/app_radii.dart` ✅
- `lib/constants/theme/app_shadows.dart` ✅
- `lib/constants/theme/app_typography.dart` ✅
- `lib/constants/theme/app_animation.dart` ✅

### Domain Files
- `lib/constants/domain/intentions.dart` ✅
- `lib/constants/domain/triggers.dart` ✅
- `lib/constants/domain/categories.dart` ✅
- `lib/constants/domain/reflection_constants.dart` ✅
- `lib/constants/domain/reflection_options.dart` ✅
- `lib/constants/domain/drug_category_colors.dart` ✅
- `lib/constants/domain/mood_emojis.dart` ✅

### System Files
- `lib/constants/system/feature_flags.dart` ✅
- `lib/constants/system/time_period.dart` ✅

---

## ⚠️ Old Files in Root (Need Migration/Deletion)

These files in `lib/constants/` root should be deleted AFTER migration:

### Will Be Deleted (After Import Updates)
- `lib/constants/ui_colors.dart` → Replaced by `theme/app_colors.dart`
- `lib/constants/theme_constants.dart` → Replaced by `theme/app_spacing.dart` + `theme/app_radii.dart`
- `lib/constants/app_theme_constants.dart` → Replaced by `theme/app_spacing.dart` + `theme/app_shadows.dart`
- `lib/constants/app_colors_light.dart` → Replaced by `theme/app_colors.dart`
- `lib/constants/app_colors_dark.dart` → Replaced by `theme/app_colors.dart`
- `lib/constants/drug_categories.dart` → Replaced by `domain/categories.dart`
- `lib/constants/craving_consatnts.dart` → Replaced by `domain/categories.dart` (typo fixed)
- `lib/constants/refelction_constants.dart` → Replaced by `domain/reflection_constants.dart` (typo fixed)
- `lib/constants/app_mood.dart` → Replaced by `domain/mood_emojis.dart`
- `lib/constants/drug_theme.dart` → Replaced by `domain/drug_category_colors.dart`
- `lib/constants/color_schemes.dart` → Already deprecated, safe to delete
- `lib/constants/app_typography.dart` → Replaced by `theme/app_typography.dart`
- `lib/constants/feature_flags.dart` → Replaced by `system/feature_flags.dart`
- `lib/constants/time_period.dart` → Replaced by `system/time_period.dart`
- `lib/constants/reflection_options.dart` → Replaced by `domain/reflection_options.dart`

### Keep These (Domain Data, Not Duplicate)
- `lib/constants/drug_use_catalog.dart` ✅ KEEP - Contains consumption methods and emotion lists
- `lib/constants/body_and_mind_catalog.dart` ✅ KEEP - Contains large lists of intentions/triggers

**Note**: `drug_use_catalog.dart` and `body_and_mind_catalog.dart` contain different data than the new domain files. They should be kept but may need to be moved to `domain/` folder for consistency.

---

## 📋 Action Plan

### Immediate Actions

1. **Run Smoke Test** ✅ (Already passed)
   ```bash
   flutter test test/constants_smoke_test.dart
   ```

2. **Follow Migration Guide** ⏳ (Your next step)
   - Open `CONSTANTS_MIGRATION_GUIDE.md`
   - Use find/replace patterns to update imports
   - Update code references (UIColors → AppColors.light, etc.)

3. **Delete Old Files** ⏳ (After migration complete)
   ```powershell
   # Run from project root AFTER verifying app works
   Remove-Item lib/constants/ui_colors.dart
   Remove-Item lib/constants/theme_constants.dart
   Remove-Item lib/constants/app_theme_constants.dart
   Remove-Item lib/constants/app_colors_light.dart
   Remove-Item lib/constants/app_colors_dark.dart
   Remove-Item lib/constants/drug_categories.dart
   Remove-Item lib/constants/craving_consatnts.dart
   Remove-Item lib/constants/refelction_constants.dart
   Remove-Item lib/constants/app_mood.dart
   Remove-Item lib/constants/drug_theme.dart
   Remove-Item lib/constants/color_schemes.dart
   Remove-Item lib/constants/app_typography.dart
   Remove-Item lib/constants/feature_flags.dart
   Remove-Item lib/constants/time_period.dart
   Remove-Item lib/constants/reflection_options.dart
   ```

### Optional Cleanup (After Migration)

Consider moving these to `domain/` folder for consistency:
- `lib/constants/drug_use_catalog.dart` → `lib/constants/domain/drug_use_catalog.dart`
- `lib/constants/body_and_mind_catalog.dart` → `lib/constants/domain/body_and_mind_catalog.dart`

---

## 📊 Summary

**Total New Files**: 18 (15 constants + 1 smoke test + 2 docs)  
**Files to Delete**: 15 old duplicate files  
**Files to Keep**: 2 domain data files  
**Imports to Update**: ~200 across codebase

---

**Status**: ✅ READY FOR MIGRATION  
**Next Step**: Follow `CONSTANTS_MIGRATION_GUIDE.md`

# 🎨 Theme System Quick Reference

## 🚀 Getting Started

### Import the theme
```dart
import '../styles/app_theme.dart';
import '../providers/settings_provider.dart';
```

### Get theme in widget
```dart
final theme = AppTheme.fromSettings(
  context.watch<SettingsProvider>().settings
);
```

---

## 📦 Common Patterns

### 1. Basic Card
```dart
Container(
  padding: EdgeInsets.all(theme.spacing.lg),
  decoration: theme.cardDecoration(),
  child: Text('Hello', style: theme.typography.heading2),
)
```

### 2. Gradient Card (Hero)
```dart
Container(
  padding: EdgeInsets.all(theme.spacing.xl),
  decoration: theme.gradientCardDecoration(useAccentGradient: true),
  child: Text(
    'Hero Title',
    style: theme.typography.heading2.copyWith(
      color: theme.colors.textInverse,
    ),
  ),
)
```

### 3. Neon Border Card (Dark Theme)
```dart
Container(
  padding: EdgeInsets.all(theme.spacing.lg),
  decoration: theme.cardDecoration(neonBorder: true),
  child: YourContent(),
)
```

### 4. Icon with Background
```dart
Container(
  padding: EdgeInsets.all(theme.spacing.md),
  decoration: BoxDecoration(
    color: theme.accent.primary.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    boxShadow: theme.isDark ? theme.getNeonGlow() : null,
  ),
  child: Icon(
    Icons.star,
    size: 32,
    color: theme.accent.primary,
  ),
)
```

### 5. Responsive Spacing
```dart
Column(
  children: [
    Widget1(),
    SizedBox(height: theme.spacing.md),  // Auto-adjusts in compact mode
    Widget2(),
    SizedBox(height: theme.spacing.xl),
    Widget3(),
  ],
)
```

---

## 🎨 Color Access

```dart
// Backgrounds
theme.colors.background
theme.colors.surface
theme.colors.surfaceVariant

// Text
theme.colors.textPrimary
theme.colors.textSecondary
theme.colors.textTertiary
theme.colors.textInverse

// Accents
theme.accent.primary
theme.accent.primaryVariant
theme.accent.secondary
theme.accent.gradient  // LinearGradient

// Status
theme.colors.success
theme.colors.warning
theme.colors.error
theme.colors.info
```

---

## 📝 Typography

```dart
// Headings
theme.typography.heading1  // 28px, bold
theme.typography.heading2  // 24px, bold
theme.typography.heading3  // 20px, semibold
theme.typography.heading4  // 18px, semibold

// Body
theme.typography.bodyLarge
theme.typography.body
theme.typography.bodyBold
theme.typography.bodySmall

// Utility
theme.typography.caption
theme.typography.captionBold
theme.typography.overline

// Buttons
theme.typography.button
theme.typography.buttonSmall
```

---

## 📏 Spacing

```dart
theme.spacing.xs      // 4px (3px compact)
theme.spacing.sm      // 8px (6px compact)
theme.spacing.md      // 12px (9px compact)
theme.spacing.lg      // 16px (12px compact)
theme.spacing.xl      // 24px (18px compact)
theme.spacing.xl2     // 32px (24px compact)
theme.spacing.xl3     // 48px (36px compact)

theme.spacing.cardPadding  // 16px (12px compact)
theme.spacing.cardMargin   // 12px (8px compact)
```

---

## 🎭 Shadows

```dart
// Card shadows
theme.cardShadow
theme.cardShadowHovered

// Button shadow
theme.buttonShadow

// Neon effects (dark mode only)
theme.getNeonGlow(intensity: 0.4)
theme.getNeonGlowIntense(intensity: 0.6)
```

---

## ⏱️ Animations

```dart
AnimatedContainer(
  duration: AppThemeConstants.animationFast,     // 150ms
  // or animationNormal (300ms)
  // or animationSlow (500ms)
  curve: AppThemeConstants.animationCurve,       // easeInOut
  // or animationCurveEmphasized (easeOutCubic)
  ...
)
```

---

## 🔘 Buttons

### Primary
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: theme.accent.primary,
    foregroundColor: theme.colors.textInverse,
    padding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: theme.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Button', style: theme.typography.button),
)
```

### Outlined
```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: theme.accent.primary,
    side: BorderSide(color: theme.accent.primary),
    padding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: theme.spacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Button', style: theme.typography.button),
)
```

---

## 🎨 Conditional Styling (Light vs Dark)

```dart
Container(
  color: theme.isDark 
    ? theme.colors.surface 
    : theme.colors.background,
  child: Text(
    'Text',
    style: theme.typography.body.copyWith(
      color: theme.isDark 
        ? theme.colors.textPrimary 
        : theme.colors.textSecondary,
    ),
  ),
)
```

---

## 🔄 Theme-Aware Gradients

```dart
Container(
  decoration: BoxDecoration(
    gradient: theme.accent.gradient,  // Uses selected accent color
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## 📱 Responsive Layout

```dart
// Card margins that adapt to screen
Container(
  margin: EdgeInsets.symmetric(
    horizontal: theme.spacing.lg,
    vertical: theme.spacing.md,
  ),
)

// Grid with responsive spacing
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: theme.spacing.md,
    mainAxisSpacing: theme.spacing.md,
  ),
)
```

---

## 🎯 Best Practices

### ✅ DO
- Always use `theme.spacing.*` instead of hardcoded numbers
- Use `theme.typography.*` for all text
- Use `theme.colors.*` for all colors
- Apply `theme.cardDecoration()` for consistent cards
- Check `theme.isDark` for conditional styling

### ❌ DON'T
- Don't use hardcoded `Color(0xFF...)` values
- Don't use magic numbers like `16.0`
- Don't create custom shadows (use theme shadows)
- Don't forget to watch SettingsProvider

---

## 📊 File Sizes

All theme files are optimized:
- `app_theme_constants.dart`: 171 lines
- `color_schemes.dart`: 192 lines
- `app_typography.dart`: 163 lines
- `app_theme.dart`: 248 lines

**Total**: 774 lines of reusable theme code!

---

## 🔗 See Also

- `HOME_PAGE_THEME_ARCHITECTURE.md` - Full system documentation
- `HOME_PAGE_REDESIGN_SUMMARY.md` - Implementation details
- `lib/widgets/home/theme_example_widget.dart` - Working examples

## Theme Rules (Design System)

This document defines mandatory rules for using the centralized theme in the Flutter app. All UI styling must flow through the theme system to ensure maintainability, consistency, accessibility, and readability.

Repository location for tokens: `lib/constants/theme/`

### Key Principles

- **No hardcoding** — never hardcode colors, fonts, sizes, spacing, radii, or shadows.
- **Single source of truth** — access all theme values via the `BuildContext` extension only.
- **Consistency over convenience** — small shorthands are allowed, but only in an approved form.
- **Accessibility & responsiveness** — tokens already consider scaling and contrast; do not bypass them.

### Approved Import

Widgets must only import the theme extension:

```dart
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
```

Direct imports of other theme files from widgets are forbidden.

### Theme Access Patterns

1) Canonical Short Prelude (allowed when multiple tokens are used)

Declare the prelude once at the top of `build()`:

```dart
@override
Widget build(BuildContext context) {
  final th = context.theme;   // AppTheme (use sparingly)
  final c  = context.colors;  // ColorPalette
  final ac = context.accent;  // AccentColors
  final tx = context.text;    // TextStyles
  final sp = context.spacing; // Spacing
  final sh = context.shapes;  // AppShapes

  // optional, only when needed
  final an = context.animations;
  final sz = context.sizes;
  final op = context.opacities;
  final bd = context.borders;
  final sf = context.surfaces;

  return Container(
    padding: EdgeInsets.all(sp.md),
    decoration: BoxDecoration(
      color: c.surface,
      borderRadius: BorderRadius.circular(sh.radiusMd),
    ),
    child: Text('Hello', style: tx.body),
  );
}
```

Rules for the prelude:
- Must be declared once at the top of `build()`.
- Must use the exact identifiers above (`th`, `c`, `ac`, `tx`, `sp`, `sh`).
- Do not mix the prelude with scattered inline and long-form theme access in the same widget.

2) Inline Access (allowed for very small widgets)

If a widget uses only one or two tokens, inline access is acceptable:

```dart
padding: EdgeInsets.all(context.spacing.md),
color: context.colors.surface,
```

Do not mix inline access with a partial prelude.

### Forbidden Patterns

- Abbreviations not in the approved set (e.g., `final t = context.text`) are forbidden.
- Multiple or repeated preludes in the same widget are forbidden.
- Adding shortcut getters to the theme extension is forbidden.

Examples of bad patterns to avoid:

```dart
// ❌ ambiguous
final t = context.text;

// ❌ repeated
final c = context.colors;
...
final c = context.colors;

// ❌ adding convenience getters to theme layer
TextStyles get tx => theme.text; // forbidden
```

Shorthand belongs only at usage sites, never in the theme layer.

### Token-Specific Rules

- **Colors**: use `context.colors` (or `c` from the prelude). Never use `Colors.*` or raw hex values.
  - Example: `color: c.primary`

- **Typography**: use `context.text` (or `tx`). Never construct `TextStyle` manually when a token exists.
  - Example: `style: tx.bodyMedium`

- **Spacing**: use `context.spacing` (or `sp`). Never use literal numbers for padding/sized boxes.
  - Example: `padding: EdgeInsets.all(sp.lg)`

- **Sizes & layout**: use `context.sizes` or `AppLayout` tokens. Never hardcode icon sizes or common layout constants.

- **Animations, borders, shadows, surfaces**: use theme-provided tokens only (e.g., `context.animations`, `context.cardShadow`).

### Migration & Compliance

Mark a file **Theme: COMPLETE** only if:

- There are no hardcoded values for theme-related properties.
- Theme access follows the approved patterns above.

If violations exist, mark **Theme: LEGACY** and add a short plan to migrate.

When a required token is missing, extend the theme instead of bypassing it.

### Examples

Good:

```dart
final c  = context.colors;
final tx = context.text;
final sp = context.spacing;

Container(
  color: c.surface,
  padding: EdgeInsets.all(sp.md),
  child: Text('Hello', style: tx.bodyLarge),
);
```

Bad:

```dart
Container(
  color: Colors.white,
  padding: EdgeInsets.all(16),
  child: Text('Hello', style: TextStyle(fontSize: 16)),
);
```

### Enforcement

- Theme violations are code review blockers.
- Shorthand violations are treated as architectural violations.
- CI and linting may automatically enforce these rules.

### Quick Checklist (for reviewers)

- [ ] Is there any hardcoded color, size, spacing, or radius?
- [ ] Is the theme imported only via `app_theme_extension.dart`?
- [ ] Is the canonical prelude used (if many tokens are required)?
- [ ] Are typography tokens used instead of manual `TextStyle`?

If anything is missing, extend theme tokens under `lib/constants/theme/` and refactor widgets to use them.

---

If you want, I can run a quick scan to surface remaining violations and automatically fix another batch.
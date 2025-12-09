# COPILOT — MIGRATE ALL FILES IN /widgets/

You must refactor **every file inside /widgets/** according to the following rules.
Apply these rules *file by file* when I open/edit a widget.

────────────────────────────────────────
1. FILE HEADER RULE
────────────────────────────────────────

For every widget file, automatically insert/update this header:

// MIGRATION
// Theme: <COMPLETE|PARTIAL|TODO>
// Common: <COMPLETE|PARTIAL|TODO>
// Riverpod: <COMPLETE|PARTIAL|TODO>
// Notes: <summary of what you changed>

Do **not** rewrite sections already marked COMPLETE.

────────────────────────────────────────
2. THEME MIGRATION RULES
────────────────────────────────────────

For each file:
- Replace any hardcoded colors → context.colors
- Replace old theme usage → context.theme, context.colors, context.text, context.spacing
- Replace any border radius → AppTheme shapes or spacing
- Replace any padding → t.spacing.*
- Replace TextStyle(...) → t.typography.*
- Remove deprecated imports from constants/deprecated/*
- Remove Colors.*, Color(0xFF…), UIColors.*, ThemeConstants.*

When unsure: ALWAYS prefer theme extension usage.

────────────────────────────────────────
3. COMMON COMPONENT EXTRACTION
────────────────────────────────────────

If a file contains repeated patterns like:
- chip groups
- icon/title/subtitle rows
- buttons
- cards
- toggles
- bottom sheets

Ask yourself:
“Should this be extracted into /common/... ?”

If yes → extract into:
widgets/common/<category>/<name>.dart

Then replace inline code with the extracted widget.

────────────────────────────────────────
4. RIVERPOD MIGRATION RULES
────────────────────────────────────────

For state:
- Convert StatefulWidget → ConsumerStatefulWidget or ConsumerWidget
- Replace setState() with Riverpod providers
- Move logic out of widgets into providers
- Never put business logic inside widgets again

If widget has no internal state → prefer ConsumerWidget.

────────────────────────────────────────
5. CLEANUP RULES (EVERY FILE)
────────────────────────────────────────

- Remove unused imports
- Sort imports: flutter → package → local
- Convert magic numbers to spacing/tokens
- Make UI responsive (use LayoutBuilder, flexible sizes)
- Use const constructors wherever possible
- Follow your app's design: neon-dark + wellness-light

────────────────────────────────────────
6. JSON/DATA FILE RULES
────────────────────────────────────────

If I open a JSON in data folders:
- Validate and normalize structure
- Remove duplicates
- Alphabetize keys
- Add header:
// JSON VERIFIED — MIGRATED
────────────────────────────────────────

# IMPORTANT:
You MUST follow these rules **every time I open or edit a file inside /widgets/**. 
Do not ask, just apply them.

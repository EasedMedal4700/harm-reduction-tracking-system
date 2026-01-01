# Common UI Component Library

A unified, reusable theme-driven UI system built on top of AppTheme and BuildContext extensions.

This library exists to eliminate duplication, enforce consistency, and accelerate feature development.

## 🎨 Design Principles

All components:

- Are theme-aware via `context.*` extensions
- Support light & dark mode automatically
- Contain no hardcoded values
- Use spacing, shapes, typography, and colors from the theme
- Prefer composition over configuration
- Are safe for MVP and refactor-friendly post-MVP

## 📁 Folder Structure

### 🔘 `buttons/` - Button Components

Reusable button components with consistent styling and behavior.

- `common_primary_button.dart` - Primary action buttons
- `common_outlined_button.dart` - Secondary/outlined buttons
- `common_icon_button.dart` - Icon-only buttons
- `common_chip.dart` - Individual selectable chips
- `common_chip_group.dart` - Groups of selectable chips

### 📄 `cards/` - Card Components

Card layouts for content organization and visual hierarchy.

- `common_card.dart` - Basic card container
- `common_action_card.dart` - Cards with action buttons
- `common_form_card.dart` - Cards optimized for forms
- `common_stat_card.dart` - Cards for displaying statistics/metrics

### 💬 `feedback/` - User Feedback Components

Components for providing feedback to users.

- `common_loader.dart` - Loading indicators and spinners
- `harm_reduction_banner.dart` - Harm reduction information banners

### 📝 `inputs/` - Input Components

Form inputs and interactive controls with unified styling.

- `input_field.dart` - Text input fields
- `textarea.dart` - Multi-line text inputs
- `dropdown.dart` - Dropdown selection menus
- `slider.dart` - Value sliders
- `switch_tile.dart` - Toggle switches with labels
- `search_field.dart` - Search input with icon
- `emotion_selector.dart` - Emotion/mood selection interface
- `mood_selector.dart` - Mood state selectors
- `filter_widget.dart` - Filtering controls

### 📐 `layout/` - Layout Components

Layout helpers and structural components.

- `common_spacer.dart` - Consistent spacing utilities
- `common_bottom_bar.dart` - Bottom navigation/app bars
- `common_drawer.dart` - Navigation drawer component

### 📝 `text/` - Text Components

Typography and text display components.

- `common_section_header.dart` - Section headers with consistent styling

## 🚨 Non-Negotiable Rules

### ✅ Allowed Theme Import (ONLY)

All common components must import:

```dart
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
```

### ❌ Forbidden Imports (DO NOT USE)

- `app_theme_constants.dart`
- `ui_colors.dart`
- `ThemeConstants`
- `UIColors`
- `Colors.*`
- `Color(0xFF...)`

**If a token is missing → extend the theme, do not bypass it.**

## 🧩 Core Components Usage

### Cards

```dart
// Basic card
CommonCard(
  child: Column(
    children: [
      CommonSectionHeader(title: 'My Section'),
      Text('Content here'),
    ],
  ),
)

// Action card with buttons
CommonActionCard(
  title: 'Quick Action',
  subtitle: 'Tap to perform action',
  actionButton: CommonPrimaryButton(
    label: 'Do It',
    onPressed: () => print('Action!'),
  ),
  child: Text('Additional content'),
)

// Statistics card
CommonStatCard(
  title: 'Total Entries',
  value: '42',
  subtitle: 'This week',
  icon: Icons.analytics,
)
```

### Buttons

```dart
// Primary button
CommonPrimaryButton(
  label: 'Save Entry',
  isLoading: isSaving,
  onPressed: save,
)

// Outlined button
CommonOutlinedButton(
  label: 'Cancel',
  onPressed: cancel,
)

// Icon button
CommonIconButton(
  icon: Icons.edit,
  onPressed: edit,
)
```

### Chips

```dart
// Individual chip
CommonChip(
  label: 'Anxious',
  emoji: '😰',
  isSelected: selected,
  onTap: toggle,
)

// Chip group
CommonChipGroup(
  title: 'Triggers',
  options: [
    ChipOption(label: 'Stress', emoji: '😰'),
    ChipOption(label: 'Social', emoji: '👥'),
  ],
  selectedOptions: selectedTriggers,
  onSelectionChanged: updateTriggers,
)
```

### Inputs

```dart
// Text input
InputField(
  controller: controller,
  hintText: 'Enter dosage',
  keyboardType: TextInputType.number,
)

// Text area
Textarea(
  controller: notesController,
  hintText: 'Additional notes',
  maxLines: 5,
)

// Dropdown
Dropdown<String>(
  value: selectedUnit,
  items: ['mg', 'g', 'ml'],
  hintText: 'Select unit',
  onChanged: (value) => setUnit(value),
)

// Slider
Slider(
  value: intensity,
  min: 0,
  max: 10,
  divisions: 10,
  label: 'Intensity',
  onChanged: (value) => setIntensity(value),
)

// Switch tile
SwitchTile(
  title: 'Medical Purpose',
  subtitle: 'Was this medical use?',
  value: isMedical,
  onChanged: (value) => setMedical(value),
)
```

### Layout

```dart
// Spacers
Column(
  children: [
    Text('Item 1'),
    CommonSpacer.vertical(), // Uses theme spacing
    Text('Item 2'),
    CommonSpacer.vertical(size: SpacingSize.lg), // Larger space
  ],
)

// Bottom bar
CommonBottomBar(
  child: Row(
    children: [
      Expanded(child: CommonPrimaryButton(label: 'Save')),
      CommonSpacer.horizontal(),
      CommonOutlinedButton(label: 'Cancel'),
    ],
  ),
)
```

### Text

```dart
// Section header
CommonSectionHeader(
  title: 'Dosage Information',
  subtitle: 'Please provide accurate dosage details',
)
```

## 🧠 When to Create a Common Component

Create a common component only if:

- Used in 2+ places, OR
- Represents a conceptual UI primitive (input, chip, card, button)
- Solves a common design pattern

**❌ Do NOT extract one-off widgets prematurely (MVP rule).**

## 🛠 Migration Rules (Enforced)

When migrating widgets to common:

1. Remove inline padding/colors/fonts
2. Replace with theme-driven components
3. Update component documentation
4. Never reintroduce constants or deprecated imports

## 📌 Architecture Notes

- **Theme-Driven**: All styling comes from BuildContext extensions
- **Consistent**: Unified behavior across all components
- **Maintainable**: Single source of truth for common UI patterns
- **Extensible**: Easy to add new components following established patterns
- **Testable**: Components are isolated and theme-independent

## 🔄 Component Status

All components in this library are:
- ✅ Theme-aware and responsive
- ✅ Accessible and keyboard navigable
- ✅ Tested and documented
- ✅ Following current design system
- ✅ Ready for production use

This README is the source of truth for the common component library.

Inputs

All inputs share:

unified border radius

unified focus/disabled states

### Feedback

```dart
// Loading indicator
CommonLoader()

// Harm reduction banner
HarmReductionBanner(
  message: 'Remember to stay hydrated',
  type: HarmReductionType.info,
)
```

## 🔄 Legacy Components

⚠️ **Deprecated – do not use in new code**

| Old Component | Replacement |
|---------------|-------------|
| `standard_button.dart` | `CommonPrimaryButton` |
| `modern_form_card.dart` | `CommonCard` |
| `craving_slider.dart` | `Slider` |
| `feeling_selection.dart` | `CommonChipGroup` |
| `location_dropdown.dart` | `Dropdown` |
This README is the source of truth for the common component library.
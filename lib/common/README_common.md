Common UI Component Library

A unified, reusable theme-driven UI system built on top of AppTheme and BuildContext extensions.

This library exists to eliminate duplication, enforce consistency, and accelerate feature development.

🚨 NON-NEGOTIABLE RULES
✅ Allowed theme import (ONLY)

All common components must import:

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

❌ Forbidden imports (DO NOT USE)
app_theme_constants.dart
ui_colors.dart
ThemeConstants
UIColors
Colors.*
Color(0xFF...)


If a token is missing → extend the theme, do not bypass it.

Folder Structure
common/
├── buttons/
│   ├── common_chip.dart
│   ├── common_chip_group.dart
│   ├── common_icon_button.dart
│   └── common_primary_button.dart
├── cards/
│   └── common_card.dart
├── inputs/
│   ├── common_dropdown.dart
│   ├── common_input_field.dart
│   ├── common_search_field.dart
│   ├── common_slider.dart
│   ├── common_switch_tile.dart
│   └── common_textarea.dart
├── layout/
│   ├── common_bottom_bar.dart
│   └── common_spacer.dart
├── text/
│   └── common_section_header.dart
├── wrappers/
│   └── (layout wrappers if needed)
└── old_common/          # ⚠ deprecated — do not use in new code

🎨 Design Principles

All components:

Are theme-aware via context.*

Support light & dark mode automatically

Contain no hardcoded values

Use spacing, shapes, typography, and colors from the theme

Prefer composition over configuration

Are safe for MVP and refactor-friendly post-MVP

🧩 Core Components
CommonCard
CommonCard(
  child: Column(
    children: [
      CommonSectionHeader(title: 'My Section'),
      ...
    ],
  ),
)


Uses:

context.colors.surface

context.spacing.cardPadding

context.shapes.radiusLg

context.cardShadow

CommonSectionHeader
CommonSectionHeader(
  title: 'Dosage',
  subtitle: 'How much did you take?',
)


Typography comes from:

context.text.titleLarge

context.text.bodySmall

Inputs

All inputs share:

unified border radius

unified focus/disabled states

unified error handling

CommonInputField
CommonInputField(
  controller: controller,
  hintText: 'Enter dosage',
)

CommonTextarea
CommonTextarea(
  controller: notesController,
  maxLines: 5,
)

CommonDropdown
CommonDropdown<String>(
  value: unit,
  items: ['mg', 'g', 'ml'],
  onChanged: setUnit,
)

CommonSlider
CommonSlider(
  value: intensity,
  min: 0,
  max: 10,
)

CommonSwitchTile
CommonSwitchTile(
  title: 'Medical Purpose',
  subtitle: 'Was this medical use?',
  value: isMedical,
  onChanged: setMedical,
)

🔘 Buttons
CommonPrimaryButton
CommonPrimaryButton(
  label: 'Save Entry',
  isLoading: isSaving,
  onPressed: save,
)


Uses:

context.accent.primary

context.text.button

context.spacing.md

CommonIconButton
CommonIconButton(
  icon: Icons.edit,
  onPressed: edit,
)

🏷 Chips
CommonChip
CommonChip(
  label: 'Anxious',
  emoji: '😰',
  isSelected: selected,
  onTap: toggle,
)

CommonChipGroup
CommonChipGroup(
  title: 'Triggers',
  options: triggers,
  selectedOptions: selected,
  onSelectionChanged: update,
)

📐 Layout
CommonSpacer
const CommonSpacer.vertical()
const CommonSpacer.horizontal()


Defaults resolve to theme spacing tokens internally.

CommonBottomBar
CommonBottomBar(
  child: CommonPrimaryButton(...),
)

🔄 Legacy Components (old_common)

⚠️ Deprecated – do not use

Old	Replacement
standard_button.dart	CommonPrimaryButton
modern_form_card.dart	CommonCard
craving_slider.dart	CommonSlider
feeling_selection.dart	CommonChipGroup
location_dropdown.dart	CommonDropdown
🧠 When to Create a Common Component

Create a common component only if:

used in 2+ places, OR

represents a conceptual UI primitive (input, chip, card)

❌ Do NOT extract one-off widgets prematurely (MVP rule).

🛠 Migration Rules (Enforced)

When migrating widgets to common:

Remove inline padding/colors/fonts

Replace with theme-driven components

Update MIGRATION header

Never reintroduce constants or deprecated imports

📌 Summary

Common is your UI contract.
Theme lives in context.
Constants are infrastructure — not API.

This README is the source of truth.
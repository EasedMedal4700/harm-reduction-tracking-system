# Common UI Component Library

A unified, reusable design system based on the Log Entry screen's UI patterns. This library provides consistent, theme-aware components for building beautiful, maintainable Flutter interfaces.

# Common UI Component Library

A unified, reusable design system based on the Log Entry screen's UI patterns. This library provides consistent, theme-aware components for building beautiful, maintainable Flutter interfaces.

```
common/
├── app_theme_.dart                 # Main theme data class
├── animations/                     # Animation utilities (empty)
├── buttons/
│   ├── common_chip.dart            # Selectable chip/tag
│   ├── common_chip_group.dart      # Group of selectable chips
│   ├── common_icon_button.dart     # Icon-only button
│   └── common_primary_button.dart  # Primary action button
├── cards/
│   └── common_card.dart            # Reusable card container
├── inputs/
│   ├── common_dropdown.dart        # Dropdown selector
│   ├── common_input_field.dart     # Single-line text input
│   ├── common_search_field.dart    # Autocomplete search field
│   ├── common_slider.dart          # Numeric slider input
│   ├── common_switch_tile.dart     # Switch with title and subtitle
│   └── common_textarea.dart        # Multi-line text input
├── layout/
│   ├── common_bottom_bar.dart      # Sticky bottom action bar
│   └── common_spacer.dart          # Consistent spacing
├── modals/                         # Modal dialogs (empty)
├── old_common/                     # Legacy components (deprecated)
│   ├── category_filter.dart
│   ├── craving_slider.dart
│   ├── drawer_menu.dart
│   ├── feeling_selection.dart
│   ├── filter.dart
│   ├── harm_reduction_banner.dart
│   ├── location_dropdown.dart
│   ├── modern_form_card.dart
│   ├── standard_button.dart
│   └── ...
├── text/
│   └── common_section_header.dart  # Section headers with title/subtitle
└── wrappers/                       # Layout wrappers (empty)
```

## 🎨 Design Principles

All components follow these core principles from the Log Entry screen:

- **Consistent Padding**: 16-24px padding for cards
- **Soft Shadows**: Light elevation for depth
- **Clean Backgrounds**: White cards in light mode, glassmorphic in dark mode
- **Rounded Corners**: 12-20px border radius
- **Theme Awareness**: Automatic light/dark mode support
- **No Hardcoded Colors**: All colors from `constants/deprecated/ui_colors.dart`

## 🧩 Components

### Cards

#### CommonCard
Reusable card container with consistent styling.

```dart
CommonCard(
  child: Column(
    children: [
      CommonSectionHeader(title: 'My Section'),
      // Your content here
    ],
  ),
)
```

**Properties:**
- `child` (Widget): Card content
- `padding` (EdgeInsetsGeometry?): Custom padding
- `backgroundColor` (Color?): Override background color
- `borderRadius` (double?): Custom border radius
- `showBorder` (bool): Show/hide border (default: true)

### Text

#### CommonSectionHeader
Section header with title and optional subtitle.

```dart
CommonSectionHeader(
  title: 'Substance',
  subtitle: 'Select the substance you used',
)
```

**Properties:**
- `title` (String): Main title
- `subtitle` (String?): Optional description
- `titleFontSize` (double?): Custom title size
- `titleFontWeight` (FontWeight?): Custom title weight

### Inputs

#### CommonInputField
Single-line text input with validation support.

```dart
CommonInputField(
  controller: _controller,
  hintText: 'Enter dosage',
  keyboardType: TextInputType.number,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

**Properties:**
- `controller` (TextEditingController?): Text controller
- `hintText` (String?): Placeholder text
- `keyboardType` (TextInputType?): Keyboard type
- `validator` (FormFieldValidator?): Validation function
- `prefixIcon` (Widget?): Leading icon
- `suffixIcon` (Widget?): Trailing icon

#### CommonTextarea
Multi-line text input for longer content.

```dart
CommonTextarea(
  controller: _notesController,
  hintText: 'Add notes...',
  maxLines: 5,
  minLines: 3,
)
```

**Properties:**
- `maxLines` (int): Maximum lines (default: 5)
- `minLines` (int?): Minimum lines
- `maxLength` (int?): Character limit

#### CommonDropdown
Dropdown selector with type safety.

```dart
CommonDropdown<String>(
  value: selectedUnit,
  items: ['mg', 'g', 'ml'],
  onChanged: (value) => setState(() => selectedUnit = value!),
)
```

**Properties:**
- `value` (T): Current selection
- `items` (List<T>): Available options
- `onChanged` (ValueChanged<T?>): Selection callback
- `itemLabel` (String Function(T)?): Custom label builder

#### CommonSlider
Numeric slider for ranges (e.g., craving intensity).

```dart
CommonSlider(
  value: cravingIntensity,
  min: 0,
  max: 10,
  divisions: 10,
  onChanged: (value) => setState(() => cravingIntensity = value),
)
```

**Properties:**
- `value` (double): Current value
- `min` (double): Minimum value (default: 0)
- `max` (double): Maximum value (default: 10)
- `divisions` (int?): Number of discrete divisions
- `showValueLabel` (bool): Show value indicator (default: true)

#### CommonSwitchTile
Switch control with title, subtitle, and consistent styling.

```dart
CommonSwitchTile(
  title: 'Medical Purpose',
  subtitle: 'Was this use for medical reasons?',
  value: isMedicalPurpose,
  onChanged: (value) => setState(() => isMedicalPurpose = value),
)
```

**Properties:**
- `title` (String): Main title
- `subtitle` (String?): Optional description
- `value` (bool): Switch state
- `onChanged` (ValueChanged<bool>?): State change callback
- `enabled` (bool): Enable/disable switch (default: true)

### Buttons

#### CommonPrimaryButton
Primary action button (Save, Submit, etc.).

```dart
CommonPrimaryButton(
  label: 'Save Entry',
  onPressed: () => saveEntry(),
  icon: Icons.check,
  isLoading: isSaving,
)
```

**Properties:**
- `label` (String): Button text
- `onPressed` (VoidCallback): Tap callback
- `isLoading` (bool): Show loading spinner (default: false)
- `isEnabled` (bool): Enable/disable (default: true)
- `icon` (IconData?): Optional leading icon

#### CommonChip
Selectable chip/tag for emotions, triggers, signals.

```dart
CommonChip(
  label: 'Anxious',
  isSelected: selectedEmotions.contains('Anxious'),
  onTap: () => toggleEmotion('Anxious'),
  emoji: '😰',
  showGlow: true,
)
```

**Properties:**
- `label` (String): Chip text
- `isSelected` (bool): Selection state
- `onTap` (VoidCallback): Tap callback
- `emoji` (String?): Optional emoji prefix
- `icon` (IconData?): Optional icon prefix
- `showGlow` (bool): Show neon glow when selected (default: false)

#### CommonChipGroup
Group of selectable chips with consistent layout and selection management.

```dart
CommonChipGroup(
  title: 'Select Emotions',
  options: ['Happy', 'Sad', 'Anxious', 'Calm'],
  selectedOptions: selectedEmotions,
  onSelectionChanged: (selected) => setState(() => selectedEmotions = selected),
  emojis: const ['😊', '😢', '😰', '😌'],
)
```

**Properties:**
- `title` (String?): Optional group title
- `options` (List<String>): Available options
- `selectedOptions` (List<String>): Currently selected options
- `onSelectionChanged` (ValueChanged<List<String>>): Selection callback
- `emojis` (List<String>?): Optional emoji for each option
- `maxSelection` (int?): Maximum selectable items

#### CommonIconButton
Icon-only button for actions like edit, delete.

```dart
CommonIconButton(
  icon: Icons.edit,
  onPressed: () => editEntry(),
  tooltip: 'Edit',
)
```

**Properties:**
- `icon` (IconData): Icon to display
- `onPressed` (VoidCallback): Tap callback
- `tooltip` (String?): Accessibility tooltip
- `size` (double?): Icon size (default: 24)

### Layout

#### CommonSpacer
Consistent spacing between elements.

```dart
// Vertical spacing
const CommonSpacer.vertical(24)

// Horizontal spacing
const CommonSpacer.horizontal(16)

// Custom
CommonSpacer(height: 20, width: 10)
```

#### CommonBottomBar
Sticky bottom bar for action buttons with consistent styling.

```dart
CommonBottomBar(
  child: CommonPrimaryButton(
    label: 'Save Entry',
    onPressed: () => saveEntry(),
    icon: Icons.check,
  ),
)
```

**Properties:**
- `child` (Widget): Content to display in the bar
- `padding` (EdgeInsetsGeometry?): Custom padding
- `backgroundColor` (Color?): Override background color
- `showShadow` (bool): Show/hide shadow (default: true)

## 📖 Usage Examples

### Complete Form Card

```dart
CommonCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommonSectionHeader(
        title: 'Dosage',
        subtitle: 'How much did you take?',
      ),
      const CommonSpacer.vertical(12),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: CommonInputField(
              controller: doseController,
              hintText: '0.0',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const CommonSpacer.horizontal(12),
          Expanded(
            child: CommonDropdown<String>(
              value: unit,
              items: const ['mg', 'g', 'ml'],
              onChanged: (value) => setUnit(value!),
            ),
          ),
        ],
      ),
    ],
  ),
)
```

### Chip Selection Grid

```dart
CommonCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommonSectionHeader(
        title: 'How are you feeling?',
      ),
      const CommonSpacer.vertical(12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: emotions.map((emotion) {
          return CommonChip(
            label: emotion.name,
            emoji: emotion.emoji,
            isSelected: selectedEmotions.contains(emotion.name),
            onTap: () => toggleEmotion(emotion.name),
            showGlow: true,
          );
        }).toList(),
      ),
    ],
  ),
)
```

### Chip Group Selection

```dart
CommonCard(
  child: CommonChipGroup(
    title: 'Select Triggers',
    options: ['Stress', 'Social', 'Boredom', 'Curiosity'],
    selectedOptions: selectedTriggers,
    onSelectionChanged: (selected) => setState(() => selectedTriggers = selected),
    maxSelection: 3,
  ),
)
```

### Switch Tile Configuration

```dart
CommonCard(
  child: Column(
    children: [
      CommonSwitchTile(
        title: 'Simple Mode',
        subtitle: 'Show basic fields only',
        value: isSimpleMode,
        onChanged: (value) => setState(() => isSimpleMode = value),
      ),
      const CommonSpacer.vertical(12),
      CommonSwitchTile(
        title: 'Medical Purpose',
        subtitle: 'Was this use for medical reasons?',
        value: isMedicalPurpose,
        onChanged: (value) => setState(() => isMedicalPurpose = value),
      ),
    ],
  ),
)
```

### Form with Save Button

```dart
Column(
  children: [
    Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Your form cards here
          ],
        ),
      ),
    ),
    CommonBottomBar(
      child: CommonPrimaryButton(
        label: 'Save Entry',
        onPressed: () => saveEntry(),
        icon: Icons.check,
        isLoading: isSaving,
      ),
    ),
  ],
)
```

## 🎯 Contribution Guidelines

### Adding New Components

1. **Create the component file** in the appropriate subdirectory
2. **Follow naming convention**: `common_[component_name].dart`
3. **Import constants**: Use `constants/deprecated/ui_colors.dart` and `constants/deprecated/theme_constants.dart`
4. **Support light/dark themes**: Check `Theme.of(context).brightness`
5. **Document properties**: Add clear comments for all parameters
6. **Provide examples**: Update this README with usage examples

### Component Checklist

Before adding a component, ensure:

- ✅ Supports light and dark themes
- ✅ Uses constants from `ui_colors.dart` and `theme_constants.dart`
- ✅ No hardcoded colors or dimensions
- ✅ Follows Log Entry screen styling patterns
- ✅ Includes proper documentation
- ✅ Has clear, descriptive property names
- ✅ Provides sensible default values
- ✅ Works with form validation (if input component)

### Style Requirements

All components must match the Log Entry design:

- **Card padding**: `ThemeConstants.cardPaddingMedium` (20px)
- **Card radius**: `ThemeConstants.cardRadius` (16px)
- **Input radius**: `ThemeConstants.radiusMedium` (18px)
- **Chip radius**: `ThemeConstants.radiusMedium` (18px)
- **Spacing**: Use `ThemeConstants.space*` constants
- **Text sizes**: Use `ThemeConstants.font*` constants
- **Animations**: Use `ThemeConstants.animation*` durations

## 🔧 Maintenance

### Legacy Components (old_common/)

The `old_common/` directory contains legacy components that are being phased out:

- `category_filter.dart` → Use `CommonChipGroup` or `CommonDropdown`
- `craving_slider.dart` → Use `CommonSlider`
- `drawer_menu.dart` → Use app-level drawer implementation
- `feeling_selection.dart` → Use `CommonChipGroup`
- `filter.dart` → Use `CommonChipGroup` or `CommonDropdown`
- `harm_reduction_banner.dart` → Use `CommonCard` with custom content
- `location_dropdown.dart` → Use `CommonDropdown`
- `modern_form_card.dart` → Use `CommonCard`
- `standard_button.dart` → Use `CommonPrimaryButton`

**Migration Priority**: High - Replace usage of old_common components with current common components.

### Updating Styles

When updating component styles:

1. Check if change should apply to ALL components
2. Update constants in `theme_constants.dart` if global
3. Test in both light and dark modes
4. Verify across all screen sizes
5. Update README examples if API changes

### Deprecating Components

To deprecate a component:

1. Add `@deprecated` annotation with replacement guidance
2. Update README with deprecation notice
3. Provide migration path for existing usage
4. Remove after 2-3 minor versions

## 📚 Related Documentation

- [UI Colors Constants](../constants/deprecated/ui_colors.dart)
- [Theme Constants](../constants/deprecated/theme_constants.dart)
- [Log Entry Screen](../screens/log_entry_page.dart) - Original design source

## 🤝 Support

For questions or issues with components:

1. Check this README for usage examples
2. Review the Log Entry screen implementation
3. Ensure you're importing the correct constants
4. Verify theme mode is being checked correctly

---

**Version**: 1.1.0  
**Last Updated**: December 8, 2025  
**Based On**: Log Entry Screen UI (v2.0)
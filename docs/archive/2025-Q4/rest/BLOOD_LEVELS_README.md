# Blood Levels Feature

## Overview
Simple blood levels tracking page that shows active drug substances in your system based on half-life calculations.

## Architecture

### Files Created
1. **`lib/services/blood_levels_service.dart`** (175 lines)
   - `calculateLevels()` - Fetches drug use data and calculates remaining levels
   - `DrugLevel` class - Data model for drug level information
   - `DoseEntry` class - Individual dose entry model
   - Uses simple half-life decay: `remaining = dose * 0.5^(hoursElapsed / halfLife)`

2. **`lib/widgets/blood_levels/level_card.dart`** (130 lines)
   - `LevelCard` widget - Displays individual drug information
   - Shows percentage remaining, last dose, time ago, half-life
   - Color-coded status: HIGH (red >20%), MODERATE (orange >10%), LOW (amber >5%), TRACE (green >1%)

3. **`lib/screens/blood_levels_page.dart`** (158 lines)
   - Main page with drawer menu and refresh button
   - Summary card showing active count, status, average percentage
   - List of active substances sorted by percentage
   - Empty state when no active substances

## Features

### What It Does
- ✅ Fetches drug use data from database (RLS filters by user)
- ✅ Calculates remaining blood levels using half-life decay
- ✅ Filters out substances below 1% remaining
- ✅ Shows summary statistics (active count, risk status, average %)
- ✅ Displays each substance with progress bar and details
- ✅ Color-coded risk levels (HIGH/MODERATE/LOW/TRACE)
- ✅ Pull to refresh

### What It Doesn't Do (Compared to 6000-line Version)
- ❌ No complex charts or graphs
- ❌ No time machine feature
- ❌ No advanced filters
- ❌ No drug profile integration
- ❌ No category-based calculations
- ❌ No metabolism timeline
- ❌ No historical doses sidebar
- ❌ No detailed dose tracking

## Comparison

### Old `blood_levels_screen.dart`
- **6000+ lines** in single file
- Complex UI with charts, timelines, filters
- Advanced pharmacokinetic calculations
- Drug profile integration
- Multiple visualization modes
- Heavy dependencies on drug catalog

### New `blood_levels_page.dart`
- **158 lines** for page + 175 lines service + 130 lines widget = **463 total lines**
- Simple list UI with summary card
- Basic half-life calculations
- Standalone service
- Single view mode
- Minimal dependencies

## Half-Life Database

Built-in half-lives for common substances:
- Methylphenidate: 3.5h
- Amphetamine: 10h
- Cocaine: 1h
- MDMA: 8h
- LSD: 3h
- Cannabis/THC: 24h
- Caffeine: 5h
- Ketamine: 2.5h
- Default: 8h (for unknown substances)

## Usage

```dart
// Navigate to page
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const BloodLevelsPage()),
);
```

The page automatically:
1. Loads drug use data on init
2. Calculates levels using half-life decay
3. Filters to show only >1% remaining
4. Sorts by percentage (highest first)
5. Updates summary statistics

## Future Enhancements (If Needed)

Easy additions without bloating the code:
- Add drug profile integration for accurate half-lives
- Add simple line chart showing decay over time
- Add tap-to-expand for dose history
- Add export/share functionality
- Add notifications when substances clear

## Benefits of Simple Approach

- **Maintainable**: 463 lines vs 6000 lines
- **Fast**: No complex calculations or rendering
- **Reliable**: Fewer moving parts, less to break
- **Testable**: Small focused methods
- **Extensible**: Easy to add features incrementally

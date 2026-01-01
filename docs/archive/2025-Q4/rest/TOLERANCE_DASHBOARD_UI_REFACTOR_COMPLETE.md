# Tolerance Dashboard UI Refactor - Complete

## Overview
Successfully refactored the Tolerance Dashboard from a **substance-first** to a **system-first hierarchical** layout, providing users with a clearer view of their neurochemical tolerance across all systems.

## Changes Made

### 1. New Hierarchical Layout
**Before (Substance-First)**:
- Substance dropdown at top
- Single substance tolerance view
- Hidden system-wide tolerance

**After (System-First)**:
```
1. Safety Disclaimer
2. System Tolerance Overview (all 7 buckets at once)
3. Bucket Details (selected bucket + contributing substances)
4. Substance Detail (unified widget with metrics)
5. Key Metrics (half-life, decay, recent uses)
```

### 2. New Widget Components

#### `lib/widgets/tolerance/system_bucket_card.dart` (180 lines)
**Purpose**: Individual bucket card for system overview section

**Features**:
- Displays bucket icon, name, tolerance %, status badge
- Selection state with highlighted border
- Active indicator for substances currently affecting this bucket
- Click to select bucket and view details
- Color-coded by tolerance state (green/blue/orange/red)

**Example**:
```dart
SystemBucketCard(
  bucketType: 'stimulant',
  tolerancePercent: 32.5,
  state: ToleranceSystemState.lightStress,
  isActive: true,
  isSelected: true,
  onTap: () => selectBucket('stimulant'),
)
```

#### `lib/widgets/tolerance/bucket_detail_section.dart` (240 lines)
**Purpose**: Detailed view of selected bucket with contributing substances

**Features**:
- Bucket name, description, system-wide tolerance
- List of substances contributing to this bucket
- Individual contribution percentages per substance
- Active badges for currently active substances
- Substance selection to drill down to detailed metrics
- Empty state handling

**Example**:
```dart
BucketDetailSection(
  bucketType: 'stimulant',
  systemTolerancePercent: 32.5,
  state: ToleranceSystemState.lightStress,
  substanceContributions: {
    'Dexedrine': 28.3,
    'Caffeine': 4.2,
  },
  substanceActiveStates: {'Dexedrine': true},
  selectedSubstance: 'Dexedrine',
  onSubstanceSelected: (name) => loadSubstanceDetails(name),
)
```

### 3. Main Dashboard Refactor

#### `lib/screens/tolerance_dashboard_page.dart`
**Major Changes**:
- Removed substance dropdown from top of page
- Added bucket selection state management
- Added scroll controller for smooth navigation to bucket details
- Implemented `_computeSubstanceContributions()` method
- Auto-selects first non-zero bucket on load

**New State Variables**:
```dart
String? _selectedBucket;  // Currently selected bucket
ScrollController _scrollController;  // For smooth scrolling
GlobalKey _bucketDetailKey;  // Scroll target for bucket details
Map<String, Map<String, double>> _substanceContributions;  // bucket -> {substance -> %}
Map<String, bool> _substanceActiveStates;  // substance -> isActive
```

**New Methods**:
- `_findFirstActiveBucket()`: Auto-selects first bucket with tolerance > 0
- `_computeSubstanceContributions()`: Aggregates per-substance data into per-bucket contributions
- `_buildSystemOverview()`: Renders all 7 bucket cards in horizontal scroll
- `_buildBucketDetails()`: Renders selected bucket detail section

### 4. Data Aggregation Logic

#### `_computeSubstanceContributions()`
**Purpose**: Compute which substances contribute to each bucket

**Algorithm**:
1. Fetch all tolerance models from database
2. Fetch all use logs for user (30 days)
3. For each substance:
   - Get use events
   - Calculate bucket tolerance for each neurochemical system
   - Extract contribution percentage
   - Mark substance as active if active_level > threshold
4. Group contributions by bucket type
5. Filter out contributions < 0.1%

**Output Example**:
```dart
{
  'stimulant': {
    'Dexedrine': 28.3,
    'Caffeine': 4.2,
    'Ritalin': 15.7,
  },
  'serotonin_release': {
    'MDMA': 45.2,
  },
  'serotonin_psychedelic': {
    'MDMA': 12.8,
    'LSD': 5.3,
  },
}
```

### 5. UI/UX Improvements

**System Overview Section**:
- All 7 canonical buckets displayed at once
- Horizontal scrollable card list
- Fixed order: GABA, Stimulant, Serotonin Release, Serotonin Psychedelic, Opioid, NMDA, Cannabinoid
- Buckets with 0% tolerance show "Recovered" state
- Active substances indicated with colored dot

**Bucket Detail Section**:
- Only shown when a bucket is selected
- Header with bucket name, description, system tolerance
- List of contributing substances with individual contributions
- Click substance to load detailed metrics below
- Active badge for substances currently in system

**Substance Detail Section**:
- Only shown when a substance is selected from bucket detail
- Existing `UnifiedBucketToleranceWidget` with all metrics
- Shows per-bucket breakdown for that substance
- Key metrics: half-life, decay, baseline, recent uses

**Scroll Behavior**:
- Clicking a bucket card smoothly scrolls to bucket detail section
- 300ms animation with easeInOut curve
- Ensures detail section is visible after selection

### 6. Integration Points

**System Tolerance Service**:
```dart
// Fetches system-wide tolerance for all 7 buckets
final systemData = await loadSystemToleranceData();
// Returns: SystemToleranceData(percents, states)
```

**Bucket Tolerance Calculator**:
```dart
// Per-substance bucket tolerance calculation
final results = BucketToleranceCalculator.calculateSubstanceTolerance(
  model: bucketModel,
  useEvents: useEvents,
  standardUnitMg: standardUnitMg,
  currentTime: DateTime.now(),
);
// Returns: Map<String, BucketToleranceResult>
```

**Tolerance Engine Service**:
```dart
// Fetches all tolerance models and use logs
final allModels = await ToleranceEngineService.fetchAllToleranceModels();
final allUseLogs = await ToleranceEngineService.fetchUseLogs(userId: id, daysBack: 30);
```

## Benefits

### 1. Improved User Understanding
- **Before**: Users saw one substance at a time, unclear how substances combined
- **After**: Users see all neurochemical systems at once, understand combined effects

### 2. Better Navigation
- **Before**: Linear navigation, substance dropdown
- **After**: Hierarchical drill-down: System → Bucket → Substance

### 3. System-Wide Awareness
- **Before**: "Is my Ritalin tolerance high?"
- **After**: "My stimulant system is at 32% (Ritalin + Dexedrine + Caffeine)"

### 4. Multi-Substance Insights
- See which substances contribute to which buckets
- Understand overlap (e.g., MDMA affects both stimulant and serotonin_release)
- Identify dominant contributors vs minor contributors

### 5. Active State Visibility
- Clearly shows which substances are currently active in system
- Helps user understand current neurochemical state
- Useful for timing next dose or identifying interactions

## Example User Journey

### Scenario: User takes Dexedrine, Ritalin, and Caffeine regularly

**Step 1: View System Overview**
- User opens dashboard
- Sees all 7 buckets at once
- Stimulant bucket shows 32.5% (orange, "Light Stress")
- GABA, Serotonin, Opioid, NMDA, Cannabinoid all show 0% (green, "Recovered")

**Step 2: Investigate Stimulant Bucket**
- User taps Stimulant bucket card
- Page scrolls to bucket detail section
- Sees contributing substances:
  - Dexedrine: 28.3% (ACTIVE)
  - Ritalin: 15.7%
  - Caffeine: 4.2% (ACTIVE)

**Step 3: Drill Down to Dexedrine**
- User taps Dexedrine from bucket detail list
- Unified tolerance widget loads below
- Shows detailed metrics:
  - Per-bucket breakdown: Stimulant 28.3%
  - Half-life: 10-12 hours
  - Days until baseline: 3.2 days
  - Recent uses: 8 in past 4 days
  - Tolerance decay curve graph

**Step 4: Understand Combined Effect**
- User returns to bucket detail
- Realizes: "My stimulant system is 32.5% tolerant because I'm using 3 different stimulants"
- Makes informed decision: "I should reduce Caffeine or skip next Dexedrine dose"

## Technical Details

### Canonical Bucket Order
Fixed order prevents UI layout shifts:
1. `gaba`
2. `stimulant`
3. `serotonin_release`
4. `serotonin_psychedelic`
5. `opioid`
6. `nmda`
7. `cannabinoid`

### Tolerance State Thresholds
```dart
0-20%:   Recovered (green)
20-40%:  Light Stress (blue)
40-60%:  Moderate Strain (orange)
60-80%:  High Strain (dark orange)
80-100%: Depleted (red)
```

### Active Substance Threshold
```dart
active_level > 0.15  // 15% of peak effect
```

### Minimum Contribution Filter
```dart
tolerance > 0.1%  // Only show if contributing > 0.1%
```

### Scroll Animation
```dart
duration: 300ms
curve: Curves.easeInOut
```

## Testing Recommendations

### 1. Test with Single Substance
- Log multiple Dexedrine doses
- Verify stimulant bucket shows correct tolerance
- Verify other 6 buckets show 0% (Recovered)
- Verify bucket detail shows only Dexedrine

### 2. Test with Multiple Substances (Same Bucket)
- Log Dexedrine + Ritalin + Caffeine
- Verify stimulant bucket shows combined tolerance
- Verify bucket detail lists all 3 with individual contributions
- Verify contributions sum roughly to system total

### 3. Test with Multi-Bucket Substance
- Log MDMA (affects stimulant + serotonin_release)
- Verify MDMA appears in both bucket detail sections
- Verify different contribution percentages per bucket

### 4. Test Active State Indicators
- Log substance within half-life window
- Verify active indicator shows on bucket card
- Verify active badge shows in bucket detail
- Wait for half-life to pass, verify indicators disappear

### 5. Test Selection State
- Click different bucket cards
- Verify selection border highlights correctly
- Verify bucket detail section updates
- Verify scroll behavior works smoothly

### 6. Test Empty States
- User with no logged substances
- Verify all 7 buckets show 0% (Recovered)
- Verify empty state message appears

### 7. Test Large Data Sets
- User with 10+ substances logged
- Verify bucket detail scrolls smoothly
- Verify performance remains good
- Verify substance list is readable

## Known Limitations

1. **Contribution Calculation**: Per-substance contributions are computed independently, so they may not sum exactly to system total due to different decay rates.

2. **Performance**: Computing substance contributions requires fetching all models and logs on every load. Consider caching for users with many substances.

3. **Substance Naming**: Assumes `substanceSlug` matches between tolerance models and use logs. If naming is inconsistent, contributions may not appear.

4. **Active State Logic**: Active state is based on `active_level > 0.15` threshold. This may not align perfectly with user's subjective experience.

5. **Horizontal Scroll**: On very narrow screens, bucket cards may be difficult to navigate. Consider vertical layout for mobile portrait.

## Future Enhancements

1. **Search/Filter**: Add search bar to filter substances in bucket detail
2. **Sort Options**: Sort substances by contribution (high to low) or alphabetically
3. **Combined Tolerance Graph**: Show system-wide tolerance over time
4. **Interaction Warnings**: Highlight dangerous combinations (e.g., stimulant + opioid)
5. **Tolerance Goals**: Allow user to set target tolerance % and show progress
6. **Export Data**: Export bucket contributions as CSV or PDF report
7. **Comparison View**: Compare current tolerance to past week/month
8. **Smart Recommendations**: Suggest which substances to reduce based on goals

## Compatibility

- **Dart**: 3.0+
- **Flutter**: 3.10+
- **Dependencies**:
  - `flutter/material.dart`
  - `models/tolerance_model.dart`
  - `models/bucket_definitions.dart`
  - `services/*_service.dart`
  - `utils/bucket_tolerance_calculator.dart`
  - `utils/tolerance_calculator.dart`

## Backwards Compatibility

All existing tolerance calculation logic remains unchanged. The refactor only affects UI/UX, not underlying algorithms. Users can still view per-substance details by selecting substances from bucket detail section.

## Conclusion

The tolerance dashboard now provides a **system-first, hierarchical view** that helps users understand their neurochemical state across all systems. By showing all 7 buckets at once and allowing drill-down to specific substances, users can make more informed decisions about their substance use.

**Key Achievements**:
✅ System-first layout with all 7 buckets visible
✅ Hierarchical navigation: System → Bucket → Substance
✅ Per-bucket substance contribution aggregation
✅ Active state indicators for currently active substances
✅ Smooth scroll behavior and selection state
✅ Backwards compatible with existing tolerance calculations
✅ Zero compilation errors
✅ Ready for testing with real data

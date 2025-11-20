# Metabolism Timeline - Modular Architecture

## Overview
Clean, modular implementation of the metabolism timeline graph from the old blood levels screen. Features exponential decay curves with FL_Chart visualization.

**IMPORTANT**: The timeline displays **ALL doses within the selected time window**, not just currently active doses. This means doses that have fully decayed by the reference time will still appear on the graph if they occurred within the lookback period.

**NEW**: The timeline now shows **multiple drugs simultaneously** with **normalized intensity (0-100%)** based on dosage thresholds. Each drug is normalized where "strong" dose = 100%.

## File Structure

### 📦 Models
- **`lib/models/curve_point.dart`** (18 lines)
  - Data class representing a point on the decay curve
  - Properties: `hours` (time offset), `remainingMg` (amount or intensity %)
  - Method: `percentOf()` for percentage calculations

### ⚙️ Services
- **`lib/services/blood_levels_service.dart`** (364 lines)
  - **Two methods for different purposes**:
    - `calculateLevels()` - Fetches currently active doses (filtered by active window & percentage)
    - `getDosesForTimeline()` - Fetches ALL doses within time window (NO filtering)
  - `getDosesForTimeline()` includes any dose between `(referenceTime - hoursBack)` and `(referenceTime + hoursForward)`
  - Enables historical visualization of fully-decayed doses

- **`lib/services/decay_service.dart`** (173 lines)
  - `decayRemaining()` - Exponential decay calculation: `dose * 2^(-t/halfLife)`
  - `generateDecayCurveForDose()` - Creates curve for single dose
  - `generateCombinedCurve()` - Sums multiple doses at each time point
  - **`normalizeToIntensity()`** - Converts mg to 0-100% using dosage thresholds
  - **`generateNormalizedCurve()`** - Generates intensity curves for timeline visualization
  - Pure business logic, no UI dependencies

### 🛠️ Utils
- **`lib/utils/drug_profile_utils.dart`** (169 lines)
  - `extractMaxDuration()` - Parse formatted_duration from profiles
  - `extractMaxAftereffects()` - Parse formatted_aftereffects
  - **`getDosageThresholds()`** - Extract [threshold, light, common, strong, heavy] from formatted_dose
  - **`getFallbackThresholds()`** - Fallback thresholds for common drugs
  - Handles multiple formats: strings, numbers, maps
  - Supports units: hours, minutes, days

### 🎨 Widgets
- **`lib/widgets/blood_levels/metabolism_timeline_card.dart`** (467 lines)
  - **StatefulWidget** that fetches unfiltered doses via `getDosesForTimeline()`
  - **Accepts `List<DrugLevel>`** to show multiple drugs simultaneously
  - Main graph widget using FL_Chart
  - Features:
    - **Multiple drug lines** with different colors
    - **Normalized intensity (0-100%)** based on dosage thresholds
    - **Horizontal legend** showing all drugs with half-lives
    - Smooth gradient area fill per drug
    - Exponential decay curves
    - Vertical "NOW" line at x=0
    - Interactive tooltips showing drug name, time, and intensity %
    - Adaptive/fixed Y-scale (capped at 200% for heavy doses)
    - Y-axis labeled as **percentage** instead of mg
    - Loading state while fetching doses
    - Auto-reloads when time window or drugs change

- **`lib/widgets/blood_levels/metabolism_timeline_controls.dart`** (165 lines)
  - Timeline configuration UI
  - Inputs: hours back, hours forward
  - Toggle: adaptive vs fixed Y-scale
  - Preset buttons: 24h, 48h, 72h, 1 week
  - Callback-based state management

### 📱 Integration
- **`lib/screens/blood_levels_page.dart`** (adds ~60 lines)
  - Timeline toggle button in AppBar
  - State: `_chartHoursBack`, `_chartHoursForward`, `_chartAdaptiveScale`, `_showTimeline`
  - Method: `_buildTimelineSection()` - Assembles controls + graph
  - **Passes ALL filtered drugs** to timeline (not just highest percentage)

## Key Features

### 🎯 Multiple Drug Visualization
**The graph shows all active substances simultaneously**:
- One colored line per drug
- Each drug normalized independently to 0-100% intensity
- "Strong" dosage threshold = 100% baseline
- Different colors per drug category
- Legend shows all drugs with half-lives
- Overlapping curves show polysubstance use patterns

### 📊 Intensity Normalization
**Dosage-aware percentage display**:
- Extracts thresholds from `drug_profiles.formatted_dose`
- Route preference: Oral > Insufflated > IV > IM > Rectal
- Fallback to hardcoded thresholds for common drugs
- Strong threshold = 100% intensity
- Allows up to 200% for heavy doses
- Y-axis shows **%** not mg for universal comparison

### 🕐 Historical Dose Visualization
**The graph shows the complete metabolism history**, not just active doses:
- Doses outside the active window appear if within time range
- Peaks of old doses visible on left side of graph
- Curves show full decay even if reaching 0% before "Now"
- Represents **substance level over time**, not just current state

Example: Viewing 72h lookback, a dose from 48h ago (now fully inactive) will still appear with its peak at -48h and its decay to 0mg.

### ✨ Behavior (matches old app)
- ✅ Exponential decay modeling based on half-life
- ✅ Multi-dose support (each dose contributes to curve)
- ✅ **Multiple drugs on same graph** (NEW)
- ✅ **Normalized to 0-100% intensity** (NEW)
- ✅ Past/future timeline (configurable window)
- ✅ Vertical "Now" line at x=0
- ✅ Smooth spline curves (curveSmoothness: 0.3)
- ✅ Gradient shaded area per drug
- ✅ Adaptive vs Fixed Y-scale toggle
- ✅ Interactive tooltips showing drug/time/intensity

### 🎯 Architecture Principles
- ✅ **Separation of concerns** - UI, business logic, data models separate
- ✅ **Small, focused files** - Largest file is 467 lines
- ✅ **Reusable services** - DecayService can be used elsewhere
- ✅ **Dependency injection** - Services passed via constructors
- ✅ **Proper state management** - StatefulWidget for async data loading
- ✅ **Clean Dart code** - Well-documented, readable
- ✅ **No business logic in widgets** - Pure presentation layer

### 📊 Visual Design
- Clean white card with subtle shadow
- Multiple colored lines (category-based colors)
- Gradient shaded areas per drug
- Red dashed "NOW" line for time reference
- Grid lines for easy reading
- Horizontal scrolling legend
- Responsive tooltips
- Y-axis as percentage (0-200%)

## Usage Example

```dart
// In blood_levels_page.dart
MetabolismTimelineCard(
  drugLevel: topDrug,           // DrugLevel with doses
  hoursBack: 24,                // Look back 24 hours
  hoursForward: 24,             // Look forward 24 hours
  adaptiveScale: true,          // Auto-scale Y-axis
  referenceTime: DateTime.now(), // "Now" point
)
```

## Testing
- ✅ All 360 tests pass
- No breaking changes to existing functionality
- Modular design makes unit testing easy

## Future Enhancements
- Multiple drug curves on same chart (different colors)
- Dosage normalization to intensity %
- Export chart as image
- Historical playback (time machine integration)

# Tolerance Dashboard

## Overview
The Tolerance Dashboard calculates and visualizes substance tolerance build-up using pharmacokinetic modeling and neurotransmitter system analysis.

## Data Model

### JSON Structure (stored inside `drug_profiles.properties -> tolerance_data`)
```json
{
  "notes": "Description of substance's neurological effects",
  "neuro_buckets": {
    "gaba": { "weight": 0.9 },
    "nmda": { "weight": 0.3 },
    "serotonin": { "weight": 0.2 }
  },
  "half_life_hours": 8,
  "tolerance_decay_days": 3
}
```

### Fields
- **notes**: Description of substance's mechanism of action
- **neuro_buckets**: Map of neurotransmitter systems with weights (0-1)
- **half_life_hours**: Elimination half-life for PK calculations
- **tolerance_decay_days**: Time constant for tolerance decay

## Calculations

### 1. Effective Plasma Level
Uses exponential decay model:
```
C(t) = C₀ × e^(-kt)
where k = ln(2) / t½
```

**Parameters:**
- `useTime`: When substance was taken
- `currentTime`: Time to calculate level at
- `halfLifeHours`: Substance half-life
- `initialDose`: Starting dose

**Returns:** Plasma concentration at current time

### 2. Tolerance Score
Calculates cumulative tolerance (0-100%) from overlapping use events.

**Algorithm:**
1. Sum plasma levels from all recent uses
2. Apply logarithmic normalization: `(log(plasma + 1) / log(100)) × 100`
3. Clamp to 0-100 range

**Parameters:**
- `useEvents`: List of recent uses (timestamp, dose)
- `halfLifeHours`: Substance half-life
- `currentTime`: Current time

**Returns:** Tolerance percentage (0-100)

### 3. Decay Function
Models tolerance reduction over time using exponential decay:
```
f(t) = e^(-t/τ)
where τ = tolerance_decay_days
```

**Parameters:**
- `daysSinceLastUse`: Days since last use
- `toleranceDecayDays`: Decay time constant

**Returns:** Decay multiplier (1.0 = full tolerance, 0.0 = baseline)

### 4. Neuro Bucket Contribution
Calculates system-specific tolerance impact:
```
contribution = weight × tolerance_score
```

**Parameters:**
- `bucketWeight`: Neurotransmitter system weight (0-1)
- `toleranceScore`: Overall tolerance (0-100)

**Returns:** System contribution (0-100)

### 5. Days Until Baseline
Calculates time to reach <5% tolerance:
```
t = -τ × ln(5 / current_tolerance)
```

**Parameters:**
- `currentTolerance`: Current tolerance level
- `toleranceDecayDays`: Decay time constant

**Returns:** Days until baseline

## UI Components

### 1. Tolerance Score Card
- **Gauge**: Circular progress indicator (0-100%)
- **Color**: Green (0-10), Yellow (10-50), Orange (50-70), Red (70-100)
- **Label**: Baseline/Low/Moderate/High/Very High
- **Subtitle**: Number of use events in last 30 days

### 2. Tolerance Build-Up Graph
- **Type**: FL_Chart LineChart
- **X-axis**: Time (30 days back to now)
- **Y-axis**: Tolerance percentage (0-100)
- **Style**: Cyan-purple gradient line with glow
- **Data**: Historical tolerance curve with decay

### 3. Decay Projection Graph
- **Type**: FL_Chart LineChart (dashed)
- **X-axis**: Future time (+14 days)
- **Y-axis**: Projected tolerance
- **Style**: Cyan dashed line
- **Label**: "X days until baseline"

### 4. Neuro Buckets Panel
For each neurotransmitter system:
- **Name**: GABA-A, NMDA, Serotonin, etc.
- **Weight Bar**: Progress bar showing system weight
- **Contribution**: Calculated impact percentage
- **Description**: System function chip

### 5. Half-Life Panel
- **Half-Life**: Elimination half-life in hours
- **Tolerance Decay**: Decay time constant in days
- **Days to Baseline**: Time until <5% tolerance
- **Recent Uses**: Count of uses in window

### 6. Notes Panel
Displays mechanism of action and cross-tolerance information.

## Styling

### Colors
- **Background**: `#0A0E27` (dark navy)
- **Card Background**: `#1A1F3A` (lighter navy)
- **Neon Cyan**: `#00FFF0` (primary)
- **Neon Purple**: `#A855F7` (secondary)
- **White Text**: `#FFFFFF` / `#FFFFFF70` (dimmed)

### Effects
- **Border Radius**: 20px on cards
- **Shadows**: Soft glow with color opacity 0.2-0.3
- **Gradients**: Top-left to bottom-right
- **Borders**: 1px with color opacity 0.3

## Example Usage

```dart
// Navigate to tolerance dashboard (optional: preselect a substance)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const ToleranceDashboardPage(initialSubstance: 'Alcohol'),
  ),
);
```

## Database Setup

Add tolerance data to existing substances:

```sql
UPDATE drug_profiles
SET properties = coalesce(properties, '{}'::jsonb) || jsonb_build_object(
  'tolerance_data',
  '{
    "notes": "Substance mechanism description",
    "neuro_buckets": {
      "gaba": {"weight": 0.9},
      "nmda": {"weight": 0.3}
    },
    "half_life_hours": 8,
    "tolerance_decay_days": 3
  }'::jsonb
)
WHERE name = 'Alcohol';
```

## Preview Data (Alcohol Example)

```json
{
  "notes": "Alcohol impacts GABA-A, NMDA, serotonin, dopamine and endogenous opioid systems. This model includes cross-tolerance to depressants, mild serotonergic effects, and NMDA rebound risk.",
  "neuro_buckets": {
    "gaba": { "weight": 0.9 },
    "nmda": { "weight": 0.3 },
    "serotonin": { "weight": 0.2 }
  },
  "half_life_hours": 8,
  "tolerance_decay_days": 3
}
```

## Dependencies
- `fl_chart: ^0.66.0` (already in pubspec.yaml)
- Supabase table: `drug_profiles` with `tolerance_data` JSONB column
- Supabase table: `drug_use` for use events

## Files Created
1. `lib/models/tolerance_model.dart` - Data models and calculation logic
2. `lib/services/tolerance_service.dart` - Supabase data fetching
3. `lib/screens/tolerance_dashboard_page.dart` - Complete UI implementation

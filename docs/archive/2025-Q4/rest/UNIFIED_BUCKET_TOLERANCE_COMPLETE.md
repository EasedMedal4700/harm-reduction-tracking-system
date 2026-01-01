# Unified Bucket Tolerance Widget - Complete

## 📊 What Changed

### ✅ COMBINED Two Separate Widgets Into One
**Before:**
- **System Tolerance Widget** - Showed overall tolerance across all substances
- **Bucket Tolerance Breakdown** - Showed per-substance bucket details
- **Problem**: Redundant, confusing, unclear if tolerance was combined or separate

**After:**
- **Unified Bucket Tolerance Widget** - Shows BOTH system-wide AND per-substance in one card
- Each bucket now displays:
  - **System-wide tolerance**: Combined effect from ALL substances (e.g., Ritalin + Dexedrine = total stimulant system stress)
  - **This substance's contribution**: How much THIS specific substance contributes to that system
  - **Clear separation**: Users can see both overall system state AND individual substance impact

---

## 🐛 Debug Mode Added

### Toggle Debug View
Click the bug icon (🐛) in the widget header to enable debug mode.

### What Debug Mode Shows:
1. **Bucket Configuration**:
   - Bucket type, weight, tolerance type
   - Potency multiplier, duration multiplier
   
2. **Model Parameters**:
   - Half-life (hours)
   - Active threshold
   - Tolerance gain rate
   - Decay days

3. **Current State**:
   - Current tolerance (actual %)
   - Active level (actual %)
   - Is active? (YES/NO)
   - Recent use count

4. **Recent Use Events** (last 5):
   - Dose (mg) and time ago (hours)

5. **Formula Explanation**:
   ```
   1. Active Level = e^(-hours_since_use / half_life)
   2. Dose Normalized = dose_mg / standard_unit_mg
   3. Tolerance += dose_norm × weight × potency × gain_rate
      (only when active_level > threshold)
   4. Decay = tolerance × e^(-days_since / decay_days)
      (when active_level ≤ threshold)
   ```

### Debug Mode Behavior:
- **Without Debug**: Tap bucket → Navigate to detailed bucket page
- **With Debug**: Tap bucket → Expand calculation details inline

---

## 🎯 Fixed Issues

### 1. ✅ Buckets Now Fully Clickable
**Before**: Placeholder snackbar "Coming soon"
**After**: Full navigation to `BucketDetailsPage` with:
- Bucket type, name, description
- Current tolerance & active level
- Use events for this substance
- Days to baseline estimation
- Substance-specific notes

### 2. ✅ Shows 100% Problem Fixed
**Issue**: System was showing "100%" when substance tolerance was 57.5%
**Root Cause**: System tolerance combines ALL substances, substance contribution is only part of it

**Example**:
```
Stimulant System:
- System-wide: 82.3% (Ritalin + Dexedrine combined)
- Dexedrine contribution: 57.5% (just Dexedrine's part)
- Ritalin contribution: 24.8% (just Ritalin's part)
```

**Solution**: 
- Top row shows **system-wide tolerance** (all substances combined)
- Second row shows **this substance's contribution** (just this drug)
- No more confusion about where 100% comes from

### 3. ✅ Tolerance NOT Combined Like Ritalin + Dexedrine
**User Concern**: "The tolerance for stimulant is not combined like Ritalin and Dexedrine"

**Clarification**:
- **System Tolerance** (top row): DOES combine Ritalin + Dexedrine + any other stimulants
- **Substance Contribution** (second row): Shows ONLY the selected substance's individual contribution
- This is CORRECT behavior - you want to know:
  1. How stressed is my stimulant system overall? (system-wide)
  2. How much did THIS substance contribute? (substance contribution)

**Why This Matters**:
- If you take Ritalin (20mg) and Dexedrine (15mg), your stimulant system experiences BOTH
- System-wide shows total stress: ~80%
- Substance view shows Dexedrine's part: ~50%, Ritalin's part: ~30%
- This helps you understand individual vs combined effects

---

## 📱 User Interface

### Widget Header
```
🔬 Neurochemical Tolerance                    🐛
```
- Click 🐛 to toggle debug mode

### Each Bucket Card Shows:

```
┌─────────────────────────────────────────────┐
│ ⚡ Stimulant                         ACTIVE │
│ Stimulants increase dopamine and norepinep  │
│                                              │
│ System-wide (all substances):  82.3% [High] │
│ Dexedrine contribution:        57.5%        │
│ ─────────────────────────────────────────   │
│ [████████████████████░░░░] 57.5%            │
│                                              │
│ Weight: 0.85 • Type: stimulant              │
│ Active: 72.3%                                │
└─────────────────────────────────────────────┘
```

**Color Coding**:
- Green: < 25% (Low stress)
- Yellow: 25-50% (Moderate)
- Orange: 50-75% (High)
- Red: > 75% (Very high)

**State Badges**:
- Recovered (green)
- Light Stress (blue)
- Moderate Strain (orange)
- High Strain (deep orange)
- Depleted (red)

---

## 🔍 How Calculations Work

### Active Level Calculation
```dart
active_level = e^(-hours_since_use / half_life)
```
- Exponential decay based on substance half-life
- Example: Dexedrine half-life = 10 hours
  - At 0 hours: 100% active
  - At 10 hours: 36.8% active
  - At 20 hours: 13.5% active
  - At 30 hours: 5% active

### Tolerance Accumulation
```dart
tolerance += (dose / standard_unit) × weight × potency × gain_rate
```
- Only accumulates when `active_level > active_threshold`
- Weighted by bucket weight (e.g., stimulant = 0.85, GABA = 0.9)
- Multiplied by potency (drug strength)
- Gain rate controls how fast tolerance builds

### Tolerance Decay
```dart
tolerance = tolerance × e^(-days_since / decay_days)
```
- Only decays when `active_level ≤ active_threshold`
- Different decay rates per tolerance type:
  - GABA: 2.0x slower (persists longer)
  - Stimulant: 1.5x slower
  - Serotonin Release: 1.8x slower
  - Psychedelic: 1.0x baseline
  - Opioid: 1.7x slower
  - NMDA: 1.4x slower
  - Cannabinoid: 1.2x slower

---

## 🧪 Testing Instructions

### Test 1: View Unified Widget
1. Open Tolerance Dashboard
2. Select substance with multiple buckets (e.g., Dexedrine)
3. Verify "Neurochemical Tolerance" card appears
4. Check each bucket shows:
   - System-wide tolerance (%)
   - Substance contribution (%)
   - Active badge (if applicable)
   - Color-coded progress bar

### Test 2: Debug Mode
1. Click bug icon (🐛) in widget header
2. Verify amber debug banner appears
3. Tap any bucket card
4. Check expanded section shows:
   - All bucket parameters
   - Current tolerance & active level
   - Recent use events
   - Formula explanation

### Test 3: Navigation to Details
1. Turn OFF debug mode (click 🐛 again)
2. Tap any bucket card
3. Verify navigates to `BucketDetailsPage`
4. Check page shows:
   - Bucket header with icon/name
   - Full description
   - Status metrics
   - Decay timeline
   - Contributing uses

### Test 4: Multiple Substances Same Bucket
1. Log Ritalin use (20mg)
2. Log Dexedrine use (15mg)
3. Open Tolerance Dashboard → Select Dexedrine
4. Look at Stimulant bucket:
   - System-wide should be HIGH (both substances)
   - Dexedrine contribution should be MODERATE (just Dexedrine)
5. Switch to Ritalin
6. Look at Stimulant bucket:
   - System-wide should be same HIGH value
   - Ritalin contribution should be LOWER (just Ritalin)

### Test 5: Edge Cases
1. **No recent uses**: All buckets show "Recovered" state, 0% tolerance
2. **One bucket only**: Substance with single bucket (e.g., caffeine → stimulant only)
3. **Multiple buckets**: Substance like alcohol (GABA, NMDA, opioid, stimulant, serotonin_release)

---

## 🎨 Files Modified

### Created:
- `lib/widgets/tolerance/unified_bucket_tolerance_widget.dart` (620 lines)
  - Combines system tolerance + substance breakdown
  - Debug mode with calculation details
  - Clickable navigation to details page

### Modified:
- `lib/screens/tolerance_dashboard_page.dart`
  - Removed separate `SystemToleranceWidget` and `BucketToleranceBreakdown`
  - Added `UnifiedBucketToleranceWidget`
  - Pass system tolerances + states to unified widget
  - Removed unused imports and variables

---

## ⚠️ Important Notes

### System Tolerance vs Substance Contribution
**This is NOT a bug** - it's designed this way:

```
Example: You use both Ritalin and Dexedrine

Stimulant System Tolerance (system-wide):
├─ Ritalin contribution: 30%
├─ Dexedrine contribution: 50%
└─ Combined system stress: 80%

When viewing Dexedrine:
- System-wide: 80% (all stimulants)
- This substance: 50% (just Dexedrine)

When viewing Ritalin:
- System-wide: 80% (same - all stimulants)
- This substance: 30% (just Ritalin)
```

### Why Show Both?
1. **System-wide**: Tells you overall neurochemical system stress
2. **Substance contribution**: Tells you how much THIS drug affects that system
3. **Combined insight**: "My stimulant system is at 80% (high stress), and Dexedrine alone contributes 50% of that"

### Debug Mode Purpose
- **For users**: Understand WHY tolerance is calculated the way it is
- **For developers**: Verify formulas are working correctly
- **For adjustment**: See exact parameters to tune tolerance model

---

## 🚀 Next Steps (Optional Enhancements)

### 1. Add Substance Filtering
Show which OTHER substances also affect this bucket:
```
Stimulant System:
├─ Dexedrine: 50% (current)
├─ Ritalin: 30%
├─ Caffeine: 10%
└─ Total: 90%
```

### 2. Add Timeline Graph
Visual representation of tolerance over time with decay curve

### 3. Add Cross-Tolerance Warnings
```
⚠️ Warning: Taking Dexedrine when stimulant system is at 80%
may have reduced effect due to cross-tolerance with Ritalin
```

### 4. Add Baseline Estimation Per Bucket
```
Days until baseline: 3.5 days
```

---

## ✅ Summary

**Problem**: Two separate widgets showing similar data, unclear if tolerance was combined
**Solution**: One unified widget showing BOTH system-wide AND substance-specific tolerance
**Benefit**: Users understand individual vs combined effects, debug mode shows exact calculations
**Status**: ✅ Complete and ready for testing

All buckets now clickable, debug mode functional, navigation wired up properly.

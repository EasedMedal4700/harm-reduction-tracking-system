# Bucket Tolerance System Integration - Complete

## Overview
The tolerance dashboard has been successfully upgraded to support the new **bucket-based neurochemical tolerance system** while maintaining backward compatibility with the existing tolerance calculation system.

## What Was Implemented

### 1. New Files Created (6 total)

#### Core System Files
1. **`lib/models/tolerance_bucket.dart`** (115 lines)
   - `ToleranceBucket`: Represents single neurochemical bucket (type, weight, multipliers)
   - `BucketToleranceModel`: Complete tolerance model with neuro_buckets map
   - JSON serialization support
   - Safety warnings in documentation

2. **`lib/utils/bucket_tolerance_formulas.dart`** (195 lines)
   - Type-specific tolerance formulas for 7 neurochemical systems:
     - **Stimulant** (Dopamine/NE): 1.0x buildup, 1.0x decay
     - **Serotonin Release**: 1.5x buildup, 2.0x decay (longer recovery)
     - **Serotonin Psychedelic** (5-HT2A): 2.0x buildup, 0.4x decay (3-5 day recovery)
     - **GABA**: Logarithmic buildup, 1.3x decay
     - **NMDA Antagonist**: 1.2x rebound-sensitive, 1.5x decay
     - **Opioid** (μ-receptor): 1.3x biphasic, 1.0x decay
     - **Cannabinoid** (CB1/CB2): 0.7x slow buildup, 1.8x decay

3. **`lib/utils/bucket_tolerance_calculator.dart`** (245 lines)
   - Core calculation engine
   - **Key algorithm**: Only accumulates tolerance while substance is active (active_level > threshold)
   - Applies decay only when substance is inactive
   - Cross-tolerance calculation (same bucket types across substances combine)
   - Days-until-baseline estimation

4. **`lib/services/bucket_tolerance_service.dart`** (125 lines)
   - Service layer for database interaction
   - Fetches data from Supabase tables
   - Orchestrates tolerance calculations
   - Methods:
     - `fetchToleranceModel()`: Gets bucket data from tolerance_models table
     - `fetchStandardUnitMg()`: Gets dose normalization from dose_normalization table
     - `fetchUseEvents()`: Gets user's log entries
     - `calculateSubstanceTolerance()`: Full calculation for one substance
     - `calculateSystemTolerance()`: Cross-tolerance across all substances

#### UI Components
5. **`lib/widgets/tolerance/tolerance_disclaimer.dart`** (155 lines)
   - `ToleranceDisclaimerWidget`: Full expandable disclaimer
   - `CompactToleranceDisclaimer`: Header disclaimer for dashboard
   - **CRITICAL**: Warns users that calculations are NOT medically validated
   - Emphasizes: Tolerance ≠ Safety, cannot predict risk

6. **`lib/widgets/tolerance/bucket_tolerance_breakdown.dart`** (175 lines)
   - Visual breakdown of tolerance by neurochemical bucket
   - Color-coded progress bars:
     - Green: 0-25% tolerance
     - Yellow: 25-50% tolerance
     - Orange: 50-75% tolerance
     - Red: 75%+ tolerance
   - Shows active status, bucket weight, active level %
   - Displays bucket-specific notes

### 2. Modified Files

#### `lib/screens/tolerance_dashboard_page.dart`
**Changes Made**:
- ✅ Added imports for bucket system classes
- ✅ Added state variables for bucket data:
  - `_bucketToleranceModel`: Stores bucket model from database
  - `_bucketResults`: Map of bucket type → tolerance result
  - `_showBucketView`: Toggle for future bucket/legacy view switching
- ✅ Updated `_loadMetrics()` to fetch and calculate bucket tolerance:
  - Fetches `BucketToleranceModel` from Supabase
  - Fetches `standardUnitMg` for dose normalization
  - Converts old `UseEvent` format to bucket `UseEvent` format
  - Calculates bucket results using `BucketToleranceCalculator`
  - Gracefully falls back to old system if bucket data unavailable
- ✅ Updated `_buildContent()` to display bucket widgets:
  - Added `CompactToleranceDisclaimer` at top (safety warnings)
  - Added `BucketToleranceBreakdown` below main tolerance card
  - Only shows bucket view when data is available

**Preserved Features**:
- ✅ All existing widgets still work (ToleranceSummaryCard, SystemToleranceWidget, etc.)
- ✅ Debug mode for per-substance tolerance still functions
- ✅ Recent uses card unchanged
- ✅ Old tolerance calculation still runs in parallel

## Database Schema

### Using Existing `drug_profiles` Table

The bucket tolerance system reads from the **existing `tolerance_model` JSONB column** in your `drug_profiles` table. No new tables are required!

#### Example `tolerance_model` JSONB structure:
```json
{
  "notes": "Alcohol is a mixed CNS depressant primarily acting via GABA-A and NMDA...",
  "neuro_buckets": {
    "gaba": {
      "weight": 0.9,
      "tolerance_type": "gaba"
    },
    "nmda": {
      "weight": 0.6,
      "tolerance_type": "nmda"
    },
    "opioid": {
      "weight": 0.2,
      "tolerance_type": "opioid"
    }
  },
  "half_life_hours": 8,
  "active_threshold": 0.05,
  "potency_multiplier": 1.0,
  "duration_multiplier": 1.0,
  "tolerance_gain_rate": 1.0,
  "tolerance_decay_days": 3
}
```

### Substances with Bucket Data (Already in DB)

Based on your sample data, these substances already have tolerance models:
- ✅ **alcohol** - GABA (0.9), NMDA (0.6), opioid (0.2), stimulant (0.2), serotonin_release (0.05)
- ✅ **mdma** - serotonin_release (1.0), stimulant (0.35), serotonin_psychedelic (0.1), nmda (0.1)
- ✅ **dexedrine** - stimulant (1.0)
- ✅ **methylphenidate** - stimulant (1.0)
- ✅ **mdpv** - stimulant (1.0)
- ✅ **bromazolam** - gaba (1.0)
- ✅ **alprazolam** - (inferred: gaba 1.0)

### Dose Normalization

The service uses built-in defaults for standard doses:
- alcohol: 10mg (1 standard drink)
- mdma: 100mg
- lsd: 0.1mg (100μg)
- amphetamine: 20mg
- dexedrine: 10mg
- methylphenidate: 20mg
- cannabis: 10mg THC
- alprazolam: 1mg
- bromazolam: 1mg
- mdpv: 5mg

## How It Works

### Tolerance Calculation Flow

1. **User selects substance** in dropdown
2. **Dashboard loads data**:
   - Fetches old ToleranceModel (for backward compatibility)
   - Fetches BucketToleranceModel (new system)
   - Fetches standardUnitMg for dose normalization
   - Fetches user's use events (log_entries)

3. **Bucket tolerance calculation**:
   ```dart
   For each use event (sorted by time):
     - Calculate active_level = e^(-hours_since_use / half_life)
     - If active_level > threshold:
         - tolerance += dose_normalized × potency × weight × duration
     - Track last active use
   
   After all uses:
     - If inactive now (active_level < threshold):
         - Apply exponential decay based on days since last active use
   ```

4. **Display results**:
   - Old tolerance score (single number)
   - Bucket breakdown (7+ neurochemical systems)
   - Color-coded bars showing tolerance per bucket
   - Active status indicators
   - Safety disclaimers

### Cross-Tolerance Support
When multiple substances share the same bucket type (e.g., multiple stimulants affecting dopamine), their tolerance accumulates:
- Cocaine + Amphetamine = Combined stimulant tolerance
- Alcohol + Benzodiazepines = Combined GABA tolerance
- LSD + Psilocybin = Combined serotonin psychedelic tolerance

### Safety Features
1. **Prominent disclaimers** at top of dashboard
2. **Orange warning styling** on bucket breakdown
3. **Code comments** throughout warning about medical validity
4. **Graceful fallback** if bucket data unavailable

## Testing Checklist

### ✅ No Database Setup Needed!
Your existing `drug_profiles` table already has `tolerance_model` JSONB data for multiple substances.

### UI Testing
- [ ] Build and run the app
- [ ] Open tolerance dashboard
- [ ] Verify disclaimer appears at top (orange warning banner)
- [ ] Select a substance with bucket data (alcohol, mdma, dexedrine, etc.)
- [ ] Verify bucket breakdown card appears below main tolerance
- [ ] Check color coding (green/yellow/orange/red bars)
- [ ] Verify "ACTIVE" badge shows for recently-used substances
- [ ] Check that old tolerance summary still works
- [ ] Test with substance that has NO tolerance_model (should not crash)

### Calculation Testing
- [ ] Log use of alcohol (has 5 buckets: gaba, nmda, opioid, stimulant, serotonin_release)
- [ ] Verify tolerance increases in all relevant buckets
- [ ] Log use of mdma (has 4 buckets: serotonin_release, stimulant, serotonin_psychedelic, nmda)
- [ ] Check cross-tolerance warning (both have stimulant bucket)
- [ ] Wait for substance to become inactive (past half-life)
- [ ] Verify tolerance decays over time

## Next Steps (Optional Enhancements)

### Short-term
1. Add bucket toggle button to switch between old/new view
2. Add bucket-specific graphs showing tolerance over time
3. Display cross-tolerance warnings when substances share buckets

### Long-term
1. Populate tolerance_models table for all 551 substances
2. Add bucket-specific daily check-in questions
3. Create bucket system tutorial/onboarding
4. Add "tolerance risk" score combining all buckets

## Important Notes

⚠️ **Safety Critical**:
- Tolerance calculations are NOT medically validated
- They CANNOT predict overdose risk or safety
- Tolerance ≠ Safety (you can be tolerant and still die)
- Users must understand these are rough estimates only

✅ **Backward Compatibility**:
- Old tolerance system still works
- Bucket system is additive, not replacing
- If bucket data unavailable, only old system shows

🔧 **Modular Architecture**:
- Each layer is independent (models → formulas → calculator → service → UI)
- Easy to add new bucket types
- Easy to modify formulas per type
- Easy to extend with new features

## File Summary

### Created (6 files, ~1,010 lines total)
- `lib/models/tolerance_bucket.dart` (115 lines)
- `lib/utils/bucket_tolerance_formulas.dart` (195 lines)
- `lib/utils/bucket_tolerance_calculator.dart` (245 lines)
- `lib/services/bucket_tolerance_service.dart` (125 lines)
- `lib/widgets/tolerance/tolerance_disclaimer.dart` (155 lines)
- `lib/widgets/tolerance/bucket_tolerance_breakdown.dart` (175 lines)

### Modified (1 file)
- `lib/screens/tolerance_dashboard_page.dart` (~60 lines changed)

---

**Status**: ✅ **READY FOR TESTING**

The bucket tolerance system is fully integrated and ready to use. Once you add the required database tables and sample data, you can test the new neurochemical bucket breakdown on the tolerance dashboard.

# Log Entry Validation System - Implementation Complete

## Overview
Implemented comprehensive validation system for log entries with DB-based substance validation, dynamic ROA restrictions, and conditional required fields for medical vs non-medical use.

## Changes Made

### 1. SubstanceRepository Enhancement
**File:** `lib/repo/substance_repository.dart`

Added three new methods:
- `getSubstanceDetails(String substanceName)` - Fetches substance data including formatted_dose field, returns null if not found
- `getAvailableROAs(Map<String, dynamic>? substanceDetails)` - Extracts ROA keys from formatted_dose JSON
- `isROAValid(String roa, Map<String, dynamic>? substanceDetails)` - Validates if ROA exists for substance

### 2. LogEntryState Validation
**File:** `lib/states/log_entry_state.dart`

#### New Fields:
- `substanceDetails` - Cached substance data for ROA validation
- `_substanceRepo` - SubstanceRepository instance

#### Enhanced Methods:
- `setSubstance()` - Now calls `_loadSubstanceDetails()` to fetch substance data
- `_loadSubstanceDetails()` - Async method to load substance details from DB

#### New Helper Methods:
- `getAvailableROAs()` - Returns base 4 ROAs + substance-specific ROAs
- `isROAValidated()` - Checks if current ROA is valid for substance

#### New Validation Methods:
- `validateSubstance(BuildContext)` - Ensures substance exists in DB, shows error if not found
- `validateROA(BuildContext)` - Shows confirmation dialog if ROA not validated for substance
- `validateEmotions(BuildContext)` - Shows confirmation if no emotions selected for non-medical use
- `validateCraving(BuildContext)` - Shows confirmation if craving = 0 for non-medical detailed mode

#### Updated save() Method:
Now runs all validation checks before saving:
```dart
1. Form validation (existing)
2. Substance exists in DB
3. ROA validation with user confirmation
4. Emotions requirement for non-medical
5. Craving requirement for non-medical detailed
```

### 3. RouteOfAdministrationCard Enhancement
**File:** `lib/widgets/log_entry_cards/route_of_administration_card.dart`

#### New Parameters:
- `availableROAs` - Dynamic list of valid ROAs (base 4 + substance-specific)
- `isROAValidated` - Optional callback to check if ROA is validated

#### Visual Enhancements:
- Shows warning icon (⚠️) on unvalidated ROAs
- Uses orange/yellow color for unvalidated routes
- Dynamically displays only available ROAs for selected substance
- Falls back to generic emoji (💊) for unknown ROAs

### 4. MedicalPurposeCard (New Component)
**File:** `lib/widgets/log_entry_cards/medical_purpose_card.dart`

Simple toggle card for medical purpose in simple mode:
- Clean switch interface with "Medical Purpose" label
- Subtitle: "Prescribed or therapeutic use"
- Green accent when enabled
- Matches existing design system (glassmorphism dark, soft shadows light)

### 5. Log Entry Page Integration
**File:** `lib/screens/log_entry_page.dart`

#### Updates:
- Imported `MedicalPurposeCard`
- Updated `RouteOfAdministrationCard` to pass:
  - `availableROAs: state.getAvailableROAs()`
  - `isROAValidated: (roa) => state.substanceDetails != null && state.isROAValidated()`
- Added `MedicalPurposeCard` in simple mode section (after FeelingsCard)

## Validation Flow

### When User Selects Substance:
1. `setSubstance()` is called
2. Automatically loads substance details from DB via `_loadSubstanceDetails()`
3. ROA list updates dynamically
4. Unvalidated ROAs show warning icon

### When User Clicks Save:
1. **Form Validation** - Standard field validation
2. **Substance Validation** - Checks DB, shows error if not found: "Substance not found in database"
3. **ROA Validation** - If unvalidated ROA selected, shows: "The route X is not validated for Y. Are you sure?"
4. **Emotions Validation** - If non-medical and no emotions: "Are you sure? No emotions selected for non-medical use."
5. **Craving Validation** - If non-medical detailed mode and craving < 1: "Are you sure? Craving intensity is 0 for non-medical use."
6. **Save to DB** - Only if all validations pass

## ROA System

### Base ROAs (Always Shown):
- Oral 💊
- Insufflated 👃
- Inhaled 🌬️
- Sublingual 👅

### Additional ROAs (Shown if in DB):
- Rectal 🔙
- Intravenous 💉
- Intramuscular 💪

### Visual Indicators:
- ✅ Validated: Blue accent color, no warning
- ⚠️ Unvalidated: Orange accent color, warning icon
- User can still select unvalidated ROAs after confirmation

## Validation Rules Summary

| Condition | Validation | Action |
|-----------|-----------|--------|
| Substance empty | Error | Block save, show message |
| Substance not in DB | Error | Block save, show error dialog |
| ROA not validated | Warning | Show confirmation dialog |
| Non-medical + no emotions | Warning | Show confirmation dialog |
| Non-medical + detailed + craving < 1 | Warning | Show confirmation dialog |

## User Experience Enhancements

### Simple Mode:
- Shows "Medical Purpose" toggle after feelings
- Validates emotions if non-medical
- No craving requirement (simple mode)

### Detailed Mode:
- Shows full IntentionCravingCard with medical toggle
- Validates emotions if non-medical
- Validates craving intensity if non-medical

### Dialog Types:
- **Error Dialogs** - Red, blocking, single "OK" button
- **Confirmation Dialogs** - Warning, optional, "Cancel" + "Continue" buttons

## Technical Details

### Database Structure:
- Table: `drug_profiles`
- Fields: `name`, `pretty_name`, `formatted_dose` (JSON)
- `formatted_dose` structure: `{"Oral": {...}, "Insufflated": {...}, ...}`

### Error Handling:
- Graceful fallback if substance details fail to load
- Empty ROA list if DB query fails
- Generic emoji for unknown ROAs

### Performance:
- Substance details loaded asynchronously
- Cached in state to avoid repeated queries
- Only reloads when substance changes

## Testing Recommendations

1. **Substance Validation:**
   - Try saving with empty substance
   - Try saving with non-existent substance (e.g., "XYZ123")
   - Verify error dialog appears

2. **ROA Validation:**
   - Select methylphenidate (has Oral, Insufflated in DB)
   - Select "Intravenous" - should show warning icon
   - Try to save - should show confirmation dialog
   - Test with substance that has limited ROAs

3. **Emotion Validation:**
   - Simple mode, non-medical use, no emotions selected
   - Try to save - should show confirmation
   - Cancel and add emotions - should save successfully

4. **Craving Validation:**
   - Detailed mode, non-medical use, craving = 0
   - Try to save - should show confirmation
   - Medical use, craving = 0 - should save without warning

5. **Simple Mode Medical Toggle:**
   - Switch to simple mode
   - Verify "Medical Purpose" card appears after feelings
   - Toggle on/off, verify state updates
   - Save with medical = true, no emotions - should succeed

## Files Modified (5 files, 1 new):
1. ✅ `lib/repo/substance_repository.dart` - Added 3 validation methods
2. ✅ `lib/states/log_entry_state.dart` - Added 4 validation methods + helpers
3. ✅ `lib/widgets/log_entry_cards/route_of_administration_card.dart` - Dynamic ROAs + warnings
4. ✅ `lib/widgets/log_entry_cards/medical_purpose_card.dart` - NEW - Simple medical toggle
5. ✅ `lib/screens/log_entry_page.dart` - Wired up validation + new card

## Requirements Checklist
✅ Substance must exist in DB before logging  
✅ ROAs fetched from DB formatted_dose field  
✅ Base 4 ROAs always shown (oral, insufflated, inhaled, sublingual)  
✅ Additional ROAs shown if in DB  
✅ Warning if ROA not validated for substance  
✅ Require ≥1 emotion for non-medical use  
✅ Require craving ≥1 for non-medical detailed mode  
✅ Medical toggle in simple mode  
✅ All validation with user-friendly dialogs  
✅ Theme-aware UI (dark/light mode)

## Status: ✅ COMPLETE
All validation requirements implemented and integrated. No compilation errors. Ready for testing.

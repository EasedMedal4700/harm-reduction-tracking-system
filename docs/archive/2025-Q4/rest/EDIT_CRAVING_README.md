# Edit Craving Feature Documentation

## Overview
Created a separate edit page for cravings following the same architecture pattern as `edit_log_entry_page.dart` and `edit_refelction_page.dart`. The edit logic is completely separate from the log craving logic, ensuring clean separation of concerns.

## Files Created

### 1. `lib/screens/edit/edit_craving_page.dart`
**Purpose:** Dedicated page for editing existing craving entries

**Key Features:**
- ✅ Loads craving data from database on mount
- ✅ Pre-fills all form fields with existing data
- ✅ Validates data before saving
- ✅ Comprehensive error handling with retry functionality
- ✅ Loading states for fetch and save operations
- ✅ Success/error feedback to user

**Form Fields:**
- Substance(s) (comma-separated list)
- Intensity (0-10 slider)
- Location
- People (who you were with)
- Emotional state
- Thoughts (text)
- Body & mind sensations
- What did you do (outcome)
- Acted on craving (yes/no)

**State Management:**
- Uses local state (no Provider dependency)
- Loads fresh data from DB using `fetchCravingById()`
- Updates via `updateCraving()` service method

## Files Modified

### 1. `lib/services/craving_service.dart`
**Added Methods:**

#### `fetchCravingById(String cravingId)`
- Queries database for single craving by `craving_id`
- Returns `Map<String, dynamic>?` with craving data
- Throws exception if not found
- Includes debug logging

#### `updateCraving(String cravingId, Map<String, dynamic> data)`
- Updates existing craving in database
- Validates intensity, substance, location before update
- Checks user ownership (matches `user_id`)
- Returns error if craving not found or unauthorized
- Includes comprehensive error handling

**Error Handling:**
- Validates required fields (intensity > 0, valid substance, valid location)
- Checks database permissions
- Logs all operations with context
- Throws descriptive exceptions

### 2. `lib/screens/activity_page.dart`
**Changes:**
- Added import for `EditCravingPage`
- Updated "Recent Cravings" section to be tappable
- Clicking a craving navigates to `EditCravingPage`
- Changed display text from `notes` to `substance` for better context

## Architecture Pattern

### Separation of Concerns
```
Log Craving Flow (Create):
CravingsPage → CravingService.saveCraving() → DB Insert

Edit Craving Flow (Update):
ActivityPage → EditCravingPage → CravingService.fetchCravingById() → Load Form
                                → CravingService.updateCraving() → DB Update
```

### Consistency with Other Edit Pages
All edit pages follow the same pattern:

| Feature | EditDrugUsePage | EditReflectionPage | EditCravingPage |
|---------|----------------|-------------------|-----------------|
| Loads DB data on mount | ✅ | ✅ | ✅ |
| Pre-fills form fields | ✅ | ✅ | ✅ |
| Uses dedicated service methods | ✅ | ✅ | ✅ |
| Error handling with dialogs | ✅ | ✅ | ✅ |
| Loading states | ✅ | ✅ | ✅ |
| Success feedback | ✅ | ✅ | ✅ |
| Local state (no shared Provider) | ✅ | ✅ | ✅ |

## Data Flow

### Loading Craving
1. User taps craving in ActivityPage
2. Navigate to EditCravingPage with entry data
3. Extract `craving_id` from entry
4. Call `CravingService.fetchCravingById(craving_id)`
5. Parse response and populate form fields:
   - Split comma-separated `substance` → `selectedCravings` list
   - Parse `intensity` as double
   - Parse `body_sensations` comma-separated → list
   - Parse `primary_emotion` comma-separated → list
   - Convert `action` string to boolean `actedOnCraving`

### Saving Changes
1. User modifies form fields
2. Clicks "Save" button
3. Build update data map:
   - Join `selectedCravings` list → comma-separated string
   - Round `intensity` to integer
   - Join `selectedSensations` → comma-separated string
   - Join `selectedEmotions` → comma-separated string
   - Convert boolean → 'Acted' or 'Resisted'
4. Call `CravingService.updateCraving(craving_id, data)`
5. Show success message and navigate back

## Database Schema
```sql
CREATE TABLE public.cravings (
  craving_id VARCHAR PRIMARY KEY,
  user_id INTEGER NOT NULL,
  substance VARCHAR,
  intensity INTEGER,
  date VARCHAR,
  time VARCHAR,
  location VARCHAR,
  people VARCHAR,
  activity VARCHAR,
  thoughts TEXT,
  triggers TEXT, -- Comma-separated
  body_sensations TEXT, -- Comma-separated
  primary_emotion VARCHAR,
  secondary_emotion VARCHAR,
  action TEXT, -- 'Acted' or 'Resisted'
  timezone NUMERIC
);
```

**Note:** `craving_id` is a VARCHAR (UUID), not an integer like other tables.

## Error Handling

### Validation Errors
- **Empty craving_id**: "Invalid craving ID: ID cannot be empty"
- **Intensity ≤ 0**: "Intensity must be higher than 0"
- **Invalid substance**: "Substance must be one from the list and not unspecified or null"
- **Invalid location**: "Please select a valid location"
- **Not found**: "Craving not found or you do not have permission to edit it"

### User Experience
- **Loading state**: Shows spinner while fetching data
- **Error dialog**: Displays detailed error with retry button
- **Success snackbar**: Confirms save and closes page
- **Saving state**: Disables save button and shows spinner

## Usage

### For Users
1. Navigate to Activity page
2. Tap any craving in "Recent Cravings" section
3. Edit desired fields
4. Tap "Save" to update

### For Developers
```dart
// Navigate to edit page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EditCravingPage(entry: cravingData),
  ),
);

// Required entry data:
{
  'craving_id': 'uuid-string', // Required
  'substance': 'Cannabis, Alcohol',
  'intensity': 7,
  'location': 'Home',
  'people': 'Friends',
  'thoughts': 'Stressed',
  'body_sensations': 'Tense, Restless',
  'primary_emotion': 'Anxious, Stressed',
  'activity': 'Went for a walk',
  'action': 'Resisted',
}
```

## Testing Checklist

### Manual Tests
- [ ] Load craving with all fields populated
- [ ] Load craving with minimal fields (only required)
- [ ] Load craving with comma-separated lists
- [ ] Edit substance selection
- [ ] Edit intensity slider
- [ ] Edit location dropdown
- [ ] Edit emotional state
- [ ] Edit body sensations
- [ ] Edit outcome text
- [ ] Toggle "Acted on craving" switch
- [ ] Save with valid data → success
- [ ] Save with intensity = 0 → validation error
- [ ] Save with "Select a location" → validation error
- [ ] Load non-existent craving_id → error dialog with retry
- [ ] Cancel edit → no changes saved

### Edge Cases
- [ ] Very long substance name (50+ chars)
- [ ] Multiple substances (5+ items)
- [ ] Special characters in text fields
- [ ] Empty optional fields
- [ ] Network timeout during save
- [ ] User edits craving created by another user (should fail)

## Troubleshooting

### Issue: "Craving not found"
**Cause:** `craving_id` doesn't exist or user doesn't own it  
**Fix:** Check database: `SELECT * FROM cravings WHERE craving_id = 'XXX' AND user_id = Y;`

### Issue: "Invalid craving ID"
**Cause:** `craving_id` is null or empty in entry data  
**Fix:** Verify ActivityService returns `craving_id` field in craving objects

### Issue: Form fields empty after load
**Cause:** Data parsing failed or DB fields are null  
**Fix:** Check console logs for "DEBUG EditCravingPage" messages showing loaded values

### Issue: Save fails with permission error
**Cause:** `user_id` doesn't match craving owner  
**Fix:** Verify `UserService.getCurrentUserId()` returns correct user

## Future Enhancements

1. **Offline Support**: Cache cravings for offline editing
2. **Validation UI**: Show inline errors instead of dialogs
3. **Auto-save**: Save draft changes automatically
4. **History**: Show edit history for craving
5. **Bulk Edit**: Select and edit multiple cravings
6. **Templates**: Save common craving patterns as templates
7. **Triggers Field**: Add UI for selecting/editing triggers
8. **Secondary Emotions**: Support for secondary emotion selection
9. **Date/Time Edit**: Allow changing when craving occurred
10. **Delete**: Add ability to delete craving from edit page

## Related Files
- `lib/screens/cravings_page.dart` - Create new craving
- `lib/models/craving_model.dart` - Craving data model
- `lib/services/craving_service.dart` - Database operations
- `lib/widgets/cravings/*.dart` - Reusable form sections
- `lib/utils/error_handler.dart` - Error UI utilities

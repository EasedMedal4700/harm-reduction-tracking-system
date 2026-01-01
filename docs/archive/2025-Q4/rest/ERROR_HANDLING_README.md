# Error Handling System Documentation

## Overview
This project now includes comprehensive error handling for reflection editing functionality. The system is organized into separate files for maintainability.

## Error Handling Files

### 1. `lib/utils/error_handler.dart`
Central error handler with UI and logging utilities.

**Key Functions:**
- `showErrorDialog()` - Display detailed error dialogs with retry option
- `showErrorSnackbar()` - Show brief error notifications
- `showSuccessSnackbar()` - Show success notifications
- `logError()`, `logWarning()`, `logInfo()`, `logDebug()` - Console logging with context

**Usage Example:**
```dart
try {
  await someOperation();
  ErrorHandler.showSuccessSnackbar(context, message: 'Operation successful!');
} catch (e) {
  ErrorHandler.logError('ComponentName', e);
  ErrorHandler.showErrorDialog(
    context,
    title: 'Operation Failed',
    message: 'Could not complete operation',
    details: e.toString(),
    onRetry: () => someOperation(),
  );
}
```

### 2. `lib/utils/reflection_exceptions.dart`
Custom exception classes for reflection operations.

**Exception Types:**
- `ReflectionException` - Base exception class
- `ReflectionNotFoundException` - When reflection ID doesn't exist
- `ReflectionValidationException` - When validation fails (with field-level errors)
- `ReflectionSaveException` - When saving/updating fails
- `ReflectionFetchException` - When fetching fails
- `ReflectionParseException` - When JSON parsing fails
- `DatabaseConnectionException` - When DB connection fails

**Usage Example:**
```dart
if (!foundInDB) {
  throw ReflectionNotFoundException(reflectionId);
}

if (validationErrors.isNotEmpty) {
  throw ReflectionValidationException(validationErrors);
}
```

### 3. `lib/utils/reflection_validator.dart`
Validation logic for reflection data.

**Key Functions:**
- `validateReflection(ReflectionModel)` - Validates all fields, throws ReflectionValidationException if invalid
- `validateRawData(Map<String, dynamic>)` - Validates JSON before parsing
- `isValidReflectionId(String?)` - Checks if ID is valid integer
- `sanitizeNotes(String?)` - Cleans up note text
- `validateRelatedEntries(dynamic)` - Ensures related entries list is properly formatted

**Validation Rules:**
- effectiveness: 0-10
- sleepHours: 0-24
- sleepQuality: Must be 'Poor', 'Fair', 'Good', or 'Excellent'
- energyLevel: Must be 'Low', 'Neutral', or 'High'
- postUseCraving: 0-10
- copingEffectiveness: 0-10
- overallSatisfaction: 0-10

## Updated Files with Error Handling

### `lib/services/reflection_service.dart`
**Changes:**
- Added comprehensive try-catch blocks
- Validates IDs before queries
- Logs all operations (debug, info, error)
- Throws specific exceptions instead of generic errors
- Returns detailed error context

**Methods Updated:**
- `getNextReflectionId()` - Logs fetch attempts, defaults to 1 on error
- `saveReflection()` - Validates user auth, logs save success/failure
- `updateReflection()` - Validates ID, checks response, throwsNotFoundException if not found
- `fetchReflectionById()` - Validates ID, logs raw DB results, validates data before parsing

### `lib/screens/edit/edit_refelction_page.dart`
**Changes:**
- Wraps async operations in try-catch
- Displays error dialogs with retry functionality
- Validates model before saving
- Prevents double-save with state check
- Shows success feedback on save

**Methods Updated:**
- `_loadFullEntry()` - Catches ReflectionException and generic errors separately
- `_saveChanges()` - Validates before save, handles validation errors, provides retry option

### `lib/models/reflection_model.dart`
**Changes:**
- Enhanced `fromJson()` with detailed logging
- Logs every field parsing attempt
- Catches and reports parsing errors with context
- Throws ReflectionParseException with raw data for debugging

## Troubleshooting Guide

### Issue: "Reflecting on 0 selected entries"

**Diagnostic Steps:**
1. Run the app in debug mode
2. Navigate to Activity → Recent Reflections → tap a reflection → Edit
3. Check console output for these log messages:

```
🔍 DEBUG [ReflectionService]: Fetching reflection by ID: {id}
🔍 DEBUG [ReflectionService]: Query params - original_id: X, parsed_id: Y
🔍 DEBUG [ReflectionService]: Raw DB result: {full row data}
🔍 DEBUG [ReflectionModel]: Raw field values: {related_entries, selected_reflections, reflections}
🔍 DEBUG [ReflectionModel]: Parsed selectedReflections: [...] (count: N)
```

**Common Causes & Fixes:**

| Symptom | Cause | Solution |
|---------|-------|----------|
| Raw DB result is null | Invalid reflection_id or doesn't exist | Check DB for row with that reflection_id |
| related_entries is null | Never saved to DB | Check save logic in ReflectionProvider |
| related_entries is empty array `[]` | Saved with no entries | Verify entries are selected before saving |
| related_entries is string | Wrong data type | Fix DB column type to JSONB array |
| Parsed count is 0 but raw has data | Parsing issue | Check _toList() handles the data format |

### Issue: "Failed to Load Reflection"

**Error Dialog Details:**
- **Invalid reflection ID** - The ID is not a valid integer
- **No reflection found** - The reflection_id doesn't exist in DB
- **Validation failed** - Required fields missing in DB row

**Fix:**
1. Verify reflection exists: `SELECT * FROM reflections WHERE reflection_id = X;`
2. Check user ownership: `WHERE user_id = Y AND reflection_id = X`
3. Ensure created_at field exists

### Issue: "Validation Error" on Save

**Possible Causes:**
- effectiveness not between 0-10
- sleepHours not between 0-24
- sleepQuality not in ['Poor', 'Fair', 'Good', 'Excellent']
- energyLevel not in ['Low', 'Neutral', 'High']

**Fix:**
Check error dialog details - it will list all invalid fields and expected values.

### Issue: Console shows unexpected data type

**Example:** `related_entries has unexpected type: _InternalLinkedHashMap`

**Likely Cause:** Supabase returns JSONB as nested object instead of array

**Fix:**
Update `_toList()` in `reflection_model.dart` to handle Map type:
```dart
if (v is Map) {
  // Extract array from nested structure
  return v.values.toList()...
}
```

## Testing Error Handling

### Test Cases:

1. **Invalid ID Test**
   - Try loading reflection with ID "abc" (non-numeric)
   - Expected: Error dialog "Invalid reflection ID"

2. **Not Found Test**
   - Try loading reflection with ID "99999" (doesn't exist)
   - Expected: Error dialog "Reflection not found"

3. **Validation Test**
   - Set effectiveness to 15 (> 10)
   - Try to save
   - Expected: Validation error dialog

4. **Network Error Test**
   - Disable internet
   - Try to load reflection
   - Expected: Error dialog with retry button

5. **Parse Error Test**
   - Manually corrupt DB data (set related_entries to invalid JSON)
   - Try to load
   - Expected: Parse exception logged, error dialog shown

## Console Log Reference

### Log Levels:
- 🔍 **DEBUG**: Detailed diagnostic info (IDs, params, raw data)
- ℹ️  **INFO**: Successful operations (loaded, saved, updated)
- ⚠️  **WARNING**: Non-critical issues (defaults used, missing optional data)
- ❌ **ERROR**: Failures with context and stack trace

### Key Logs to Monitor:

**On Edit Page Load:**
```
🔍 DEBUG [EditReflectionPage]: Loading reflection with ID: X
🔍 DEBUG [ReflectionService]: Fetching reflection by ID: X
🔍 DEBUG [ReflectionService]: Raw DB result: {...}
🔍 DEBUG [ReflectionModel]: Raw field values: {...}
🔍 DEBUG [ReflectionModel]: Parsed selectedReflections: [...] (count: N)
ℹ️  INFO [ReflectionService]: Reflection fetched - ID: X, notes: true/false, selected_count: N
```

**On Save:**
```
🔍 DEBUG [EditReflectionPage]: Saving changes for reflection: X
🔍 DEBUG [EditReflectionPage]: Update data prepared with N fields
🔍 DEBUG [ReflectionService]: Updating reflection X with N fields
ℹ️  INFO [ReflectionService]: Reflection updated successfully: X
```

## Integration with Existing Code

The error handling system is **non-breaking**:
- Existing code without error handling still works
- New code can gradually adopt error handling
- UI components gracefully degrade if context not available

## Future Improvements

1. Add error tracking service (Sentry, Firebase Crashlytics)
2. Create error history log for debugging
3. Add network status detection
4. Implement offline queue for failed operations
5. Add error analytics dashboard

## Support

If issues persist after checking logs:
1. Copy all DEBUG/ERROR logs from console
2. Note steps to reproduce
3. Check database directly with SQL queries
4. Review this guide for similar issues

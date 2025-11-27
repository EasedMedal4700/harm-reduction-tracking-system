# Database Migration: user_id → auth_user_id

## Overview

This document details the migration from a dual-system user identification (local integer `user_id` + Supabase Auth UUID) to a unified UUID-based system using `auth_user_id` directly from Supabase Auth.

**Migration Date**: January 2025  
**Migration Type**: Breaking Change - Database Schema & Code

---

## What Changed

### Database Schema Changes

The following tables were migrated from `user_id` (integer) to `auth_user_id` (UUID):

1. **drug_use** - Drug use log entries
2. **cravings** - Craving records
3. **daily_checkins** - Daily mood/wellness check-ins
4. **reflections** - User reflections
5. **deleted_drug_use** - Soft-deleted drug use entries
6. **drug_presaves** - Pre-saved drug templates
7. **error_logs** - Application error logs

### Code Changes

**27+ files** were updated across the codebase:

#### Core Services (16 files)
- `blood_levels_service.dart`
- `personal_library_service.dart`
- `craving_service.dart`
- `log_entry_service.dart`
- `daily_checkin_service.dart`
- `reflection_service.dart`
- `analytics_service.dart`
- `activity_service.dart`
- `tolerance_service.dart`
- `tolerance_engine_service.dart`
- `cache_service.dart`
- And others...

#### UI Components (11 files)
- `tolerance_dashboard_page.dart`
- `system_tolerance_widget.dart`
- `system_tolerance_breakdown_sheet.dart`
- `activity_page.dart`
- `account_management_section.dart`
- And others...

#### Tests (1 file)
- `cache_service_test.dart`

---

## Migration Pattern

### Before (Old System)
```dart
// Method call - async, returns integer
final userId = await UserService.getIntegerUserId();

// Query filter
.eq('user_id', userId)

// Insert data
'user_id': userId

// Parameter type
int userId

// Cache key
CacheKeys.recentEntries(123)
```

### After (New System)
```dart
// Method call - synchronous, returns UUID string
final userId = UserService.getCurrentUserId();

// Query filter
.eq('auth_user_id', userId)

// Insert data
'auth_user_id': userId

// Parameter type
String userId

// Cache key
CacheKeys.recentEntries('550e8400-e29b-41d4-a716-446655440000')
```

---

## Why This Migration?

### Old Architecture Issues
1. **Dual System Complexity**: Maintained both Supabase Auth UUID and local integer ID
2. **Data Integrity Risk**: Required email-based linking between auth and users table
3. **Additional DB Calls**: Every operation needed to fetch integer user_id first
4. **Potential Race Conditions**: User creation could fail between auth and users table insert

### New Architecture Benefits
1. ✅ **Single Source of Truth**: UUID directly from Supabase Auth
2. ✅ **Better Security**: No email-based lookups, direct UUID matching
3. ✅ **Improved Performance**: One less database query per operation
4. ✅ **Simplified Code**: Synchronous user ID access via `getCurrentUserId()`
5. ✅ **Better Isolation**: UUIDs are globally unique, no collision risk

---

## Detailed Changes by Service

### 1. Authentication & User Management

**UserService**
- `getCurrentUserId()` now returns UUID string (synchronous)
- Removed `getIntegerUserId()` (async, deprecated)

### 2. Logging Services

**LogEntryService** (`drug_use` table)
- `saveLogEntry()`: Insert uses `'auth_user_id': userId`
- `updateLogEntry()`: Query uses `.eq('auth_user_id', userId)`
- `deleteLogEntry()`: Query uses `.eq('auth_user_id', userId)`
- `fetchRecentEntriesRaw()`: Filter uses `.eq('auth_user_id', userId)`

**CravingService** (`cravings` table)
- `saveCraving()`: Insert uses `'auth_user_id': userId`
- `updateCraving()`: Query uses `.eq('auth_user_id', userId)`
- `fetchCravingById()`: Filter uses `.eq('auth_user_id', userId)`

**DailyCheckinService** (`daily_checkins` table)
- ALL 6 methods updated (save, update, fetch*, delete)
- All queries now use `.eq('auth_user_id', userId)`

**ReflectionService** (`reflections` table)
- `saveReflection()`: Insert uses `'auth_user_id': userId`
- `updateReflection()`: Query uses `.eq('auth_user_id', userId)`

### 3. Analysis Services

**BloodLevelsService**
- `calculateLevels()`: Fetches doses with `auth_user_id` filter
- `getDosesForTimeline()`: Same changes
- `getDrugsInTimelineWindow()`: Same changes

**AnalyticsService**
- `fetchEntries()`: Uses `getCurrentUserId()` and `auth_user_id` filter

**ActivityService**
- `fetchRecentActivity()`: All 3 table queries (drug_use, cravings, reflections) updated

### 4. Tolerance System

**ToleranceService**
- `fetchUserSubstances(String userId)`: Parameter changed from `int` to `String`
- `fetchUseEvents()`: Parameter changed, query uses `auth_user_id`

**ToleranceEngineService**
- ALL methods updated: `int userId` → `String userId`
- ALL queries updated: `'user_id'` → `'auth_user_id'`
- Methods: `computeSystemTolerance`, `fetchUseLogs`, `getBucketBreakdown`, etc.

### 5. Personal Library

**PersonalLibraryService**
- `_loadDatabaseEntries()`: Uses `getCurrentUserId()` and `auth_user_id`

### 6. Cache System

**CacheService**
- Updated `CacheKeys` class to accept `String userId` instead of `int userId`
- Methods changed:
  - `userDrugEntries(String userId)`
  - `recentEntries(String userId)`
  - `dailyCheckins(String userId)`
  - `dailyCheckin(String userId, ...)`
  - `userCravings(String userId)`
  - `clearUserCache(String userId)`

### 7. Account Management

**AccountManagementSection**
- `_downloadUserData()`: Uses `getCurrentUserId()`, queries all tables with `auth_user_id`
- `_deleteUserData()`: Same changes
- `_deleteAccount()`: Deletes from all tables using `auth_user_id`, then auth user

---

## Testing

### Integration Tests

Created comprehensive integration test suite: `integration_test/logging_flow_test.dart`

**Test Coverage:**
- ✅ Drug use logging with `auth_user_id`
- ✅ Craving logging with `auth_user_id`
- ✅ Daily checkin logging with `auth_user_id`
- ✅ Reflection logging with `auth_user_id`
- ✅ Data isolation between users (critical security test)

**Test Groups:**
1. **Drug Use**: Save, update, delete operations
2. **Cravings**: Save and update operations
3. **Daily Checkins**: Save and update operations
4. **Reflections**: Save and update operations
5. **Data Isolation**: Multi-user verification

### Running Tests

```bash
# Run integration tests
flutter test integration_test/logging_flow_test.dart

# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## Security Improvements

### Data Isolation
All queries now enforce strict user isolation using UUID:

```dart
// Old - potential security risk with integer IDs
.eq('user_id', 123)

// New - globally unique UUID, better isolation
.eq('auth_user_id', '550e8400-e29b-41d4-a716-446655440000')
```

### Benefits
1. **No Collision Risk**: UUIDs are globally unique
2. **Direct Auth Link**: No intermediate email-based lookup
3. **Type Safety**: String UUIDs vs integers less prone to mistakes
4. **Audit Trail**: UUID matches Supabase Auth records exactly

---

## Breaking Changes

⚠️ **This is a breaking change**. Old code using `user_id` will fail with:
```
column "user_id" does not exist
```

### Migration Checklist
- ✅ Update all database queries to use `auth_user_id`
- ✅ Change method calls from `getIntegerUserId()` to `getCurrentUserId()`
- ✅ Update parameter types from `int userId` to `String userId`
- ✅ Update cache keys to use String UUIDs
- ✅ Update all insert statements to use `'auth_user_id'`
- ✅ Update tests to use UUID strings instead of integers
- ✅ Run integration tests to verify data isolation
- ✅ Test with multiple accounts to ensure security

---

## Rollback Plan

If rollback is needed (not recommended):

1. **Database**: Restore `user_id` column in all tables
2. **Code**: Revert all 27+ files to use `user_id`
3. **Auth**: Re-enable `getIntegerUserId()` method
4. **Cache**: Revert CacheKeys to accept int

⚠️ **Note**: Rolling back is complex due to the scope of changes. Better to fix forward.

---

## Performance Impact

### Improvements
- ⚡ **Fewer DB Calls**: No more double-lookup (auth UUID → integer user_id)
- ⚡ **Faster Auth**: Synchronous `getCurrentUserId()` vs async `getIntegerUserId()`
- ⚡ **Better Caching**: UUID-based cache keys more reliable

### Considerations
- UUID columns slightly larger than integers (36 bytes vs 4 bytes)
- Negligible impact for application scale

---

## Future Considerations

### Deprecated Code
The following are now deprecated:
- ❌ `UserService.getIntegerUserId()` - Use `getCurrentUserId()` instead
- ❌ Integer-based cache keys - Use String UUID keys
- ❌ `'user_id'` column references - Use `'auth_user_id'`

### Maintenance
- Keep all queries using `auth_user_id`
- Always use `getCurrentUserId()` for user identification
- Update any new features to use UUID from the start
- Maintain test coverage for data isolation

---

## Summary

This migration unified user identification to use Supabase Auth UUIDs directly, eliminating complexity and improving security. All 27+ files were updated to use `auth_user_id` instead of `user_id`, with comprehensive testing to ensure data isolation works correctly.

**Status**: ✅ Complete  
**Test Coverage**: ✅ Integration tests created  
**Security**: ✅ Data isolation verified  
**Performance**: ✅ Improved (fewer DB calls)

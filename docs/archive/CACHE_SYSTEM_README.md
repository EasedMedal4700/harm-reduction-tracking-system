# Cache System Documentation

## Overview
The app now includes a comprehensive caching system to improve performance and reduce database queries. The cache system automatically stores frequently accessed data in memory with configurable expiration times.

## Architecture

### CacheService
Central service that manages all caching operations. Uses a singleton pattern for app-wide access.

**Location:** `lib/services/cache_service.dart`

### Cache TTL (Time To Live) Configurations
- **Short TTL (5 minutes)**: Search results, frequently changing data
- **Default TTL (15 minutes)**: Most common operations
- **Long TTL (1 hour)**: Static data like drug names, user profiles

## Cached Data Types

### 1. Drug Profiles
**Service:** `DrugProfileService`
- All drug names list (Long TTL)
- Drug search results (Short TTL)
- Individual drug profile data

**Cache Keys:**
```dart
CacheKeys.allDrugNames                    // List of all drugs
'drug_search:$query'                      // Search results
CacheKeys.drugProfile('drugName')         // Individual profile
```

**Invalidation:** Clear when new drugs are added to database
```dart
CacheKeys.clearDrugCache();
```

### 2. User Data
**Service:** `UserService`
- Current user ID (Long TTL)
- Admin status (Long TTL)
- User profile data (Long TTL)

**Cache Keys:**
```dart
CacheKeys.currentUserId
CacheKeys.currentUserIsAdmin
CacheKeys.currentUserData
```

**Invalidation:** Automatically cleared on logout
```dart
UserService.clearCache();
```

### 3. Drug Use Entries
**Service:** `LogEntryService`
- Recent entries list (Default TTL)
- Individual entry details

**Cache Keys:**
```dart
CacheKeys.recentEntries(userId)
CacheKeys.drugEntry(entryId)
CacheKeys.userDrugEntries(userId)
```

**Invalidation:** Cleared when entries are added, updated, or deleted

### 4. Daily Check-ins
**Service:** `DailyCheckinService`
- Daily check-ins by date
- Check-in for specific time of day

**Cache Keys:**
```dart
CacheKeys.dailyCheckins(userId)
CacheKeys.dailyCheckin(userId, date, timeOfDay)
```

**Invalidation:** Cleared when check-ins are saved or updated

### 5. Admin Data
**Service:** `AdminService` (when implemented)
- All users list
- System statistics

**Cache Keys:**
```dart
CacheKeys.allUsers
CacheKeys.systemStats
```

## Usage Examples

### Basic Cache Operations

```dart
final cache = CacheService();

// Get cached data
final data = cache.get<List<String>>('my_key');

// Set cached data with default TTL
cache.set('my_key', myData);

// Set cached data with custom TTL
cache.set('my_key', myData, ttl: Duration(minutes: 30));

// Remove specific cache
cache.remove('my_key');

// Remove by pattern (all matching keys)
cache.removePattern('drug_');

// Clear all cache
cache.clearAll();

// Clear expired entries
cache.clearExpired();

// Check if cache has valid entry
if (cache.has('my_key')) {
  // Cache exists and not expired
}
```

### Service Integration Pattern

```dart
class MyService {
  final _cache = CacheService();
  
  Future<List<Data>> fetchData() async {
    // 1. Check cache first
    final cached = _cache.get<List<Data>>('data_key');
    if (cached != null) {
      return cached;
    }
    
    // 2. Fetch from database
    final data = await database.query();
    
    // 3. Store in cache
    _cache.set('data_key', data, ttl: CacheService.defaultTTL);
    
    return data;
  }
  
  Future<void> updateData(Data newData) async {
    // Update database
    await database.update(newData);
    
    // Invalidate cache
    _cache.remove('data_key');
  }
}
```

## Cache Invalidation Strategy

### When to Invalidate

1. **Create Operations**: Clear related list caches
2. **Update Operations**: Clear specific item and list caches
3. **Delete Operations**: Clear specific item and list caches
4. **User Logout**: Clear all user-specific caches
5. **Data Import**: Clear all relevant caches

### Invalidation Examples

```dart
// After saving a new drug entry
_cache.remove(CacheKeys.recentEntries(userId));
_cache.removePattern('drug_entries:user:$userId');

// After updating user profile
_cache.remove(CacheKeys.currentUserData);

// On logout
UserService.clearCache();
CacheKeys.clearUserCache(userId);
```

## Performance Benefits

### Before Caching
- Every screen load triggers database queries
- Search performs DB query for each keystroke
- User data fetched multiple times per session

### After Caching
- ✅ Repeated data access is instant (memory)
- ✅ Search results cached for 5 minutes
- ✅ User data cached for entire session
- ✅ Reduced Supabase API calls = lower costs
- ✅ Better offline experience (data survives short disconnections)

## Monitoring & Debugging

### Get Cache Statistics
```dart
final stats = CacheService().getStats();
print('Total entries: ${stats['total_entries']}');
print('Active entries: ${stats['active_entries']}');
print('Expired entries: ${stats['expired_entries']}');
```

### Debug Cache Hits/Misses
Services already include debug logging:
```
DEBUG [DrugProfileService]: Cache hit for all drug names
DEBUG [DrugProfileService]: Searching for: methylphenidate
```

## Best Practices

### DO:
✅ Cache data that's read frequently
✅ Use appropriate TTL for data volatility
✅ Invalidate cache after write operations
✅ Clear user-specific cache on logout
✅ Use pattern matching for bulk invalidation

### DON'T:
❌ Cache sensitive data without encryption
❌ Set very long TTLs for frequently changing data
❌ Forget to invalidate after updates
❌ Cache large objects (>1MB per entry)
❌ Use cache as permanent storage

## Future Enhancements

Potential improvements for the cache system:

1. **Persistent Cache**: Save cache to disk for app restarts
2. **Size Limits**: Implement max cache size with LRU eviction
3. **Cache Warming**: Pre-load common data on app start
4. **Analytics**: Track cache hit/miss rates
5. **Encrypted Cache**: For sensitive user data
6. **Background Refresh**: Auto-refresh expiring cache entries

## Troubleshooting

### Cache Not Working?
1. Check if cache key is correct
2. Verify TTL hasn't expired
3. Ensure cache isn't cleared prematurely
4. Check for pattern matching conflicts

### Stale Data Issues?
1. Verify invalidation after updates
2. Reduce TTL for volatile data
3. Add manual refresh option in UI
4. Clear cache on version updates

### Memory Concerns?
1. Call `clearExpired()` periodically
2. Reduce TTL for large data sets
3. Implement size limits
4. Clear cache on low memory warnings

## Testing

The cache system is designed to work seamlessly with tests:

```dart
// In tests, cache automatically works with mocked data
final cache = CacheService();
cache.set('test_key', testData);

// Clear cache between tests
setUp(() {
  CacheService().clearAll();
});
```

## Migration Notes

All services have been updated to use caching:
- ✅ DrugProfileService
- ✅ UserService
- ✅ LogEntryService
- ✅ DailyCheckinService

No breaking changes - caching is transparent to calling code.

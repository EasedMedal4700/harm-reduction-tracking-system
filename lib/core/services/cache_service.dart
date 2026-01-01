// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'performance_service.dart';

/// Central cache service for managing app data caching
/// Reduces database queries and improves performance
class CacheService {
  // Singleton pattern
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();
  // Cache storage
  final Map<String, _CacheEntry> _cache = {};
  // Cache configuration
  static const Duration defaultTTL = Duration(minutes: 15);
  static const Duration shortTTL = Duration(minutes: 5);
  static const Duration longTTL = Duration(hours: 1);

  /// Get cached data
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) {
      // Cache miss - record it
      PerformanceService.recordCacheEvent(key: key, hit: false);
      return null;
    }
    // Check if cache expired
    if (entry.isExpired) {
      _cache.remove(key);
      // Cache miss (expired) - record it
      PerformanceService.recordCacheEvent(key: key, hit: false);
      return null;
    }
    // Cache hit - record it
    PerformanceService.recordCacheEvent(key: key, hit: true);
    // Safe type cast - return null if type doesn't match
    try {
      return entry.data as T?;
    } catch (e) {
      return null;
    }
  }

  /// Set cache data with optional TTL
  void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = _CacheEntry(
      data: data,
      expiresAt: DateTime.now().add(ttl ?? defaultTTL),
    );
  }

  /// Remove specific cache entry
  void remove(String key) {
    _cache.remove(key);
  }

  /// Remove all cache entries matching a pattern
  void removePattern(String pattern) {
    final keysToRemove = _cache.keys
        .where((key) => key.contains(pattern))
        .toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  /// Clear all cache
  void clearAll() {
    _cache.clear();
  }

  /// Clear expired entries
  void clearExpired() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getStats() {
    return {
      'total_entries': _cache.length,
      'expired_entries': _cache.values.where((e) => e.isExpired).length,
      'active_entries': _cache.values.where((e) => !e.isExpired).length,
    };
  }

  /// Check if cache has valid entry
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }
}

/// Internal cache entry class
class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;
  _CacheEntry({required this.data, required this.expiresAt});
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Cache keys constants
class CacheKeys {
  // Drug profiles
  static String drugProfile(String drugName) => 'drug_profile:$drugName';
  static const String allDrugNames = 'drug_names:all';
  // User data
  static const String currentUserData = 'user:current';
  static const String currentUserId = 'user:id';
  static const String currentUserIsAdmin = 'user:is_admin';
  // Drug use entries - now using UUID strings
  static String userDrugEntries(String userId) => 'drug_entries:user:$userId';
  static String drugEntry(String entryId) => 'drug_entry:$entryId';
  static String recentEntries(String userId) => 'recent_entries:user:$userId';
  // Daily check-ins - now using UUID strings
  static String dailyCheckins(String userId) => 'daily_checkins:user:$userId';
  static String dailyCheckin(String userId, String date, String timeOfDay) =>
      'daily_checkin:$userId:$date:$timeOfDay';
  // Cravings - now using UUID strings
  static String userCravings(String userId) => 'cravings:user:$userId';
  static String craving(String cravingId) => 'craving:$cravingId';
  // Admin data
  static const String allUsers = 'admin:users:all';
  static const String systemStats = 'admin:stats';
  // Location and settings
  static const String locationsList = 'locations:all';
  // Clear all user-specific cache - now using UUID strings
  static void clearUserCache(String userId) {
    final cache = CacheService();
    cache.removePattern('user:$userId');
    cache.removePattern(':user:$userId');
  }

  // Clear all drug-related cache
  static void clearDrugCache() {
    final cache = CacheService();
    cache.removePattern('drug_profile:');
    cache.remove(allDrugNames);
  }
}

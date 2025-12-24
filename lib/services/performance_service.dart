import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for tracking app performance metrics (admin-only)
class PerformanceService {
  static const String _keyPerformanceData = 'performance_metrics';
  static const String _keyCacheStats = 'cache_statistics';
  static const int _maxSamples = 1000; // Keep last 1000 samples
  /// Record a network request response time
  static Future<void> recordResponseTime({
    required String endpoint,
    required int milliseconds,
    required bool fromCache,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = prefs.getString(_keyPerformanceData);
      Map<String, dynamic> data = dataJson != null
          ? json.decode(dataJson) as Map<String, dynamic>
          : {};
      List<dynamic> samples = data['response_times'] ?? [];
      samples.add({
        'endpoint': endpoint,
        'ms': milliseconds,
        'cached': fromCache,
        'timestamp': DateTime.now().toIso8601String(),
      });
      // Keep only recent samples
      if (samples.length > _maxSamples) {
        samples = samples.sublist(samples.length - _maxSamples);
      }
      data['response_times'] = samples;
      await prefs.setString(_keyPerformanceData, json.encode(data));
    } catch (e) {
      // Silent fail for performance tracking
    }
  }

  /// Record cache hit or miss
  static Future<void> recordCacheEvent({
    required String key,
    required bool hit,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = prefs.getString(_keyCacheStats);
      Map<String, dynamic> data = dataJson != null
          ? json.decode(dataJson) as Map<String, dynamic>
          : {'hits': 0, 'misses': 0, 'total_requests': 0};
      data['total_requests'] = (data['total_requests'] ?? 0) + 1;
      if (hit) {
        data['hits'] = (data['hits'] ?? 0) + 1;
      } else {
        data['misses'] = (data['misses'] ?? 0) + 1;
      }
      data['last_updated'] = DateTime.now().toIso8601String();
      await prefs.setString(_keyCacheStats, json.encode(data));
    } catch (e) {
      // Silent fail
    }
  }

  /// Get performance statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get response time data
      final dataJson = prefs.getString(_keyPerformanceData);
      final cacheJson = prefs.getString(_keyCacheStats);
      Map<String, dynamic> perfData = dataJson != null
          ? json.decode(dataJson) as Map<String, dynamic>
          : {};
      Map<String, dynamic> cacheData = cacheJson != null
          ? json.decode(cacheJson) as Map<String, dynamic>
          : {'hits': 0, 'misses': 0, 'total_requests': 0};
      List<dynamic> samples = perfData['response_times'] ?? [];
      // Calculate average response time
      double avgResponseTime = 0.0;
      double avgCachedTime = 0.0;
      double avgUncachedTime = 0.0;
      int cachedCount = 0;
      int uncachedCount = 0;
      if (samples.isNotEmpty) {
        for (var sample in samples) {
          final ms = sample['ms'] ?? 0;
          avgResponseTime += ms;
          if (sample['cached'] == true) {
            avgCachedTime += ms;
            cachedCount++;
          } else {
            avgUncachedTime += ms;
            uncachedCount++;
          }
        }
        avgResponseTime /= samples.length;
        if (cachedCount > 0) avgCachedTime /= cachedCount;
        if (uncachedCount > 0) avgUncachedTime /= uncachedCount;
      }
      // Calculate cache hit rate
      int totalRequests = cacheData['total_requests'] ?? 0;
      int hits = cacheData['hits'] ?? 0;
      double hitRate = totalRequests > 0 ? (hits / totalRequests) * 100 : 0.0;
      return {
        'avg_response_time': avgResponseTime,
        'avg_cached_response': avgCachedTime,
        'avg_uncached_response': avgUncachedTime,
        'total_samples': samples.length,
        'cache_hit_rate': hitRate,
        'cache_hits': hits,
        'cache_misses': cacheData['misses'] ?? 0,
        'cache_total_requests': totalRequests,
        'last_updated': cacheData['last_updated'],
      };
    } catch (e) {
      return {
        'avg_response_time': 0.0,
        'cache_hit_rate': 0.0,
        'error': e.toString(),
      };
    }
  }

  /// Clear all performance data
  static Future<void> clearData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyPerformanceData);
      await prefs.remove(_keyCacheStats);
    } catch (e) {
      // Silent fail
    }
  }
}

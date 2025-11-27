import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/cache_service.dart';

void main() {
  late CacheService cache;

  setUp(() {
    cache = CacheService();
    cache.clearAll(); // Start with clean cache
  });

  group('CacheService Basic Operations', () {
    test('should store and retrieve data', () {
      cache.set('test_key', 'test_value');
      final result = cache.get<String>('test_key');
      expect(result, equals('test_value'));
    });

    test('should return null for non-existent key', () {
      final result = cache.get<String>('non_existent');
      expect(result, isNull);
    });

    test('should remove specific cache entry', () {
      cache.set('key1', 'value1');
      cache.set('key2', 'value2');
      
      cache.remove('key1');
      
      expect(cache.get<String>('key1'), isNull);
      expect(cache.get<String>('key2'), equals('value2'));
    });

    test('should clear all cache entries', () {
      cache.set('key1', 'value1');
      cache.set('key2', 'value2');
      
      cache.clearAll();
      
      expect(cache.get<String>('key1'), isNull);
      expect(cache.get<String>('key2'), isNull);
    });
  });

  group('CacheService Pattern Matching', () {
    test('should remove entries matching pattern', () {
      cache.set('user:123:data', 'data1');
      cache.set('user:123:profile', 'profile1');
      cache.set('drug:aspirin', 'aspirin_data');
      
      cache.removePattern('user:123');
      
      expect(cache.get<String>('user:123:data'), isNull);
      expect(cache.get<String>('user:123:profile'), isNull);
      expect(cache.get<String>('drug:aspirin'), equals('aspirin_data'));
    });
  });

  group('CacheService Expiration', () {
    test('should expire cache after TTL', () async {
      cache.set(
        'expiring_key',
        'value',
        ttl: const Duration(milliseconds: 100),
      );
      
      // Should exist immediately
      expect(cache.get<String>('expiring_key'), equals('value'));
      
      // Wait for expiration
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Should be expired
      expect(cache.get<String>('expiring_key'), isNull);
    });

    test('should clear only expired entries', () async {
      cache.set(
        'short_lived',
        'value1',
        ttl: const Duration(milliseconds: 50),
      );
      cache.set(
        'long_lived',
        'value2',
        ttl: const Duration(seconds: 10),
      );
      
      // Wait for first to expire
      await Future.delayed(const Duration(milliseconds: 100));
      
      cache.clearExpired();
      
      expect(cache.get<String>('short_lived'), isNull);
      expect(cache.get<String>('long_lived'), equals('value2'));
    });
  });

  group('CacheService Type Safety', () {
    test('should handle different data types', () {
      cache.set('string', 'text');
      cache.set('int', 42);
      cache.set('list', [1, 2, 3]);
      cache.set('map', {'key': 'value'});
      
      expect(cache.get<String>('string'), equals('text'));
      expect(cache.get<int>('int'), equals(42));
      expect(cache.get<List<int>>('list'), equals([1, 2, 3]));
      expect(cache.get<Map<String, String>>('map'), equals({'key': 'value'}));
    });

    test('should return null for wrong type cast', () {
      cache.set('string_value', 'text');
      
      // Trying to get as wrong type returns null
      final result = cache.get<int>('string_value');
      expect(result, isNull);
    });
  });

  group('CacheService Statistics', () {
    test('should provide accurate stats', () async {
      cache.set('key1', 'value1', ttl: const Duration(milliseconds: 50));
      cache.set('key2', 'value2', ttl: const Duration(seconds: 10));
      cache.set('key3', 'value3', ttl: const Duration(seconds: 10));
      
      var stats = cache.getStats();
      expect(stats['total_entries'], equals(3));
      expect(stats['active_entries'], equals(3));
      expect(stats['expired_entries'], equals(0));
      
      // Wait for one to expire
      await Future.delayed(const Duration(milliseconds: 100));
      
      stats = cache.getStats();
      expect(stats['total_entries'], equals(3));
      expect(stats['active_entries'], equals(2));
      expect(stats['expired_entries'], equals(1));
    });
  });

  group('CacheService Has Method', () {
    test('should correctly check cache existence', () async {
      cache.set('valid_key', 'value');
      cache.set('expiring_key', 'value', ttl: const Duration(milliseconds: 50));
      
      expect(cache.has('valid_key'), isTrue);
      expect(cache.has('non_existent'), isFalse);
      expect(cache.has('expiring_key'), isTrue);
      
      // Wait for expiration
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(cache.has('expiring_key'), isFalse);
    });
  });

  group('CacheKeys Helpers', () {
    test('should generate correct cache keys', () {
      expect(CacheKeys.drugProfile('aspirin'), equals('drug_profile:aspirin'));
      expect(CacheKeys.recentEntries('user-123-uuid'), equals('recent_entries:user:user-123-uuid'));
      expect(
        CacheKeys.dailyCheckin('user-123-uuid', '2025-01-01', 'morning'),
        equals('daily_checkin:user-123-uuid:2025-01-01:morning'),
      );
    });

    test('should clear user cache by pattern', () {
      cache.set('drug_entries:user:user-123-uuid', 'data1');
      cache.set('recent_entries:user:user-123-uuid', 'data2');
      cache.set('drug_entries:user:user-456-uuid', 'data3');
      
      CacheKeys.clearUserCache('user-123-uuid');
      
      expect(cache.get('drug_entries:user:user-123-uuid'), isNull);
      expect(cache.get('recent_entries:user:user-123-uuid'), isNull);
      expect(cache.get('drug_entries:user:user-456-uuid'), equals('data3'));
    });

    test('should clear drug cache', () {
      cache.set(CacheKeys.allDrugNames, ['aspirin', 'ibuprofen']);
      cache.set(CacheKeys.drugProfile('aspirin'), 'profile_data');
      cache.set('unrelated_key', 'value');
      
      CacheKeys.clearDrugCache();
      
      expect(cache.get(CacheKeys.allDrugNames), isNull);
      expect(cache.get(CacheKeys.drugProfile('aspirin')), isNull);
      expect(cache.get('unrelated_key'), equals('value'));
    });
  });
}

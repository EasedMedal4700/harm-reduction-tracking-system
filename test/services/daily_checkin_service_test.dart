import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/daily_checkin_model.dart';
import 'package:mobile_drug_use_app/services/cache_service.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/services/daily_checkin_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'daily_checkin_service_test.mocks.dart';

@GenerateMocks([SupabaseClient, SupabaseQueryBuilder, CacheService])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockCacheService mockCacheService;
  late DailyCheckinService service;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockCacheService = MockCacheService();

    service = DailyCheckinService(
      client: mockSupabaseClient,
      cache: mockCacheService,
      getUserId: () => 'user123',
    );
  });

  group('DailyCheckinService', () {
    test('fetchCheckinsByDate returns checkins', () async {
      final date = DateTime(2023, 10, 27);
      final mockData = [
        {
          'id': '1',
          'uuid_user_id': 'user123',
          'checkin_date': '2023-10-27',
          'mood': 'Happy',
          'emotions': ['Joy'],
          'time_of_day': 'Morning',
          'notes': 'Good day',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];

      final fakeBuilder = FakePostgrestBuilder<List<Map<String, dynamic>>>(
        mockData,
      );

      when(
        mockSupabaseClient.from('daily_checkins'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.select()).thenAnswer((_) => fakeBuilder);

      final result = await service.fetchCheckinsByDate(date);

      expect(result.length, 1);
      expect(result.first.mood, 'Happy');
    });

    test('saveCheckin inserts data and invalidates cache', () async {
      final checkin = DailyCheckin(
        id: '1',
        userId: 'user123',
        checkinDate: DateTime(2023, 10, 27),
        mood: 'Happy',
        emotions: ['Joy'],
        timeOfDay: 'Morning',
        notes: 'Good day',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final fakeBuilder = FakePostgrestBuilder<dynamic>(null);

      when(
        mockSupabaseClient.from('daily_checkins'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.insert(any)).thenAnswer((_) => fakeBuilder);

      await service.saveCheckin(checkin);

      verify(mockCacheService.removePattern('daily_checkin')).called(1);
    });
  });
}

// Fake implementation
class FakePostgrestBuilder<T> extends Fake
    implements PostgrestFilterBuilder<T>, PostgrestTransformBuilder<T> {
  final T _data;
  FakePostgrestBuilder(this._data);

  @override
  PostgrestFilterBuilder<T> eq(String column, Object value) => this;

  @override
  PostgrestFilterBuilder<T> not(
    String column,
    String operator,
    Object? value,
  ) => this;

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) {
    return this as PostgrestTransformBuilder<List<Map<String, dynamic>>>;
  }

  @override
  PostgrestFilterBuilder<T> ilike(String column, String pattern) => this;

  @override
  PostgrestFilterBuilder<T> gte(String column, Object value) => this;

  @override
  PostgrestFilterBuilder<T> lte(String column, Object value) => this;

  @override
  PostgrestFilterBuilder<T> or(String filters, {String? referencedTable}) =>
      this;

  @override
  PostgrestTransformBuilder<T> order(
    String column, {
    bool ascending = true,
    bool nullsFirst = false,
    String? referencedTable,
  }) => this;

  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() {
    dynamic singleData;
    if (_data is List) {
      singleData = (_data as List).isNotEmpty ? (_data as List).first : null;
    } else {
      singleData = _data;
    }
    return FakePostgrestBuilder<Map<String, dynamic>?>(singleData);
  }

  PostgrestFilterBuilder<T> delete({bool count = false, String? returning}) =>
      this;

  PostgrestFilterBuilder<T> update(
    Map<String, dynamic> values, {
    bool count = false,
    String? returning,
  }) => this;

  PostgrestFilterBuilder<T> insert(
    dynamic values, {
    bool count = false,
    String? returning,
  }) => this;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) async {
    return onValue(_data);
  }
}

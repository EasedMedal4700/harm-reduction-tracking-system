import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/tolerance_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tolerance_service_test.mocks.dart';

@GenerateMocks([SupabaseClient, SupabaseQueryBuilder])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late ToleranceService service;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    service = ToleranceService(client: mockSupabaseClient);
  });

  group('ToleranceService', () {
    test('fetchUserSubstances returns sorted list of substances', () async {
      const userId = 'user123';
      final mockData = [
        {'name': 'weed'},
        {'name': 'Alcohol'},
        {'name': 'caffeine'},
      ];

      final fakeBuilder = FakePostgrestBuilder<List<Map<String, dynamic>>>(
        mockData,
      );

      when(
        mockSupabaseClient.from('drug_use'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.select('name')).thenAnswer((_) => fakeBuilder);

      final result = await service.fetchUserSubstances(userId);

      expect(result, ['Alcohol', 'Caffeine', 'Weed']);
    });

    test('fetchUserSubstances handles empty response', () async {
      const userId = 'user123';

      final fakeBuilder = FakePostgrestBuilder<List<Map<String, dynamic>>>([]);

      when(
        mockSupabaseClient.from('drug_use'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.select('name')).thenAnswer((_) => fakeBuilder);

      final result = await service.fetchUserSubstances(userId);

      expect(result, isEmpty);
    });
  });
}

// Fake implementation to handle method chaining and await
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

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) async {
    return onValue(_data);
  }
}

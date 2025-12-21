import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/admin_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'admin_service_test.mocks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

@GenerateMocks([SupabaseClient, SupabaseQueryBuilder])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late AdminService adminService;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();

    adminService = AdminService(mockSupabaseClient);
  });

  group('AdminService - Initialization', () {
    test('service can be instantiated with mock client', () {
      expect(adminService, isNotNull);
    });
  });

  group('AdminService - fetchAllUsers', () {
    test('handles database errors gracefully', () async {
      when(
        mockSupabaseClient.from('users'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.select('auth_user_id, display_name, is_admin'),
      ).thenThrow(Exception('Database error'));

      expect(() => adminService.fetchAllUsers(), throwsException);
    });
  });

  group('AdminService - getSystemStats', () {
    test('returns system statistics when successful', () async {
      final fakeEntriesBuilder =
          FakePostgrestBuilder<List<Map<String, dynamic>>>(
            List.generate(10, (i) => {'use_id': i}),
          );
      final fakeActiveUsersBuilder =
          FakePostgrestBuilder<List<Map<String, dynamic>>>(
            List.generate(5, (i) => {'uuid_user_id': 'user$i'}),
          );

      when(
        mockSupabaseClient.from('drug_use'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.select('use_id'),
      ).thenAnswer((_) => fakeEntriesBuilder);
      when(
        mockQueryBuilder.select('uuid_user_id'),
      ).thenAnswer((_) => fakeActiveUsersBuilder);

      final result = await adminService.getSystemStats();

      expect(result, isNotNull);
      expect(result['total_entries'], 10);
      expect(result['active_users'], 5);
    });

    test('handles errors gracefully', () async {
      when(
        mockSupabaseClient.from('drug_use'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.select('use_id'),
      ).thenThrow(Exception('Database error'));

      final result = await adminService.getSystemStats();

      expect(result, isNotNull);
      expect(result['total_entries'], 0);
      expect(result['active_users'], 0);
    });
  });

  group('AdminService - promoteUser/demoteUser', () {
    test('promoteUser calls update with correct data', () async {
      final fakeUpdateBuilder =
          FakePostgrestBuilder<List<Map<String, dynamic>>>([]);

      when(
        mockSupabaseClient.from('users'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.update(captureAny),
      ).thenAnswer((_) => fakeUpdateBuilder);

      await adminService.promoteUser('user1');

      verify(mockQueryBuilder.update(captureAny)).called(1);
    });

    test('demoteUser calls update with correct data', () async {
      final fakeUpdateBuilder =
          FakePostgrestBuilder<List<Map<String, dynamic>>>([]);

      when(
        mockSupabaseClient.from('users'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.update(captureAny),
      ).thenAnswer((_) => fakeUpdateBuilder);

      await adminService.demoteUser('user1');

      verify(mockQueryBuilder.update(captureAny)).called(1);
    });

    test('promoteUser handles errors', () async {
      when(
        mockSupabaseClient.from('users'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.update(captureAny),
      ).thenThrow(Exception('Update failed'));

      expect(() => adminService.promoteUser('user1'), throwsException);
    });
  });

  group('AdminService - clearErrorLogs', () {
    test('clears error logs successfully', () async {
      final fakeDeleteBuilder =
          FakePostgrestBuilder<List<Map<String, dynamic>>>([]);

      when(
        mockSupabaseClient.from('error_logs'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.delete()).thenAnswer((_) => fakeDeleteBuilder);

      await adminService.clearErrorLogs(deleteAll: true);

      verify(mockQueryBuilder.delete()).called(1);
    });

    test('clearErrorLogs handles errors', () async {
      when(
        mockSupabaseClient.from('error_logs'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(mockQueryBuilder.delete()).thenThrow(Exception('Delete failed'));

      expect(
        () => adminService.clearErrorLogs(deleteAll: true),
        throwsException,
      );
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
  PostgrestFilterBuilder<T> lt(String column, Object value) => this;

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
  PostgrestTransformBuilder<T> limit(int count, {String? referencedTable}) =>
      this;

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

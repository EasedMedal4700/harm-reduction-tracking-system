import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/services/activity_service.dart';
import 'package:mobile_drug_use_app/services/encryption_service_v2.dart';
import 'dart:async';

// Generate mocks
@GenerateMocks([
  SupabaseClient,
  GoTrueClient,
  User,
  EncryptionServiceV2,
])
import 'activity_service_test.mocks.dart';

void main() {
  late ActivityService service;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;
  late MockUser mockUser;
  late MockEncryptionServiceV2 mockEncryptionService;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockUser = MockUser();
    mockEncryptionService = MockEncryptionServiceV2();

    // Setup auth mocking
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
    when(mockGoTrueClient.currentUser).thenReturn(mockUser);
    when(mockUser.id).thenReturn('test-user-id');
    
    // Setup encryption mocking
    when(mockEncryptionService.decryptFields(any, any)).thenAnswer((invocation) {
      return Future.value(invocation.positionalArguments[0] as Map<String, dynamic>);
    });

    service = ActivityService(
      client: mockSupabaseClient,
      encryption: mockEncryptionService,
    );
  });

  group('ActivityService', () {
    test('fetchRecentActivity returns combined and sorted activities', () async {
      // Mock data
      final entriesData = [
        {'id': '1', 'created_at': '2023-01-01T10:00:00Z', 'substance_type': 'Alcohol'},
        {'id': '2', 'created_at': '2023-01-02T10:00:00Z', 'substance_type': 'Cannabis'},
      ];
      final cravingsData = [
        {'id': '3', 'created_at': '2023-01-01T12:00:00Z', 'intensity': 5},
      ];
      final reflectionsData = [
        {'id': '4', 'created_at': '2023-01-03T10:00:00Z', 'notes': 'Reflection'},
      ];

      // Create fake builders
      final fakeEntriesBuilder = FakePostgrestBuilder(entriesData);
      final fakeCravingsBuilder = FakePostgrestBuilder(cravingsData);
      final fakeReflectionsBuilder = FakePostgrestBuilder(reflectionsData);

      final fakeEntriesQueryBuilder = FakeSupabaseQueryBuilder(fakeEntriesBuilder);
      final fakeCravingsQueryBuilder = FakeSupabaseQueryBuilder(fakeCravingsBuilder);
      final fakeReflectionsQueryBuilder = FakeSupabaseQueryBuilder(fakeReflectionsBuilder);

      // Setup Supabase client to return fake builders
      when(mockSupabaseClient.from('drug_use')).thenAnswer((_) => fakeEntriesQueryBuilder);
      when(mockSupabaseClient.from('cravings')).thenAnswer((_) => fakeCravingsQueryBuilder);
      when(mockSupabaseClient.from('reflections')).thenAnswer((_) => fakeReflectionsQueryBuilder);

      final result = await service.fetchRecentActivity();

      expect(result['entries'], hasLength(2));
      expect(result['cravings'], hasLength(1));
      expect(result['reflections'], hasLength(1));
    });

    test('fetchRecentActivity handles empty data', () async {
      final fakeEntriesBuilder = FakePostgrestBuilder(<Map<String, dynamic>>[]);
      final fakeCravingsBuilder = FakePostgrestBuilder(<Map<String, dynamic>>[]);
      final fakeReflectionsBuilder = FakePostgrestBuilder(<Map<String, dynamic>>[]);

      final fakeEntriesQueryBuilder = FakeSupabaseQueryBuilder(fakeEntriesBuilder);
      final fakeCravingsQueryBuilder = FakeSupabaseQueryBuilder(fakeCravingsBuilder);
      final fakeReflectionsQueryBuilder = FakeSupabaseQueryBuilder(fakeReflectionsBuilder);

      when(mockSupabaseClient.from('drug_use')).thenAnswer((_) => fakeEntriesQueryBuilder);
      when(mockSupabaseClient.from('cravings')).thenAnswer((_) => fakeCravingsQueryBuilder);
      when(mockSupabaseClient.from('reflections')).thenAnswer((_) => fakeReflectionsQueryBuilder);

      final result = await service.fetchRecentActivity();

      expect(result['entries'], isEmpty);
      expect(result['cravings'], isEmpty);
      expect(result['reflections'], isEmpty);
    });
    
    test('fetchRecentActivity throws StateError when user not logged in', () async {
      when(mockGoTrueClient.currentUser).thenReturn(null);
      
      expect(() => service.fetchRecentActivity(), throwsA(isA<StateError>()));
    });
  });
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final FakePostgrestBuilder _fakeBuilder;
  FakeSupabaseQueryBuilder(this._fakeBuilder);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([String columns = '*']) {
    return _fakeBuilder as PostgrestFilterBuilder<List<Map<String, dynamic>>>;
  }
}

// Fake implementation to handle method chaining and await
class FakePostgrestBuilder<T> extends Fake implements PostgrestFilterBuilder<T>, PostgrestTransformBuilder<T> {
  final T _data;
  FakePostgrestBuilder(this._data);

  @override
  PostgrestFilterBuilder<T> eq(String column, Object value) => this;

  @override
  PostgrestFilterBuilder<T> not(String column, String operator, Object? value) => this;
  
  @override
  PostgrestFilterBuilder<T> ilike(String column, String pattern) => this;
  
  @override
  PostgrestFilterBuilder<T> gte(String column, Object value) => this;
  
  @override
  PostgrestFilterBuilder<T> or(String filters, {String? referencedTable}) => this;
  
  @override
  PostgrestTransformBuilder<T> order(String column, {bool ascending = true, bool nullsFirst = false, String? referencedTable}) => this;

  @override
  PostgrestTransformBuilder<T> limit(int count, {String? referencedTable}) => this;

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
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) async {
    return onValue(_data);
  }
}

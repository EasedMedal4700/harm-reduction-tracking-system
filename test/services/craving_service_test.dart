import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_drug_use_app/features/craving/services/craving_service.dart';
import 'package:mobile_drug_use_app/features/craving/models/craving_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'craving_service_test_mocks.mocks.dart';

// Fake implementation for TransformBuilder (returned by maybeSingle)
class FakePostgrestTransformBuilder<T> extends Fake
    implements PostgrestTransformBuilder<T> {
  final T _data;
  FakePostgrestTransformBuilder(this._data);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) {
    return Future.value(_data).then(onValue, onError: onError);
  }
}

// Fake implementation for FilterBuilder (returned by select, insert, update)
class FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> _data;

  FakePostgrestFilterBuilder([List<Map<String, dynamic>> data = const []])
    : _data = List<Map<String, dynamic>>.from(data);

  void setData(List<Map<String, dynamic>> data) {
    _data
      ..clear()
      ..addAll(data);
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> eq(
    String column,
    dynamic value,
  ) {
    return this;
  }

  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() {
    return FakePostgrestTransformBuilder<Map<String, dynamic>?>(
      _data.isNotEmpty ? _data.first : null,
    );
  }

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) {
    return this;
  }

  @override
  PostgrestTransformBuilder<Map<String, dynamic>> single() {
    if (_data.isEmpty) throw Exception('Row not found');
    return FakePostgrestTransformBuilder<Map<String, dynamic>>(_data.first);
  }

  @override
  Future<R> then<R>(
    FutureOr<R> Function(List<Map<String, dynamic>> value) onValue, {
    Function? onError,
  }) {
    return Future.value(_data).then(onValue, onError: onError);
  }
}

void main() {
  group('CravingService', () {
    late CravingService service;
    late MockSupabaseClient mockSupabase;
    late MockEncryptionServiceV2 mockEncryption;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late FakePostgrestFilterBuilder fakeFilterBuilder;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockEncryption = MockEncryptionServiceV2();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      fakeFilterBuilder = FakePostgrestFilterBuilder();

      // Default stubs
      when(mockSupabase.from(any)).thenAnswer((_) => mockQueryBuilder);
      when(
        mockEncryption.encryptText(any),
      ).thenAnswer((i) async => 'encrypted_${i.positionalArguments[0]}');
      when(mockEncryption.encryptFields(any, any)).thenAnswer((i) async {
        final data = i.positionalArguments[0] as Map<String, dynamic>;
        final fields = i.positionalArguments[1] as List<String>;
        final result = Map<String, dynamic>.from(data);
        for (final field in fields) {
          if (result.containsKey(field)) {
            result[field] = 'encrypted_${result[field]}';
          }
        }
        return result;
      });
      when(mockEncryption.decryptFields(any, any)).thenAnswer((i) async {
        final data = i.positionalArguments[0] as Map<String, dynamic>;
        final fields = i.positionalArguments[1] as List<String>;
        final result = Map<String, dynamic>.from(data);
        for (final field in fields) {
          if (result.containsKey(field) &&
              result[field].toString().startsWith('encrypted_')) {
            result[field] = result[field].toString().replaceFirst(
              'encrypted_',
              '',
            );
          }
        }
        return result;
      });

      // Stubbing insert/update/select to return our Fake
      // Since PostgrestFilterBuilder implements Future, we must use thenAnswer
      when(mockQueryBuilder.insert(any)).thenAnswer((_) => fakeFilterBuilder);
      when(mockQueryBuilder.update(any)).thenAnswer((_) => fakeFilterBuilder);
      when(mockQueryBuilder.select(any)).thenAnswer((_) => fakeFilterBuilder);

      service = CravingService(
        encryption: mockEncryption,
        supabase: mockSupabase,
        getUserId: () => 'test-user-id',
      );
    });

    group('Validation', () {
      test('throws exception for zero intensity', () {
        final craving = Craving(
          cravingId: 'test',
          userId: 'user-123',
          substance: 'Cannabis',
          intensity: 0,
          date: DateTime.now(),
          time: '2025-11-07 21:56:00+00',
          location: 'Home',
          people: 'Friends',
          activity: 'Movie',
          thoughts: 'Wanted to relax',
          triggers: ['stress'],
          bodySensations: ['restlessness'],
          primaryEmotion: 'Anxious',
          secondaryEmotion: 'Worried',
          action: 'Resisted',
          timezone: -5.0,
        );

        expect(() => service.saveCraving(craving), throwsA(isA<Exception>()));
      });

      test('throws exception for empty substance', () {
        final craving = Craving(
          cravingId: 'test',
          userId: 'user-123',
          substance: '',
          intensity: 7,
          date: DateTime.now(),
          time: '2025-11-07 21:56:00+00',
          location: 'Home',
          people: 'Friends',
          activity: 'Movie',
          thoughts: 'Wanted to relax',
          triggers: ['stress'],
          bodySensations: ['restlessness'],
          primaryEmotion: 'Anxious',
          secondaryEmotion: 'Worried',
          action: 'Resisted',
          timezone: -5.0,
        );

        expect(() => service.saveCraving(craving), throwsA(isA<Exception>()));
      });
    });

    group('saveCraving', () {
      test('encrypts and saves valid craving', () async {
        final craving = Craving(
          cravingId: 'test',
          userId: 'user-123',
          substance: 'Cannabis',
          intensity: 5,
          date: DateTime.now(),
          time: '12:00',
          location: 'Home',
          people: 'Friends',
          activity: 'Movie',
          thoughts: 'My thoughts',
          triggers: ['stress'],
          bodySensations: ['shaking'],
          primaryEmotion: 'Anxious',
          secondaryEmotion: 'None',
          action: 'Resisted',
          timezone: -5.0,
        );

        // We need to set the fake return data for insert if the code expects it
        // But insert usually just returns the inserted data if select() is chained, or just completes.
        // Our fake returns empty list by default, which is fine if the code doesn't use the result.
        // But wait, `insert` in Supabase usually returns the data if `select()` is called.
        // If the code just awaits `insert(...)`, it might expect `List<Map>` or `null`.
        // Our fake returns `List<Map>`.

        // Let's see if `saveCraving` uses the result.
        // It probably just awaits it.

        // We need to capture the arguments passed to insert.

        await service.saveCraving(craving);

        verify(mockSupabase.from('cravings')).called(1);
        final captured = verify(mockQueryBuilder.insert(captureAny)).captured;
        final inserted = captured.first as Map<String, dynamic>;

        expect(inserted['substance'], 'Cannabis');
        expect(inserted['thoughts'], 'encrypted_My thoughts');
        expect(inserted['action'], 'encrypted_Resisted');
        expect(inserted['uuid_user_id'], 'test-user-id');
      });
    });

    group('fetchCravingById', () {
      test('returns decrypted craving when found', () async {
        // Setup fake data
        fakeFilterBuilder.setData([
          {
            'craving_id': 'c1',
            'uuid_user_id': 'test-user-id',
            'substance': 'Alcohol',
            'thoughts': 'encrypted_Secret thoughts',
            'action': 'encrypted_Drank water',
          },
        ]);

        final result = await service.fetchCravingById('c1');

        expect(result, isNotNull);
        expect(result!['thoughts'], 'Secret thoughts');
        expect(result['action'], 'Drank water');
      });

      test('throws exception when not found', () async {
        fakeFilterBuilder.setData([]);

        expect(
          () => service.fetchCravingById('c1'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('not found'),
            ),
          ),
        );
      });
    });

    group('updateCraving', () {
      test('encrypts and updates craving', () async {
        fakeFilterBuilder.setData([
          {'craving_id': 'c1'},
        ]);

        final data = {'substance': 'Tobacco', 'thoughts': 'New thoughts'};

        await service.updateCraving('c1', data);

        final captured = verify(mockQueryBuilder.update(captureAny)).captured;
        final updated = captured.first as Map<String, dynamic>;

        expect(updated, isNotNull);
        expect(updated['substance'], 'Tobacco');
        expect(updated['thoughts'], 'encrypted_New thoughts');
      });
    });
  });
}

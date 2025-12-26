import 'dart:convert';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/models/drug_catalog_entry.dart';

class _FakePersonalLibraryApi implements PersonalLibraryApi {
  _FakePersonalLibraryApi({required this.profiles, required this.rows});

  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async => profiles;

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async => rows;
}

class _ThrowingProfilesApi extends _FakePersonalLibraryApi {
  _ThrowingProfilesApi({required super.profiles, required super.rows});

  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async {
    throw StateError('boom');
  }
}

class _ThrowingRowsApi extends _FakePersonalLibraryApi {
  _ThrowingRowsApi({required super.profiles, required super.rows});

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async {
    throw StateError('boom');
  }
}

class _FakeSupabaseHttpClient extends http.BaseClient {
  _FakeSupabaseHttpClient({required this.jsonByPath});

  final Map<String, Object?> jsonByPath;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    final body = jsonEncode(
      jsonByPath.entries
              .firstWhere(
                (e) => path.contains(e.key),
                orElse: () => const MapEntry('', <Object?>[]),
              )
              .value ??
          <Object?>[],
    );

    return http.StreamedResponse(
      Stream<List<int>>.value(utf8.encode(body)),
      200,
      headers: const {'content-type': 'application/json'},
      request: request,
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('SupabasePersonalLibraryApi maps response rows', () async {
    final client = SupabaseClient(
      'https://example.com',
      'anon',
      httpClient: _FakeSupabaseHttpClient(
        jsonByPath: {
          '/rest/v1/drug_profiles': [
            {
              'name': 'methylphenidate',
              'categories': ['Stimulant'],
            },
          ],
          '/rest/v1/drug_use': [
            {
              'name': 'methylphenidate',
              'start_time': DateTime(2025, 1, 1, 10).toIso8601String(),
              'dose': '5 mg',
            },
          ],
        },
      ),
    );

    final api = SupabasePersonalLibraryApi(client);
    final profiles = await api.fetchDrugProfiles();
    final rows = await api.fetchDrugUseRows(userId: 'u1');

    expect(profiles, hasLength(1));
    expect(profiles.single['name'], 'methylphenidate');
    expect(rows, hasLength(1));
    expect(rows.single['dose'], '5 mg');
  });

  test(
    'fetchCatalog groups entries, applies profiles, reads prefs, and sorts by lastUsed',
    () async {
      final api = _FakePersonalLibraryApi(
        profiles: [
          {
            'name': 'methylphenidate',
            'categories': ['Stimulant'],
          },
          {
            'name': 'cannabis',
            'categories': ['Cannabinoid'],
          },
        ],
        rows: [
          {
            'name': 'methylphenidate',
            'start_time': DateTime(2025, 1, 2, 10).toIso8601String(),
            'dose': '5 mg',
          },
          {
            'name': 'Methylphenidate',
            'start_time': DateTime(2025, 1, 3, 10).toIso8601String(),
            'dose': '10 mg',
          },
          {
            'name': 'cannabis',
            'start_time': DateTime(2025, 1, 1, 10).toIso8601String(),
            'dose': '1 g',
          },
        ],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'drug_Methylphenidate',
        jsonEncode({
          'favorite': true,
          'archived': false,
          'notes': 'n',
          'quantity': 2,
        }),
      );

      final service = PersonalLibraryService(
        api: api,
        prefsFactory: () async => prefs,
        userIdGetter: () => 'u1',
      );

      final catalog = await service.fetchCatalog();
      expect(catalog, hasLength(2));

      // Sorted by lastUsed desc: methylphenidate (Jan 3) before cannabis (Jan 1)
      expect(catalog.first.name, 'Methylphenidate');
      expect(catalog.first.categories, contains('Stimulant'));
      expect(catalog.first.totalUses, 2);
      expect(catalog.first.favorite, isTrue);

      final cannabis = catalog.last;
      expect(cannabis.name, 'Cannabis');
      expect(cannabis.categories, contains('Cannabinoid'));
      expect(cannabis.totalUses, 1);
    },
  );

  test('applySearch filters by name or category', () {
    const a = DrugCatalogEntry(
      name: 'Methylphenidate',
      categories: ['Stimulant'],
      totalUses: 1,
      avgDose: 0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 0, 0, 0, 0, 0, 0],
        mostActive: 0,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );
    const b = DrugCatalogEntry(
      name: 'Cannabis',
      categories: ['Cannabinoid'],
      totalUses: 1,
      avgDose: 0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 0, 0, 0, 0, 0, 0],
        mostActive: 0,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    final service = PersonalLibraryService(
      api: _FakePersonalLibraryApi(profiles: const [], rows: const []),
      userIdGetter: () => 'u1',
    );

    expect(service.applySearch('canna', const [a, b]).single.name, 'Cannabis');
    expect(
      service.applySearch('stimul', const [a, b]).single.name,
      'Methylphenidate',
    );
    expect(service.applySearch('   ', const [a, b]), hasLength(2));
  });

  test(
    'toggleFavorite and toggleArchive delegate to injected savers',
    () async {
      bool? favoriteValue;
      bool? archivedValue;

      final service = PersonalLibraryService(
        api: _FakePersonalLibraryApi(profiles: const [], rows: const []),
        userIdGetter: () => 'u1',
        saveFavorite: (name, value, current) async {
          expect(name, 'Test');
          favoriteValue = value;
          expect(current.favorite, isFalse);
        },
        saveArchived: (name, value, current) async {
          expect(name, 'Test');
          archivedValue = value;
          expect(current.archived, isFalse);
        },
      );

      const entry = DrugCatalogEntry(
        name: 'Test',
        categories: ['Unknown'],
        totalUses: 0,
        avgDose: 0,
        lastUsed: null,
        weekdayUsage: WeekdayUsage(
          counts: [0, 0, 0, 0, 0, 0, 0],
          mostActive: 0,
          leastActive: 0,
        ),
        favorite: false,
        archived: false,
        notes: '',
        quantity: 0,
      );

      final fav = await service.toggleFavorite(entry);
      final arch = await service.toggleArchive(entry);

      expect(fav, isTrue);
      expect(arch, isTrue);
      expect(favoriteValue, isTrue);
      expect(archivedValue, isTrue);
    },
  );

  test('toggleFavorite rethrows when saver throws', () async {
    final service = PersonalLibraryService(
      api: _FakePersonalLibraryApi(profiles: const [], rows: const []),
      userIdGetter: () => 'u1',
      saveFavorite: (_, __, ___) async {
        throw StateError('save failed');
      },
    );

    const entry = DrugCatalogEntry(
      name: 'Test',
      categories: ['Unknown'],
      totalUses: 0,
      avgDose: 0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 0, 0, 0, 0, 0, 0],
        mostActive: 0,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    expect(service.toggleFavorite(entry), throwsA(isA<StateError>()));
  });

  test('toggleArchive rethrows when saver throws', () async {
    final service = PersonalLibraryService(
      api: _FakePersonalLibraryApi(profiles: const [], rows: const []),
      userIdGetter: () => 'u1',
      saveArchived: (_, __, ___) async {
        throw StateError('save failed');
      },
    );

    const entry = DrugCatalogEntry(
      name: 'Test',
      categories: ['Unknown'],
      totalUses: 0,
      avgDose: 0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 0, 0, 0, 0, 0, 0],
        mostActive: 0,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    expect(service.toggleArchive(entry), throwsA(isA<StateError>()));
  });

  test('fetchCatalog rethrows when row fetch fails', () async {
    final api = _ThrowingRowsApi(profiles: const [], rows: const []);
    final prefs = await SharedPreferences.getInstance();

    final service = PersonalLibraryService(
      api: api,
      prefsFactory: () async => prefs,
      userIdGetter: () => 'u1',
    );

    expect(service.fetchCatalog(), throwsA(isA<StateError>()));
  });

  test('falls back to default profiles if profile fetch fails', () async {
    final api = _ThrowingProfilesApi(
      profiles: const [],
      rows: [
        {
          'name': 'methylphenidate',
          'start_time': DateTime(2025, 1, 1, 10).toIso8601String(),
          'dose': '5 mg',
        },
      ],
    );

    final prefs = await SharedPreferences.getInstance();

    final service = PersonalLibraryService(
      api: api,
      prefsFactory: () async => prefs,
      userIdGetter: () => 'u1',
    );

    final catalog = await service.fetchCatalog();
    expect(catalog.single.categories, contains('Stimulant'));
  });

  test('falls back to default profiles if profile list is empty', () async {
    final api = _FakePersonalLibraryApi(
      profiles: const [],
      rows: [
        {
          'name': 'methylphenidate',
          'start_time': DateTime(2025, 1, 1, 10).toIso8601String(),
          'dose': '5 mg',
        },
      ],
    );

    final prefs = await SharedPreferences.getInstance();

    final service = PersonalLibraryService(
      api: api,
      prefsFactory: () async => prefs,
      userIdGetter: () => 'u1',
    );

    final catalog = await service.fetchCatalog();
    expect(catalog.single.categories, contains('Stimulant'));
  });

  test(
    'default PersonalLibraryService constructor can be instantiated when Supabase is initialized',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      try {
        await Supabase.initialize(url: 'https://example.com', anonKey: 'dummy');
      } catch (_) {}

      expect(PersonalLibraryService(), isA<PersonalLibraryService>());
    },
  );
}

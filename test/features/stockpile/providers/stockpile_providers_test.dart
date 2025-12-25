import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/day_usage_service.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/repo/stockpile_repository.dart';
import 'package:mobile_drug_use_app/repo/substance_repository.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({});

    // Workaround for Supabase.instance assertion (providers default to Supabase-backed services)
    try {
      await Supabase.initialize(url: 'https://example.com', anonKey: 'dummy');
    } catch (_) {}
  });

  test('stockpile providers can be read', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(personalLibraryServiceProvider),
      isA<PersonalLibraryService>(),
    );
    expect(container.read(dayUsageServiceProvider), isA<DayUsageService>());
    expect(
      container.read(stockpileRepositoryProvider),
      isA<StockpileRepository>(),
    );
    expect(
      container.read(substanceRepositoryProvider),
      isA<SubstanceRepository>(),
    );

    // Family provider resolves
    final item = await container.read(stockpileItemProvider('x').future);
    expect(item, isNull);
  });
}

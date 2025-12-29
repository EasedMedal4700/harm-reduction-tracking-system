// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/day_usage_service.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/stockpile_item.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/stockpile_repository.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/substance_repository.dart';

final personalLibraryServiceProvider = Provider<PersonalLibraryService>((ref) {
  return PersonalLibraryService();
});

final dayUsageServiceProvider = Provider<DayUsageService>((ref) {
  return DayUsageService();
});

final stockpileRepositoryProvider = Provider<StockpileRepository>((ref) {
  return StockpileRepository();
});

final substanceRepositoryProvider = Provider<SubstanceRepository>((ref) {
  return SubstanceRepository();
});

final stockpileItemProvider = FutureProvider.autoDispose
    .family<StockpileItem?, String>((ref, substanceId) async {
      final repo = ref.watch(stockpileRepositoryProvider);
      return repo.getStockpile(substanceId);
    });

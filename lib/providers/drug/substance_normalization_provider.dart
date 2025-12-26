// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Drug provider.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/catalog/services/drug_profile_service.dart';

final substanceSearchProvider = FutureProvider.family((
  ref,
  String query,
) async {
  final service = DrugProfileService();
  return await service.searchDrugNamesWithAliases(query);
});

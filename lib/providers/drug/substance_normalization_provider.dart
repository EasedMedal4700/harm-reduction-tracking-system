import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/drug_profile_service.dart';

final substanceSearchProvider = FutureProvider.family((
  ref,
  String query,
) async {
  final service = DrugProfileService();
  return await service.searchDrugNamesWithAliases(query);
});

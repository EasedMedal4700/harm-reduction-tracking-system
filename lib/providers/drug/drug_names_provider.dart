import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/catalog/services/drug_profile_service.dart';

final drugNamesProvider = FutureProvider<List<String>>((ref) async {
  final service = DrugProfileService();
  return await service.getAllDrugNames();
});

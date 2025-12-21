import 'package:mobile_drug_use_app/services/craving_service.dart';
import 'package:mobile_drug_use_app/models/craving_model.dart';

class FakeCravingService implements CravingService {
  @override
  Future<void> saveCraving(Craving craving) async {
    // Simulate save
  }

  @override
  Future<Map<String, dynamic>?> fetchCravingById(String id) async {
    return {
      'id': id,
      'substance': 'Dexedrine',
      'intensity': 5.0,
      'location': 'Home',
      'date': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<void> updateCraving(String id, Map<String, dynamic> data) async {
    // Simulate update
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

import 'package:mobile_drug_use_app/services/blood_levels_service.dart';

class FakeBloodLevelsService implements BloodLevelsService {
  @override
  Future<Map<String, DrugLevel>> calculateCurrentLevels(DateTime time) async {
    return {
      'Dexedrine': DrugLevel(
        drugName: 'Dexedrine',
        totalDose: 10.0,
        totalRemaining: 5.0,
        lastDose: 10.0,
        lastUse: time.subtract(const Duration(hours: 2)),
        halfLife: 10.0,
        doses: [],
      ),
    };
  }

  @override
  Future<Map<String, DrugLevel>> calculateLevels({DateTime? referenceTime}) async {
    return calculateCurrentLevels(referenceTime ?? DateTime.now());
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

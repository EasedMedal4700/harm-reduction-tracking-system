import 'package:mobile_drug_use_app/features/reflection/reflection_service.dart';
import 'package:mobile_drug_use_app/features/reflection/models/reflection_model.dart';

class FakeReflectionService implements ReflectionService {
  @override
  Future<void> saveReflection(
    Reflection reflection,
    List<int> relatedEntries,
  ) async {
    // Simulate save
  }

  @override
  Future<void> updateReflection(String id, Map<String, dynamic> data) async {
    // Simulate update
  }

  @override
  Future<ReflectionModel?> fetchReflectionById(String id) async {
    return ReflectionModel(
      id: id,
      notes: 'Test notes',
      selectedReflections: [],
      date: DateTime.now(),
      hour: 12,
      minute: 0,
      effectiveness: 5.0,
      overallSatisfaction: 5.0,
      copingEffectiveness: 5.0,
      postUseCraving: 5.0,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

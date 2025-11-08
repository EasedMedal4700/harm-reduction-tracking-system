// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\services\reflection_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reflection_model.dart';
import '../services/user_service.dart';

class ReflectionService {
  Future<int> getNextReflectionId() async {
    try {
      final response = await Supabase.instance.client
        .from('reflections')
        .select('reflection_id')
        .order('reflection_id', ascending: false)
        .limit(1);
      return response.isNotEmpty ? (response[0]['reflection_id'] as int) + 1 : 1;
    } catch (e) {
      return 1;
    }
  }

  Future<void> saveReflection(Reflection reflection, List<int> relatedEntries) async {
    final nextId = await getNextReflectionId();
    await Supabase.instance.client.from('reflections').insert({
      'reflection_id': nextId,
      'user_id': UserService.getCurrentUserId(),
      ...reflection.toJson(),
      'created_at': DateTime.now().toIso8601String(),
      'related_entries': relatedEntries,
      'is_simple': false,
    });
  }
}
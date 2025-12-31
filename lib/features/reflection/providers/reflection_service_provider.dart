import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reflection_service.dart';

final reflectionServiceProvider = Provider<ReflectionService>((ref) {
  return ReflectionService();
});

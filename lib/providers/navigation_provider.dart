import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/navigation_service.dart';

final navigationProvider = Provider<NavigationService>(
  (ref) => NavigationService(),
);

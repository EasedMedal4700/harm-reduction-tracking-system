import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';

/// Provides the currently authenticated user's ID.
/// Throws if no user is logged in.
final currentUserIdProvider = Provider<String>((ref) {
  return UserService.getCurrentUserId();
});

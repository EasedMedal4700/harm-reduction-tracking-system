import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static String getCurrentUserId() {
    return Supabase.instance.client.auth.currentUser?.id ?? '2'; // Changed fallback to '2'
  }

  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
import 'package:flutter/material.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    // Simulate a backend call (replace this with Supabase, Firebase, etc.)
    await Future.delayed(const Duration(seconds: 1));

    if (email == "test" && password == "test") {
      return true; // success
    } else {
      return true; // cahnge later to false
    }
  }
}

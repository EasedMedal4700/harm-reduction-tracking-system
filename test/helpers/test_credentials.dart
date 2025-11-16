import 'dart:convert';
import 'dart:io';

/// Helper class to load test credentials from login_data.json
class TestCredentials {
  static Map<String, dynamic>? _credentials;

  /// Load credentials from login_data.json
  static Map<String, dynamic> load() {
    if (_credentials != null) return _credentials!;

    try {
      final file = File('login_data.json');
      if (!file.existsSync()) {
        throw Exception('login_data.json not found in project root');
      }

      final contents = file.readAsStringSync();
      _credentials = jsonDecode(contents) as Map<String, dynamic>;
      return _credentials!;
    } catch (e) {
      throw Exception('Failed to load test credentials: $e');
    }
  }

  /// Get email from credentials
  static String get email {
    final creds = load();
    return creds['email'] as String? ?? '';
  }

  /// Get password from credentials
  static String get password {
    final creds = load();
    return creds['password'] as String? ?? '';
  }

  /// Clear cached credentials (useful for testing)
  static void clear() {
    _credentials = null;
  }
}

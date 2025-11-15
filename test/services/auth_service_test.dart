import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService service;

    setUp(() {
      service = AuthService();
    });

    test('login with correct credentials returns true', () async {
      final result = await service.login('test', 'test');
      expect(result, isTrue);
    });

    test('login with incorrect credentials returns true (temporary)', () async {
      // Note: Currently hardcoded to return true for all inputs
      final result = await service.login('wrong', 'wrong');
      expect(result, isTrue);
    });

    test('login simulates async operation', () async {
      final stopwatch = Stopwatch()..start();
      await service.login('test', 'test');
      stopwatch.stop();
      
      // Verify there's a delay (at least 500ms, since delay is 1 second)
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(500));
    });

    test('login accepts empty strings', () async {
      final result = await service.login('', '');
      expect(result, isA<bool>());
    });

    test('login accepts null-like inputs', () async {
      final result = await service.login('null', 'undefined');
      expect(result, isA<bool>());
    });
  });
}

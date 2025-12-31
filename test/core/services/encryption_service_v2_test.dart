import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EncryptionServiceV2 service;

  setUp(() {
    service = EncryptionServiceV2();
    service.lock();
    service.setDataKeyForTesting(SecretKey(List<int>.generate(32, (i) => i)));
  });

  tearDown(() {
    service.lock();
  });

  test('encryptText/decryptText roundtrip', () async {
    const plaintext = 'hello world';

    final encrypted = await service.encryptText(plaintext);
    expect(encrypted, isNot(equals(plaintext)));
    expect(encrypted, contains('nonce'));
    expect(encrypted, contains('ciphertext'));
    expect(encrypted, contains('mac'));

    final decrypted = await service.decryptText(encrypted);
    expect(decrypted, plaintext);
  });

  test('encryptText returns empty string unchanged', () async {
    expect(await service.encryptText(''), '');
  });

  test('decryptText returns empty string unchanged', () async {
    expect(await service.decryptText(''), '');
  });

  test(
    'decryptText returns plaintext unchanged when input is not encrypted',
    () async {
      expect(await service.decryptText('not json'), 'not json');
      expect(await service.decryptText('{"a":1}'), '{"a":1}');
    },
  );

  test('decryptText returns original on malformed encrypted payload', () async {
    const malformed = '{"nonce":"@@","ciphertext":"@@","mac":"@@"}';
    expect(await service.decryptText(malformed), malformed);
  });

  test('lock disables encryption helpers', () async {
    service.lock();
    expect(service.isReady, isFalse);

    expect(() => service.encryptText('x'), throwsA(isA<Exception>()));

    expect(() => service.decryptText('x'), throwsA(isA<Exception>()));
  });

  test('nullable helpers return null for null/empty', () async {
    expect(await service.encryptTextNullable(null), isNull);
    expect(await service.encryptTextNullable(''), isNull);

    expect(await service.decryptTextNullable(null), isNull);
    expect(await service.decryptTextNullable(''), isNull);
  });

  test(
    'encryptFields only encrypts selected non-empty string fields',
    () async {
      final data = <String, dynamic>{
        'a': 'hello',
        'b': '   ',
        'c': '',
        'd': 123,
      };

      final encrypted = await service.encryptFields(data, ['a', 'b', 'c', 'd']);

      expect(encrypted['a'], isA<String>());
      expect(encrypted['a'], isNot(equals('hello')));

      // Only emptiness is checked, not whitespace-trimmed.
      expect(encrypted['b'], isA<String>());
      expect(encrypted['b'], isNot(equals('   ')));

      expect(encrypted['c'], '');
      expect(encrypted['d'], 123);
    },
  );

  test(
    'decryptFields decrypts selected fields and leaves plaintext as-is',
    () async {
      final encryptedHello = await service.encryptText('hello');

      final data = <String, dynamic>{
        'a': encryptedHello,
        'b': 'already plaintext',
        'c': 999,
      };

      final decrypted = await service.decryptFields(data, ['a', 'b', 'c']);
      expect(decrypted['a'], 'hello');
      expect(decrypted['b'], 'already plaintext');
      expect(decrypted['c'], 999);
    },
  );
}

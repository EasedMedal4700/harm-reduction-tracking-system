import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EncryptionService service;

  setUp(() {
    service = EncryptionService();
    service.dispose();
    service.setMasterKeyForTesting(
      SecretKey(List<int>.generate(32, (i) => (i * 7) % 256)),
    );
  });

  tearDown(() {
    service.dispose();
  });

  test('encryptText/decryptText roundtrip', () async {
    const plaintext = 'sensitive data';

    final encrypted = await service.encryptText(plaintext);
    expect(encrypted, isNotNull);
    expect(encrypted, isNot(equals(plaintext)));
    expect(encrypted, contains('nonce'));
    expect(encrypted, contains('ciphertext'));
    expect(encrypted, contains('mac'));

    final decrypted = await service.decryptText(encrypted);
    expect(decrypted, plaintext);
  });

  test('encryptText returns null for null/empty', () async {
    expect(await service.encryptText(null), isNull);
    expect(await service.encryptText(''), isNull);
  });

  test('decryptText returns null for null/empty', () async {
    expect(await service.decryptText(null), isNull);
    expect(await service.decryptText(''), isNull);
  });

  test(
    'decryptText returns plaintext unchanged when input is not encrypted',
    () async {
      expect(await service.decryptText('plain'), 'plain');
      expect(await service.decryptText('{"a":1}'), '{"a":1}');
    },
  );

  test('decryptText returns original on malformed encrypted payload', () async {
    const malformed = '{"nonce":"@@","ciphertext":"@@","mac":"@@"}';
    expect(await service.decryptText(malformed), malformed);
  });

  test('isEncrypted detects encrypted JSON payloads', () async {
    final encrypted = await service.encryptText('x');
    expect(encrypted, isNotNull);

    expect(service.isEncrypted(encrypted!), isTrue);
    expect(service.isEncrypted('x'), isFalse);
    expect(service.isEncrypted(''), isFalse);
    expect(service.isEncrypted('{"nonce":1,"ciphertext":2,"mac":3}'), isTrue);
  });

  test('encryptFields/decryptFields roundtrip for selected fields', () async {
    final data = <String, dynamic>{'a': 'hello', 'b': 'world', 'c': 123};

    final encrypted = await service.encryptFields(data, ['a', 'b', 'c']);
    expect(encrypted['a'], isA<String?>());
    expect(encrypted['b'], isA<String?>());

    final decrypted = await service.decryptFields(encrypted, ['a', 'b', 'c']);
    expect(decrypted['a'], 'hello');
    expect(decrypted['b'], 'world');
    expect(decrypted['c'], 123);
  });

  test(
    'dispose clears key (subsequent encrypt requires initialization)',
    () async {
      service.dispose();

      await expectLater(
        () => service.encryptText('x'),
        throwsA(isA<Exception>()),
      );
    },
  );
}

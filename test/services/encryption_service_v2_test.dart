import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';

/// Test helper class that exposes internal methods for testing
/// This mirrors EncryptionServiceV2 but without Supabase dependencies
class TestableEncryptionService {
  final AesGcm _aesGcm = AesGcm.with256bits();
  SecretKey? _dataKey;

  bool get isReady => _dataKey != null;

  /// Set the data key directly for testing
  void setDataKey(SecretKey key) {
    _dataKey = key;
  }

  /// Lock encryption (clear dataKey)
  void lock() {
    _dataKey = null;
  }

  /// Generate random bytes
  Uint8List randomBytes(int length) {
    final random = List<int>.generate(length, (i) => i % 256);
    return Uint8List.fromList(random);
  }

  /// Convert bytes to hex string
  String bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Check if string is numeric
  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  /// Check if string is encrypted JSON
  bool isEncrypted(String text) {
    try {
      final json = jsonDecode(text);
      if (json is! Map<String, dynamic>) return false;
      return json.containsKey('nonce') &&
          json.containsKey('ciphertext') &&
          json.containsKey('mac');
    } catch (_) {
      return false;
    }
  }

  /// Derive 256-bit key from secret using PBKDF2-HMAC-SHA256
  Future<SecretKey> deriveKey(
    String secret,
    Uint8List salt,
    int iterations,
  ) async {
    final pbkdf2Custom = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: 256,
    );

    final secretKey = await pbkdf2Custom.deriveKey(
      secretKey: SecretKey(utf8.encode(secret)),
      nonce: salt,
    );

    return secretKey;
  }

  /// Encrypt dataKey with masterKey using AES-GCM
  Future<String> encryptDataKey(
    SecretKey masterKey,
    Uint8List dataKeyBytes,
  ) async {
    final nonce = _aesGcm.newNonce();
    final secretBox = await _aesGcm.encrypt(
      dataKeyBytes,
      secretKey: masterKey,
      nonce: nonce,
    );

    final encryptedData = {
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return jsonEncode(encryptedData);
  }

  /// Decrypt dataKey with masterKey using AES-GCM
  Future<Uint8List?> decryptDataKey(
    SecretKey masterKey,
    String encryptedJson,
  ) async {
    try {
      final encryptedData = jsonDecode(encryptedJson);

      final secretBox = SecretBox(
        base64Decode(encryptedData['ciphertext'] as String),
        nonce: base64Decode(encryptedData['nonce'] as String),
        mac: Mac(base64Decode(encryptedData['mac'] as String)),
      );

      final decryptedBytes = await _aesGcm.decrypt(
        secretBox,
        secretKey: masterKey,
      );

      return Uint8List.fromList(decryptedBytes);
    } on SecretBoxAuthenticationError {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Encrypt plaintext with dataKey
  Future<String> encryptText(String plaintext) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }

    if (plaintext.isEmpty) {
      return plaintext;
    }

    final nonce = _aesGcm.newNonce();
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: _dataKey!,
      nonce: nonce,
    );

    final encryptedData = {
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return jsonEncode(encryptedData);
  }

  /// Decrypt ciphertext with dataKey
  Future<String> decryptText(String encryptedJson) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }

    if (encryptedJson.isEmpty) {
      return encryptedJson;
    }

    if (!isEncrypted(encryptedJson)) {
      return encryptedJson;
    }

    try {
      final encryptedData = jsonDecode(encryptedJson);

      final secretBox = SecretBox(
        base64Decode(encryptedData['ciphertext'] as String),
        nonce: base64Decode(encryptedData['nonce'] as String),
        mac: Mac(base64Decode(encryptedData['mac'] as String)),
      );

      final decryptedBytes = await _aesGcm.decrypt(
        secretBox,
        secretKey: _dataKey!,
      );

      return utf8.decode(decryptedBytes);
    } catch (e) {
      return encryptedJson;
    }
  }

  /// Encrypt nullable text
  Future<String?> encryptTextNullable(String? plaintext) async {
    if (plaintext == null || plaintext.isEmpty) {
      return null;
    }
    return encryptText(plaintext);
  }

  /// Decrypt nullable text
  Future<String?> decryptTextNullable(String? encryptedJson) async {
    if (encryptedJson == null || encryptedJson.isEmpty) {
      return null;
    }
    return decryptText(encryptedJson);
  }

  /// Encrypt multiple fields in a map
  Future<Map<String, dynamic>> encryptFields(
    Map<String, dynamic> data,
    List<String> fieldsToEncrypt,
  ) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }

    final result = Map<String, dynamic>.from(data);

    for (final field in fieldsToEncrypt) {
      if (result.containsKey(field) && result[field] is String) {
        final value = result[field] as String;
        if (value.isNotEmpty) {
          result[field] = await encryptText(value);
        }
      }
    }

    return result;
  }

  /// Decrypt multiple fields in a map
  Future<Map<String, dynamic>> decryptFields(
    Map<String, dynamic> data,
    List<String> fieldsToDecrypt,
  ) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }

    final result = Map<String, dynamic>.from(data);

    for (final field in fieldsToDecrypt) {
      if (result.containsKey(field) && result[field] is String) {
        final value = result[field] as String;
        if (value.isNotEmpty) {
          result[field] = await decryptText(value);
        }
      }
    }

    return result;
  }
}

void main() {
  late TestableEncryptionService service;

  setUp(() {
    service = TestableEncryptionService();
  });

  group('Utility Methods', () {
    test('isNumeric returns true for numeric strings', () {
      expect(service.isNumeric('123456'), isTrue);
      expect(service.isNumeric('000000'), isTrue);
      expect(service.isNumeric('999999'), isTrue);
    });

    test('isNumeric returns false for non-numeric strings', () {
      expect(service.isNumeric('abc123'), isFalse);
      expect(service.isNumeric('12.34'), isFalse);
      expect(service.isNumeric('12-34'), isFalse);
      expect(service.isNumeric(''), isFalse);
      expect(service.isNumeric(' '), isFalse);
    });

    test('bytesToHex converts bytes to hex string', () {
      final bytes = Uint8List.fromList([0, 15, 255, 128]);
      expect(service.bytesToHex(bytes), equals('000fff80'));
    });

    test('bytesToHex handles empty bytes', () {
      final bytes = Uint8List.fromList([]);
      expect(service.bytesToHex(bytes), equals(''));
    });

    test('randomBytes generates bytes of correct length', () {
      expect(service.randomBytes(16).length, equals(16));
      expect(service.randomBytes(32).length, equals(32));
      expect(service.randomBytes(0).length, equals(0));
    });

    test('isEncrypted detects valid encrypted JSON', () {
      final validEncrypted = jsonEncode({
        'nonce': base64Encode([1, 2, 3]),
        'ciphertext': base64Encode([4, 5, 6]),
        'mac': base64Encode([7, 8, 9]),
      });
      expect(service.isEncrypted(validEncrypted), isTrue);
    });

    test('isEncrypted returns false for plaintext', () {
      expect(service.isEncrypted('Hello World'), isFalse);
      expect(service.isEncrypted(''), isFalse);
      expect(service.isEncrypted('not json'), isFalse);
    });

    test('isEncrypted returns false for incomplete JSON', () {
      expect(service.isEncrypted('{"nonce": "abc"}'), isFalse);
      expect(service.isEncrypted('{"nonce": "abc", "ciphertext": "def"}'), isFalse);
    });

    test('isEncrypted returns false for non-object JSON', () {
      expect(service.isEncrypted('[1, 2, 3]'), isFalse);
      expect(service.isEncrypted('"string"'), isFalse);
    });
  });

  group('Key Derivation', () {
    test('deriveKey produces 256-bit key', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final key = await service.deriveKey('123456', salt, 1000);
      
      final keyData = await key.extractBytes();
      expect(keyData.length, equals(32)); // 256 bits = 32 bytes
    });

    test('deriveKey produces consistent results with same inputs', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      
      final key1 = await service.deriveKey('123456', salt, 1000);
      final key2 = await service.deriveKey('123456', salt, 1000);
      
      final keyData1 = await key1.extractBytes();
      final keyData2 = await key2.extractBytes();
      
      expect(keyData1, equals(keyData2));
    });

    test('deriveKey produces different results with different PINs', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      
      final key1 = await service.deriveKey('123456', salt, 1000);
      final key2 = await service.deriveKey('654321', salt, 1000);
      
      final keyData1 = await key1.extractBytes();
      final keyData2 = await key2.extractBytes();
      
      expect(keyData1, isNot(equals(keyData2)));
    });

    test('deriveKey produces different results with different salts', () async {
      final salt1 = Uint8List.fromList(List.generate(16, (i) => i));
      final salt2 = Uint8List.fromList(List.generate(16, (i) => i + 1));
      
      final key1 = await service.deriveKey('123456', salt1, 1000);
      final key2 = await service.deriveKey('123456', salt2, 1000);
      
      final keyData1 = await key1.extractBytes();
      final keyData2 = await key2.extractBytes();
      
      expect(keyData1, isNot(equals(keyData2)));
    });
  });

  group('DataKey Encryption/Decryption', () {
    test('encryptDataKey produces valid JSON format', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await service.deriveKey('123456', salt, 1000);
      final dataKey = Uint8List.fromList(List.generate(32, (i) => i));
      
      final encrypted = await service.encryptDataKey(masterKey, dataKey);
      
      final parsed = jsonDecode(encrypted);
      expect(parsed['nonce'], isNotNull);
      expect(parsed['ciphertext'], isNotNull);
      expect(parsed['mac'], isNotNull);
    });

    test('decryptDataKey recovers original dataKey with correct key', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await service.deriveKey('123456', salt, 1000);
      final dataKey = Uint8List.fromList(List.generate(32, (i) => i * 2));
      
      final encrypted = await service.encryptDataKey(masterKey, dataKey);
      final decrypted = await service.decryptDataKey(masterKey, encrypted);
      
      expect(decrypted, equals(dataKey));
    });

    test('decryptDataKey returns null with wrong key', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final correctKey = await service.deriveKey('123456', salt, 1000);
      final wrongKey = await service.deriveKey('654321', salt, 1000);
      final dataKey = Uint8List.fromList(List.generate(32, (i) => i));
      
      final encrypted = await service.encryptDataKey(correctKey, dataKey);
      final decrypted = await service.decryptDataKey(wrongKey, encrypted);
      
      expect(decrypted, isNull);
    });

    test('decryptDataKey returns null for invalid JSON', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await service.deriveKey('123456', salt, 1000);
      
      final decrypted = await service.decryptDataKey(masterKey, 'invalid json');
      
      expect(decrypted, isNull);
    });

    test('decryptDataKey returns null for corrupted ciphertext', () async {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      final masterKey = await service.deriveKey('123456', salt, 1000);
      
      final corrupted = jsonEncode({
        'nonce': base64Encode([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
        'ciphertext': base64Encode([1, 2, 3]),
        'mac': base64Encode([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]),
      });
      
      final decrypted = await service.decryptDataKey(masterKey, corrupted);
      
      expect(decrypted, isNull);
    });
  });

  group('Text Encryption/Decryption - CRITICAL', () {
    late SecretKey testDataKey;

    setUp(() async {
      // Create a fixed data key for testing
      testDataKey = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(testDataKey);
    });

    test('encryptText and decryptText roundtrip works', () async {
      const originalText = 'This is a secret message!';
      
      final encrypted = await service.encryptText(originalText);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(originalText));
    });

    test('encryptText produces encrypted JSON format', () async {
      const text = 'Secret';
      
      final encrypted = await service.encryptText(text);
      
      expect(service.isEncrypted(encrypted), isTrue);
    });

    test('encryptText produces different ciphertext each time (random nonce)', () async {
      const text = 'Same message';
      
      final encrypted1 = await service.encryptText(text);
      final encrypted2 = await service.encryptText(text);
      
      expect(encrypted1, isNot(equals(encrypted2)));
      
      // But both decrypt to the same value
      final decrypted1 = await service.decryptText(encrypted1);
      final decrypted2 = await service.decryptText(encrypted2);
      expect(decrypted1, equals(decrypted2));
    });

    test('encryptText handles empty string', () async {
      final encrypted = await service.encryptText('');
      expect(encrypted, equals(''));
    });

    test('decryptText handles empty string', () async {
      final decrypted = await service.decryptText('');
      expect(decrypted, equals(''));
    });

    test('decryptText returns plaintext for non-encrypted input', () async {
      const plaintext = 'This is not encrypted';
      
      final result = await service.decryptText(plaintext);
      
      expect(result, equals(plaintext));
    });

    test('encryptText handles special characters', () async {
      const specialText = 'Hello 世界! 🎉 Ümläuts & "quotes" <tags>';
      
      final encrypted = await service.encryptText(specialText);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(specialText));
    });

    test('encryptText handles long text', () async {
      final longText = 'A' * 10000;
      
      final encrypted = await service.encryptText(longText);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(longText));
    });

    test('encryptText handles multiline text', () async {
      const multiline = 'Line 1\nLine 2\nLine 3\n\tIndented';
      
      final encrypted = await service.encryptText(multiline);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(multiline));
    });

    test('encryptText throws when not ready', () async {
      service.lock();
      
      expect(
        () => service.encryptText('test'),
        throwsA(isA<Exception>()),
      );
    });

    test('decryptText throws when not ready', () async {
      service.lock();
      
      expect(
        () => service.decryptText('{"nonce":"a","ciphertext":"b","mac":"c"}'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Nullable Text Encryption/Decryption', () {
    setUp(() async {
      final testDataKey = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(testDataKey);
    });

    test('encryptTextNullable returns null for null input', () async {
      final result = await service.encryptTextNullable(null);
      expect(result, isNull);
    });

    test('encryptTextNullable returns null for empty input', () async {
      final result = await service.encryptTextNullable('');
      expect(result, isNull);
    });

    test('encryptTextNullable encrypts non-empty input', () async {
      final result = await service.encryptTextNullable('test');
      expect(result, isNotNull);
      expect(service.isEncrypted(result!), isTrue);
    });

    test('decryptTextNullable returns null for null input', () async {
      final result = await service.decryptTextNullable(null);
      expect(result, isNull);
    });

    test('decryptTextNullable returns null for empty input', () async {
      final result = await service.decryptTextNullable('');
      expect(result, isNull);
    });

    test('encryptTextNullable and decryptTextNullable roundtrip', () async {
      const original = 'Secret note';
      
      final encrypted = await service.encryptTextNullable(original);
      final decrypted = await service.decryptTextNullable(encrypted);
      
      expect(decrypted, equals(original));
    });
  });

  group('Batch Field Encryption/Decryption', () {
    setUp(() async {
      final testDataKey = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(testDataKey);
    });

    test('encryptFields encrypts specified fields', () async {
      final data = {
        'name': 'John',
        'notes': 'Secret notes',
        'public': 'visible',
      };
      
      final encrypted = await service.encryptFields(data, ['notes']);
      
      expect(encrypted['name'], equals('John'));
      expect(encrypted['public'], equals('visible'));
      expect(service.isEncrypted(encrypted['notes']), isTrue);
    });

    test('encryptFields ignores non-existent fields', () async {
      final data = {'name': 'John'};
      
      final encrypted = await service.encryptFields(data, ['nonexistent']);
      
      expect(encrypted, equals(data));
    });

    test('encryptFields ignores empty string fields', () async {
      final data = {'notes': ''};
      
      final encrypted = await service.encryptFields(data, ['notes']);
      
      expect(encrypted['notes'], equals(''));
    });

    test('encryptFields ignores non-string fields', () async {
      final data = {
        'count': 42,
        'active': true,
        'notes': 'secret',
      };
      
      final encrypted = await service.encryptFields(data, ['count', 'active', 'notes']);
      
      expect(encrypted['count'], equals(42));
      expect(encrypted['active'], equals(true));
      expect(service.isEncrypted(encrypted['notes']), isTrue);
    });

    test('decryptFields decrypts specified fields', () async {
      final testDataKey = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(testDataKey);
      
      final encrypted = await service.encryptText('Secret');
      final data = {
        'name': 'John',
        'notes': encrypted,
      };
      
      final decrypted = await service.decryptFields(data, ['notes']);
      
      expect(decrypted['name'], equals('John'));
      expect(decrypted['notes'], equals('Secret'));
    });

    test('encryptFields and decryptFields roundtrip', () async {
      final original = {
        'name': 'Test',
        'notes': 'Secret message',
        'action': 'Private action',
        'id': 123,
      };
      
      final encrypted = await service.encryptFields(
        original,
        ['notes', 'action'],
      );
      final decrypted = await service.decryptFields(
        encrypted,
        ['notes', 'action'],
      );
      
      expect(decrypted['name'], equals('Test'));
      expect(decrypted['notes'], equals('Secret message'));
      expect(decrypted['action'], equals('Private action'));
      expect(decrypted['id'], equals(123));
    });

    test('encryptFields throws when not ready', () async {
      service.lock();
      
      expect(
        () => service.encryptFields({'a': 'b'}, ['a']),
        throwsA(isA<Exception>()),
      );
    });

    test('decryptFields throws when not ready', () async {
      service.lock();
      
      expect(
        () => service.decryptFields({'a': 'b'}, ['a']),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Lock/Unlock State', () {
    test('isReady is false initially', () {
      expect(service.isReady, isFalse);
    });

    test('isReady is true after setDataKey', () async {
      final key = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(key);
      
      expect(service.isReady, isTrue);
    });

    test('isReady is false after lock', () async {
      final key = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(key);
      service.lock();
      
      expect(service.isReady, isFalse);
    });
  });

  group('Full PIN Flow Simulation', () {
    test('simulates complete PIN setup and unlock flow', () async {
      // Simulate PIN setup
      const pin = '920894';
      final salt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000; // Lower for testing speed
      
      // 1. Derive key from PIN
      final kPin = await service.deriveKey(pin, salt, iterations);
      
      // 2. Encrypt dataKey with PIN
      final encryptedKey = await service.encryptDataKey(kPin, dataKeyBytes);
      
      // 3. Simulate unlock with correct PIN
      final kPin2 = await service.deriveKey(pin, salt, iterations);
      final decryptedKey = await service.decryptDataKey(kPin2, encryptedKey);
      
      expect(decryptedKey, equals(dataKeyBytes));
      
      // 4. Set up encryption and verify it works
      service.setDataKey(SecretKey(decryptedKey!));
      
      const testMessage = 'This is a secret note';
      final encrypted = await service.encryptText(testMessage);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(testMessage));
    });

    test('simulates wrong PIN rejection', () async {
      const correctPin = '920894';
      const wrongPin = '123456';
      final salt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000;
      
      // Setup with correct PIN
      final kPin = await service.deriveKey(correctPin, salt, iterations);
      final encryptedKey = await service.encryptDataKey(kPin, dataKeyBytes);
      
      // Try to unlock with wrong PIN
      final kWrong = await service.deriveKey(wrongPin, salt, iterations);
      final decryptedKey = await service.decryptDataKey(kWrong, encryptedKey);
      
      expect(decryptedKey, isNull);
    });

    test('simulates recovery key flow', () async {
      const pin = '920894';
      const recoveryKey = 'abc123def456789012345678';
      final saltPin = service.randomBytes(16);
      final saltRecovery = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000;
      
      // Setup with both PIN and recovery key
      final kPin = await service.deriveKey(pin, saltPin, iterations);
      final kRec = await service.deriveKey(recoveryKey, saltRecovery, iterations);
      
      final encryptedKeyPin = await service.encryptDataKey(kPin, dataKeyBytes);
      final encryptedKeyRecovery = await service.encryptDataKey(kRec, dataKeyBytes);
      
      // Unlock with recovery key
      final kRec2 = await service.deriveKey(recoveryKey, saltRecovery, iterations);
      final decryptedKey = await service.decryptDataKey(kRec2, encryptedKeyRecovery);
      
      expect(decryptedKey, equals(dataKeyBytes));
      
      // Verify both keys decrypt to the same dataKey
      final kPin2 = await service.deriveKey(pin, saltPin, iterations);
      final decryptedKeyPin = await service.decryptDataKey(kPin2, encryptedKeyPin);
      
      expect(decryptedKeyPin, equals(dataKeyBytes));
    });

    test('simulates PIN reset with recovery key', () async {
      const originalPin = '920894';
      const newPin = '111222';
      const recoveryKey = 'abc123def456789012345678';
      final saltPin = service.randomBytes(16);
      final saltRecovery = service.randomBytes(16);
      final newSaltPin = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000;
      
      // Initial setup
      final kPin = await service.deriveKey(originalPin, saltPin, iterations);
      final kRec = await service.deriveKey(recoveryKey, saltRecovery, iterations);
      
      await service.encryptDataKey(kPin, dataKeyBytes);
      final encryptedKeyRecovery = await service.encryptDataKey(kRec, dataKeyBytes);
      
      // Reset PIN using recovery key
      // 1. Decrypt dataKey with recovery key
      final kRec2 = await service.deriveKey(recoveryKey, saltRecovery, iterations);
      final recoveredDataKey = await service.decryptDataKey(kRec2, encryptedKeyRecovery);
      
      expect(recoveredDataKey, isNotNull);
      
      // 2. Re-encrypt with new PIN
      final kNewPin = await service.deriveKey(newPin, newSaltPin, iterations);
      final newEncryptedKey = await service.encryptDataKey(kNewPin, recoveredDataKey!);
      
      // 3. Verify new PIN works
      final kNewPin2 = await service.deriveKey(newPin, newSaltPin, iterations);
      final decryptedNewKey = await service.decryptDataKey(kNewPin2, newEncryptedKey);
      
      expect(decryptedNewKey, equals(dataKeyBytes));
      
      // 4. Verify old PIN no longer works for new encrypted key
      final kOldPin = await service.deriveKey(originalPin, newSaltPin, iterations);
      final shouldFail = await service.decryptDataKey(kOldPin, newEncryptedKey);
      
      expect(shouldFail, isNull);
    });

    test('simulates PIN change with old PIN (changePin flow)', () async {
      // This tests the critical changePin() flow that re-wraps dataKey
      // WITHOUT regenerating the dataKey itself
      
      const originalPin = '920894';
      const newPin = '111222';
      final originalSalt = service.randomBytes(16);
      final newSalt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000;
      
      // Step 1: Initial PIN setup (simulates setupNewSecrets)
      final kOriginalPin = await service.deriveKey(originalPin, originalSalt, iterations);
      final encryptedKeyWithOriginal = await service.encryptDataKey(kOriginalPin, dataKeyBytes);
      
      // Set up encryption with the dataKey
      service.setDataKey(SecretKey(dataKeyBytes));
      
      // Encrypt some test data with the original dataKey
      const testMessage = 'My secret drug use note';
      final encryptedTestData = await service.encryptText(testMessage);
      
      // Step 2: Change PIN (simulates changePin method)
      // 2a. Verify old PIN by decrypting dataKey
      final kOldPinForChange = await service.deriveKey(originalPin, originalSalt, iterations);
      final recoveredDataKey = await service.decryptDataKey(kOldPinForChange, encryptedKeyWithOriginal);
      
      expect(recoveredDataKey, isNotNull, reason: 'Old PIN should decrypt dataKey');
      expect(recoveredDataKey, equals(dataKeyBytes), reason: 'DataKey should match original');
      
      // 2b. Re-encrypt the SAME dataKey with new PIN (this is the critical part)
      final kNewPin = await service.deriveKey(newPin, newSalt, iterations);
      final encryptedKeyWithNew = await service.encryptDataKey(kNewPin, recoveredDataKey!);
      
      // Step 3: Verify the change worked correctly
      // 3a. New PIN should unlock
      final kNewPin2 = await service.deriveKey(newPin, newSalt, iterations);
      final decryptedWithNewPin = await service.decryptDataKey(kNewPin2, encryptedKeyWithNew);
      
      expect(decryptedWithNewPin, equals(dataKeyBytes), 
          reason: 'New PIN should decrypt to same dataKey');
      
      // 3b. Old PIN should NOT work with new encrypted key
      final kOldPinFail = await service.deriveKey(originalPin, newSalt, iterations);
      final shouldFail = await service.decryptDataKey(kOldPinFail, encryptedKeyWithNew);
      
      expect(shouldFail, isNull, 
          reason: 'Old PIN should not work with new encryption');
      
      // Step 4: CRITICAL - Verify existing encrypted data is still readable
      // The dataKey never changed, so old data should still decrypt
      service.setDataKey(SecretKey(decryptedWithNewPin!));
      
      final decryptedTestData = await service.decryptText(encryptedTestData);
      
      expect(decryptedTestData, equals(testMessage),
          reason: 'Changing PIN should NOT break existing encrypted data');
    });

    test('verifies data key consistency during PIN change', () async {
      // This test explicitly verifies that the dataKey remains unchanged
      // during a PIN change operation
      
      const pin1 = '111111';
      const pin2 = '222222';
      const pin3 = '333333';
      final salt1 = service.randomBytes(16);
      final salt2 = service.randomBytes(16);
      final salt3 = service.randomBytes(16);
      final originalDataKey = service.randomBytes(32);
      const iterations = 1000;
      
      // Multiple encryption operations with same dataKey
      service.setDataKey(SecretKey(originalDataKey));
      
      const message1 = 'First message';
      const message2 = 'Second message';
      const message3 = 'Third message';
      
      final encrypted1 = await service.encryptText(message1);
      final encrypted2 = await service.encryptText(message2);
      
      // Now simulate multiple PIN changes
      // PIN 1 -> PIN 2
      final k1 = await service.deriveKey(pin1, salt1, iterations);
      final encryptedKey1 = await service.encryptDataKey(k1, originalDataKey);
      
      // Recover and re-wrap for PIN 2
      final recoveredKey1 = await service.decryptDataKey(k1, encryptedKey1);
      final k2 = await service.deriveKey(pin2, salt2, iterations);
      await service.encryptDataKey(k2, recoveredKey1!);
      
      // Encrypt more data (simulating use after first PIN change)
      final encrypted3 = await service.encryptText(message3);
      
      // PIN 2 -> PIN 3
      final recoveredKey2 = await service.decryptDataKey(k2, 
          await service.encryptDataKey(k2, originalDataKey));
      final k3 = await service.deriveKey(pin3, salt3, iterations);
      await service.encryptDataKey(k3, recoveredKey2!);
      
      // Verify ALL encrypted data is still readable
      final decrypted1 = await service.decryptText(encrypted1);
      final decrypted2 = await service.decryptText(encrypted2);
      final decrypted3 = await service.decryptText(encrypted3);
      
      expect(decrypted1, equals(message1), reason: 'Message 1 should still decrypt');
      expect(decrypted2, equals(message2), reason: 'Message 2 should still decrypt');
      expect(decrypted3, equals(message3), reason: 'Message 3 should still decrypt');
    });

    test('wrong old PIN fails changePin', () async {
      const correctPin = '920894';
      const wrongPin = '000000';
      // const newPin = '111222'; // Would be used if old PIN validation passed
      final salt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      const iterations = 1000;
      
      // Setup with correct PIN
      final kCorrect = await service.deriveKey(correctPin, salt, iterations);
      final encryptedKey = await service.encryptDataKey(kCorrect, dataKeyBytes);
      
      // Try to change with wrong old PIN
      final kWrong = await service.deriveKey(wrongPin, salt, iterations);
      final recoveredKey = await service.decryptDataKey(kWrong, encryptedKey);
      
      // Should fail - can't proceed with PIN change
      expect(recoveredKey, isNull, 
          reason: 'Wrong old PIN should fail to decrypt dataKey');
    });
  });

  group('Edge Cases', () {
    test('handles PIN with leading zeros', () async {
      const pin = '000001';
      final salt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      
      final kPin = await service.deriveKey(pin, salt, 1000);
      final encrypted = await service.encryptDataKey(kPin, dataKeyBytes);
      
      final kPin2 = await service.deriveKey(pin, salt, 1000);
      final decrypted = await service.decryptDataKey(kPin2, encrypted);
      
      expect(decrypted, equals(dataKeyBytes));
    });

    test('handles recovery key with special hex chars', () async {
      const recoveryKey = 'aabbccddeeff001122334455';
      final salt = service.randomBytes(16);
      final dataKeyBytes = service.randomBytes(32);
      
      final kRec = await service.deriveKey(recoveryKey, salt, 1000);
      final encrypted = await service.encryptDataKey(kRec, dataKeyBytes);
      
      final kRec2 = await service.deriveKey(recoveryKey, salt, 1000);
      final decrypted = await service.decryptDataKey(kRec2, encrypted);
      
      expect(decrypted, equals(dataKeyBytes));
    });

    test('handles very long text encryption', () async {
      final key = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(key);
      
      final longText = 'X' * 100000;
      
      final encrypted = await service.encryptText(longText);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(longText));
    });

    test('handles JSON text that looks like encrypted data', () async {
      final key = SecretKey(List.generate(32, (i) => i));
      service.setDataKey(key);
      
      // Text that contains JSON but isn't our encrypted format
      const textWithJson = 'Notes: {"key": "value", "array": [1,2,3]}';
      
      final encrypted = await service.encryptText(textWithJson);
      final decrypted = await service.decryptText(encrypted);
      
      expect(decrypted, equals(textWithJson));
    });
  });
}

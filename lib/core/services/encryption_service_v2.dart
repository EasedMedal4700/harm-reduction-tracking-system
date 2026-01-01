// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../utils/error_handler.dart';

/// Zero-Knowledge Encryption Service with PIN/Biometric unlock
///
/// Architecture:
/// 1. User sets 6-digit PIN
/// 2. PIN → PBKDF2 → masterKey (Kpin)
/// 3. Random dataKey generated once (never changes)
/// 4. dataKey encrypted with Kpin → stored in Supabase
/// 5. Recovery key also generated for backup access
/// 6. Biometrics encrypt PIN locally (optional)
///
/// Zero-knowledge guarantee:
/// - Server never sees PIN, recoveryKey, or dataKey
/// - All encryption happens client-side
/// - Works across devices with PIN or recovery key
class EncryptionServiceV2 {
  static final EncryptionServiceV2 _instance = EncryptionServiceV2._internal();
  factory EncryptionServiceV2() => _instance;
  EncryptionServiceV2._internal();
  SupabaseClient get _client => Supabase.instance.client;
  final _secureStorage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  final AesGcm _aesGcm = AesGcm.with256bits();
  SecretKey? _dataKey;

  /// Check if encryption is ready (dataKey loaded)
  bool get isReady => _dataKey != null;

  @visibleForTesting
  void setDataKeyForTesting(SecretKey dataKey) {
    _dataKey = dataKey;
  }

  /// Storage keys
  static const String _keyEncryptedPin = 'encrypted_pin';
  static const String _keyBiometricsEnabled = 'biometrics_enabled';
  // ============================================================================
  // SETUP: First-time key generation
  // ============================================================================
  /// Setup new encryption secrets for a user
  ///
  /// Returns: Recovery key (MUST be shown to user and saved securely)
  ///
  /// Steps:
  /// 1. Generate random 32-byte dataKey
  /// 2. Generate random recovery key (24 chars hex)
  /// 3. Create salts for PIN and recovery key
  /// 4. Derive Kpin and Krec using PBKDF2
  /// 5. Encrypt dataKey twice (PIN and recovery)
  /// 6. Upload to Supabase
  Future<String> setupNewSecrets(String uuidUserId, String pin) async {
    try {
      if (pin.length != 6 || !_isNumeric(pin)) {
        throw Exception('PIN must be exactly 6 digits');
      }
      // 1. Generate random dataKey (THIS NEVER CHANGES)
      final dataKeyBytes = _randomBytes(32);
      _dataKey = SecretKey(dataKeyBytes);
      // 2. Generate recovery key (24 hex chars = 96 bits entropy)
      final recoveryKeyBytes = _randomBytes(12);
      final recoveryKey = _bytesToHex(recoveryKeyBytes);
      // 3. Generate salts
      final salt = _randomBytes(16);
      final saltRecovery = _randomBytes(16);
      // 4. Derive keys from PIN and recovery key
      const iterations = 100000;
      final kPin = await _deriveKey(pin, salt, iterations);
      final kRec = await _deriveKey(recoveryKey, saltRecovery, iterations);
      // 5. Encrypt dataKey twice
      final encryptedKey = await _encryptDataKey(kPin, dataKeyBytes);
      final encryptedKeyRecovery = await _encryptDataKey(kRec, dataKeyBytes);
      // 6. Store in Supabase
      await _client.from('user_keys').upsert({
        'uuid_user_id': uuidUserId,
        'encrypted_key': encryptedKey,
        'salt': base64Encode(salt),
        'kdf_iterations': iterations,
        'encrypted_key_recovery': encryptedKeyRecovery,
        'salt_recovery': base64Encode(saltRecovery),
        'kdf_iterations_recovery': iterations,
        'key_version': 1,
        'updated_at': DateTime.now().toIso8601String(),
      });
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'Setup complete for user ${uuidUserId.substring(0, 8)}...',
      );
      return recoveryKey;
    } catch (e, stack) {
      ErrorHandler.logError('EncryptionServiceV2', 'Setup failed: $e', stack);
      rethrow;
    }
  }

  // ============================================================================
  // UNLOCK: PIN-based unlock
  // ============================================================================
  /// Unlock encryption with 6-digit PIN
  ///
  /// Returns: true if PIN correct, false if wrong
  Future<bool> unlockWithPin(String uuidUserId, String pin) async {
    try {
      if (pin.length != 6 || !_isNumeric(pin)) {
        return false;
      }
      // Fetch user_keys from Supabase
      final response = await _client
          .from('user_keys')
          .select()
          .eq('uuid_user_id', uuidUserId)
          .maybeSingle();
      if (response == null) {
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'No encryption keys found for user',
        );
        return false;
      }
      final encryptedKey = response['encrypted_key'] as String;
      final salt = base64Decode(response['salt'] as String);
      final iterations = response['kdf_iterations'] as int;
      // Derive key from PIN
      final kPin = await _deriveKey(pin, salt, iterations);
      // Try to decrypt dataKey
      final dataKeyBytes = await _decryptDataKey(kPin, encryptedKey);
      if (dataKeyBytes == null) {
        // Wrong PIN (MAC error)
        return false;
      }
      // Success!
      _dataKey = SecretKey(dataKeyBytes);
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'Unlocked with PIN for user ${uuidUserId.substring(0, 8)}...',
      );
      return true;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'PIN unlock failed: $e',
        stack,
      );
      return false;
    }
  }

  // ============================================================================
  // UNLOCK: Recovery key-based unlock
  // ============================================================================
  /// Unlock encryption with recovery key
  ///
  /// Returns: true if recovery key correct, false if wrong
  Future<bool> unlockWithRecoveryKey(
    String uuidUserId,
    String recoveryKey,
  ) async {
    try {
      // Fetch user_keys from Supabase
      final response = await _client
          .from('user_keys')
          .select()
          .eq('uuid_user_id', uuidUserId)
          .maybeSingle();
      if (response == null) {
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'No encryption keys found for user',
        );
        return false;
      }
      final encryptedKeyRecovery = response['encrypted_key_recovery'] as String;
      final saltRecovery = base64Decode(response['salt_recovery'] as String);
      final iterationsRecovery = response['kdf_iterations_recovery'] as int;
      // Derive key from recovery key
      final kRec = await _deriveKey(
        recoveryKey,
        saltRecovery,
        iterationsRecovery,
      );
      // Try to decrypt dataKey
      final dataKeyBytes = await _decryptDataKey(kRec, encryptedKeyRecovery);
      if (dataKeyBytes == null) {
        // Wrong recovery key (MAC error)
        return false;
      }
      // Success!
      _dataKey = SecretKey(dataKeyBytes);
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'Unlocked with recovery key for user ${uuidUserId.substring(0, 8)}...',
      );
      return true;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'Recovery key unlock failed: $e',
        stack,
      );
      return false;
    }
  }

  /// Reset PIN using recovery key
  ///
  /// This validates the recovery key, decrypts the dataKey, then re-encrypts
  /// it with the new PIN. The recovery key remains unchanged.
  ///
  /// Returns: true if successful, false if recovery key is invalid
  Future<bool> resetPinWithRecoveryKey(
    String uuidUserId,
    String recoveryKey,
    String newPin,
  ) async {
    try {
      // Validate new PIN
      if (newPin.length != 6 || !_isNumeric(newPin)) {
        throw Exception('PIN must be exactly 6 digits');
      }
      // Fetch user_keys from Supabase
      final response = await _client
          .from('user_keys')
          .select()
          .eq('uuid_user_id', uuidUserId)
          .maybeSingle();
      if (response == null) {
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'No encryption keys found for user',
        );
        return false;
      }
      final encryptedKeyRecovery = response['encrypted_key_recovery'] as String;
      final saltRecovery = base64Decode(response['salt_recovery'] as String);
      final iterationsRecovery = response['kdf_iterations_recovery'] as int;
      // Derive key from recovery key
      final kRec = await _deriveKey(
        recoveryKey,
        saltRecovery,
        iterationsRecovery,
      );
      // Try to decrypt dataKey with recovery key
      final dataKeyBytes = await _decryptDataKey(kRec, encryptedKeyRecovery);
      if (dataKeyBytes == null) {
        // Wrong recovery key (MAC error)
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'Invalid recovery key provided for PIN reset',
        );
        return false;
      }
      // Recovery key is valid! Now create new PIN encryption
      // Generate new salt for PIN
      final newSalt = _randomBytes(16);
      const iterations = 100000;
      // Derive key from new PIN
      final kPin = await _deriveKey(newPin, newSalt, iterations);
      // Encrypt dataKey with new PIN
      final newEncryptedKey = await _encryptDataKey(kPin, dataKeyBytes);
      // Update database with new PIN encryption (keep recovery unchanged)
      await _client
          .from('user_keys')
          .update({
            'encrypted_key': newEncryptedKey,
            'salt': base64Encode(newSalt),
            'kdf_iterations': iterations,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uuid_user_id', uuidUserId);
      // Set the dataKey in memory (user is now unlocked)
      _dataKey = SecretKey(dataKeyBytes);
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'PIN reset successful for user ${uuidUserId.substring(0, 8)}...',
      );
      return true;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'PIN reset with recovery key failed: $e',
        stack,
      );
      return false;
    }
  }

  /// Change PIN using old PIN (NOT for first-time setup)
  ///
  /// This validates the old PIN, decrypts the dataKey, then re-encrypts
  /// it with the new PIN. The recovery key remains unchanged.
  ///
  /// IMPORTANT: This does NOT regenerate the dataKey or recovery key.
  /// All existing encrypted data remains accessible.
  ///
  /// Returns: true if successful, false if old PIN is invalid
  Future<bool> changePin(
    String uuidUserId,
    String oldPin,
    String newPin,
  ) async {
    try {
      // Validate PINs
      if (oldPin.length != 6 || !_isNumeric(oldPin)) {
        throw Exception('Old PIN must be exactly 6 digits');
      }
      if (newPin.length != 6 || !_isNumeric(newPin)) {
        throw Exception('New PIN must be exactly 6 digits');
      }
      if (oldPin == newPin) {
        throw Exception('New PIN must be different from old PIN');
      }
      // Fetch user_keys from Supabase
      final response = await _client
          .from('user_keys')
          .select()
          .eq('uuid_user_id', uuidUserId)
          .maybeSingle();
      if (response == null) {
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'No encryption keys found for user',
        );
        return false;
      }
      final encryptedKey = response['encrypted_key'] as String;
      final salt = base64Decode(response['salt'] as String);
      final iterations = response['kdf_iterations'] as int;
      // Derive key from old PIN
      final kOldPin = await _deriveKey(oldPin, salt, iterations);
      // Try to decrypt dataKey with old PIN
      final dataKeyBytes = await _decryptDataKey(kOldPin, encryptedKey);
      if (dataKeyBytes == null) {
        // Wrong old PIN (MAC error)
        ErrorHandler.logWarning(
          'EncryptionServiceV2',
          'Invalid old PIN provided for PIN change',
        );
        return false;
      }
      // Old PIN is valid! Now create new PIN encryption
      // Generate new salt for new PIN
      final newSalt = _randomBytes(16);
      const newIterations = 100000;
      // Derive key from new PIN
      final kNewPin = await _deriveKey(newPin, newSalt, newIterations);
      // Re-encrypt the SAME dataKey with new PIN
      final newEncryptedKey = await _encryptDataKey(kNewPin, dataKeyBytes);
      // Update database with new PIN encryption
      // Recovery key and encrypted_key_recovery remain unchanged!
      await _client
          .from('user_keys')
          .update({
            'encrypted_key': newEncryptedKey,
            'salt': base64Encode(newSalt),
            'kdf_iterations': newIterations,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uuid_user_id', uuidUserId);
      // Set the dataKey in memory (user remains unlocked)
      _dataKey = SecretKey(dataKeyBytes);
      // If biometrics is enabled, update the stored PIN
      if (await isBiometricsEnabled()) {
        // Disable and re-enable with new PIN
        await disableBiometrics();
        await enableBiometrics(newPin);
      }
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'PIN changed successfully for user ${uuidUserId.substring(0, 8)}...',
      );
      return true;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'PIN change failed: $e',
        stack,
      );
      return false;
    }
  }

  // ============================================================================
  // BIOMETRICS: Fingerprint unlock
  // ============================================================================
  /// Enable biometric unlock (encrypts PIN with device keystore)
  Future<void> enableBiometrics(String pin) async {
    try {
      if (pin.length != 6 || !_isNumeric(pin)) {
        throw Exception('PIN must be exactly 6 digits');
      }
      // Check if biometrics available
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!canAuthenticate || !isDeviceSupported) {
        throw Exception('Biometrics not available on this device');
      }
      // Authenticate user before storing PIN
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable fingerprint unlock',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }
      // Generate random key for encrypting PIN
      final keystoreKey = SecretKey(_randomBytes(32));
      // Encrypt PIN with keystoreKey
      final nonce = _aesGcm.newNonce();
      final secretBox = await _aesGcm.encrypt(
        utf8.encode(pin),
        secretKey: keystoreKey,
        nonce: nonce,
      );
      final encryptedData = {
        'nonce': base64Encode(secretBox.nonce),
        'ciphertext': base64Encode(secretBox.cipherText),
        'mac': base64Encode(secretBox.mac.bytes),
        'keystore_key': base64Encode(await keystoreKey.extractBytes()),
      };
      // Store encrypted PIN and keystore key in secure storage
      await _secureStorage.write(
        key: _keyEncryptedPin,
        value: jsonEncode(encryptedData),
      );
      await _secureStorage.write(key: _keyBiometricsEnabled, value: 'true');
      ErrorHandler.logInfo(
        'EncryptionServiceV2',
        'Biometrics enabled successfully',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'Enable biometrics failed: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Disable biometric unlock
  Future<void> disableBiometrics() async {
    await _secureStorage.delete(key: _keyEncryptedPin);
    await _secureStorage.delete(key: _keyBiometricsEnabled);
    ErrorHandler.logInfo('EncryptionServiceV2', 'Biometrics disabled');
  }

  /// Check if biometrics is enabled
  Future<bool> isBiometricsEnabled() async {
    final enabled = await _secureStorage.read(key: _keyBiometricsEnabled);
    return enabled == 'true';
  }

  /// Unlock with biometrics (decrypt stored PIN and unlock)
  Future<bool> unlockWithBiometrics(String uuidUserId) async {
    try {
      // Check if biometrics enabled
      if (!await isBiometricsEnabled()) {
        return false;
      }
      // Authenticate user biometrically
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock with fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!authenticated) {
        return false;
      }
      // Read encrypted PIN
      final encryptedPinJson = await _secureStorage.read(key: _keyEncryptedPin);
      if (encryptedPinJson == null) {
        return false;
      }
      final encryptedData = jsonDecode(encryptedPinJson);
      final keystoreKeyBytes = base64Decode(
        encryptedData['keystore_key'] as String,
      );
      final keystoreKey = SecretKey(keystoreKeyBytes);
      // Decrypt PIN
      final secretBox = SecretBox(
        base64Decode(encryptedData['ciphertext'] as String),
        nonce: base64Decode(encryptedData['nonce'] as String),
        mac: Mac(base64Decode(encryptedData['mac'] as String)),
      );
      final decryptedBytes = await _aesGcm.decrypt(
        secretBox,
        secretKey: keystoreKey,
      );
      final pin = utf8.decode(decryptedBytes);
      // Unlock with decrypted PIN
      return await unlockWithPin(uuidUserId, pin);
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'Biometric unlock failed: $e',
        stack,
      );
      return false;
    }
  }

  // ============================================================================
  // DATA ENCRYPTION/DECRYPTION
  // ============================================================================
  /// Encrypt plaintext with dataKey
  /// Returns JSON: {nonce, ciphertext, mac}
  Future<String> encryptText(String plaintext) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }
    if (plaintext.isEmpty) {
      return plaintext;
    }
    try {
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
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'Text encryption failed: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Decrypt ciphertext with dataKey
  /// Input: JSON {nonce, ciphertext, mac}
  /// Returns: Plaintext or original if not encrypted
  Future<String> decryptText(String encryptedJson) async {
    if (!isReady) {
      throw Exception('Encryption not ready. Call unlock first.');
    }
    if (encryptedJson.isEmpty) {
      return encryptedJson;
    }
    // Check if already plaintext
    if (!_isEncrypted(encryptedJson)) {
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
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'Text decryption failed: $e',
        stack,
      );
      // Return original as fallback (legacy plaintext data)
      return encryptedJson;
    }
  }

  // ============================================================================
  // HELPERS: Key derivation and encryption
  // ============================================================================
  /// Derive 256-bit key from secret using PBKDF2-HMAC-SHA256
  Future<SecretKey> _deriveKey(
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
  /// Returns JSON: {nonce, ciphertext, mac}
  Future<String> _encryptDataKey(
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
  /// Returns dataKeyBytes or null if MAC error (wrong key)
  Future<Uint8List?> _decryptDataKey(
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
      // Wrong key (MAC mismatch)
      return null;
    } catch (e) {
      ErrorHandler.logError(
        'EncryptionServiceV2',
        'DataKey decryption error: $e',
        StackTrace.current,
      );
      return null;
    }
  }

  // ============================================================================
  // UTILITIES
  // ============================================================================
  /// Generate random bytes
  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Convert bytes to hex string
  String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Check if string is numeric
  bool _isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  /// Check if string is encrypted JSON
  bool _isEncrypted(String text) {
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

  /// Lock encryption (clear dataKey from memory)
  void lock() {
    _dataKey = null;
    ErrorHandler.logInfo('EncryptionServiceV2', 'Encryption locked');
  }

  /// Check if user has encryption setup
  Future<bool> hasEncryptionSetup(String uuidUserId) async {
    final response = await _client
        .from('user_keys')
        .select('uuid_user_id')
        .eq('uuid_user_id', uuidUserId)
        .maybeSingle();
    return response != null;
  }

  // ============================================================================
  // BATCH ENCRYPTION HELPERS
  // ============================================================================
  /// Encrypt a nullable text field
  /// Returns null if input is null or empty
  Future<String?> encryptTextNullable(String? plaintext) async {
    if (plaintext == null || plaintext.isEmpty) {
      return null;
    }
    return encryptText(plaintext);
  }

  /// Decrypt a nullable text field
  /// Returns null if input is null or empty
  Future<String?> decryptTextNullable(String? encryptedJson) async {
    if (encryptedJson == null || encryptedJson.isEmpty) {
      return null;
    }
    return decryptText(encryptedJson);
  }

  /// Encrypt multiple text fields in a map
  /// Useful for batch encryption before database insert/update
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

  /// Decrypt multiple text fields in a map
  /// Useful for batch decryption after database fetch
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

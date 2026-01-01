// MIGRATION:
// State: LEGACY
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Legacy service.
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

/// Service for handling end-to-end encryption of sensitive user data.
///
/// Architecture:
/// 1. User's JWT is used to derive an encryption key (never stored)
/// 2. A random 32-byte master key is generated per user
/// 3. The master key is encrypted with the JWT-derived key and stored in Supabase
/// 4. The master key is used to encrypt/decrypt user's notes and free-text fields
///
/// This ensures:
/// - Data is encrypted at rest in Supabase
/// - Only the authenticated user can decrypt their data
/// - Server never has access to plaintext or master keys
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      // Supabase not initialized (e.g., in tests)
      return null;
    }
  }

  final AesGcm _algorithm = AesGcm.with256bits();
  SecretKey? _masterKey;

  @visibleForTesting
  void setMasterKeyForTesting(SecretKey masterKey) {
    _masterKey = masterKey;
  }

  /// Initialize encryption for the current user.
  /// Call this after user logs in.
  Future<void> initialize() async {
    try {
      if (_client == null) {
        throw Exception('Supabase not initialized');
      }
      final user = _client!.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }
      // Check if user already has an encrypted key stored
      final response = await _client!
          .from('user_keys')
          .select('encrypted_key')
          .eq('uuid_user_id', user.id)
          .maybeSingle();
      if (response == null) {
        // First time login - generate and store new master key
        await _generateAndStoreNewKey(user);
      } else {
        // Load existing master key
        try {
          await _loadUserEncryptionKey();
        } catch (e) {
          // If decryption fails (MAC error), regenerate the key
          // This can happen if JWT was refreshed and old encrypted key is invalid
          if (e.toString().contains('MAC') ||
              e.toString().contains('authentication')) {
            ErrorHandler.logWarning(
              'EncryptionService',
              'Encryption key invalid (likely due to token refresh). Regenerating...',
            );
            await _generateAndStoreNewKey(user, isRegeneration: true);
          } else {
            rethrow;
          }
        }
      }
      ErrorHandler.logInfo(
        'EncryptionService',
        'Initialized for user: ${user.id.substring(0, 8)}...',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionService',
        'Failed to initialize: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Generate a new master key, encrypt it with JWT-derived key, and store in Supabase
  Future<void> _generateAndStoreNewKey(
    User user, {
    bool isRegeneration = false,
  }) async {
    try {
      // 1. Generate random 32-byte master key
      final random = Random.secure();
      final masterKeyBytes = List<int>.generate(32, (_) => random.nextInt(256));
      _masterKey = SecretKey(masterKeyBytes);
      // 2. Derive encryption key from JWT
      final session = _client!.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }
      final jwtKey = _deriveKeyFromJWT(session.accessToken);
      // 3. Encrypt master key with JWT-derived key
      final nonce = _algorithm.newNonce();
      final secretBox = await _algorithm.encrypt(
        masterKeyBytes,
        secretKey: jwtKey,
        nonce: nonce,
      );
      // 4. Store encrypted key as JSON
      final encryptedData = {
        'nonce': base64Encode(secretBox.nonce),
        'ciphertext': base64Encode(secretBox.cipherText),
        'mac': base64Encode(secretBox.mac.bytes),
      };
      // Generate a dummy salt for schema compatibility (JWT-based system doesn't use salt)
      final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
      final salt = base64Encode(saltBytes);
      final keyData = {
        'uuid_user_id': user.id,
        'encrypted_key': jsonEncode(encryptedData),
        'salt': salt, // Dummy salt for schema compatibility
        'kdf_iterations': 200000,
      };
      // Use upsert to handle both insert and update cases
      if (isRegeneration) {
        // Update existing row
        await _client!
            .from('user_keys')
            .update(keyData)
            .eq('uuid_user_id', user.id);
      } else {
        // Insert new row (use upsert to avoid conflicts)
        await _client!.from('user_keys').upsert(keyData);
      }
      ErrorHandler.logInfo(
        'EncryptionService',
        'Generated and stored new master key',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionService',
        'Failed to generate key: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Load and decrypt the user's master encryption key from Supabase
  Future<void> _loadUserEncryptionKey() async {
    try {
      if (_client == null) {
        throw Exception('Supabase not initialized');
      }
      final user = _client!.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }
      // 1. Fetch encrypted key from database
      final response = await _client!
          .from('user_keys')
          .select('encrypted_key')
          .eq('uuid_user_id', user.id)
          .single();
      final encryptedKeyJson = response['encrypted_key'] as String;
      final encryptedData =
          jsonDecode(encryptedKeyJson) as Map<String, dynamic>;
      // 2. Derive decryption key from JWT
      final session = _client!.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }
      final jwtKey = _deriveKeyFromJWT(session.accessToken);
      // 3. Decrypt master key
      final secretBox = SecretBox(
        base64Decode(encryptedData['ciphertext'] as String),
        nonce: base64Decode(encryptedData['nonce'] as String),
        mac: Mac(base64Decode(encryptedData['mac'] as String)),
      );
      final decryptedBytes = await _algorithm.decrypt(
        secretBox,
        secretKey: jwtKey,
      );
      _masterKey = SecretKey(decryptedBytes);
      ErrorHandler.logInfo(
        'EncryptionService',
        'Loaded master key successfully',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionService',
        'Failed to load key: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Derive an AES-256 key from the user's JWT using SHA-256
  SecretKey _deriveKeyFromJWT(String jwt) {
    final bytes = utf8.encode(jwt);
    final digest = sha256.convert(bytes);
    return SecretKey(digest.bytes);
  }

  /// Encrypt plaintext using AES-256-GCM with the master key
  /// Returns a JSON string: {nonce, ciphertext, mac}
  Future<String?> encryptText(String? plaintext) async {
    if (plaintext == null || plaintext.isEmpty) {
      return null;
    }
    if (_masterKey == null) {
      ErrorHandler.logWarning(
        'EncryptionService',
        'Master key not loaded, initializing...',
      );
      try {
        await initialize();
      } catch (e) {
        if (e.toString().contains('MAC') ||
            e.toString().contains('authentication')) {
          ErrorHandler.logWarning(
            'EncryptionService',
            'Recovering from MAC error during initialization',
          );
          // Clear the key and retry initialization to regenerate
          _masterKey = null;
          await initialize();
        } else {
          rethrow;
        }
      }
      if (_masterKey == null) {
        throw Exception('Failed to initialize encryption');
      }
    }
    try {
      final nonce = _algorithm.newNonce();
      final secretBox = await _algorithm.encrypt(
        utf8.encode(plaintext),
        secretKey: _masterKey!,
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
        'EncryptionService',
        'Encryption failed: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Decrypt ciphertext JSON using AES-256-GCM with the master key
  /// Input: JSON string {nonce, ciphertext, mac}
  /// Returns: Decrypted plaintext or null if input is null
  Future<String?> decryptText(String? encryptedJson) async {
    if (encryptedJson == null || encryptedJson.isEmpty) {
      return null;
    }
    // Auto-detect if already plaintext (not encrypted)
    if (!isEncrypted(encryptedJson)) {
      return encryptedJson;
    }
    if (_masterKey == null) {
      ErrorHandler.logWarning(
        'EncryptionService',
        'Master key not loaded, initializing...',
      );
      try {
        await initialize();
      } catch (e) {
        if (e.toString().contains('MAC') ||
            e.toString().contains('authentication')) {
          ErrorHandler.logWarning(
            'EncryptionService',
            'Recovering from MAC error during initialization',
          );
          // Clear the key and retry initialization to regenerate
          _masterKey = null;
          await initialize();
        } else {
          rethrow;
        }
      }
      if (_masterKey == null) {
        throw Exception('Failed to initialize encryption');
      }
    }
    try {
      final encryptedData = jsonDecode(encryptedJson) as Map<String, dynamic>;
      final secretBox = SecretBox(
        base64Decode(encryptedData['ciphertext'] as String),
        nonce: base64Decode(encryptedData['nonce'] as String),
        mac: Mac(base64Decode(encryptedData['mac'] as String)),
      );
      final decryptedBytes = await _algorithm.decrypt(
        secretBox,
        secretKey: _masterKey!,
      );
      return utf8.decode(decryptedBytes);
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionService',
        'Decryption failed: $e',
        stack,
      );
      // Return original text as fallback (might be legacy plaintext data)
      return encryptedJson;
    }
  }

  /// Check if a string is encrypted JSON (contains nonce, ciphertext, mac)
  /// Returns true if encrypted, false if plaintext
  bool isEncrypted(String text) {
    if (text.isEmpty) return false;
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

  /// Encrypt multiple text fields in a map
  /// Useful for batch encryption before database insert/update
  Future<Map<String, dynamic>> encryptFields(
    Map<String, dynamic> data,
    List<String> fieldsToEncrypt,
  ) async {
    final result = Map<String, dynamic>.from(data);
    for (final field in fieldsToEncrypt) {
      if (result.containsKey(field) && result[field] is String) {
        result[field] = await encryptText(result[field] as String);
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
    final result = Map<String, dynamic>.from(data);
    for (final field in fieldsToDecrypt) {
      if (result.containsKey(field) && result[field] is String) {
        result[field] = await decryptText(result[field] as String);
      }
    }
    return result;
  }

  /// Clear the master key from memory (call on logout)
  void dispose() {
    _masterKey = null;
    ErrorHandler.logInfo('EncryptionService', 'Master key cleared from memory');
  }

  /// Re-encrypt user's master key with a new JWT (call after token refresh)
  Future<void> rotateEncryption() async {
    try {
      if (_client == null) {
        throw Exception('Supabase not initialized');
      }
      final user = _client!.auth.currentUser;
      if (user == null || _masterKey == null) {
        throw Exception('No authenticated user or master key');
      }
      // Encrypt master key with new JWT
      final session = _client!.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }
      final jwtKey = _deriveKeyFromJWT(session.accessToken);
      final nonce = _algorithm.newNonce();
      final secretBox = await _algorithm.encrypt(
        (_masterKey as SecretKeyData).bytes,
        secretKey: jwtKey,
        nonce: nonce,
      );
      final encryptedData = {
        'nonce': base64Encode(secretBox.nonce),
        'ciphertext': base64Encode(secretBox.cipherText),
        'mac': base64Encode(secretBox.mac.bytes),
      };
      // Update stored key
      await _client!
          .from('user_keys')
          .update({'encrypted_key': jsonEncode(encryptedData)})
          .eq('uuid_user_id', user.id);
      ErrorHandler.logInfo('EncryptionService', 'Rotated encryption key');
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionService',
        'Failed to rotate key: $e',
        stack,
      );
      rethrow;
    }
  }
}

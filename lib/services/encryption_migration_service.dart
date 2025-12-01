/// Migration Service: Migrate from old JWT-based encryption to new PIN-based encryption
/// 
/// This service handles the migration for existing users who have data encrypted
/// with the old EncryptionService (JWT-based). It detects if migration is needed,
/// prompts the user to create a PIN, and re-encrypts all existing data with the
/// new EncryptionServiceV2 (PIN-based).

import 'package:supabase_flutter/supabase_flutter.dart';
import 'encryption_service.dart'; // Old service
import 'encryption_service_v2.dart'; // New service
import '../utils/error_handler.dart';

class EncryptionMigrationService {
  final SupabaseClient _client = Supabase.instance.client;
  final EncryptionService _oldService = EncryptionService();
  final EncryptionServiceV2 _newService = EncryptionServiceV2();

  // ============================================================================
  // DETECTION: Check if user needs migration
  // ============================================================================

  /// Check if user needs to migrate from old to new encryption system
  /// 
  /// Returns:
  /// - `true`: User has old encryption data, needs migration
  /// - `false`: User already migrated or new user
  Future<bool> needsMigration(String uuidUserId) async {
    try {
      final response = await _client
          .from('user_keys')
          .select()
          .eq('uuid_user_id', uuidUserId)
          .maybeSingle();

      if (response == null) {
        // No encryption keys at all - new user
        return false;
      }

      // Check for new system columns
      final hasRecoveryKey = response['encrypted_key_recovery'] != null;
      final hasSaltRecovery = response['salt_recovery'] != null;

      if (hasRecoveryKey && hasSaltRecovery) {
        // New system already set up
        return false;
      }

      // Has old system keys but not new system keys - needs migration
      return true;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Failed to check migration status: $e',
        stack,
      );
      return false;
    }
  }

  // ============================================================================
  // MIGRATION: Re-encrypt all data with new system
  // ============================================================================

  /// Migrate user data from old JWT-based encryption to new PIN-based encryption
  /// 
  /// Process:
  /// 1. Initialize old encryption service (JWT-based)
  /// 2. Setup new encryption service (PIN-based) with user's PIN
  /// 3. Fetch all encrypted data (cravings, logs, reflections, notes)
  /// 4. Decrypt with old service, re-encrypt with new service
  /// 5. Update database with re-encrypted data
  /// 6. Delete old encryption keys
  /// 
  /// Parameters:
  /// - `uuidUserId`: User's UUID
  /// - `pin`: User's chosen 6-digit PIN (validated before calling this)
  /// 
  /// Returns: Recovery key string (24-char hex) on success
  /// Throws: Exception on failure
  Future<String> migrateUserData(String uuidUserId, String pin) async {
    try {
      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Starting migration for user ${uuidUserId.substring(0, 8)}...',
      );

      // Step 1: Initialize old encryption service
      await _oldService.initialize();

      // Step 2: Setup new encryption service and get recovery key
      final recoveryKey = await _newService.setupNewSecrets(uuidUserId, pin);

      // Step 3: Unlock new encryption service with PIN
      final unlocked = await _newService.unlockWithPin(uuidUserId, pin);
      if (!unlocked) {
        throw Exception('Failed to unlock new encryption service after setup');
      }

      // Step 4: Migrate all encrypted data
      await _migrateCravings(uuidUserId);
      await _migrateLogEntries(uuidUserId);
      await _migrateReflections(uuidUserId);
      await _migrateNotes(uuidUserId);

      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Migration completed successfully',
      );

      return recoveryKey;
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Migration failed: $e',
        stack,
      );
      rethrow;
    }
  }

  /// Migrate cravings table
  Future<void> _migrateCravings(String uuidUserId) async {
    try {
      final response = await _client
          .from('cravings')
          .select()
          .eq('uuid_user_id', uuidUserId);

      if (response.isEmpty) {
        ErrorHandler.logInfo(
          'EncryptionMigrationService',
          'No cravings to migrate',
        );
        return;
      }

      int migrated = 0;
      for (final row in response) {
        final id = row['id'] as int;

        // Migrate substance_name (encrypted field)
        if (row['substance_name'] != null) {
          final oldEncrypted = row['substance_name'] as String;
          try {
            final decrypted = await _oldService.decryptText(oldEncrypted);
            if (decrypted == null || decrypted.isEmpty) continue;
            final newEncrypted = await _newService.encryptText(decrypted);

            await _client
                .from('cravings')
                .update({'substance_name': newEncrypted})
                .eq('id', id);

            migrated++;
          } catch (e) {
            ErrorHandler.logWarning(
              'EncryptionMigrationService',
              'Failed to migrate craving $id: $e',
            );
          }
        }
      }

      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Migrated $migrated/${response.length} cravings',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Failed to migrate cravings: $e',
        stack,
      );
      // Don't rethrow - continue with other tables
    }
  }

  /// Migrate log_entries table
  Future<void> _migrateLogEntries(String uuidUserId) async {
    try {
      final response = await _client
          .from('log_entries')
          .select()
          .eq('uuid_user_id', uuidUserId);

      if (response.isEmpty) {
        ErrorHandler.logInfo(
          'EncryptionMigrationService',
          'No log entries to migrate',
        );
        return;
      }

      int migrated = 0;
      for (final row in response) {
        final id = row['id'] as int;
        Map<String, dynamic> updates = {};

        // Migrate substance_name (encrypted field)
        if (row['substance_name'] != null) {
          final oldEncrypted = row['substance_name'] as String;
          try {
            final decrypted = await _oldService.decryptText(oldEncrypted);
            if (decrypted != null) {
              final newEncrypted = await _newService.encryptText(decrypted);
              updates['substance_name'] = newEncrypted;
            }
          } catch (e) {
            ErrorHandler.logWarning(
              'EncryptionMigrationService',
              'Failed to migrate substance_name for log entry $id: $e',
            );
          }
        }

        // Migrate notes (encrypted field)
        if (row['notes'] != null) {
          final oldEncrypted = row['notes'] as String;
          try {
            final decrypted = await _oldService.decryptText(oldEncrypted);
            if (decrypted != null) {
              final newEncrypted = await _newService.encryptText(decrypted);
              updates['notes'] = newEncrypted;
            }
          } catch (e) {
            ErrorHandler.logWarning(
              'EncryptionMigrationService',
              'Failed to migrate notes for log entry $id: $e',
            );
          }
        }

        if (updates.isNotEmpty) {
          await _client
              .from('log_entries')
              .update(updates)
              .eq('id', id);
          migrated++;
        }
      }

      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Migrated $migrated/${response.length} log entries',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Failed to migrate log entries: $e',
        stack,
      );
      // Don't rethrow - continue with other tables
    }
  }

  /// Migrate reflections table
  Future<void> _migrateReflections(String uuidUserId) async {
    try {
      final response = await _client
          .from('reflections')
          .select()
          .eq('uuid_user_id', uuidUserId);

      if (response.isEmpty) {
        ErrorHandler.logInfo(
          'EncryptionMigrationService',
          'No reflections to migrate',
        );
        return;
      }

      int migrated = 0;
      for (final row in response) {
        final id = row['id'] as int;

        // Migrate content (encrypted field)
        if (row['content'] != null) {
          final oldEncrypted = row['content'] as String;
          try {
            final decrypted = await _oldService.decryptText(oldEncrypted);
            if (decrypted == null || decrypted.isEmpty) continue;
            final newEncrypted = await _newService.encryptText(decrypted);

            await _client
                .from('reflections')
                .update({'content': newEncrypted})
                .eq('id', id);

            migrated++;
          } catch (e) {
            ErrorHandler.logWarning(
              'EncryptionMigrationService',
              'Failed to migrate reflection $id: $e',
            );
          }
        }
      }

      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Migrated $migrated/${response.length} reflections',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Failed to migrate reflections: $e',
        stack,
      );
      // Don't rethrow - continue with other tables
    }
  }

  /// Migrate notes table
  Future<void> _migrateNotes(String uuidUserId) async {
    try {
      final response = await _client
          .from('notes')
          .select()
          .eq('uuid_user_id', uuidUserId);

      if (response.isEmpty) {
        ErrorHandler.logInfo(
          'EncryptionMigrationService',
          'No notes to migrate',
        );
        return;
      }

      int migrated = 0;
      for (final row in response) {
        final id = row['id'] as int;

        // Migrate content (encrypted field)
        if (row['content'] != null) {
          final oldEncrypted = row['content'] as String;
          try {
            final decrypted = await _oldService.decryptText(oldEncrypted);
            if (decrypted == null || decrypted.isEmpty) continue;
            final newEncrypted = await _newService.encryptText(decrypted);

            await _client
                .from('notes')
                .update({'content': newEncrypted})
                .eq('id', id);

            migrated++;
          } catch (e) {
            ErrorHandler.logWarning(
              'EncryptionMigrationService',
              'Failed to migrate note $id: $e',
            );
          }
        }
      }

      ErrorHandler.logInfo(
        'EncryptionMigrationService',
        'Migrated $migrated/${response.length} notes',
      );
    } catch (e, stack) {
      ErrorHandler.logError(
        'EncryptionMigrationService',
        'Failed to migrate notes: $e',
        stack,
      );
      // Don't rethrow - continue
    }
  }
}

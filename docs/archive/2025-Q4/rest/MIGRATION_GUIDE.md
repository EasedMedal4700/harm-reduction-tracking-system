# Encryption System Migration Guide

## Overview

This guide explains the migration from the old JWT-based encryption system to the new PIN-based zero-knowledge encryption system.

## What Changed?

### Old System (JWT-Based)
- Master key derived from JWT token
- Vulnerable to token refresh issues (MAC errors)
- Server-dependent authentication
- No recovery mechanism

### New System (PIN-Based)
- PIN-based master key derivation
- Recovery key fallback
- Biometric unlock support
- Zero-knowledge architecture
- Multi-device support

## Automatic Migration Flow

When existing users log in after the update, they will:

1. **Detection**: System detects old encryption keys (no recovery key present)
2. **Explanation Screen**: Shows benefits of new security system
3. **PIN Creation**: User creates 6-digit PIN (twice for confirmation)
4. **Migration Process**: All encrypted data is re-encrypted automatically
   - Cravings
   - Log entries
   - Reflections
   - Notes
5. **Recovery Key Display**: User receives 24-character recovery key
6. **Optional Biometrics**: User can enable fingerprint/face unlock

## Migration Implementation

### Files Involved

1. **`lib/services/encryption_migration_service.dart`**
   - Detects if migration needed
   - Re-encrypts all data tables
   - Handles errors gracefully

2. **`lib/screens/encryption_migration_screen.dart`**
   - UI for migration flow
   - 5-step process (explanation → PIN → confirm → migrating → recovery key)
   - Progress indicators

3. **`lib/services/encryption_service_v2.dart`**
   - New PIN-based encryption service
   - PBKDF2 key derivation (100k iterations)
   - AES-256-GCM encryption
   - Biometric support

### Integration Steps

To integrate migration into your app:

1. **Check Migration Status on Login**
   ```dart
   final migrationService = EncryptionMigrationService();
   final needsMigration = await migrationService.needsMigration(userId);
   
   if (needsMigration) {
     Navigator.pushNamed(context, '/encryption-migration');
   } else {
     // Continue to home or PIN unlock
   }
   ```

2. **Add Route**
   ```dart
   '/encryption-migration': (context) => const EncryptionMigrationScreen(),
   ```

3. **Run Database Migration**
   - Execute `DB/migration_add_recovery_key.sql` in Supabase SQL editor
   - Adds `encrypted_key_recovery`, `salt_recovery`, `kdf_iterations_recovery` columns

## For New Users

New users will:
1. See PIN setup screen after registration
2. Create 6-digit PIN
3. Receive recovery key
4. Optionally enable biometrics
5. Start using the app

## Security Improvements

### Zero-Knowledge Architecture
- Server never sees PIN or recovery key
- DataKey encrypted client-side before upload
- No plaintext ever sent to server

### Recovery Mechanism
- 24-character hex recovery key (96-bit entropy)
- Independent encryption path (different salt)
- Can recover data if PIN forgotten

### Biometric Support
- PIN encrypted with device keystore
- Stored in `flutter_secure_storage`
- Requires biometric authentication to decrypt

### Multi-Device Support
- Same PIN works on all devices
- Same recovery key works everywhere
- DataKey synchronized via Supabase

## Technical Details

### Key Derivation
```
PIN + Salt → PBKDF2-HMAC-SHA256 (100k iterations) → MasterKey (32 bytes)
MasterKey + DataKey + Nonce → AES-256-GCM → EncryptedDataKey
```

### Data Encryption
```
PlainText + DataKey + Nonce → AES-256-GCM → CipherText + MAC
```

### Database Schema
```sql
-- user_keys table
uuid_user_id: text (primary key)
encrypted_key_pin: text          -- DataKey encrypted with PIN-derived key
salt_pin: text                   -- Salt for PIN PBKDF2
kdf_iterations_pin: integer      -- PBKDF2 iterations (100,000)
encrypted_key_recovery: text     -- DataKey encrypted with recovery-key-derived key
salt_recovery: text              -- Salt for recovery key PBKDF2
kdf_iterations_recovery: integer -- PBKDF2 iterations (100,000)
biometric_enabled: boolean       -- Whether biometrics enabled
```

## Migration Testing

### Test Scenarios

1. **Existing User with Encrypted Data**
   - Should see migration screen on login
   - All data should migrate successfully
   - Can log new entries after migration

2. **Existing User with No Encrypted Data**
   - Should see PIN setup screen
   - Can start using encryption immediately

3. **New User**
   - Should see PIN setup screen after registration
   - Can start using app with encryption

### Manual Testing Steps

1. **Setup Old System User**
   ```sql
   INSERT INTO user_keys (uuid_user_id, encrypted_key, salt, kdf_iterations)
   VALUES ('test-user-id', 'old-encrypted-key', 'old-salt', 100000);
   ```

2. **Login as Old User**
   - Should detect migration needed
   - Migration screen should appear

3. **Complete Migration**
   - Create PIN
   - Confirm PIN
   - Wait for migration (watch logs)
   - Save recovery key

4. **Verify Migration**
   ```sql
   SELECT * FROM user_keys WHERE uuid_user_id = 'test-user-id';
   -- Should have encrypted_key_recovery and salt_recovery populated
   ```

5. **Test Data Access**
   - Create new log entry
   - View existing entries (should be decrypted correctly)

## Troubleshooting

### Migration Fails
- **Symptoms**: Error message during migration, data not accessible
- **Cause**: Old encryption service failed to decrypt
- **Solution**: Check logs for specific errors, may need to re-run migration

### MAC Errors After Migration
- **Symptoms**: "MAC authentication failed" when accessing data
- **Cause**: Some data didn't migrate correctly
- **Solution**: Re-run migration for affected rows

### Recovery Key Not Showing
- **Symptoms**: Migration completes but no recovery key displayed
- **Cause**: UI issue or navigation interrupted
- **Solution**: Check `user_keys` table for `salt_recovery` (key was generated)

### Biometrics Not Working
- **Symptoms**: Fingerprint unlock button disabled
- **Cause**: Device doesn't support biometrics or not enrolled
- **Solution**: Check device settings, enroll biometrics

## Rollback Plan

If migration fails catastrophically:

1. **Restore Old System**
   - Keep `EncryptionService` (old) in codebase
   - Disable migration check
   - Use old system for affected users

2. **Data Recovery**
   - Old `encrypted_key` still in database
   - Can decrypt with old system
   - Re-attempt migration later

3. **User Communication**
   - Notify users of issue
   - Provide support contact
   - Explain recovery process

## Support

For issues or questions:
1. Check error logs in `error_logging_service`
2. Review Supabase database state
3. Test with clean user account
4. Contact development team

## Checklist

- [ ] Run database migration SQL
- [ ] Add routes for new screens
- [ ] Test migration with existing user
- [ ] Test PIN setup with new user
- [ ] Test recovery key unlock
- [ ] Test biometric unlock
- [ ] Verify data encryption/decryption
- [ ] Check error handling
- [ ] Review logs for issues
- [ ] Deploy to production

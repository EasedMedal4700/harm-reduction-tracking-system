# Fix: Database Constraint Violation on Login

## Problem

Users were encountering the following error when logging in:

```
PostgrestException: null value in column "salt" of relation "user_keys" violates not-null constraint
Code: 23502
```

## Root Cause

The database schema for `user_keys` table requires the `salt` column to be NOT NULL:

```sql
CREATE TABLE public.user_keys (
  uuid_user_id uuid NOT NULL,
  encrypted_key text NOT NULL,
  salt text NOT NULL,              -- ❌ NOT NULL constraint
  kdf_iterations integer NOT NULL DEFAULT 200000,
  ...
);
```

However, the old JWT-based `EncryptionService` was inserting records without providing a `salt` value:

```dart
// ❌ OLD CODE - Missing salt
await _client!.from('user_keys').insert({
  'uuid_user_id': user.id,
  'encrypted_key': jsonEncode(encryptedData),
  // Missing 'salt' field!
});
```

The JWT-based encryption system doesn't use a salt (it derives keys directly from the JWT token), but the database schema was updated to require it for the new PIN-based system.

## Solution

### Option 1: Make Old Service Schema-Compatible (IMPLEMENTED)

Updated `EncryptionService._generateAndStoreNewKey()` to provide dummy values for schema compatibility:

```dart
// ✅ NEW CODE - Provides salt for schema compatibility
// Generate a dummy salt for schema compatibility (JWT-based system doesn't use salt)
final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
final salt = base64Encode(saltBytes);

await _client!.from('user_keys').insert({
  'uuid_user_id': user.id,
  'encrypted_key': jsonEncode(encryptedData),
  'salt': salt, // Dummy salt for schema compatibility
  'kdf_iterations': 200000,
});
```

**Benefits:**
- No database migration required immediately
- Old encryption service continues to work
- Satisfies NOT NULL constraint
- The dummy salt is harmless (JWT-based system doesn't use it)

### Option 2: Make Salt Nullable (RECOMMENDED FOR PRODUCTION)

Created migration script `DB/migration_make_salt_nullable.sql`:

```sql
-- Make salt column nullable for backward compatibility
ALTER TABLE public.user_keys
ALTER COLUMN salt DROP NOT NULL;

COMMENT ON COLUMN public.user_keys.salt IS 'Salt for PBKDF2 derivation (base64). NULL for legacy JWT-based encryption users.';
```

**Benefits:**
- More semantically correct (NULL indicates "not used")
- Clearly distinguishes old vs new encryption
- No dummy data needed
- Can make NOT NULL again after full migration

## Deployment Steps

### Immediate Fix (Already Applied)
✅ Updated `lib/services/encryption_service.dart` to provide dummy salt

### Recommended for Production
1. **Run Database Migration**:
   ```sql
   -- Execute in Supabase SQL Editor
   ALTER TABLE public.user_keys
   ALTER COLUMN salt DROP NOT NULL;
   ```

2. **Test Login Flow**:
   - Test with existing user (should work with dummy salt)
   - Test with new user (should work with dummy salt)
   - Verify no constraint violations

3. **Monitor Error Logs**:
   - Check for any remaining constraint violations
   - Verify encryption initialization succeeds

### Future Migration Path

Once ready to migrate all users to the new PIN-based system:

1. Deploy PIN-based encryption system (`EncryptionServiceV2`)
2. Add migration detection on login
3. Guide users through PIN setup
4. Re-encrypt data with new system
5. After all users migrated, optionally:
   ```sql
   -- Make salt NOT NULL again
   ALTER TABLE public.user_keys
   ALTER COLUMN salt SET NOT NULL;
   ```

## Testing

### Test Scenarios

1. **New User Login** ✅
   - Register new account
   - Login should succeed
   - `user_keys` row should be created with dummy salt
   - Encryption should initialize successfully

2. **Existing User with Old Keys** ✅
   - User with existing `encrypted_key` but no `salt`
   - Login should succeed
   - No constraint violation
   - Can encrypt/decrypt data

3. **Token Refresh Recovery** ✅
   - MAC error occurs during initialization
   - Service regenerates key
   - New row inserted with salt
   - Login succeeds

### Verification Queries

Check user_keys table:
```sql
-- See all users and their encryption setup
SELECT 
  uuid_user_id,
  encrypted_key IS NOT NULL as has_encrypted_key,
  salt IS NOT NULL as has_salt,
  salt_recovery IS NOT NULL as has_recovery,
  created_at
FROM public.user_keys
ORDER BY created_at DESC;
```

Check for constraint violations:
```sql
-- Should return 0 rows after fix
SELECT * FROM public.user_keys
WHERE salt IS NULL;
```

## Files Modified

1. **`lib/services/encryption_service.dart`**
   - Line ~125: Added dummy salt generation and inclusion in insert

2. **`DB/migration_make_salt_nullable.sql`** (NEW)
   - Optional migration to make salt nullable

## Related Issues

- Original error: `PostgrestException code: 23502` (NOT NULL violation)
- Affected screens: `/login_page`
- Affected services: `EncryptionService`, `AuthService`

## Technical Details

### Why Dummy Salt is Safe

The JWT-based encryption system:
1. Derives key directly from JWT token (SHA-256)
2. Never uses the `salt` column
3. The dummy salt is just to satisfy the schema
4. No security implications

### Why NULL is Better

Making `salt` nullable:
1. Clearly indicates "not used" vs "used"
2. Can query to find old users: `WHERE salt IS NULL`
3. No dummy data cluttering database
4. More semantically correct

## Rollback Plan

If issues occur:
1. Revert code change in `encryption_service.dart`
2. Run: `ALTER TABLE user_keys ALTER COLUMN salt DROP NOT NULL;`
3. Old service will insert without salt (now allowed)

## Success Criteria

✅ Users can log in without constraint violations
✅ Encryption initializes successfully
✅ No errors in error_logs table related to user_keys
✅ New user registrations work
✅ Existing users can continue using app

## Next Steps

1. Monitor production logs for 24 hours
2. Verify no new constraint violations
3. Plan rollout of PIN-based encryption migration
4. Update documentation for new encryption system

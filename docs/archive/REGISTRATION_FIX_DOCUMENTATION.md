# Registration Fix Documentation

## Problem

When creating a new account through the Flutter app, the Supabase Auth user was created successfully, but the corresponding entry in the local `users` table was either failing silently or not being verified. This caused users to be unable to login after registration.

## Architecture

The app uses a dual authentication system:

1. **Supabase Auth**: Handles password authentication and stores passwords securely
   - Uses UUIDs for user identification
   - Manages authentication sessions
   - Stores passwords (no need for password_hash in local DB)

2. **Local `users` table**: Stores application-specific user data
   - Uses auto-incrementing integer `user_id` as primary key
   - Stores email, display_name, is_admin, timestamps
   - Linked to Supabase Auth by **email** (not by UUID)

The `UserService.getIntegerUserId()` method links these systems by looking up the integer user_id using the authenticated user's email.

## Solution

Updated `auth_service.dart` `register()` function to:

1. **Verify the insert succeeds**: Changed from fire-and-forget insert to `.select('user_id').single()` to verify the insert completes and returns the new user_id

2. **Better error handling**: Added try-catch around the users table insert to catch PostgrestException errors specifically

3. **Check for duplicate emails**: Added check for PostgreSQL error code '23505' (unique constraint violation) to return user-friendly error message

4. **Verify user_id returned**: Check that the insert response contains a valid user_id

### Code Changes

**Before:**
```dart
await _client.from('users').insert({
  'email': email,
  'display_name': friendlyName,
  'is_admin': false,
});
```

**After:**
```dart
try {
  final insertResponse = await _client.from('users').insert({
    'email': email,
    'display_name': friendlyName,
    'is_admin': false,
  }).select('user_id').single();

  // Verify we got a user_id back
  if (insertResponse['user_id'] == null) {
    return const AuthResult.failure(
      'Failed to create user profile. Please try again.',
    );
  }
} on PostgrestException catch (e, stackTrace) {
  ErrorHandler.logError('AuthService.register.insertUser', e, stackTrace);
  
  if (e.code == '23505') {
    // Unique constraint violation
    return const AuthResult.failure('Email is already in use.');
  }
  return const AuthResult.failure(
    'Failed to create user profile. Please try again.',
  );
}
```

## Testing

Created comprehensive integration test (`integration_test/registration_flow_test.dart`) that verifies:

### Test Cases

1. **Successful registration**: 
   - Creates both Auth user and database entry
   - Can login after registration
   - User data is retrievable
   - Integer user_id is generated correctly

2. **Duplicate email rejection**:
   - First registration succeeds
   - Second registration with same email fails
   - Error message indicates email already in use

3. **Display name fallback**:
   - Empty string display name → uses email
   - Null display name → uses email

4. **Invalid inputs**:
   - Invalid email format is rejected
   - Weak password is rejected

5. **User service integration**:
   - `getUserData()` works after registration
   - `getIntegerUserId()` works and caches correctly
   - `isAdmin()` returns false for new users

### Running the Test

```bash
flutter test integration_test/registration_flow_test.dart --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

## Why password_hash Column Exists But Isn't Used

The `users` table schema includes a `password_hash` column, but it's not populated because:

1. Supabase Auth handles all password storage and hashing securely
2. Storing passwords twice would be redundant and a security risk
3. The `password_hash` column might be legacy or reserved for future use
4. The nullable constraint allows it to remain empty

## Database Schema

```sql
CREATE TABLE public.users (
  user_id integer NOT NULL DEFAULT nextval('users_user_id_seq'::regclass),
  email character varying NOT NULL UNIQUE,
  display_name character varying NOT NULL,
  password_hash character varying,  -- Nullable, not used with Supabase Auth
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  is_admin boolean NOT NULL DEFAULT false,
  CONSTRAINT users_pkey PRIMARY KEY (user_id)
);
```

## Related Files

- `lib/services/auth_service.dart` - Registration logic
- `lib/services/user_service.dart` - User data retrieval, links Auth UUID to integer user_id
- `integration_test/registration_flow_test.dart` - Comprehensive registration tests
- `DB/DB_structure.sql` - Database schema

## Future Considerations

If you need to migrate to using Supabase Auth UUIDs throughout:

1. Change all `user_id` columns from integer to UUID
2. Update foreign key references in all tables
3. Modify `UserService` to use Auth UUID directly instead of looking up by email
4. Remove the integer user_id and email lookup logic

However, the current email-based linking approach works well and maintains backward compatibility.

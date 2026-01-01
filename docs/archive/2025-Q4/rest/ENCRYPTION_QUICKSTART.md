# Zero-Knowledge PIN Encryption - Quick Start

## ✅ What's Been Created

### Core Files
1. **`lib/services/encryption_service_v2.dart`** - Complete encryption service
2. **`lib/screens/pin_setup_screen.dart`** - PIN creation UI
3. **`lib/screens/pin_unlock_screen.dart`** - Unlock with PIN/fingerprint
4. **`lib/screens/recovery_key_screen.dart`** - Recovery key unlock
5. **`DB/migration_add_recovery_key.sql`** - Database migration
6. **`docs/PIN_ENCRYPTION_SYSTEM.md`** - Full documentation

### Dependencies Added to pubspec.yaml
- `flutter_secure_storage: ^9.2.2`
- `local_auth: ^2.3.0`

## 🚀 Quick Integration (5 Steps)

### Step 1: Run Database Migration
```sql
-- Copy migration_add_recovery_key.sql into Supabase SQL Editor and run
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Add Routes
In `lib/routes/app_routes.dart`:
```dart
'/pin-setup': (context) => const PinSetupScreen(),
'/pin-unlock': (context) => const PinUnlockScreen(),
'/recovery-key': (context) => const RecoveryKeyScreen(),
```

### Step 4: Update Login Success Handler
In `lib/screens/login_page.dart`, after successful login:

```dart
final user = Supabase.instance.client.auth.currentUser;
if (user != null) {
  final encryptionService = EncryptionServiceV2();
  final hasSetup = await encryptionService.hasEncryptionSetup(user.id);
  
  if (!hasSetup) {
    Navigator.pushReplacementNamed(context, '/pin-setup');
  } else {
    Navigator.pushReplacementNamed(context, '/pin-unlock');
  }
}
```

### Step 5: Replace Old Encryption Service
Find and replace in all service files:

```dart
// Old
final _encryptionService = EncryptionService();

// New
final _encryptionService = EncryptionServiceV2();
```

Files to update:
- `lib/services/craving_service.dart`
- `lib/services/log_entry_service.dart`  
- `lib/services/reflection_service.dart`
- Any other files using encryption

## 📱 User Flow

```
Login Success
    ↓
Has encryption setup?
    ├─ NO → PIN Setup Screen
    │         ↓
    │   Show Recovery Key
    │         ↓
    │   Enable Biometrics? (optional)
    │         ↓
    │   Go to Home
    │
    └─ YES → PIN Unlock Screen
              ├─ Enter PIN
              ├─ Use Fingerprint
              └─ Forgot PIN? → Recovery Key Screen
                  ↓
              Unlock Success
                  ↓
              Go to Home
```

## 🔑 Key Features

✅ **6-Digit PIN** - Simple and memorable  
✅ **Biometric Unlock** - Optional fingerprint (works on same device only)  
✅ **Recovery Key** - 24-char hex backup (works on all devices)  
✅ **Zero-Knowledge** - Server never sees keys or PIN  
✅ **AES-256-GCM** - Industry-standard encryption  
✅ **PBKDF2** - 100k iterations for key derivation  

## 🧪 Testing

```dart
// 1. Setup encryption
final service = EncryptionServiceV2();
final recoveryKey = await service.setupNewSecrets('user-uuid', '123456');
print('Save this: $recoveryKey');

// 2. Test unlock
final unlocked = await service.unlockWithPin('user-uuid', '123456');
print('Unlocked: $unlocked'); // true

// 3. Test encryption
final encrypted = await service.encryptText('secret data');
final decrypted = await service.decryptText(encrypted);
print('Decrypted: $decrypted'); // secret data
```

## ⚠️ Important Security Notes

1. **Recovery Key**: User MUST save it during setup (show only once)
2. **PIN**: Never stored plaintext, only derived with PBKDF2
3. **DataKey**: Generated once, never changes (preserves encrypted data)
4. **Biometrics**: Device-specific, encrypts PIN locally
5. **MAC Errors**: Wrong PIN returns false (no exceptions)

## 🐛 Common Issues

### Issue: "Encryption not ready"
**Solution**: Call `unlockWithPin()` or `unlockWithBiometrics()` first

### Issue: Biometric unlock not showing
**Solution**: 
- Check device supports biometrics
- User must enable it during setup
- Android: Add permissions to AndroidManifest.xml

### Issue: Recovery key not working
**Solution**:
- Verify exact 24-character hex string
- No spaces or extra characters
- Case-insensitive

## 📋 Checklist

- [ ] Run database migration
- [ ] Install dependencies (`flutter pub get`)
- [ ] Add routes to app_routes.dart
- [ ] Update login flow
- [ ] Replace EncryptionService with EncryptionServiceV2
- [ ] Test PIN setup flow
- [ ] Test PIN unlock flow
- [ ] Test recovery key flow
- [ ] Test data encryption/decryption
- [ ] Add lock functionality to drawer/settings
- [ ] Update biometric permissions in AndroidManifest.xml

## 🎯 Next Steps

1. Build and test on physical device
2. Test biometric unlock
3. Test recovery key save/restore
4. Migrate existing users (see full docs)
5. Add PIN change feature (optional)
6. Add lock timeout feature (optional)

## 📚 Full Documentation

See `docs/PIN_ENCRYPTION_SYSTEM.md` for:
- Complete architecture details
- Security audit checklist
- Migration strategies
- Troubleshooting guide
- Performance metrics

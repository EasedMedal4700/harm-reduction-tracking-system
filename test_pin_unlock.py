"""
Test PIN unlock flow to verify encryption setup
"""
import os
import base64
import hashlib
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import json
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment
load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_ANON_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ ERROR: Missing Supabase credentials in .env file")
    exit(1)

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Your user ID and PIN - SET THESE BEFORE RUNNING
USER_ID = os.getenv('TEST_USER_ID', 'YOUR_USER_ID_HERE')
PIN = os.getenv('TEST_PIN', 'YOUR_PIN_HERE')

print(f"🔍 Testing PIN unlock for user: {USER_ID}")
print(f"🔑 PIN: {PIN}")
print()

# Step 1: Fetch user_keys from database
print("📥 Step 1: Fetching user_keys from database...")
try:
    response = supabase.table('user_keys').select('*').eq('uuid_user_id', USER_ID).execute()
    
    if not response.data or len(response.data) == 0:
        print("❌ ERROR: No encryption keys found for user")
        exit(1)
    
    user_key = response.data[0]
    print("✅ Found user_keys record:")
    print(f"   - encrypted_key exists: {bool(user_key.get('encrypted_key'))}")
    print(f"   - salt exists: {bool(user_key.get('salt'))}")
    print(f"   - kdf_iterations: {user_key.get('kdf_iterations')}")
    print(f"   - encrypted_key_recovery exists: {bool(user_key.get('encrypted_key_recovery'))}")
    print(f"   - salt_recovery exists: {bool(user_key.get('salt_recovery'))}")
    print()
    
except Exception as e:
    print(f"❌ ERROR fetching user_keys: {e}")
    exit(1)

# Step 2: Extract encryption parameters
print("🔧 Step 2: Extracting encryption parameters...")
print("   📌 NOTE: The primary columns have OLD data (200k iterations)")
print("   📌 Testing with PRIMARY columns first...")
encrypted_key_b64 = user_key.get('encrypted_key')
salt_b64 = user_key.get('salt')
iterations = user_key.get('kdf_iterations', 100000)

if not encrypted_key_b64:
    print("❌ ERROR: encrypted_key is null")
    exit(1)

if not salt_b64:
    print("❌ ERROR: salt is null")
    exit(1)

print(f"✅ encrypted_key (first 50 chars): {encrypted_key_b64[:50]}...")
print(f"✅ salt (base64): {salt_b64}")
print(f"✅ iterations: {iterations}")
print()

# Step 3: Decode salt
print("🔧 Step 3: Decoding salt...")
try:
    salt = base64.b64decode(salt_b64)
    print(f"✅ Salt decoded: {len(salt)} bytes")
    print(f"   Salt (hex): {salt.hex()}")
    print()
except Exception as e:
    print(f"❌ ERROR decoding salt: {e}")
    exit(1)

# Step 4: Derive key from PIN using PBKDF2
print(f"🔐 Step 4: Deriving key from PIN '{PIN}' using PBKDF2...")
try:
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,  # 256 bits
        salt=salt,
        iterations=iterations,
        backend=default_backend()
    )
    pin_bytes = PIN.encode('utf-8')
    derived_key = kdf.derive(pin_bytes)
    print(f"✅ Key derived: {len(derived_key)} bytes")
    print(f"   Derived key (hex, first 32 chars): {derived_key.hex()[:32]}...")
    print()
except Exception as e:
    print(f"❌ ERROR deriving key: {e}")
    exit(1)

# Step 5: Parse encrypted_key
print("🔧 Step 5: Parsing encrypted_key...")
try:
    # The encrypted_key should be in format: base64(nonce + ciphertext + mac)
    # Or it might be JSON with nonce and ciphertext fields
    
    # Try parsing as JSON first (Flutter format)
    try:
        encrypted_data = json.loads(encrypted_key_b64)
        nonce_b64 = encrypted_data.get('nonce')
        ciphertext_b64 = encrypted_data.get('ciphertext')
        
        if not nonce_b64 or not ciphertext_b64:
            raise ValueError("Missing nonce or ciphertext in JSON")
        
        nonce = base64.b64decode(nonce_b64)
        ciphertext_with_tag = base64.b64decode(ciphertext_b64)
        
        print(f"✅ Parsed as JSON:")
        print(f"   - nonce: {len(nonce)} bytes ({nonce.hex()})")
        print(f"   - ciphertext+tag: {len(ciphertext_with_tag)} bytes")
        print()
        
    except (json.JSONDecodeError, ValueError) as e:
        # Try parsing as raw base64
        print(f"⚠️  Not JSON format, trying raw base64...")
        encrypted_bytes = base64.b64decode(encrypted_key_b64)
        
        # AES-GCM format: nonce (12 bytes) + ciphertext + tag (16 bytes)
        nonce = encrypted_bytes[:12]
        ciphertext_with_tag = encrypted_bytes[12:]
        
        print(f"✅ Parsed as raw base64:")
        print(f"   - nonce: {len(nonce)} bytes ({nonce.hex()})")
        print(f"   - ciphertext+tag: {len(ciphertext_with_tag)} bytes")
        print()
        
except Exception as e:
    print(f"❌ ERROR parsing encrypted_key: {e}")
    import traceback
    traceback.print_exc()
    exit(1)

# Step 6: Decrypt dataKey using AES-GCM
print("🔓 Step 6: Attempting to decrypt dataKey...")
try:
    aesgcm = AESGCM(derived_key)
    
    # The ciphertext_with_tag includes the authentication tag at the end
    # AESGCM.decrypt expects: ciphertext || tag
    decrypted_data = aesgcm.decrypt(nonce, ciphertext_with_tag, None)
    
    print(f"✅ SUCCESS! Decrypted dataKey: {len(decrypted_data)} bytes")
    print(f"   DataKey (hex, first 32 chars): {decrypted_data.hex()[:32]}...")
    print()
    print("=" * 60)
    print("🎉 PIN UNLOCK TEST PASSED!")
    print("=" * 60)
    print()
    print("The PIN is correct and can decrypt the dataKey.")
    print("If the app is still not letting you in, the issue is")
    print("elsewhere in the code (navigation, state management, etc.)")
    
except Exception as e:
    print(f"❌ DECRYPTION FAILED WITH PRIMARY COLUMNS!")
    print(f"   Error: {e}")
    print()
    print("🔄 Retrying with RECOVERY columns (where PIN data was actually stored)...")
    print()
    
    # Try again with recovery columns
    try:
        encrypted_key_b64 = user_key.get('encrypted_key_recovery')
        salt_b64 = user_key.get('salt_recovery')
        iterations = user_key.get('kdf_iterations_recovery', 100000)
        
        print(f"✅ encrypted_key_recovery (first 50 chars): {encrypted_key_b64[:50]}...")
        print(f"✅ salt_recovery (base64): {salt_b64}")
        print(f"✅ iterations: {iterations}")
        print()
        
        # Decode salt
        salt = base64.b64decode(salt_b64)
        print(f"✅ Salt decoded: {len(salt)} bytes")
        print()
        
        # Derive key
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=iterations,
            backend=default_backend()
        )
        pin_bytes = PIN.encode('utf-8')
        derived_key = kdf.derive(pin_bytes)
        print(f"✅ Key derived: {len(derived_key)} bytes")
        print()
        
        # Parse encrypted data
        encrypted_data = json.loads(encrypted_key_b64)
        nonce = base64.b64decode(encrypted_data['nonce'])
        ciphertext_with_tag = base64.b64decode(encrypted_data['ciphertext'])
        print(f"✅ Parsed encrypted_key_recovery")
        print()
        
        # Decrypt
        aesgcm = AESGCM(derived_key)
        decrypted_data = aesgcm.decrypt(nonce, ciphertext_with_tag, None)
        
        print(f"✅ SUCCESS! Decrypted dataKey: {len(decrypted_data)} bytes")
        print(f"   DataKey (hex, first 32 chars): {decrypted_data.hex()[:32]}...")
        print()
        print("=" * 60)
        print("🎉 PIN UNLOCK TEST PASSED (using recovery columns)!")
        print("=" * 60)
        print()
        print("💡 SOLUTION:")
        print("The PIN data is stored in the RECOVERY columns, but")
        print("unlockWithPin() is reading from PRIMARY columns!")
        print()
        print("We need to fix the code to either:")
        print("1. Make setupNewSecrets() store PIN in PRIMARY columns")
        print("2. Make unlockWithPin() read from RECOVERY columns")
        print()
        print("The correct fix is #2: unlockWithPin() should read")
        print("from encrypted_key_recovery and salt_recovery columns.")
        
        exit(0)
        
    except Exception as e2:
        print(f"❌ ALSO FAILED WITH RECOVERY COLUMNS!")
        print(f"   Error: {e2}")
        import traceback
        traceback.print_exc()
    
    print()
    print("=" * 60)
    print("🔴 PIN UNLOCK TEST FAILED!")
    print("=" * 60)
    print()
    print("Possible reasons:")
    print("1. Wrong PIN - The PIN you entered doesn't match the one used during setup")
    print("2. Wrong salt - The salt in the database doesn't match what was used during setup")
    print("3. Wrong iterations - The iteration count doesn't match")
    print("4. Corrupted encrypted_key - The encrypted data in database is corrupted")
    print()
    print("💡 Suggestion: You may need to reset your PIN by:")
    print("   1. Going to Settings → Privacy & Security")
    print("   2. Clicking 'Setup PIN Encryption' again")
    print("   3. This will create a new PIN and re-encrypt your data")
    import traceback
    traceback.print_exc()
    exit(1)

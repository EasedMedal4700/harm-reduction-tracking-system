"""
Reset encryption and setup new PIN using the EXACT same method as Dart code
"""
import os
import base64
import secrets
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import json
from datetime import datetime, timezone
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

# Configuration - hardcoded for debugging
USER_ID = '96a2a84f-35d3-4f86-b127-5d57d5ffe14d'
NEW_PIN = '920894'

print("🔄 Resetting encryption and setting up new PIN...")
print(f"   User ID: {USER_ID}")
print(f"   New PIN: {NEW_PIN}")
print()

# Step 1: Delete existing encryption data
print("🗑️  Step 1: Deleting existing encryption data...")
try:
    result = supabase.table('user_keys').delete().eq('uuid_user_id', USER_ID).execute()
    print("✅ Old encryption data deleted")
    print()
except Exception as e:
    print(f"⚠️  Warning: Could not delete old data: {e}")
    print("   (This is OK if no data existed)")
    print()

# Step 2: Generate new dataKey (32 random bytes)
print("🔐 Step 2: Generating random dataKey (32 bytes)...")
data_key = secrets.token_bytes(32)
print(f"✅ DataKey generated: {data_key.hex()[:32]}...")
print()

# Step 3: Generate recovery key (12 random bytes = 24 hex chars)
print("🔑 Step 3: Generating recovery key...")
recovery_key_bytes = secrets.token_bytes(12)
recovery_key = recovery_key_bytes.hex()
print(f"✅ Recovery key: {recovery_key}")
print()

# Step 4: Generate salts
print("🧂 Step 4: Generating salts...")
salt_pin = secrets.token_bytes(16)
salt_recovery = secrets.token_bytes(16)
print(f"✅ PIN salt: {salt_pin.hex()}")
print(f"✅ Recovery salt: {salt_recovery.hex()}")
print()

# Step 5: Derive keys using PBKDF2
print("🔐 Step 5: Deriving keys from PIN and recovery key...")
iterations = 100000

# Derive key from PIN
kdf_pin = PBKDF2HMAC(
    algorithm=hashes.SHA256(),
    length=32,
    salt=salt_pin,
    iterations=iterations,
    backend=default_backend()
)
k_pin = kdf_pin.derive(NEW_PIN.encode('utf-8'))
print(f"✅ Derived PIN key: {k_pin.hex()[:32]}...")

# Derive key from recovery key
kdf_recovery = PBKDF2HMAC(
    algorithm=hashes.SHA256(),
    length=32,
    salt=salt_recovery,
    iterations=iterations,
    backend=default_backend()
)
k_recovery = kdf_recovery.derive(recovery_key.encode('utf-8'))
print(f"✅ Derived recovery key: {k_recovery.hex()[:32]}...")
print()

# Step 6: Encrypt dataKey with both keys
print("🔒 Step 6: Encrypting dataKey with PIN and recovery key...")

# Encrypt with PIN
# Note: Python's AESGCM.encrypt returns ciphertext + tag (16 bytes)
# Dart expects: {nonce, ciphertext, mac} as separate fields
aesgcm_pin = AESGCM(k_pin)
nonce_pin = secrets.token_bytes(12)
ciphertext_with_tag_pin = aesgcm_pin.encrypt(nonce_pin, data_key, None)
# Split ciphertext and tag (last 16 bytes are the tag/MAC)
ciphertext_only_pin = ciphertext_with_tag_pin[:-16]
mac_pin = ciphertext_with_tag_pin[-16:]
encrypted_key_pin = json.dumps({
    'nonce': base64.b64encode(nonce_pin).decode('utf-8'),
    'ciphertext': base64.b64encode(ciphertext_only_pin).decode('utf-8'),
    'mac': base64.b64encode(mac_pin).decode('utf-8')
})
print(f"✅ Encrypted with PIN")
print(f"   Nonce: {nonce_pin.hex()}")
print(f"   Ciphertext: {len(ciphertext_only_pin)} bytes")
print(f"   MAC: {len(mac_pin)} bytes")

# Encrypt with recovery key
aesgcm_recovery = AESGCM(k_recovery)
nonce_recovery = secrets.token_bytes(12)
ciphertext_with_tag_recovery = aesgcm_recovery.encrypt(nonce_recovery, data_key, None)
# Split ciphertext and tag
ciphertext_only_recovery = ciphertext_with_tag_recovery[:-16]
mac_recovery = ciphertext_with_tag_recovery[-16:]
encrypted_key_recovery = json.dumps({
    'nonce': base64.b64encode(nonce_recovery).decode('utf-8'),
    'ciphertext': base64.b64encode(ciphertext_only_recovery).decode('utf-8'),
    'mac': base64.b64encode(mac_recovery).decode('utf-8')
})
print(f"✅ Encrypted with recovery key")
print(f"   Nonce: {nonce_recovery.hex()}")
print(f"   Ciphertext: {len(ciphertext_only_recovery)} bytes")
print(f"   MAC: {len(mac_recovery)} bytes")
print()

# Step 7: Store in database
print("💾 Step 7: Storing in database...")
try:
    data = {
        'uuid_user_id': USER_ID,
        'encrypted_key': encrypted_key_pin,
        'salt': base64.b64encode(salt_pin).decode('utf-8'),
        'kdf_iterations': iterations,
        'encrypted_key_recovery': encrypted_key_recovery,
        'salt_recovery': base64.b64encode(salt_recovery).decode('utf-8'),
        'kdf_iterations_recovery': iterations,
        'key_version': 1,
        'updated_at': datetime.now(timezone.utc).isoformat(),
    }
    
    result = supabase.table('user_keys').upsert(data).execute()
    print("✅ Data stored in database")
    print()
except Exception as e:
    print(f"❌ ERROR storing data: {e}")
    import traceback
    traceback.print_exc()
    exit(1)

# Step 8: Verify by attempting to unlock with PIN
print("🔓 Step 8: Verifying PIN unlock...")
try:
    # Fetch from database
    response = supabase.table('user_keys').select('*').eq('uuid_user_id', USER_ID).execute()
    user_key = response.data[0]
    
    # Extract data
    encrypted_key_b64 = user_key['encrypted_key']
    salt_b64 = user_key['salt']
    iterations_db = user_key['kdf_iterations']
    
    # Derive key from PIN
    salt_test = base64.b64decode(salt_b64)
    kdf_test = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt_test,
        iterations=iterations_db,
        backend=default_backend()
    )
    k_test = kdf_test.derive(NEW_PIN.encode('utf-8'))
    
    # Decrypt
    encrypted_data = json.loads(encrypted_key_b64)
    nonce_test = base64.b64decode(encrypted_data['nonce'])
    ciphertext_test = base64.b64decode(encrypted_data['ciphertext'])
    mac_test = base64.b64decode(encrypted_data['mac'])
    # Combine ciphertext and MAC for Python's AESGCM
    ciphertext_with_tag_test = ciphertext_test + mac_test
    
    aesgcm_test = AESGCM(k_test)
    decrypted_test = aesgcm_test.decrypt(nonce_test, ciphertext_with_tag_test, None)
    
    if decrypted_test == data_key:
        print("✅ VERIFICATION SUCCESS!")
        print(f"   Decrypted dataKey matches original: {decrypted_test.hex()[:32]}...")
        print()
    else:
        print("❌ VERIFICATION FAILED: Decrypted data doesn't match!")
        exit(1)
        
except Exception as e:
    print(f"❌ VERIFICATION FAILED: {e}")
    import traceback
    traceback.print_exc()
    exit(1)

# Success!
print("=" * 60)
print("🎉 SUCCESS! PIN ENCRYPTION SETUP COMPLETE!")
print("=" * 60)
print()
print("📋 IMPORTANT INFORMATION:")
print(f"   PIN: {NEW_PIN}")
print(f"   Recovery Key: {recovery_key}")
print()
print("⚠️  SAVE YOUR RECOVERY KEY!")
print("   Write it down and store it safely.")
print("   You'll need it if you forget your PIN.")
print()
print("✅ You can now log in to the app and use PIN: {NEW_PIN}")
print("   The app will prompt you to unlock with this PIN.")

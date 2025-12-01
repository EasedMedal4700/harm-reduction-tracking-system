"""
Try common PINs or check if biometrics stored the PIN locally
"""
import os
import base64
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

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

USER_ID = os.getenv('TEST_USER_ID', 'YOUR_USER_ID_HERE')

# Fetch data
response = supabase.table('user_keys').select('*').eq('uuid_user_id', USER_ID).execute()
user_key = response.data[0]

# Try with recovery columns (where PIN should be)
encrypted_key_b64 = user_key.get('encrypted_key_recovery')
salt_b64 = user_key.get('salt_recovery')
iterations = user_key.get('kdf_iterations_recovery', 100000)

salt = base64.b64decode(salt_b64)
encrypted_data = json.loads(encrypted_key_b64)
nonce = base64.b64decode(encrypted_data['nonce'])
ciphertext_with_tag = base64.b64decode(encrypted_data['ciphertext'])

print("🔍 Trying common 6-digit PINs...")
print()

# Try some common PINs
test_pins = [
    "123456",
    "000000",
    "111111",
    "123123",
    "654321",
]

for test_pin in test_pins:
    try:
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=iterations,
            backend=default_backend()
        )
        pin_bytes = test_pin.encode('utf-8')
        derived_key = kdf.derive(pin_bytes)
        
        aesgcm = AESGCM(derived_key)
        decrypted_data = aesgcm.decrypt(nonce, ciphertext_with_tag, None)
        
        print(f"✅ SUCCESS! PIN is: {test_pin}")
        print(f"   Decrypted dataKey: {decrypted_data.hex()[:32]}...")
        break
        
    except:
        print(f"❌ Not: {test_pin}")
        continue
else:
    print()
    print("=" * 60)
    print("❓ None of the common PINs worked.")
    print()
    print("This means you either:")
    print("1. Used a different PIN during setup")
    print("2. There's a bug in the encryption implementation")
    print("3. The data was corrupted during storage")
    print()
    print("🔧 RECOMMENDATION:")
    print("Delete your existing PIN data and set it up again:")
    print("Run this SQL in Supabase:")
    print(f"DELETE FROM user_keys WHERE uuid_user_id = '{USER_ID}';")
    print()
    print("Then in the app:")
    print("1. Log out and log back in")
    print("2. You'll be prompted to setup PIN again")
    print("3. Enter your desired PIN carefully")

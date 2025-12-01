"""
Check database state to understand what encryption data exists
"""
import os
from dotenv import load_dotenv
from supabase import create_client, Client
import json

# Load environment
load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_ANON_KEY')

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

USER_ID = os.getenv('TEST_USER_ID', 'YOUR_USER_ID_HERE')

print("🔍 Checking database state for encryption keys...")
print()

try:
    response = supabase.table('user_keys').select('*').eq('uuid_user_id', USER_ID).execute()
    
    if not response.data or len(response.data) == 0:
        print("❌ No encryption keys found")
        exit(1)
    
    data = response.data[0]
    
    print("📊 Current database state:")
    print("=" * 60)
    print()
    
    print("🔑 PRIMARY ENCRYPTION (PIN-based):")
    print(f"   encrypted_key exists: {bool(data.get('encrypted_key'))}")
    print(f"   salt exists: {bool(data.get('salt'))}")
    print(f"   kdf_iterations: {data.get('kdf_iterations')}")
    if data.get('encrypted_key'):
        ek = data['encrypted_key']
        if ek.startswith('{'):
            parsed = json.loads(ek)
            print(f"   encrypted_key format: JSON")
            print(f"   encrypted_key.nonce: {parsed.get('nonce', 'N/A')[:20]}...")
            print(f"   encrypted_key.ciphertext length: {len(parsed.get('ciphertext', ''))}")
        else:
            print(f"   encrypted_key format: raw base64")
            print(f"   encrypted_key length: {len(ek)}")
    print()
    
    print("🔐 RECOVERY ENCRYPTION:")
    print(f"   encrypted_key_recovery exists: {bool(data.get('encrypted_key_recovery'))}")
    print(f"   salt_recovery exists: {bool(data.get('salt_recovery'))}")
    print(f"   kdf_iterations_recovery: {data.get('kdf_iterations_recovery')}")
    if data.get('encrypted_key_recovery'):
        ekr = data['encrypted_key_recovery']
        if ekr.startswith('{'):
            parsed = json.loads(ekr)
            print(f"   encrypted_key_recovery format: JSON")
            print(f"   encrypted_key_recovery.nonce: {parsed.get('nonce', 'N/A')[:20]}...")
            print(f"   encrypted_key_recovery.ciphertext length: {len(parsed.get('ciphertext', ''))}")
        else:
            print(f"   encrypted_key_recovery format: raw base64")
            print(f"   encrypted_key_recovery length: {len(ekr)}")
    print()
    
    print("📅 METADATA:")
    print(f"   key_version: {data.get('key_version')}")
    print(f"   created_at: {data.get('created_at')}")
    print(f"   updated_at: {data.get('updated_at')}")
    print()
    
    print("=" * 60)
    print()
    
    # Diagnosis
    print("💡 DIAGNOSIS:")
    if data.get('kdf_iterations') == 200000:
        print("⚠️  PRIMARY encryption uses 200,000 iterations")
        print("   This is from the OLD JWT-based encryption system!")
        print("   Your PIN setup did NOT overwrite the old data.")
        print()
    
    if data.get('kdf_iterations_recovery') == 100000:
        print("✅ RECOVERY encryption uses 100,000 iterations")
        print("   This is correct for the new PIN system.")
        print()
    
    print("🔧 RECOMMENDATION:")
    print("The issue is that setupNewSecrets() is creating NEW columns")
    print("(encrypted_key_recovery, salt_recovery) but NOT overwriting")
    print("the old encrypted_key and salt columns.")
    print()
    print("The app is trying to unlock using encrypted_key (old data)")
    print("instead of encrypted_key_recovery (new PIN data).")
    print()
    print("SOLUTION: Either:")
    print("1. Modify unlockWithPin() to use encrypted_key_recovery columns")
    print("2. Modify setupNewSecrets() to overwrite encrypted_key columns")
    
except Exception as e:
    print(f"❌ ERROR: {e}")
    import traceback
    traceback.print_exc()

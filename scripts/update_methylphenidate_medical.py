import os
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables from .env file in parent directory
script_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(script_dir, '..', '.env')
load_dotenv(env_path)

# Supabase credentials (set as environment variables for security)
SUPABASE_URL = os.getenv('SUPABASE_URL', 'your_supabase_url_here')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_ANON_KEY', 'your_supabase_anon_key_here')

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def update_methylphenidate_medical():
    """
    Update all drug_use entries where name = 'Methylphenidate' to set medical = true.
    """
    try:
        # First, let's see how many entries we need to update
        response = supabase.table('drug_use').select('use_id, name, medical').eq('name', 'Methylphenidate').execute()
        methylphenidate_entries = response.data

        print(f"Found {len(methylphenidate_entries)} Methylphenidate entries")

        # Count how many are already medical = true
        already_medical = sum(1 for entry in methylphenidate_entries if entry.get('medical') == True)
        print(f"{already_medical} entries are already marked as medical = true")

        # Count how many need to be updated (medical = false or null)
        to_update = [entry for entry in methylphenidate_entries if entry.get('medical') != True]

        if not to_update:
            print("No entries need to be updated - all Methylphenidate entries are already medical = true")
            return

        print(f"Updating {len(to_update)} entries to set medical = true")

        # Update each entry
        updated_count = 0
        for entry in to_update:
            use_id = entry['use_id']
            current_medical = entry.get('medical')

            # Update the entry
            supabase.table('drug_use').update({'medical': True}).eq('use_id', use_id).execute()

            print(f"Updated entry {use_id}: medical {current_medical} -> true")
            updated_count += 1

        print(f"\nSuccessfully updated {updated_count} Methylphenidate entries to medical = true")

        # Verify the updates
        verify_response = supabase.table('drug_use').select('use_id, name, medical').eq('name', 'Methylphenidate').eq('medical', True).execute()
        verified_count = len(verify_response.data)
        print(f"Verification: {verified_count} Methylphenidate entries now have medical = true")

    except Exception as e:
        print(f"Error updating Methylphenidate entries: {e}")
        raise

if __name__ == '__main__':
    update_methylphenidate_medical()
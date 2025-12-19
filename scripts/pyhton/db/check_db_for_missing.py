#!/usr/bin/env python3
"""
Check if missing MD* substances exist in Supabase database
"""
import os
from dotenv import load_dotenv

try:
    from supabase import create_client, Client
except ImportError:
    print("Error: supabase-py not installed. Install with: pip install supabase")
    exit(1)

load_dotenv()

def check_substances_in_db():
    """Check if substances exist in database"""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("Error: SUPABASE_URL and SUPABASE_ANON_KEY must be set")
        exit(1)
    
    supabase: Client = create_client(url, key)
    
    # Missing substances from JSON
    missing_from_json = [
        'mdbu', 'mdbz', 'mdd', 'mdh', 'mdip', 'mdm', 'mdmc',
        'mdmb-4en-pinaca', 'mdmb-chmica', 'mdmb-fubinaca',
        'mdmbp', 'mdmp', 'mdp', 'mdpbp', 'mdph', 'mdppp'
    ]
    
    print("=" * 80)
    print("Checking if missing MD* substances exist in Supabase database")
    print("=" * 80)
    
    results = {
        'in_db': [],
        'not_in_db': []
    }
    
    for slug in missing_from_json:
        try:
            response = supabase.table("drug_profiles").select("slug, name, pretty_name").eq("slug", slug).execute()
            
            if response.data and len(response.data) > 0:
                drug = response.data[0]
                results['in_db'].append((slug, drug['pretty_name']))
                print(f"✓ IN DB:     {slug:25} | {drug['pretty_name']}")
            else:
                results['not_in_db'].append(slug)
                print(f"✗ NOT IN DB: {slug}")
        except Exception as e:
            print(f"✗ ERROR checking {slug}: {e}")
            results['not_in_db'].append(slug)
    
    print("\n" + "=" * 80)
    print(f"Summary:")
    print(f"  Found in database:     {len(results['in_db'])}")
    print(f"  NOT in database:       {len(results['not_in_db'])}")
    print("=" * 80)
    
    if results['not_in_db']:
        print("\nSubstances to add:")
        for slug in results['not_in_db']:
            print(f"  - {slug}")
    
    return results

if __name__ == "__main__":
    check_substances_in_db()

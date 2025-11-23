#!/usr/bin/env python3
"""
Comprehensive check of substance synchronization between drugs.json and database.
Shows substances in DB only, JSON only, and in both.
"""

import json
import os
from pathlib import Path
from dotenv import load_dotenv

try:
    from supabase import create_client, Client
    SUPABASE_AVAILABLE = True
except ImportError:
    SUPABASE_AVAILABLE = False
    print("Error: supabase-py not installed. Install with: pip install supabase")
    exit(1)

load_dotenv()

def load_drugs_json():
    """Load drugs.json file"""
    json_path = Path(__file__).parent / "drugs.json"
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_all_drugs_from_db():
    """Get all drug slugs and names from database"""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("Error: SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env file")
        exit(1)
    
    try:
        supabase: Client = create_client(url, key)
        response = supabase.table("drug_profiles").select("slug, name, pretty_name, categories").execute()
        return {row['slug']: {
            'name': row['name'],
            'pretty_name': row['pretty_name'],
            'categories': row['categories']
        } for row in response.data}
    except Exception as e:
        print(f"Error fetching from database: {e}")
        exit(1)

def main():
    print("=" * 100)
    print("COMPREHENSIVE SUBSTANCE SYNCHRONIZATION CHECK")
    print("=" * 100)
    
    # Load data
    print("\n📂 Loading data sources...")
    drugs_json = load_drugs_json()
    drugs_db = get_all_drugs_from_db()
    
    json_slugs = set(drugs_json.keys())
    db_slugs = set(drugs_db.keys())
    
    # Calculate differences
    only_in_json = json_slugs - db_slugs
    only_in_db = db_slugs - json_slugs
    in_both = json_slugs & db_slugs
    
    # Summary
    print(f"\n📊 SUMMARY:")
    print(f"   Total in drugs.json:  {len(json_slugs):4d}")
    print(f"   Total in database:    {len(db_slugs):4d}")
    print(f"   In both:              {len(in_both):4d}")
    print(f"   Only in JSON:         {len(only_in_json):4d}")
    print(f"   Only in DB:           {len(only_in_db):4d}")
    
    # Substances only in JSON (missing from DB)
    if only_in_json:
        print(f"\n⚠️  SUBSTANCES IN JSON BUT NOT IN DATABASE ({len(only_in_json)}):")
        for slug in sorted(only_in_json):
            pretty_name = drugs_json[slug].get('pretty_name', slug)
            categories = drugs_json[slug].get('categories', [])
            print(f"   - {slug:30s} | {pretty_name:30s} | {categories}")
    else:
        print("\n✅ No substances found only in JSON")
    
    # Substances only in DB (not in JSON)
    if only_in_db:
        print(f"\n⚠️  SUBSTANCES IN DATABASE BUT NOT IN JSON ({len(only_in_db)}):")
        for slug in sorted(only_in_db):
            db_info = drugs_db[slug]
            pretty_name = db_info['pretty_name'] or slug
            categories = db_info['categories'] or []
            print(f"   - {slug:30s} | {pretty_name:30s} | {categories}")
    else:
        print("\n✅ No substances found only in database")
    
    # Check for user-created drugs in DB
    print(f"\n🔍 Checking for user-created substances in database...")
    try:
        url = os.getenv("SUPABASE_URL")
        key = os.getenv("SUPABASE_ANON_KEY")
        supabase: Client = create_client(url, key)
        
        # Check properties->is_user_created
        response = supabase.table("drug_profiles").select("slug, name, pretty_name, properties").execute()
        user_created = []
        for row in response.data:
            props = row.get('properties', {})
            if isinstance(props, dict) and props.get('is_user_created') == 1:
                user_created.append({
                    'slug': row['slug'],
                    'name': row['name'],
                    'pretty_name': row['pretty_name']
                })
        
        if user_created:
            print(f"\n👤 USER-CREATED SUBSTANCES ({len(user_created)}):")
            for drug in sorted(user_created, key=lambda x: x['slug']):
                print(f"   - {drug['slug']:30s} | {drug['pretty_name']}")
        else:
            print("   No user-created substances found")
            
    except Exception as e:
        print(f"   Error checking user-created drugs: {e}")
    
    # Final status
    print("\n" + "=" * 100)
    if not only_in_json and not only_in_db:
        print("✅ PERFECT SYNC: All substances are synchronized between JSON and database!")
    elif only_in_json:
        print(f"⚠️  ACTION NEEDED: {len(only_in_json)} substances need to be added to database")
    elif only_in_db:
        print(f"ℹ️  INFO: {len(only_in_db)} substances in database (possibly user-created or extras)")
    print("=" * 100)

if __name__ == "__main__":
    main()

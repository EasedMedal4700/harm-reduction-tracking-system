#!/usr/bin/env python3
"""
Check which substances from drugs.json are missing in the database
and generate INSERT statements for them.
"""

import json
import uuid
from pathlib import Path
from datetime import datetime
import os
from dotenv import load_dotenv

# Try to import supabase
try:
    from supabase import create_client, Client
    SUPABASE_AVAILABLE = True
except ImportError:
    SUPABASE_AVAILABLE = False
    print("Warning: supabase-py not installed. Install with: pip install supabase")

# Load environment variables
load_dotenv()

def load_drugs_json():
    """Load drugs.json file"""
    json_path = Path(__file__).parent / "drugs.json"
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_existing_drugs_from_db():
    """Get list of existing drug slugs from database"""
    if not SUPABASE_AVAILABLE:
        print("Cannot connect to database - supabase not available")
        return set()
    
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("Error: SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env file")
        return set()
    
    try:
        supabase: Client = create_client(url, key)
        response = supabase.table("drug_profiles").select("slug").execute()
        return {row['slug'] for row in response.data}
    except Exception as e:
        print(f"Error fetching from database: {e}")
        return set()

def generate_insert_statement(slug: str, drug_data: dict) -> str:
    """Generate PostgreSQL INSERT statement for a drug"""
    profile_id = str(uuid.uuid4())
    now = datetime.now().isoformat()
    
    # Extract fields with safe defaults
    name = drug_data.get('name', slug)
    pretty_name = drug_data.get('pretty_name', name.title())
    categories = json.dumps(drug_data.get('categories', []))
    aliases = json.dumps(drug_data.get('aliases', []))
    
    # Complex fields that may or may not exist
    formatted_dose = json.dumps(drug_data.get('formatted_dose')) if 'formatted_dose' in drug_data else 'null'
    formatted_duration = json.dumps(drug_data.get('formatted_duration')) if 'formatted_duration' in drug_data else 'null'
    formatted_onset = json.dumps(drug_data.get('formatted_onset')) if 'formatted_onset' in drug_data else 'null'
    formatted_aftereffects = json.dumps(drug_data.get('formatted_aftereffects')) if 'formatted_aftereffects' in drug_data else 'null'
    formatted_effects = json.dumps(drug_data.get('formatted_effects')) if 'formatted_effects' in drug_data else 'null'
    
    # Properties with is_user_created flag
    properties = drug_data.get('properties', {})
    properties['is_user_created'] = 0
    properties_json = json.dumps(properties)
    
    combos = json.dumps(drug_data.get('combos', {}))
    pweffects = json.dumps(drug_data.get('pweffects', {}))
    sources = json.dumps(drug_data.get('sources', []))
    dose_note = drug_data.get('dose_note', '')
    tolerance_model = json.dumps(drug_data.get('tolerance', {})) if 'tolerance' in drug_data else 'null'
    
    # Escape single quotes in strings
    def escape_sql(s):
        if s == 'null':
            return s
        return s.replace("'", "''")
    
    dose_note_escaped = escape_sql(dose_note) if dose_note else ''
    
    sql = f"""INSERT INTO "public"."drug_profiles" (
    "profile_id", 
    "slug", 
    "name", 
    "pretty_name", 
    "categories", 
    "aliases", 
    "formatted_dose", 
    "formatted_duration", 
    "formatted_onset", 
    "formatted_aftereffects", 
    "formatted_effects", 
    "properties", 
    "combos", 
    "pweffects", 
    "sources", 
    "dose_note", 
    "created_at", 
    "updated_at", 
    "tolerance_model"
) VALUES (
    '{profile_id}', 
    '{slug}', 
    '{name}', 
    '{pretty_name}', 
    '{escape_sql(categories)}', 
    '{escape_sql(aliases)}', 
    {formatted_dose if formatted_dose == 'null' else "'" + escape_sql(formatted_dose) + "'"}, 
    {formatted_duration if formatted_duration == 'null' else "'" + escape_sql(formatted_duration) + "'"}, 
    {formatted_onset if formatted_onset == 'null' else "'" + escape_sql(formatted_onset) + "'"}, 
    {formatted_aftereffects if formatted_aftereffects == 'null' else "'" + escape_sql(formatted_aftereffects) + "'"}, 
    {formatted_effects if formatted_effects == 'null' else "'" + escape_sql(formatted_effects) + "'"}, 
    '{escape_sql(properties_json)}', 
    '{escape_sql(combos)}', 
    '{escape_sql(pweffects)}', 
    '{escape_sql(sources)}', 
    {'null' if not dose_note_escaped else "'" + dose_note_escaped + "'"}, 
    '{now}', 
    '{now}', 
    {tolerance_model if tolerance_model == 'null' else "'" + escape_sql(tolerance_model) + "'"}
);
"""
    return sql

def main():
    print("=" * 80)
    print("Checking for missing substances in database")
    print("=" * 80)
    
    # Load drugs from JSON
    print("\n1. Loading drugs.json...")
    drugs_data = load_drugs_json()
    print(f"   Found {len(drugs_data)} substances in drugs.json")
    
    # Get existing drugs from database
    print("\n2. Fetching existing drugs from database...")
    existing_slugs = get_existing_drugs_from_db()
    print(f"   Found {len(existing_slugs)} substances in database")
    
    # Find missing drugs
    json_slugs = set(drugs_data.keys())
    missing_slugs = json_slugs - existing_slugs
    
    print(f"\n3. Comparison:")
    print(f"   - Substances in JSON: {len(json_slugs)}")
    print(f"   - Substances in DB: {len(existing_slugs)}")
    print(f"   - Missing in DB: {len(missing_slugs)}")
    
    if not missing_slugs:
        print("\n✅ All substances from drugs.json are already in the database!")
        return
    
    # Generate INSERT statements
    print(f"\n4. Generating INSERT statements for {len(missing_slugs)} missing substances...")
    
    output_file = Path(__file__).parent.parent / "DB" / "missing_drugs_inserts.sql"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Missing drug profiles INSERT statements\n")
        f.write(f"-- Generated: {datetime.now().isoformat()}\n")
        f.write(f"-- Total missing: {len(missing_slugs)}\n\n")
        
        for i, slug in enumerate(sorted(missing_slugs), 1):
            f.write(f"\n-- {i}/{len(missing_slugs)}: {slug}\n")
            try:
                sql = generate_insert_statement(slug, drugs_data[slug])
                f.write(sql)
                f.write("\n")
            except Exception as e:
                f.write(f"-- ERROR generating SQL for {slug}: {e}\n\n")
                print(f"   ⚠️  Error with {slug}: {e}")
    
    print(f"\n✅ SQL file generated: {output_file}")
    print(f"\n5. Missing substances list:")
    for slug in sorted(missing_slugs):
        pretty_name = drugs_data[slug].get('pretty_name', slug)
        print(f"   - {slug} ({pretty_name})")
    
    print("\n" + "=" * 80)
    print(f"Done! Execute the SQL file to add {len(missing_slugs)} missing substances.")
    print("=" * 80)

if __name__ == "__main__":
    main()

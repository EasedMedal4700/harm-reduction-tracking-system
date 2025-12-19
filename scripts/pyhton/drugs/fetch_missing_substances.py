#!/usr/bin/env python3
"""
Fetch missing MD* substances from TripSit API and prepare them for database
"""
import json
import uuid
import requests
from pathlib import Path
from datetime import datetime

def fetch_from_tripsit(slug):
    """Fetch drug data from TripSit API"""
    try:
        url = f"http://tripbot.tripsit.me/api/tripsit/getDrug?name={slug}"
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            data = response.json()
            if 'data' in data and len(data['data']) > 0:
                # Get the first drug data (should match slug)
                drug_data = data['data'][0]
                return drug_data
        return None
    except Exception as e:
        print(f"Error fetching {slug}: {e}")
        return None

def generate_insert_statement(slug, drug_data):
    """Generate PostgreSQL INSERT statement"""
    profile_id = str(uuid.uuid4())
    now = datetime.now().isoformat()
    
    name = drug_data.get('name', slug)
    pretty_name = drug_data.get('pretty_name', name.title())
    categories = json.dumps(drug_data.get('categories', []))
    aliases = json.dumps(drug_data.get('aliases', []))
    
    formatted_dose = json.dumps(drug_data.get('formatted_dose')) if 'formatted_dose' in drug_data else 'null'
    formatted_duration = json.dumps(drug_data.get('formatted_duration')) if 'formatted_duration' in drug_data else 'null'
    formatted_onset = json.dumps(drug_data.get('formatted_onset')) if 'formatted_onset' in drug_data else 'null'
    formatted_aftereffects = json.dumps(drug_data.get('formatted_aftereffects')) if 'formatted_aftereffects' in drug_data else 'null'
    formatted_effects = json.dumps(drug_data.get('formatted_effects')) if 'formatted_effects' in drug_data else 'null'
    
    properties = drug_data.get('properties', {})
    properties['is_user_created'] = 0
    properties_json = json.dumps(properties)
    
    combos = json.dumps(drug_data.get('combos', {}))
    pweffects = json.dumps(drug_data.get('pweffects', {}))
    sources = json.dumps(drug_data.get('sources', {}))
    dose_note = drug_data.get('dose_note', '')
    tolerance_model = json.dumps(drug_data.get('tolerance', {})) if 'tolerance' in drug_data else 'null'
    
    def escape_sql(s):
        if s == 'null':
            return s
        return s.replace("'", "''")
    
    dose_note_escaped = escape_sql(dose_note) if dose_note else ''
    
    sql = f"""INSERT INTO "public"."drug_profiles" (
    "profile_id", "slug", "name", "pretty_name", "categories", "aliases", 
    "formatted_dose", "formatted_duration", "formatted_onset", "formatted_aftereffects", 
    "formatted_effects", "properties", "combos", "pweffects", "sources", "dose_note", 
    "created_at", "updated_at", "tolerance_model"
) VALUES (
    '{profile_id}', '{slug}', '{name}', '{pretty_name}', 
    '{escape_sql(categories)}', '{escape_sql(aliases)}', 
    {formatted_dose if formatted_dose == 'null' else "'" + escape_sql(formatted_dose) + "'"}, 
    {formatted_duration if formatted_duration == 'null' else "'" + escape_sql(formatted_duration) + "'"}, 
    {formatted_onset if formatted_onset == 'null' else "'" + escape_sql(formatted_onset) + "'"}, 
    {formatted_aftereffects if formatted_aftereffects == 'null' else "'" + escape_sql(formatted_aftereffects) + "'"}, 
    {formatted_effects if formatted_effects == 'null' else "'" + escape_sql(formatted_effects) + "'"}, 
    '{escape_sql(properties_json)}', '{escape_sql(combos)}', '{escape_sql(pweffects)}', 
    '{escape_sql(sources)}', 
    {'null' if not dose_note_escaped else "'" + dose_note_escaped + "'"}, 
    '{now}', '{now}', 
    {tolerance_model if tolerance_model == 'null' else "'" + escape_sql(tolerance_model) + "'"}
);
"""
    return sql

def main():
    missing_substances = [
        'mdbu', 'mdbz', 'mdd', 'mdh', 'mdip', 'mdm', 'mdmc',
        'mdmb-4en-pinaca', 'mdmb-chmica', 'mdmb-fubinaca',
        'mdmbp', 'mdmp', 'mdp', 'mdpbp', 'mdph', 'mdppp'
    ]
    
    print("=" * 80)
    print("Fetching missing MD* substances from TripSit API")
    print("=" * 80)
    
    fetched_data = {}
    sql_statements = []
    
    for slug in missing_substances:
        print(f"\nFetching {slug}...", end=" ")
        data = fetch_from_tripsit(slug)
        
        if data:
            fetched_data[slug] = data
            sql = generate_insert_statement(slug, data)
            sql_statements.append((slug, sql))
            pretty = data.get('pretty_name', slug.upper())
            print(f"✓ SUCCESS - {pretty}")
        else:
            print(f"✗ NOT FOUND in TripSit API")
    
    # Save to JSON file for updating drugs.json
    if fetched_data:
        output_json = Path(__file__).parent.parent / "DB" / "missing_md_substances.json"
        with open(output_json, 'w', encoding='utf-8') as f:
            json.dump(fetched_data, f, indent=2, ensure_ascii=False)
        print(f"\n✓ Saved JSON data to: {output_json}")
    
    # Generate SQL file
    if sql_statements:
        output_sql = Path(__file__).parent.parent / "DB" / "missing_md_substances.sql"
        with open(output_sql, 'w', encoding='utf-8') as f:
            f.write("-- Missing MD* substances INSERT statements\n")
            f.write(f"-- Generated: {datetime.now().isoformat()}\n")
            f.write(f"-- Total: {len(sql_statements)}\n\n")
            
            for slug, sql in sql_statements:
                f.write(f"\n-- {slug}\n")
                f.write(sql)
                f.write("\n")
        
        print(f"✓ Saved SQL statements to: {output_sql}")
    
    print("\n" + "=" * 80)
    print(f"Summary:")
    print(f"  Successfully fetched: {len(fetched_data)}")
    print(f"  Failed to fetch: {len(missing_substances) - len(fetched_data)}")
    print("=" * 80)
    
    if len(fetched_data) < len(missing_substances):
        print("\nSubstances NOT found in TripSit API:")
        for slug in missing_substances:
            if slug not in fetched_data:
                print(f"  - {slug}")

if __name__ == "__main__":
    main()

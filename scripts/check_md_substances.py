#!/usr/bin/env python3
import json
from pathlib import Path

json_path = Path(__file__).parent / "drugs.json"
with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Check for substances from mcpp to mdoh
substances_to_check = [
    'mcpp', 'mda', 'mdai', 'mdbu', 'mdbz', 'mdd', 
    'mdea', 'mdh', 'mdip', 'mdm', 'mdma', 'mdmc', 
    'mdmb-4en-pinaca', 'mdmb-chmica', 'mdmb-fubinaca',
    'mdmbp', 'mdmp', 'mdoh', 'mdp', 'mdpbp', 'mdph', 
    'mdppp', 'mdpv'
]

print("Checking substances from mcpp to mdpv range:")
print("=" * 60)
for s in substances_to_check:
    status = "✓ FOUND" if s in data else "✗ MISSING"
    if s in data:
        pretty = data[s].get('pretty_name', s.upper())
        print(f"{status:12} | {s:20} | {pretty}")
    else:
        print(f"{status:12} | {s:20}")

# List all substances starting with 'md'
print("\n" + "=" * 60)
print("All substances in drugs.json starting with 'md':")
print("=" * 60)
md_substances = sorted([k for k in data.keys() if k.startswith('md')])
for s in md_substances:
    pretty = data[s].get('pretty_name', s.upper())
    print(f"  {s:25} | {pretty}")
print(f"\nTotal: {len(md_substances)} substances")

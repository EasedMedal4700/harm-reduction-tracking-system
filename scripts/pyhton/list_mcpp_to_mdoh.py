#!/usr/bin/env python3
import json
from pathlib import Path

json_path = Path(__file__).parent / "drugs.json"
with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

keys = list(data.keys())
mcpp_idx = keys.index('mcpp')
mdoh_idx = keys.index('mdoh')

print("Substances from mcpp to mdoh:")
print("=" * 60)
for i in range(mcpp_idx, mdoh_idx + 1):
    slug = keys[i]
    pretty = data[slug].get('pretty_name', slug.upper())
    print(f"  {i - mcpp_idx + 1:2}. {slug:25} | {pretty}")

print("=" * 60)
print(f"Total: {mdoh_idx - mcpp_idx + 1} substances")

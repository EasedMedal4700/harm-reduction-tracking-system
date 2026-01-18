import json
import os

# Path to drugs.json relative to this script
drugs_file = os.path.join(os.path.dirname(__file__), '..', 'ci', 'drugs.json')

# Load the JSON data
with open(drugs_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Dictionary to count category occurrences
category_count = {}

# Iterate through each drug entry
for drug, info in data.items():
    if 'categories' in info and isinstance(info['categories'], list):
        for category in info['categories']:
            category_count[category] = category_count.get(category, 0) + 1

# Print the results
print("Categories and their frequencies in drugs.json:")
print("-" * 50)
for category, count in sorted(category_count.items()):
    print(f"{category}: {count}")

print("-" * 50)
print(f"Total unique categories: {len(category_count)}")
import json
import os
from backend.utils.config import CLEANED_DIR, DIFF_DIR, timestamp
from backend.utils.logging_utils import log

os.makedirs(DIFF_DIR, exist_ok=True)

def generate_diff(normalized, db):
    diff = []

    for drug_name, scraped_sources in normalized.items():
        if drug_name not in db:
            diff.append({"drug": drug_name, "change": "missing_in_db"})
            continue

        # placeholder comparison logic
        diff.append({
            "drug": drug_name,
            "scraped_sources": len(scraped_sources),
            "db_source": "present",
        })

    return diff

def run_diff():
    latest_norm = sorted(os.listdir(CLEANED_DIR))[-1]
    with open(os.path.join(CLEANED_DIR, latest_norm)) as f:
        norm = json.load(f)

    # Fake DB values for now
    fake_db = {
        "MDMA": {},
        "LSD": {},
        "Ketamine": {}
    }

    merged = {}
    for r in norm:
        merged.setdefault(r["drug"], []).append(r)

    diff = generate_diff(merged, fake_db)

    filename = os.path.join(DIFF_DIR, f"db_vs_scrape_{timestamp()}.json")
    with open(filename, "w") as f:
        json.dump(diff, f, indent=2)

    print(f"Diff written: {filename}")

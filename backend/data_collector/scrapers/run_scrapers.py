import json
import os
from backend.scrapers.scrape_pubchem import scrape_pubchem
from backend.scrapers.scrape_psychonautwiki import scrape_psychonautwiki
from backend.scrapers.scrape_tripsit import scrape_tripsit
from backend.scrapers.scrape_wikipedia import scrape_wikipedia
from backend.scrapers.scrape_tripsit_file import scrape_tripsit_file
from backend.utils.config import SCRAPED_DIR, timestamp
from backend.utils.logging_utils import log

os.makedirs(SCRAPED_DIR, exist_ok=True)

# All drugs will come from TripSit JSON
def run_all_scrapers():
    output = []

    # STEP 1: Load baseline dataset
    log.info("Loading baseline TripSit JSON dataset...")
    base = scrape_tripsit_file()

    if not base["ok"]:
        raise Exception(f"Failed to load TripSit baseline: {base['error']}")

    raw_drug_map = base["raw"]     # dict of drug_name → drug_data

    # Convert to cleaned searchable list of names
    drug_names = sorted(raw_drug_map.keys())

    log.info(f"Found {len(drug_names)} drugs in TripSit baseline")

    # STEP 2: Add baseline record
    output.append(base)

    # STEP 3: For each drug, enrich from the other scrapers
    for drug in drug_names:
        log.info(f"Scraping enrichment sources for {drug}")

        output.append(scrape_pubchem(drug))
        output.append(scrape_psychonautwiki(drug))
        output.append(scrape_tripsit(drug))       # API version
        output.append(scrape_wikipedia(drug))

    filename = os.path.join(SCRAPED_DIR, f"raw_{timestamp()}.json")
    with open(filename, "w") as f:
        json.dump(output, f, indent=2)

    print(f"Scraped data saved to {filename}")

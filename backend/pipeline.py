"""
=============================================================================
DRUG DATA PIPELINE - INTEGRATED SCRAPER AND MERGER
=============================================================================

This pipeline:
1. Fetches TripSit drugs.json from GitHub as the BASELINE
2. Scrapes PsychonautWiki index for additional substances
3. Enriches each drug with data from multiple sources
4. Merges data with priority: PsychonautWiki > TripSit > Others
5. Exports final JSON file matching the drugs.json format

Priority order for overlapping data:
  #1 PsychonautWiki (most trusted for harm reduction)
  #2 TripSit (baseline, comprehensive)
  #3 PubChem (chemical data)
  #4 Wikipedia (general info)

Run with:
  python -m backend.pipeline                    # Full run
  python -m backend.pipeline --max-pw 10        # Limit PW scrapes to 10
  python -m backend.pipeline --skip-pw          # Skip PW, use TripSit only
  python -m backend.pipeline --quick            # Quick test (20 PW scrapes)

=============================================================================
"""

import json
import os
import sys
import time
import traceback
from datetime import datetime
from typing import Dict, List, Optional, Any

# Local imports
from backend.scrapers.scrape_tripsit_file import scrape_tripsit_file
from backend.scrapers.scrape_psychonautwiki_index import scrape_psychonautwiki_index, scrape_psychonautwiki_page, parse_substance_page
from backend.scrapers.scrape_psychonautwiki import scrape_psychonautwiki
from backend.scrapers.scrape_pubchem import scrape_pubchem
from backend.scrapers.scrape_wikipedia import scrape_wikipedia
from backend.utils.config import SCRAPED_DIR, CLEANED_DIR, DATA_DIR, timestamp
from backend.utils.logging_utils import log

# Ensure directories exist
os.makedirs(SCRAPED_DIR, exist_ok=True)
os.makedirs(CLEANED_DIR, exist_ok=True)
os.makedirs(DATA_DIR, exist_ok=True)


# =============================================================================
# CONSOLE OUTPUT HELPERS
# =============================================================================

def print_header(text: str):
    """Print a prominent header."""
    print("\n" + "=" * 70)
    print(f"  {text}")
    print("=" * 70)


def print_step(step_num: int, total: int, text: str):
    """Print a step indicator."""
    print(f"\n[STEP {step_num}/{total}] {text}")
    print("-" * 50)


def print_progress(current: int, total: int, name: str, status: str = ""):
    """Print progress bar."""
    pct = (current / total) * 100 if total > 0 else 0
    bar_len = 30
    filled = int(bar_len * current / total) if total > 0 else 0
    bar = "█" * filled + "░" * (bar_len - filled)
    status_str = f" [{status}]" if status else ""
    print(f"\r  [{bar}] {current}/{total} ({pct:.1f}%) - {name[:30]:<30}{status_str}", end="", flush=True)


def print_success(text: str):
    """Print success message."""
    print(f"  ✅ {text}")


def print_warning(text: str):
    """Print warning message."""
    print(f"  ⚠️  {text}")


def print_error(text: str):
    """Print error message."""
    print(f"  ❌ {text}")


def print_info(text: str):
    """Print info message."""
    print(f"  ℹ️  {text}")


def print_stats(label: str, value: Any):
    """Print a stat line."""
    print(f"  • {label}: {value}")


# =============================================================================
# DATA MERGING LOGIC
# =============================================================================

def deep_merge(base: dict, overlay: dict, prefer_overlay: bool = True) -> dict:
    """
    Deep merge two dictionaries.
    If prefer_overlay is True, overlay values take precedence for conflicts.
    """
    result = base.copy()
    
    for key, value in overlay.items():
        if key in result:
            # Both have this key
            if isinstance(result[key], dict) and isinstance(value, dict):
                # Recursively merge dicts
                result[key] = deep_merge(result[key], value, prefer_overlay)
            elif isinstance(result[key], list) and isinstance(value, list):
                # Combine lists, remove duplicates
                combined = result[key] + [v for v in value if v not in result[key]]
                result[key] = combined
            elif prefer_overlay and value is not None:
                # Overlay wins for scalar values
                result[key] = value
            # else: keep base value
        else:
            # Key only in overlay
            if value is not None:
                result[key] = value
    
    return result


def normalize_drug_name(name: str) -> str:
    """Normalize a drug name for matching."""
    if not name:
        return ""
    return name.lower().strip().replace(" ", "-").replace("_", "-")


def create_drug_record(name: str, pretty_name: str = None) -> dict:
    """Create an empty drug record with the standard structure."""
    slug = normalize_drug_name(name)
    return {
        "name": slug,
        "pretty_name": pretty_name or name,
        "aliases": [],
        "categories": [],
        "formatted_dose": {},
        "formatted_duration": {},
        "formatted_onset": {},
        "formatted_aftereffects": {},
        "formatted_effects": [],
        "properties": {},
        "combos": {},
        "pweffects": {},
        "sources": {},
        "dose_note": None,
        "links": {}
    }


# =============================================================================
# STEP 1: FETCH TRIPSIT BASELINE
# =============================================================================

def fetch_tripsit_baseline() -> Dict[str, dict]:
    """
    Fetch the TripSit drugs.json from GitHub as the baseline dataset.
    Returns a dict mapping normalized drug names to their data.
    """
    print_step(1, 5, "FETCHING TRIPSIT BASELINE FROM GITHUB")
    
    print_info("Downloading TripSit drugs.json...")
    log.info("[Pipeline] Fetching TripSit baseline...")
    
    result = scrape_tripsit_file()
    
    if not result["ok"]:
        print_error(f"Failed to fetch TripSit baseline: {result['error']}")
        log.error(f"[Pipeline] TripSit baseline fetch failed: {result['error']}")
        raise Exception(f"TripSit baseline fetch failed: {result['error']}")
    
    raw_data = result["raw"]
    
    # Build normalized lookup
    drugs = {}
    for name, data in raw_data.items():
        normalized = normalize_drug_name(name)
        drugs[normalized] = data
        # Ensure name field is set
        if "name" not in data:
            data["name"] = normalized
        if "pretty_name" not in data:
            data["pretty_name"] = data.get("pretty_name", name)
    
    print_success(f"Loaded {len(drugs)} drugs from TripSit baseline")
    print_stats("Sample drugs", ", ".join(list(drugs.keys())[:5]) + "...")
    
    log.info(f"[Pipeline] TripSit baseline loaded: {len(drugs)} drugs")
    
    return drugs


# =============================================================================
# STEP 2: FETCH PSYCHONAUTWIKI INDEX
# =============================================================================

def fetch_psychonautwiki_index() -> List[dict]:
    """
    Fetch the PsychonautWiki substance index.
    Returns a list of {"name": str, "url": str} dicts.
    """
    print_step(2, 5, "FETCHING PSYCHONAUTWIKI SUBSTANCE INDEX")
    
    print_info("Scraping PsychonautWiki index page...")
    log.info("[Pipeline] Fetching PsychonautWiki index...")
    
    result = scrape_psychonautwiki_index()
    
    if not result["ok"]:
        print_warning(f"Failed to fetch PW index: {result['error']}")
        print_info("Will continue with TripSit baseline only")
        log.warning(f"[Pipeline] PW index fetch failed: {result['error']}")
        return []
    
    substances = result["raw"]
    
    print_success(f"Found {len(substances)} substances on PsychonautWiki")
    print_stats("Sample substances", ", ".join([s["name"] for s in substances[:5]]) + "...")
    
    log.info(f"[Pipeline] PW index loaded: {len(substances)} substances")
    
    return substances


# =============================================================================
# STEP 3: SCRAPE AND MERGE DATA
# =============================================================================

def scrape_and_merge_all(
    tripsit_drugs: Dict[str, dict],
    pw_substances: List[dict],
    scrape_delay: float = 0.5,
    max_pw_scrapes: int = None
) -> Dict[str, dict]:
    """
    Main scraping and merging logic.
    
    Priority:
      1. PsychonautWiki data overwrites TripSit data
      2. TripSit is the baseline
      3. Other sources (PubChem, Wikipedia) fill gaps
    
    Args:
        tripsit_drugs: Dict of normalized_name -> drug_data from TripSit
        pw_substances: List of {"name": str, "url": str} from PW index
        scrape_delay: Delay between requests (rate limiting)
        max_pw_scrapes: Limit PW page scrapes (None = all)
    
    Returns:
        Dict of normalized_name -> merged_drug_data
    """
    print_step(3, 5, "SCRAPING AND MERGING DATA FROM ALL SOURCES")
    
    # Start with TripSit as base
    merged = {}
    for name, data in tripsit_drugs.items():
        merged[name] = data.copy()
    
    print_info(f"Starting with {len(merged)} drugs from TripSit baseline")
    
    # Build PW lookup for matching
    pw_lookup = {}
    for sub in pw_substances:
        normalized = normalize_drug_name(sub["name"])
        pw_lookup[normalized] = sub
    
    print_info(f"PsychonautWiki has {len(pw_lookup)} unique substances")
    
    # Find substances in PW but not in TripSit
    pw_only = set(pw_lookup.keys()) - set(merged.keys())
    print_info(f"Substances only on PsychonautWiki: {len(pw_only)}")
    
    # Track statistics
    stats = {
        "pw_scraped": 0,
        "pw_failed": 0,
        "pw_matched": 0,
        "pw_new": 0,
        "enrichment_success": 0,
        "enrichment_failed": 0
    }
    
    # -------------------------------------------------------------------------
    # PHASE A: Scrape PsychonautWiki pages for substances that match TripSit
    # -------------------------------------------------------------------------
    print("\n  📖 Phase A: Enriching existing drugs with PsychonautWiki data...")
    
    # Find matches between TripSit and PW
    matched_drugs = set(merged.keys()) & set(pw_lookup.keys())
    print_info(f"Found {len(matched_drugs)} drugs in both TripSit and PW")
    
    scrape_list = list(matched_drugs)
    if max_pw_scrapes and max_pw_scrapes < len(scrape_list):
        scrape_list = scrape_list[:max_pw_scrapes]
        print_warning(f"Limiting to {max_pw_scrapes} PW scrapes for testing")
    
    for i, drug_name in enumerate(scrape_list):
        pw_info = pw_lookup[drug_name]
        
        print_progress(i + 1, len(scrape_list), drug_name, "scraping PW")
        
        try:
            # Scrape the PW page
            page_result = scrape_psychonautwiki_page(pw_info["url"], pw_info["name"])
            
            if page_result["ok"] and page_result["raw"]:
                # Parse the HTML
                pw_data = parse_substance_page(page_result["raw"]["html"], pw_info["name"])
                
                # Merge PW data INTO existing drug (PW takes priority)
                merged[drug_name] = deep_merge(merged[drug_name], pw_data, prefer_overlay=True)
                merged[drug_name]["_pw_enriched"] = True
                
                stats["pw_scraped"] += 1
                stats["pw_matched"] += 1
            else:
                stats["pw_failed"] += 1
                log.warning(f"[Pipeline] PW page scrape failed for {drug_name}: {page_result.get('error')}")
        
        except Exception as e:
            stats["pw_failed"] += 1
            log.error(f"[Pipeline] Error scraping PW page for {drug_name}: {e}")
        
        # Rate limiting
        time.sleep(scrape_delay)
    
    print()  # New line after progress bar
    print_success(f"Enriched {stats['pw_matched']} drugs with PsychonautWiki data")
    
    # -------------------------------------------------------------------------
    # PHASE B: Add new substances from PW that aren't in TripSit
    # -------------------------------------------------------------------------
    print("\n  📖 Phase B: Adding PsychonautWiki-only substances...")
    
    pw_only_list = list(pw_only)
    if max_pw_scrapes and max_pw_scrapes < len(pw_only_list):
        pw_only_list = pw_only_list[:max_pw_scrapes]
        print_warning(f"Limiting to {max_pw_scrapes} new PW substances for testing")
    
    for i, drug_name in enumerate(pw_only_list):
        pw_info = pw_lookup[drug_name]
        
        print_progress(i + 1, len(pw_only_list), drug_name, "adding from PW")
        
        try:
            page_result = scrape_psychonautwiki_page(pw_info["url"], pw_info["name"])
            
            if page_result["ok"] and page_result["raw"]:
                pw_data = parse_substance_page(page_result["raw"]["html"], pw_info["name"])
                
                # Create new record with PW data
                new_drug = create_drug_record(drug_name, pw_info["name"])
                new_drug = deep_merge(new_drug, pw_data, prefer_overlay=True)
                new_drug["_pw_only"] = True
                
                merged[drug_name] = new_drug
                stats["pw_new"] += 1
            else:
                stats["pw_failed"] += 1
        
        except Exception as e:
            stats["pw_failed"] += 1
            log.error(f"[Pipeline] Error adding PW-only substance {drug_name}: {e}")
        
        time.sleep(scrape_delay)
    
    print()
    print_success(f"Added {stats['pw_new']} new substances from PsychonautWiki")
    
    # -------------------------------------------------------------------------
    # PHASE C: Enrich with additional sources (PubChem, Wikipedia)
    # -------------------------------------------------------------------------
    print("\n  📖 Phase C: Enriching with additional sources (PubChem, Wikipedia)...")
    print_info("This phase adds supplementary data without overwriting existing values")
    
    # Only enrich a subset for now (the ones that don't have full data)
    drugs_to_enrich = [name for name in list(merged.keys())[:50]]  # Limit for speed
    
    for i, drug_name in enumerate(drugs_to_enrich):
        print_progress(i + 1, len(drugs_to_enrich), drug_name, "enriching")
        
        try:
            # PubChem
            pubchem_result = scrape_pubchem(drug_name)
            if pubchem_result["ok"] and pubchem_result["raw"]:
                # Only add if we don't have this data already
                if not merged[drug_name].get("properties", {}).get("formula"):
                    try:
                        pc_data = pubchem_result["raw"]
                        if "PC_Compounds" in pc_data and pc_data["PC_Compounds"]:
                            props = pc_data["PC_Compounds"][0].get("props", [])
                            for prop in props:
                                if prop.get("urn", {}).get("label") == "Molecular Formula":
                                    formula = prop.get("value", {}).get("sval")
                                    if formula:
                                        merged[drug_name].setdefault("properties", {})["formula"] = formula
                    except Exception:
                        pass
                stats["enrichment_success"] += 1
            
            # Wikipedia (for summary if missing)
            if not merged[drug_name].get("properties", {}).get("summary"):
                wiki_result = scrape_wikipedia(drug_name)
                if wiki_result["ok"] and wiki_result["raw"]:
                    try:
                        pages = wiki_result["raw"]["query"]["pages"]
                        page = next(iter(pages.values()))
                        extract = page.get("extract", "").strip()
                        if extract and len(extract) > 50:
                            merged[drug_name].setdefault("properties", {})["summary_wiki"] = extract[:500]
                    except Exception:
                        pass
        
        except Exception as e:
            stats["enrichment_failed"] += 1
            log.error(f"[Pipeline] Error enriching {drug_name}: {e}")
        
        time.sleep(scrape_delay / 2)  # Faster for these sources
    
    print()
    print_success(f"Enriched {stats['enrichment_success']} drugs with additional sources")
    
    # Print summary
    print("\n  📊 Scraping Summary:")
    print_stats("Total drugs in final dataset", len(merged))
    print_stats("PW pages scraped successfully", stats["pw_scraped"])
    print_stats("PW-matched drugs enriched", stats["pw_matched"])
    print_stats("New substances from PW", stats["pw_new"])
    print_stats("PW scrape failures", stats["pw_failed"])
    print_stats("Additional enrichments", stats["enrichment_success"])
    
    return merged


# =============================================================================
# STEP 4: VALIDATE AND CLEAN DATA
# =============================================================================

def validate_and_clean(drugs: Dict[str, dict]) -> Dict[str, dict]:
    """
    Validate and clean the merged data.
    Remove internal flags, ensure consistent structure.
    """
    print_step(4, 5, "VALIDATING AND CLEANING DATA")
    
    cleaned = {}
    warnings = []
    
    for name, data in drugs.items():
        # Remove internal tracking fields
        clean_data = {k: v for k, v in data.items() if not k.startswith("_")}
        
        # Ensure required fields
        if "name" not in clean_data:
            clean_data["name"] = name
        
        if "pretty_name" not in clean_data:
            clean_data["pretty_name"] = name.replace("-", " ").title()
        
        # Validate categories is a list
        if "categories" in clean_data and not isinstance(clean_data["categories"], list):
            clean_data["categories"] = [clean_data["categories"]] if clean_data["categories"] else []
        
        # Validate aliases is a list
        if "aliases" in clean_data and not isinstance(clean_data["aliases"], list):
            clean_data["aliases"] = [clean_data["aliases"]] if clean_data["aliases"] else []
        
        # Validate effects is a list
        if "formatted_effects" in clean_data and not isinstance(clean_data["formatted_effects"], list):
            clean_data["formatted_effects"] = []
        
        # Check for missing critical data
        has_dose = bool(clean_data.get("formatted_dose"))
        has_duration = bool(clean_data.get("formatted_duration"))
        
        if not has_dose and not has_duration:
            warnings.append(f"{name}: missing dose and duration data")
        
        cleaned[name] = clean_data
    
    print_success(f"Validated {len(cleaned)} drug records")
    
    if warnings:
        print_warning(f"{len(warnings)} drugs have incomplete data")
        if len(warnings) <= 10:
            for w in warnings:
                print(f"      • {w}")
        else:
            print(f"      (showing first 10)")
            for w in warnings[:10]:
                print(f"      • {w}")
    
    return cleaned


# =============================================================================
# STEP 5: EXPORT TO JSON
# =============================================================================

def export_to_json(drugs: Dict[str, dict], filename: str = None) -> str:
    """
    Export the final drug data to a JSON file.
    """
    print_step(5, 5, "EXPORTING TO JSON FILE")
    
    if filename is None:
        filename = os.path.join(CLEANED_DIR, f"drugs_merged_{timestamp()}.json")
    
    # Sort by name for consistent output
    sorted_drugs = dict(sorted(drugs.items()))
    
    print_info(f"Writing {len(sorted_drugs)} drugs to JSON...")
    
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(sorted_drugs, f, indent=2, ensure_ascii=False)
    
    file_size = os.path.getsize(filename)
    print_success(f"Exported to: {filename}")
    print_stats("File size", f"{file_size / 1024:.1f} KB")
    print_stats("Total drugs", len(sorted_drugs))
    
    # Also save a raw scraped version for debugging
    raw_filename = os.path.join(SCRAPED_DIR, f"raw_merged_{timestamp()}.json")
    with open(raw_filename, "w", encoding="utf-8") as f:
        json.dump(sorted_drugs, f, indent=2, ensure_ascii=False)
    print_info(f"Raw backup saved to: {raw_filename}")
    
    return filename


# =============================================================================
# MAIN PIPELINE
# =============================================================================

def run_pipeline(
    scrape_delay: float = 0.5,
    max_pw_scrapes: int = None,
    skip_pw_scraping: bool = False,
    output_file: str = None
):
    """
    Run the complete data pipeline.
    
    Args:
        scrape_delay: Delay between HTTP requests (seconds)
        max_pw_scrapes: Limit PW page scrapes (None = all)
        skip_pw_scraping: Skip PW page scraping (use index only)
        output_file: Custom output filename
    """
    start_time = time.time()
    
    print_header("DRUG DATA PIPELINE - STARTING")
    print(f"  Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"  Scrape delay: {scrape_delay}s")
    print(f"  Max PW scrapes: {max_pw_scrapes or 'unlimited'}")
    print(f"  Skip PW scraping: {skip_pw_scraping}")
    
    try:
        # Step 1: Fetch TripSit baseline
        tripsit_drugs = fetch_tripsit_baseline()
        
        # Step 2: Fetch PsychonautWiki index
        if skip_pw_scraping:
            print_step(2, 5, "SKIPPING PSYCHONAUTWIKI (--skip-pw flag)")
            pw_substances = []
        else:
            pw_substances = fetch_psychonautwiki_index()
        
        # Step 3: Scrape and merge
        if skip_pw_scraping:
            print_step(3, 5, "USING TRIPSIT BASELINE ONLY")
            merged = tripsit_drugs
        else:
            merged = scrape_and_merge_all(
                tripsit_drugs,
                pw_substances,
                scrape_delay=scrape_delay,
                max_pw_scrapes=max_pw_scrapes
            )
        
        # Step 4: Validate and clean
        cleaned = validate_and_clean(merged)
        
        # Step 5: Export
        output_path = export_to_json(cleaned, output_file)
        
        # Final summary
        elapsed = time.time() - start_time
        print_header("PIPELINE COMPLETED SUCCESSFULLY")
        print(f"  Total time: {elapsed:.1f} seconds")
        print(f"  Output file: {output_path}")
        print(f"  Total drugs: {len(cleaned)}")
        print()
        
        return output_path
    
    except KeyboardInterrupt:
        print("\n\n")
        print_error("Pipeline interrupted by user (Ctrl+C)")
        print_info("Partial data may have been saved")
        sys.exit(1)
    
    except Exception as e:
        print("\n\n")
        print_error(f"PIPELINE FAILED: {e}")
        print("\n  Full traceback:")
        traceback.print_exc()
        print()
        log.error(f"[Pipeline] Fatal error: {e}")
        log.error(traceback.format_exc())
        sys.exit(1)


# =============================================================================
# COMMAND LINE INTERFACE
# =============================================================================

def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Drug Data Pipeline - Scrape and merge drug information from multiple sources",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python -m backend.pipeline                    # Full run
  python -m backend.pipeline --max-pw 10        # Limit PW scrapes to 10
  python -m backend.pipeline --skip-pw          # Skip PW, use TripSit only
  python -m backend.pipeline --delay 1.0        # 1 second between requests
  python -m backend.pipeline --output drugs.json  # Custom output file
        """
    )
    
    parser.add_argument(
        "--delay", "-d",
        type=float,
        default=0.5,
        help="Delay between HTTP requests in seconds (default: 0.5)"
    )
    
    parser.add_argument(
        "--max-pw", "-m",
        type=int,
        default=None,
        help="Maximum number of PsychonautWiki pages to scrape (default: all)"
    )
    
    parser.add_argument(
        "--skip-pw",
        action="store_true",
        help="Skip PsychonautWiki scraping entirely"
    )
    
    parser.add_argument(
        "--output", "-o",
        type=str,
        default=None,
        help="Output JSON file path"
    )
    
    parser.add_argument(
        "--quick", "-q",
        action="store_true",
        help="Quick mode: limit to 20 PW scrapes for testing"
    )
    
    args = parser.parse_args()
    
    # Quick mode overrides
    if args.quick:
        args.max_pw = 20
        print_info("Quick mode enabled: limiting to 20 PW scrapes")
    
    run_pipeline(
        scrape_delay=args.delay,
        max_pw_scrapes=args.max_pw,
        skip_pw_scraping=args.skip_pw,
        output_file=args.output
    )


if __name__ == "__main__":
    main()

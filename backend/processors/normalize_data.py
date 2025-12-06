import json
import os
import re
from bs4 import BeautifulSoup
from backend.utils.config import SCRAPED_DIR, CLEANED_DIR, timestamp
from backend.utils.logging_utils import log

os.makedirs(CLEANED_DIR, exist_ok=True)

# ----------------------------------------------------
# Helper: clean text
# ----------------------------------------------------
def clean_text(text: str):
    if not text:
        return None
    return re.sub(r"\s+", " ", text).strip()


# ----------------------------------------------------
# 1. Extract from PUBCHEM
# ----------------------------------------------------
def extract_pubchem(raw):
    try:
        c = raw["PC_Compounds"][0]

        props = c.get("props", [])
        half_life = None
        formula = None
        summary = None

        # Find formula
        for prop in props:
            if prop.get("urn", {}).get("label") == "Molecular Formula":
                formula = prop.get("value", {}).get("sval")

        # (PubChem doesn't always have half-life; extracted elsewhere)
        summary = clean_text(c.get("description", [{}])[0].get("value", ""))

        return {
            "half_life": half_life,
            "formula": formula,
            "summary": summary
        }
    except Exception as e:
        log.error(f"PubChem extract failed: {e}")
        return {}


# ----------------------------------------------------
# 2. Extract from PSYCHONAUTWIKI
# ----------------------------------------------------
def extract_psychonautwiki(raw):
    try:
        # Handle different raw formats
        if "html" in raw:
            html = raw["html"]
        elif "parse" in raw and "text" in raw["parse"]:
            html = raw["parse"]["text"]["*"]
        else:
            # Fallback: maybe raw IS the html string?
            html = str(raw)

        soup = BeautifulSoup(html, "lxml")

        # Effects list
        effects = []
        effects_section = soup.find("span", {"id": "Effects"})
        if effects_section:
            ul = effects_section.find_next("ul")
            if ul:
                effects = [clean_text(li.text) for li in ul.find_all("li")]

        # Tolerance section
        tolerance = None
        tol_section = soup.find("span", {"id": "Tolerance"})
        if tol_section:
            tolerance = clean_text(tol_section.find_next("p").text)

        # Common names / Aliases
        aliases = []
        # Look for "Common names" in table headers
        for th in soup.find_all("th"):
            header_text = th.get_text().lower()
            if "common names" in header_text:
                td = th.find_next("td")
                if td:
                    # Split by comma
                    text = clean_text(td.get_text())
                    if text:
                        # Remove citations like [1]
                        text = re.sub(r"\[\d+\]", "", text)
                        aliases = [a.strip() for a in text.split(",")]
                break

        # ROA Parsing
        roas = {}
        
        # Find all ROA tables (usually class "ROATable")
        # Note: The first table might be a disclaimer, so we check for headers
        tables = soup.find_all("table", class_="ROATable")
        
        for table in tables:
            # Try to find the ROA name in the header
            # Usually in a th with class ROAHeader
            header = table.find("th", class_="ROAHeader")
            if not header:
                continue
                
            roa_name = clean_text(header.get_text())
            # Remove arrow symbols like "⇣ "
            roa_name = re.sub(r"[^\w\s]", "", roa_name).strip().lower()
            
            if not roa_name or roa_name == "routes of administration":
                continue

            # Initialize ROA entry
            roas[roa_name] = {
                "dosage": {},
                "duration": {},
                "bioavailability": None
            }

            # Parse rows
            for row in table.find_all("tr"):
                # Check for Bioavailability
                if "Bioavailability" in row.get_text():
                    td = row.find("td")
                    if td:
                        roas[roa_name]["bioavailability"] = clean_text(td.get_text())
                    continue

                # Check for Dosage/Duration rows
                # Usually th class="ROARowHeader" contains the label (Common, Peak, etc.)
                # and td class="RowValues" contains the value
                th = row.find("th", class_="ROARowHeader")
                td = row.find("td", class_="RowValues")
                
                if th and td:
                    label = clean_text(th.get_text()).lower()
                    value = clean_text(td.get_text())
                    
                    # Map labels to categories
                    dose_keys = ["threshold", "light", "common", "strong", "heavy"]
                    dur_keys = ["total", "onset", "come_up", "peak", "offset", "after_effects"]
                    
                    # Normalize label for duration (e.g. "Come up" -> "come_up")
                    norm_label = label.replace(" ", "_").replace("-", "_")
                    
                    if label in dose_keys:
                        roas[roa_name]["dosage"][label] = value
                    elif norm_label in dur_keys:
                        roas[roa_name]["duration"][norm_label] = value
                    elif label == "total": # Ambiguous, usually duration in this context if not specified
                         roas[roa_name]["duration"]["total"] = value

        return {
            "effects": effects,
            "roas": roas,
            "tolerance": tolerance,
            "aliases": aliases
        }

    except Exception as e:
        log.error(f"PW extract failed: {e}")
        return {}


# ----------------------------------------------------
# 3. Extract from TRIPSIT
# ----------------------------------------------------
def extract_tripsit(raw):
    try:
        props = {}
        # Handle API format
        if "data" in raw and isinstance(raw["data"], list) and len(raw["data"]) > 0:
            props = raw["data"][0].get("properties", {})
        # Handle File format (direct dict)
        elif isinstance(raw, dict):
            # If 'properties' exists, use it, otherwise assume raw IS the properties
            props = raw.get("properties", raw)
        
        duration = props.get("duration", {})
        # Fallback for file format which might have formatted_duration
        if not duration and "formatted_duration" in raw:
             duration = raw["formatted_duration"]

        interaction = props.get("interactions", {})
        
        aliases = props.get("aliases", [])

        return {
            "duration_tripsit": duration,
            "interactions": interaction,
            "onset": props.get("onset"),
            "half_life": props.get("half_life"),
            "aliases": aliases
        }

    except Exception as e:
        log.error(f"TripSit extract failed: {e}")
        return {}


# ----------------------------------------------------
# 4. Extract from WIKIPEDIA
# ----------------------------------------------------
def extract_wikipedia(raw):
    try:
        pages = raw["query"]["pages"]
        page = next(iter(pages.values()))

        extract_text = clean_text(page.get("extract"))

        # no structured half-life here, only summary available
        return {
            "summary_wiki": extract_text
        }

    except Exception as e:
        log.error(f"Wikipedia extract failed: {e}")
        return {}


# ----------------------------------------------------
# MERGE SOURCES INTO FINAL STRUCTURE
# ----------------------------------------------------
def merge_sources(grouped):
    final = {}

    # Base structure
    final.update({
        "drug": grouped[0]["drug"],
        "summary": None,
        "half_life": None,
        "duration": {},
        "dosage": {},
        "roas": {},  # New field for Routes of Administration
        "tolerance": None,
        "effects": [],
        "interactions": {},
        "aliases": [], # New field for Aliases
        "sources": [],
        # Explicit source flags
        "source_tripsit": False,
        "source_psychonautwiki": False,
        "source_wikipedia": False,
        "source_pubchem": False
    })

    # Define priority: Low -> High (Last one wins/overwrites)
    # TripSit < Wikipedia < PubChem < PsychonautWiki
    priority_map = {
        "tripsit": 1,
        "tripsit_file": 1,
        "wikipedia": 2,
        "pubchem": 3,
        "psychonautwiki": 4
    }

    # Sort records by priority
    grouped.sort(key=lambda x: priority_map.get(x["source"], 0))

    for record in grouped:
        src = record["source"]
        raw = record["raw"]
        
        # Normalize source name for flags
        if src == "tripsit_file":
            src_key = "tripsit"
        else:
            src_key = src
            
        final["sources"].append(src_key)
        final[f"source_{src_key}"] = True

        if src == "pubchem":
            d = extract_pubchem(raw)
            final.update({k: v for k, v in d.items() if v})

        elif src == "psychonautwiki":
            d = extract_psychonautwiki(raw)
            # combine nested fields
            if "effects" in d:
                # PW effects are high quality, maybe we want to prefer them or extend?
                # If we want PW to be the authority, we might want to overwrite if it exists
                if d["effects"]:
                    final["effects"] = d["effects"] # Overwrite instead of extend to avoid duplicates/noise
            
            # New ROA handling
            if "roas" in d and d["roas"]:
                final["roas"] = d["roas"]
                
                # Optional: Populate top-level dosage/duration from "Oral" as default if available
                # This maintains some backward compatibility for simple views
                if "oral" in d["roas"]:
                    if d["roas"]["oral"].get("dosage"):
                        final["dosage"] = d["roas"]["oral"]["dosage"]
                    if d["roas"]["oral"].get("duration"):
                        final["duration"] = d["roas"]["oral"]["duration"]

            if d.get("tolerance"):
                final["tolerance"] = d["tolerance"]
            
            if d.get("aliases"):
                final["aliases"].extend(d["aliases"])

        elif src in ["tripsit", "tripsit_file"]:
            d = extract_tripsit(raw)
            if "duration_tripsit" in d and d["duration_tripsit"]:
                dur = d["duration_tripsit"]
                if isinstance(dur, dict):
                    # Only update if we don't have better data from PW (which might be in ROAs now)
                    # But since we process PW last, PW will overwrite if we set it above.
                    # If PW didn't set top-level duration, we use TripSit.
                    final["duration"].update(dur)
                elif isinstance(dur, str):
                    # If it's a string, maybe put it under "total" if not present
                    if "total" not in final["duration"]:
                        final["duration"]["total"] = dur
                        
            if "interactions" in d:
                final["interactions"].update(d["interactions"])
            if d.get("half_life") and not final["half_life"]:
                final["half_life"] = d["half_life"]
            
            if d.get("aliases"):
                final["aliases"].extend(d["aliases"])

        elif src == "wikipedia":
            d = extract_wikipedia(raw)
            if d.get("summary_wiki"):
                if not final["summary"]:
                    final["summary"] = d["summary_wiki"]

    # Dedupe sources list
    final["sources"] = list(set(final["sources"]))
    # Dedupe aliases
    final["aliases"] = list(set(final["aliases"]))

    return final


# ----------------------------------------------------
# MAIN NORMALIZER
# ----------------------------------------------------
def normalize_file():
    # Find latest JSON file, ignoring directories and merged files
    files = [f for f in os.listdir(SCRAPED_DIR) 
             if f.endswith(".json") 
             and f.startswith("raw_") 
             and "merged" not in f]
    
    if not files:
        log.error("No raw JSON files found in scraped directory.")
        raise FileNotFoundError("No raw JSON files found to normalize.")
        
    latest = sorted(files)[-1]
    path = os.path.join(SCRAPED_DIR, latest)

    print(f"📂 Loading raw data from: {path}")
    log.info(f"Normalizing file: {path}")
    with open(path, "r", encoding="utf-8") as f:
        raw_records = json.load(f)

    # 1. Build Alias Map from TripSit (Starting Point)
    alias_map = {}
    print("🔍 Building alias map from TripSit data...")
    for r in raw_records:
        if r["source"] == "tripsit_file":
            drug_name = r["drug"].lower().strip()
            raw = r["raw"]
            # TripSit file format: raw is the dict
            props = raw.get("properties", raw)
            aliases = props.get("aliases", [])
            
            # Map aliases to this drug name
            for a in aliases:
                clean_alias = a.lower().strip()
                if clean_alias and clean_alias != drug_name:
                    # If conflict, first one wins (TripSit is starting point)
                    if clean_alias not in alias_map:
                        alias_map[clean_alias] = drug_name
    
    print(f"   Mapped {len(alias_map)} aliases.")

    # Group raw records by drug (case-insensitive)
    grouped = {}
    for r in raw_records:
        drug_key = r["drug"].lower().strip()
        
        # Resolve alias
        if drug_key in alias_map:
            canonical = alias_map[drug_key]
            # print(f"   Merging alias '{drug_key}' -> '{canonical}'")
            drug_key = canonical
            
        grouped.setdefault(drug_key, []).append(r)

    normalized = []
    total_drugs = len(grouped)
    print(f"🔄 Normalizing {total_drugs} unique drugs...")

    count = 0
    last_report = 0
    
    for drug, records in grouped.items():
        merged = merge_sources(records)
        normalized.append(merged)
        
        count += 1
        # Progress report every 100 items or 10%
        if count % 100 == 0 or count == total_drugs:
            print(f"   Progress: {count}/{total_drugs} drugs processed ({int(count/total_drugs*100)}%)")

    filename = os.path.join(CLEANED_DIR, f"normalized_{timestamp()}.json")
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(normalized, f, indent=4)

    print(f"✅ Normalization complete. Saved to {filename}")

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
        html = raw["parse"]["text"]["*"]
        soup = BeautifulSoup(html, "lxml")

        # Effects list
        effects = []
        effects_section = soup.find("span", {"id": "Effects"})
        if effects_section:
            ul = effects_section.find_next("ul")
            if ul:
                effects = [clean_text(li.text) for li in ul.find_all("li")]

        # Duration table
        duration_data = {}
        for label in ["Total", "Come-up", "Peak"]:
            th = soup.find("th", string=re.compile(label, re.I))
            if th:
                duration_data[label.lower().replace("-", "_")] = clean_text(
                    th.find_next("td").text
                )

        # Dosage ranges
        dosage = {}
        for dose_key in ["Threshold", "Light", "Common", "Strong", "Heavy"]:
            th = soup.find("th", string=re.compile(dose_key, re.I))
            if th:
                dosage[dose_key.lower()] = clean_text(
                    th.find_next("td").text
                )

        # Tolerance section
        tolerance = None
        tol_section = soup.find("span", {"id": "Tolerance"})
        if tol_section:
            tolerance = clean_text(tol_section.find_next("p").text)

        return {
            "effects": effects,
            "duration": duration_data,
            "dosage": dosage,
            "tolerance": tolerance
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

        return {
            "duration_tripsit": duration,
            "interactions": interaction,
            "onset": props.get("onset"),
            "half_life": props.get("half_life")
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
        "tolerance": None,
        "effects": [],
        "interactions": {},
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
            if "duration" in d and d["duration"]:
                final["duration"] = d["duration"] # Overwrite
            if "dosage" in d and d["dosage"]:
                final["dosage"] = d["dosage"] # Overwrite
            if d.get("tolerance"):
                final["tolerance"] = d["tolerance"]

        elif src in ["tripsit", "tripsit_file"]:
            d = extract_tripsit(raw)
            if "duration_tripsit" in d:
                # Only set if empty (PW takes precedence) or if we are iterating in order
                # Since we sort Low->High, PW comes later and will overwrite this if PW has data.
                final["duration"].update(d["duration_tripsit"])
            if "interactions" in d:
                final["interactions"].update(d["interactions"])
            if d.get("half_life") and not final["half_life"]:
                final["half_life"] = d["half_life"]

        elif src == "wikipedia":
            d = extract_wikipedia(raw)
            if d.get("summary_wiki"):
                if not final["summary"]:
                    final["summary"] = d["summary_wiki"]

    # Dedupe sources list
    final["sources"] = list(set(final["sources"]))

    return final


# ----------------------------------------------------
# MAIN NORMALIZER
# ----------------------------------------------------
def normalize_file():
    latest = sorted(os.listdir(SCRAPED_DIR))[-1]
    path = os.path.join(SCRAPED_DIR, latest)

    log.info(f"Normalizing file: {path}")
    with open(path, "r", encoding="utf-8") as f:
        raw_records = json.load(f)

    # Group raw records by drug
    grouped = {}
    for r in raw_records:
        grouped.setdefault(r["drug"], []).append(r)

    normalized = []

    for drug, records in grouped.items():
        merged = merge_sources(records)
        normalized.append(merged)

    filename = os.path.join(CLEANED_DIR, f"normalized_{timestamp()}.json")
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(normalized, f, indent=4)

    print(f"Normalized → {filename}")

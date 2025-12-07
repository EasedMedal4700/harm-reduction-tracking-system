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
# Helper: clean effect list
# ----------------------------------------------------
def clean_effect_list(effects):
    cleaned = []
    for e in effects:
        if not e:
            continue

        stripped = e.strip()

        # remove single letters (very common PW scrape bug)
        if re.fullmatch(r"[A-Za-z]", stripped):
            continue

        # remove punctuation-only items
        if stripped in [".", ",", ";", ":", "-", "_", "(", ")", "[", "]"]:
            continue

        # remove Wikipedia artifacts
        if "wikipedia" in stripped.lower():
            continue

        # remove citation leftovers
        if "citation needed" in stripped.lower():
            continue

        # too short (noise)
        if len(stripped) <= 2:
            continue

        # too long (usually broken multi-paragraph PW text)
        if len(stripped) > 200:
            continue

        cleaned.append(stripped)

    # dedupe while keeping order
    return list(dict.fromkeys(cleaned))

def clean_alias_list(aliases):
    cleaned = []
    for a in aliases:
        if not a: 
            continue

        a = a.strip()

        # remove too short items
        if len(a) < 2: 
            continue

        # remove noise phrases from PW
        if "more names" in a.lower():
            continue
        if "slang" in a.lower():
            continue
        if "wikipedia" in a.lower():
            continue

        cleaned.append(a)

    # case-insensitive deduplication while preserving order
    deduped = []
    seen_lower = set()

    for item in cleaned:
        low = item.lower()
        if low not in seen_lower:
            seen_lower.add(low)
            deduped.append(item)

    return deduped



# =====================================================================
# 1. PUBCHEM EXTRACTION (Half-life + Formula + Summary)
# =====================================================================
def extract_pubchem(raw):
    try:
        c = raw["PC_Compounds"][0]
        props = c.get("props", [])

        half_life = None
        formula = None
        summary = None

        # Molecular Formula
        for prop in props:
            if prop.get("urn", {}).get("label") == "Molecular Formula":
                formula = prop.get("value", {}).get("sval")

        # PubChem summary (not great but sometimes usable)
        summary = clean_text(
            c.get("description", [{}])[0].get("value", "")
        )

        # Some PubChem pages include  "Half-Life" under props
        for prop in props:
            label = prop.get("urn", {}).get("label", "").lower()
            if "half" in label:
                hv = prop.get("value", {}).get("sval")
                if hv:
                    # Extract numeric hours if possible
                    m = re.search(r"(\d+(\.\d+)?)", hv)
                    if m:
                        half_life = float(m.group(1))

        return {
            "half_life": half_life,
            "formula": formula,
            "summary_pubchem": summary
        }
    except Exception as e:
        log.error(f"PubChem extract failed: {e}")
        return {}



# =====================================================================
# 2. PSYCHONAUTWIKI EXTRACTION 
# -- Effects, Categories, Summary, Aliases, ROA, Marquis
# =====================================================================
def extract_psychonautwiki(raw):
    try:
        if "html" in raw:
            html = raw["html"]
        elif "parse" in raw and "text" in raw["parse"]:
            html = raw["parse"]["text"]["*"]
        else:
            html = str(raw)

        soup = BeautifulSoup(html, "lxml")

        # -------------------------
        #  Summary Extraction
        # -------------------------
        summary = None
        summary_p = soup.find("p")

        if summary_p:
            candidate = clean_text(summary_p.text)
            # Skip template junk
            if candidate and not candidate.lower().startswith("template"):
                summary = candidate

        # -------------------------
        #  Categories (sidebar)
        # -------------------------
        categories = []
        cat_div = soup.find("div", {"id": "mw-normal-catlinks"})
        if cat_div:
            for a in cat_div.find_all("a"):
                t = clean_text(a.text)
                if t and t.lower() != "categories":
                    categories.append(t)

        # -------------------------
        #  Effects (full table extraction)
        # -------------------------
        effects = []

        # All section IDs PW may use
        EFFECT_IDS = ["Effects", "Subjective_effects", "Subjective_effects_section"]

        for effect_id in EFFECT_IDS:
            effects_section = soup.find(id=effect_id)
            if not effects_section:
                continue

            # Find the FIRST UL that actually contains LI items
            ul = effects_section.find_next("ul")
            if ul and ul.find("li"):
                for li in ul.find_all("li"):
                    text = clean_text(li.get_text())
                    if text and len(text) > 1:   # avoid single-char garbage
                        effects.append(text)
            break  # Stop after first valid section

        # -------------------------
        # CLEANUP EFFECTS
        # -------------------------
        cleaned_effects = []
        for e in effects:
            if not e:
                continue

            stripped = e.strip()

            # Remove single characters or punctuation-only
            if len(stripped) <= 2:
                continue
            if stripped in [".", ",", "(", ")", "-", "_"]:
                continue

            # Remove huge paragraph blocks (bad PW scrape)
            if len(stripped) > 200:
                continue

            # Remove items that are just single letters (common PW bug)
            if re.match(r"^[A-Za-z]$", stripped):
                continue

            cleaned_effects.append(stripped)

        # Deduplicate final effects list
        effects = list(dict.fromkeys(cleaned_effects))

        # -------------------------
        # Aliases (common names)
        # -------------------------
        aliases = []
        for th in soup.find_all("th"):
            if "common name" in th.text.lower():
                td = th.find_next("td")
                if td:
                    text = re.sub(r"\[\d+\]", "", td.get_text())
                    aliases = [clean_text(a) for a in text.split(",")]

        # -------------------------
        # Marquis Reagent (optional)
        # -------------------------
        marquis = None
        for th in soup.find_all("th"):
            if "marquis" in th.text.lower():
                td = th.find_next("td")
                if td:
                    marquis = clean_text(td.text)

        # -------------------------
        # ROA Tables (your original code retained)
        # -------------------------
        roas = {}
        tables = soup.find_all("table", class_="ROATable")
        for table in tables:
            header = table.find("th", class_="ROAHeader")
            if not header:
                continue

            roa_name = clean_text(header.get_text()).lower()
            roa_name = re.sub(r"[^\w\s]", "", roa_name).strip()
            if not roa_name or roa_name == "routes of administration":
                continue

            roas[roa_name] = {
                "dosage": {},
                "duration": {},
                "bioavailability": None
            }

            for row in table.find_all("tr"):
                if "Bioavailability" in row.text:
                    td = row.find("td")
                    if td:
                        roas[roa_name]["bioavailability"] = clean_text(td.text)
                    continue

                th = row.find("th", class_="ROARowHeader")
                td = row.find("td", class_="RowValues")

                if th and td:
                    label = clean_text(th.text).lower()
                    value = clean_text(td.text)

                    dose_keys = ["threshold", "light", "common", "strong", "heavy"]
                    dur_keys = ["total", "onset", "come_up", "peak", "offset", "after_effects"]
                    norm = label.replace(" ", "_").replace("-", "_")

                    if label in dose_keys:
                        roas[roa_name]["dosage"][label] = value
                    elif norm in dur_keys:
                        roas[roa_name]["duration"][norm] = value

        return {
            "summary_pw": summary,
            "effects_pw": effects,
            "categories_pw": categories,
            "roas": roas,
            "aliases": aliases,
            "marquis": marquis
        }

    except Exception as e:
        log.error(f"PW extract failed: {e}")
        return {}



# =====================================================================
# 3. TRIPSIT EXTRACTION 
# =====================================================================
def extract_tripsit(raw):
    try:
        props = {}
        if "data" in raw:
            props = raw["data"][0].get("properties", {})
        else:
            props = raw.get("properties", raw)

        duration = props.get("duration", {})
        raw_effects = props.get("effects", [])
        effects = clean_effect_list(raw_effects)
        categories = props.get("categories", [])
        aliases = props.get("aliases", [])

        return {
            "duration_ts": duration,
            "effects_ts": effects,
            "categories_ts": categories,
            "interactions": props.get("interactions", {}),
            "half_life_ts": props.get("half_life"),
            "aliases_ts": aliases
        }

    except Exception as e:
        log.error(f"TripSit extract failed: {e}")
        return {}



# =====================================================================
# 4. WIKIPEDIA EXTRACTION
# =====================================================================
def extract_wikipedia(raw):
    try:
        pages = raw["query"]["pages"]
        page = next(iter(pages.values()))
        extract_text = clean_text(page.get("extract"))
        return {"summary_wiki": extract_text}
    except:
        return {}



# =====================================================================
# MERGING LOGIC (ENRICHED)
# =====================================================================
def merge_sources(grouped):
    final = {
        "drug": grouped[0]["drug"],
        "summary": None,
        "categories": [],
        "half_life": None,
        "duration": {},
        "dosage": {},
        "roas": {},
        "tolerance": None,
        "effects": [],
        "interactions": {},
        "aliases": [],
        "marquis": None,
        "sources": [],
        "source_tripsit": False,
        "source_psychonautwiki": False,
        "source_wikipedia": False,
        "source_pubchem": False
    }

    # Priority
    priority = {"tripsit": 1, "tripsit_file": 1, "wikipedia": 2,
                "pubchem": 3, "psychonautwiki": 4}
    grouped.sort(key=lambda r: priority.get(r["source"], 0))

    for r in grouped:
        src = r["source"]
        raw = r["raw"]
        key = "tripsit" if src == "tripsit_file" else src
        final["sources"].append(key)
        final[f"source_{key}"] = True

        # -------------------------
        # PubChem
        # -------------------------
        if key == "pubchem":
            d = extract_pubchem(raw)
            if d.get("formula"): final["formula"] = d["formula"]
            if d.get("summary_pubchem") and not final["summary"]:
                final["summary"] = d["summary_pubchem"]
            if d.get("half_life") and not final["half_life"]:
                final["half_life"] = d["half_life"]

        # -------------------------
        # PsychonautWiki
        # -------------------------
        elif key == "psychonautwiki":
            d = extract_psychonautwiki(raw)

            if d.get("summary_pw"):
                final["summary"] = d["summary_pw"]

            if d.get("categories_pw"):
                final["categories"].extend(d["categories_pw"])

            if d.get("effects_pw"):
                final["effects"] = list(set(final["effects"]) | set(d["effects_pw"]))

            if d.get("marquis") and not final["marquis"]:
                final["marquis"] = d["marquis"]

            if "roas" in d and d["roas"]:
                final["roas"] = d["roas"]
                if "oral" in d["roas"]:
                    if d["roas"]["oral"].get("dosage"):
                        final["dosage"] = d["roas"]["oral"]["dosage"]
                    if d["roas"]["oral"].get("duration"):
                        final["duration"] = d["roas"]["oral"]["duration"]

            if d.get("aliases"):
                final["aliases"].extend(clean_alias_list(d["aliases"]))


        # -------------------------
        # TripSit
        # -------------------------
        elif key in ["tripsit", "tripsit_json", "tripsit_file"]:
            props = raw.get("properties", raw)

            # SUMMARY
            if props.get("summary") and not final["summary"]:
                final["summary"] = props["summary"]

            # DURATION
            if raw.get("formatted_duration"):
                dur = raw["formatted_duration"]
                final["duration"] = {
                    "total": f"{dur.get('value')}{dur.get('_unit', '')}"
                }
            elif props.get("duration"):
                final["duration"]["total"] = props["duration"]

            # ONSET
            if raw.get("formatted_onset"):
                onset = raw["formatted_onset"]
                final["duration"]["onset"] = f"{onset.get('value')}{onset.get('_unit', '')}"
            elif props.get("onset"):
                final["duration"]["onset"] = props["onset"]

            # AFTER-EFFECTS
            if raw.get("formatted_aftereffects"):
                ae = raw["formatted_aftereffects"]
                final["duration"]["after_effects"] = f"{ae.get('value')}{ae.get('_unit', '')}"
            elif props.get("after-effects"):
                final["duration"]["after_effects"] = props["after-effects"]

            # DOSAGE
            if raw.get("formatted_dose"):
                final["dosage"] = raw["formatted_dose"]
            elif props.get("dose"):
                final["dosage"]["raw"] = props["dose"]

            # EFFECTS
            if raw.get("formatted_effects"):
                final["effects"] += clean_effect_list(raw["formatted_effects"])
            elif props.get("effects"):
                final["effects"] += clean_effect_list(props["effects"])

            # CATEGORIES
            if raw.get("categories"):
                final["categories"] += raw["categories"]
            if props.get("categories"):
                final["categories"] += props["categories"]

            # ALIASES
            if raw.get("aliases"):
                final["aliases"].extend(clean_alias_list(raw["aliases"]))

            if props.get("aliases"):
                final["aliases"].extend(clean_alias_list(props["aliases"]))

            # INTERACTIONS (TripSit `avoid:` is very important)
            if props.get("avoid"):
                final["interactions"]["avoid"] = props["avoid"]
            if props.get("interactions"):
                final["interactions"].update(props["interactions"])


        # -------------------------
        # Wikipedia
        # -------------------------
        elif key == "wikipedia":
            d = extract_wikipedia(raw)
            if d.get("summary_wiki") and not final["summary"]:
                final["summary"] = d["summary_wiki"]

    # Clean up duplicates and noise
    final["effects"] = clean_effect_list(final["effects"])
    final["aliases"] = clean_alias_list(final["aliases"])
    final["categories"] = sorted(list(set([c for c in final["categories"] if c])))
    final["sources"] = sorted(list(set(final["sources"])))

    return final




# =====================================================================
# MAIN NORMALIZATION TASK
# =====================================================================
def normalize_file():
    files = [
        f for f in os.listdir(SCRAPED_DIR)
        if f.endswith(".json") and f.startswith("raw_") and "merged" not in f
    ]
    if not files:
        raise FileNotFoundError("No raw files found.")

    latest = sorted(files)[-1]
    print(f"📂 Loading raw data from {latest}")

    with open(os.path.join(SCRAPED_DIR, latest), "r", encoding="utf-8") as f:
        raw_records = json.load(f)

    # Alias map (TripSit)
    alias_map = {}
    for r in raw_records:
        if r["source"] == "tripsit_file":
            dname = r["drug"].lower()
            props = r["raw"].get("properties", r["raw"])
            for a in props.get("aliases", []):
                alias = a.lower().strip()
                if alias not in alias_map:
                    alias_map[alias] = dname

    # Group by canonical key
    grouped = {}
    for r in raw_records:
        key = r["drug"].lower()
        if key in alias_map:
            key = alias_map[key]
        grouped.setdefault(key, []).append(r)

    normalized = []
    for k, records in grouped.items():
        merged = merge_sources(records)
        normalized.append(merged)

    # Save
    out = os.path.join(CLEANED_DIR, f"normalized_{timestamp()}.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(normalized, f, indent=2)

    print(f"✅ Normalized dataset saved to {out}")

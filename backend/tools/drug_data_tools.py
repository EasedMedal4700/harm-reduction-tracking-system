import argparse
import json
import logging
import os
import re
from typing import Dict, List, Any, Tuple, Set

import requests
from bs4 import BeautifulSoup

# -------------------------------------------------------------------
# Logging setup
# -------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s] %(levelname)s: %(message)s",
)
log = logging.getLogger(__name__)

PW_INDEX_URL = "https://psychonautwiki.org/wiki/Psychoactive_substance_index"


# -------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------
def load_json(path: str) -> Any:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def save_json(path: str, obj: Any) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=2, ensure_ascii=False)


def clean_text(text: str | None) -> str | None:
    if not text:
        return None
    return re.sub(r"\s+", " ", text).strip()


# -------------------------------------------------------------------
# 1) TripSit loader + basic inspection
# -------------------------------------------------------------------
def load_tripsit_dataset(path: str) -> Dict[str, Dict[str, Any]]:
    """
    Expect TripSit-style dict: { "mdma": { ... }, "lsd": { ... }, ... }
    """
    data = load_json(path)
    if not isinstance(data, dict):
        raise ValueError("TripSit dataset should be a dict of slug -> record")
    return data


# -------------------------------------------------------------------
# 2) Duplicate alias detection
# -------------------------------------------------------------------
def collect_aliases(tripsit: Dict[str, Dict[str, Any]]) -> Dict[str, List[str]]:
    """
    Return: alias_lower -> [slug1, slug2, ...] where alias appears.
    """
    alias_map: Dict[str, List[str]] = {}

    for slug, rec in tripsit.items():
        aliases: Set[str] = set()

        # top-level aliases
        if isinstance(rec.get("aliases"), list):
            aliases.update([a for a in rec["aliases"] if isinstance(a, str)])

        # nested in properties.aliases
        props = rec.get("properties", {})
        if isinstance(props, dict) and isinstance(props.get("aliases"), list):
            aliases.update([a for a in props["aliases"] if isinstance(a, str)])

        for alias in aliases:
            norm = alias.strip().lower()
            if not norm:
                continue
            alias_map.setdefault(norm, []).append(slug)

    return alias_map


def find_duplicate_aliases(alias_map: Dict[str, List[str]]) -> Dict[str, List[str]]:
    return {alias: slugs for alias, slugs in alias_map.items() if len(slugs) > 1}


# -------------------------------------------------------------------
# 3) PsychonautWiki index scraping (for completeness check)
# -------------------------------------------------------------------
def fetch_psychonautwiki_index() -> List[str]:
    """
    Scrape the PW master substance index.
    """
    log.info("[PW Index] Fetching psychoactive substance index...")
    res = requests.get(PW_INDEX_URL, timeout=10)
    if res.status_code != 200:
        log.error("[PW Index] HTTP %s", res.status_code)
        return []

    soup = BeautifulSoup(res.text, "lxml")
    content = soup.find("div", {"id": "mw-content-text"})
    if not content:
        log.error("[PW Index] Could not find content block")
        return []

    drugs: Set[str] = set()

    for a in content.find_all("a", href=True):
        href = a["href"]
        if not href.startswith("/wiki/"):
            continue
        if ":" in href:
            continue  # skip special pages (categories, templates, etc.)

        name = a.get_text().strip()
        if len(name) < 2:
            continue

        drugs.add(name)

    out = sorted(drugs, key=lambda x: x.lower())
    log.info("[PW Index] Found %d unique substances in index", len(out))
    return out


# -------------------------------------------------------------------
# 4) Scraped raw file loader (from your existing pipeline)
# -------------------------------------------------------------------
def load_scraped_raw(path: str) -> List[Dict[str, Any]]:
    """
    Expect list of records:
    { "drug": "MDMA", "source": "psychonautwiki", "raw": {...}, ... }
    """
    data = load_json(path)
    if not isinstance(data, list):
        raise ValueError("Scraped raw file must be a list")
    return data


def group_scraped_by_drug(scraped: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
    grouped: Dict[str, List[Dict[str, Any]]] = {}
    for r in scraped:
        drug = r.get("drug")
        if not isinstance(drug, str):
            continue
        grouped.setdefault(drug.lower(), []).append(r)
    return grouped


# -------------------------------------------------------------------
# 5) Extractors for PW + Wikipedia (reusing your logic)
# -------------------------------------------------------------------
def extract_psychonautwiki(raw: Dict[str, Any]) -> Dict[str, Any]:
    try:
        html = raw["parse"]["text"]["*"]
        soup = BeautifulSoup(html, "lxml")

        # Effects list
        effects: List[str] = []
        effects_section = soup.find("span", {"id": "Effects"})
        if effects_section:
            ul = effects_section.find_next("ul")
            if ul:
                effects = [clean_text(li.text) for li in ul.find_all("li") if clean_text(li.text)]

        # Duration table
        duration_data: Dict[str, str] = {}
        for label in ["Total", "Come-up", "Peak"]:
            th = soup.find("th", string=re.compile(label, re.I))
            if th:
                duration_data[label.lower().replace("-", "_")] = clean_text(
                    th.find_next("td").text
                )

        # Dosage ranges
        dosage: Dict[str, str] = {}
        for dose_key in ["Threshold", "Light", "Common", "Strong", "Heavy"]:
            th = soup.find("th", string=re.compile(dose_key, re.I))
            if th:
                dosage[dose_key.lower()] = clean_text(th.find_next("td").text)

        # Tolerance section
        tolerance = None
        tol_section = soup.find("span", {"id": "Tolerance"})
        if tol_section:
            tolerance = clean_text(tol_section.find_next("p").text)

        return {
            "effects_pw": effects,
            "duration_pw": duration_data,
            "dosage_pw": dosage,
            "tolerance_pw": tolerance,
        }
    except Exception as e:
        log.error(f"[PW] Extract failed: {e}")
        return {}


def extract_wikipedia(raw: Dict[str, Any]) -> Dict[str, Any]:
    try:
        pages = raw["query"]["pages"]
        page = next(iter(pages.values()))
        extract_text = clean_text(page.get("extract"))
        return {"summary_wiki": extract_text}
    except Exception as e:
        log.error(f"[Wikipedia] Extract failed: {e}")
        return {}


# -------------------------------------------------------------------
# 6) TripSit → clean schema normalizer
# -------------------------------------------------------------------
def normalize_tripsit_record(slug: str, rec: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create a cleaner, uniform schema for one TripSit record.
    We don't do heavy parsing, just organize fields in predictable places.
    """
    name = rec.get("pretty_name") or rec.get("name") or slug
    props = rec.get("properties", {}) if isinstance(rec.get("properties"), dict) else {}

    aliases = set()
    if isinstance(rec.get("aliases"), list):
        aliases.update([a for a in rec["aliases"] if isinstance(a, str)])
    if isinstance(props.get("aliases"), list):
        aliases.update([a for a in props["aliases"] if isinstance(a, str)])

    categories = set()
    if isinstance(rec.get("categories"), list):
        categories.update([c for c in rec["categories"] if isinstance(c, str)])
    if isinstance(props.get("categories"), list):
        categories.update([c for c in props["categories"] if isinstance(c, str)])

    summary = (
        props.get("summary")
        or rec.get("summary")
    )

    normalized = {
        "slug": slug,
        "name": name,
        "aliases": sorted(aliases),
        "categories": sorted(categories),
        "summary": summary,
        "dose": rec.get("formatted_dose") or props.get("dose"),
        "duration": rec.get("formatted_duration") or props.get("duration"),
        "onset": rec.get("formatted_onset") or props.get("onset"),
        "aftereffects": rec.get("formatted_aftereffects") or props.get("after-effects"),
        "effects": rec.get("formatted_effects") or props.get("effects"),
        "raw_properties": props,  # keep raw for now
    }

    return normalized


def normalize_tripsit_dataset(tripsit: Dict[str, Dict[str, Any]]) -> Dict[str, Dict[str, Any]]:
    return {slug: normalize_tripsit_record(slug, rec) for slug, rec in tripsit.items()}


# -------------------------------------------------------------------
# 7) Merge TripSit + PW + Wikipedia
# -------------------------------------------------------------------
def merge_sources_for_drug(
    base: Dict[str, Any],
    scraped_records: List[Dict[str, Any]] | None,
) -> Dict[str, Any]:
    """
    base: normalized TripSit record
    scraped_records: list of { drug, source, raw, ... } for this drug (may be None)
    """
    merged = dict(base)
    merged["sources"] = ["tripsit"]

    if not scraped_records:
        return merged

    pw_data: Dict[str, Any] = {}
    wiki_data: Dict[str, Any] = {}

    for r in scraped_records:
        src = r.get("source")
        raw = r.get("raw", {})

        if src == "psychonautwiki":
            pw_piece = extract_psychonautwiki(raw)
            for k, v in pw_piece.items():
                if not v:
                    continue
                pw_data[k] = v

        elif src == "wikipedia":
            wiki_piece = extract_wikipedia(raw)
            for k, v in wiki_piece.items():
                if not v:
                    continue
                wiki_data[k] = v

    # integrate PW into main
    if pw_data:
        merged["sources"].append("psychonautwiki")
        effects = merged.get("effects") or []
        if isinstance(effects, list):
            extra = pw_data.get("effects_pw") or []
            if isinstance(extra, list):
                merged["effects"] = effects + extra

        duration = merged.get("duration") or {}
        if isinstance(duration, dict):
            duration.update(pw_data.get("duration_pw") or {})
            merged["duration"] = duration

        dosage = merged.get("dose") or {}
        if isinstance(dosage, dict):
            # If Dose is already formatted_dose-like structure,
            # we don't overwrite, just add a field pw_dose separately
            merged.setdefault("dose_pw", pw_data.get("dosage_pw"))
        else:
            merged["dose_pw"] = pw_data.get("dosage_pw")

        if pw_data.get("tolerance_pw"):
            merged["tolerance"] = pw_data["tolerance_pw"]

    # integrate Wikipedia summary only if TripSit summary is missing
    if wiki_data:
        merged["sources"].append("wikipedia")
        if not merged.get("summary") and wiki_data.get("summary_wiki"):
            merged["summary"] = wiki_data["summary_wiki"]

    return merged


def merge_all_sources(
    tripsit_norm: Dict[str, Dict[str, Any]],
    scraped_grouped: Dict[str, List[Dict[str, Any]]],
) -> Dict[str, Dict[str, Any]]:
    merged: Dict[str, Dict[str, Any]] = {}
    for slug, base in tripsit_norm.items():
        recs = scraped_grouped.get(slug.lower())
        merged[slug] = merge_sources_for_drug(base, recs)
    return merged


# -------------------------------------------------------------------
# 8) Data quality report
# -------------------------------------------------------------------
def generate_quality_report(
    tripsit: Dict[str, Dict[str, Any]],
    tripsit_norm: Dict[str, Dict[str, Any]],
    alias_map: Dict[str, List[str]],
    duplicate_aliases: Dict[str, List[str]],
    pw_index: List[str],
    scraped_grouped: Dict[str, List[Dict[str, Any]]],
) -> Dict[str, Any]:
    tripsit_slugs = set(tripsit.keys())
    tripsit_names = {slug.lower() for slug in tripsit_slugs}

    pw_lower = {name.lower() for name in pw_index}
    missing_in_tripsit = sorted(pw_lower - tripsit_names)

    # coverage: how many tripsit drugs have PW/Wiki scraped
    with_pw = 0
    with_wiki = 0

    for slug in tripsit_slugs:
        recs = scraped_grouped.get(slug.lower(), [])
        has_pw = any(r.get("source") == "psychonautwiki" for r in recs)
        has_wiki = any(r.get("source") == "wikipedia" for r in recs)
        if has_pw:
            with_pw += 1
        if has_wiki:
            with_wiki += 1

    total = len(tripsit_slugs)
    report = {
        "counts": {
            "tripsit_total_drugs": total,
            "pw_index_total_drugs": len(pw_index),
            "alias_total_unique": len(alias_map),
            "alias_duplicates": len(duplicate_aliases),
        },
        "coverage": {
            "tripsit_with_pw_scrape": with_pw,
            "tripsit_with_pw_scrape_pct": (with_pw / total * 100) if total else 0.0,
            "tripsit_with_wiki_scrape": with_wiki,
            "tripsit_with_wiki_scrape_pct": (with_wiki / total * 100) if total else 0.0,
        },
        "duplicates": {
            "aliases": duplicate_aliases,  # alias_lower -> [slug1, slug2, ...]
        },
        "missing": {
            "drugs_in_pw_index_but_not_tripsit": missing_in_tripsit,
        },
    }

    return report


# -------------------------------------------------------------------
# 9) CLI
# -------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="Drug data tools: TripSit baseline, PW index, quality report, and merged dataset"
    )
    parser.add_argument(
        "--tripsit",
        required=True,
        help="Path to TripSit merged JSON (e.g., drugs_merged_20251205.json or drugs.json)",
    )
    parser.add_argument(
        "--scraped",
        required=True,
        help="Path to scraped raw JSON (e.g., data/scraped/raw_20251205.json)",
    )
    parser.add_argument(
        "--out-dir",
        required=True,
        help="Output directory for normalized and merged files",
    )

    args = parser.parse_args()

    tripsit_path = args.tripsit
    scraped_path = args.scraped
    out_dir = args.out_dir

    os.makedirs(out_dir, exist_ok=True)

    # 1) Load TripSit dataset
    log.info("Loading TripSit dataset from %s", tripsit_path)
    tripsit = load_tripsit_dataset(tripsit_path)

    # 2) Normalize TripSit
    log.info("Normalizing TripSit dataset...")
    tripsit_norm = normalize_tripsit_dataset(tripsit)
    tripsit_norm_path = os.path.join(out_dir, "tripsit_normalized.json")
    save_json(tripsit_norm_path, tripsit_norm)
    log.info("Saved normalized TripSit dataset → %s", tripsit_norm_path)

    # 3) Duplicate alias detection
    log.info("Detecting duplicate aliases...")
    alias_map = collect_aliases(tripsit)
    duplicate_aliases = find_duplicate_aliases(alias_map)
    log.info("Found %d aliases that map to multiple drugs", len(duplicate_aliases))

    # 4) Fetch PsychonautWiki index (for completeness)
    pw_index = fetch_psychonautwiki_index()

    # 5) Load scraped raw (PW + Wiki)
    log.info("Loading scraped raw data from %s", scraped_path)
    scraped_raw = load_scraped_raw(scraped_path)
    scraped_grouped = group_scraped_by_drug(scraped_raw)

    # 6) Merge TripSit baseline + PW + Wikipedia
    log.info("Merging TripSit baseline with PW + Wikipedia...")
    merged = merge_all_sources(tripsit_norm, scraped_grouped)
    merged_path = os.path.join(out_dir, "merged_enriched.json")
    save_json(merged_path, merged)
    log.info("Saved merged dataset → %s", merged_path)

    # 7) Data quality report
    log.info("Generating data quality report...")
    quality_report = generate_quality_report(
        tripsit,
        tripsit_norm,
        alias_map,
        duplicate_aliases,
        pw_index,
        scraped_grouped,
    )
    quality_report_path = os.path.join(out_dir, "quality_report.json")
    save_json(quality_report_path, quality_report)
    log.info("Saved data quality report → %s", quality_report_path)

    log.info("Done.")


if __name__ == "__main__":
    main()

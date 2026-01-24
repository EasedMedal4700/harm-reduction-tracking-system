"""Find substances present in `drugs.json` but missing from `drug_tolerance_model/inspo.json`.

Run with the workspace virtualenv Python, for example:

  .venv\Scripts\python backend\ML\find_missing_substances.py

This prints up to `--count` missing substance keys and (optionally) a JSON template
you can paste into the inspo file.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import List, Optional
import random
import re


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def find_missing(drugs_path: Path, inspo_path: Path) -> List[str]:
    drugs = load_json(drugs_path)
    inspo = load_json(inspo_path)

    drugs_subs = set()
    inspo_subs = set()

    if isinstance(drugs, dict) and "substances" in drugs:
        drugs_subs = set(drugs["substances"].keys())
    else:
        drugs_subs = set(drugs.keys())

    if isinstance(inspo, dict) and "substances" in inspo:
        inspo_subs = set(inspo["substances"].keys())
    else:
        inspo_subs = set(inspo.keys())

    missing = sorted(drugs_subs - inspo_subs)
    return missing


def get_unit_for_substance(drugs: dict, name: str) -> Optional[str]:
    """Return the unit string for `name` from drugs dict or None.

    If multiple units are present (comma, slash, 'and'), pick the smallest
    using a simple scale map (kg > g > mg > mcg > ng).
    """
    entry = None
    if isinstance(drugs, dict) and "substances" in drugs:
        entry = drugs["substances"].get(name)
    else:
        entry = drugs.get(name) if isinstance(drugs, dict) else None

    if not entry:
        return None

    # Prefer units in `formatted_dose`, then `properties.dose`, then fall back
    # to any `standard_unit` or similar key.
    unit_val = None

    def extract_units_from_texts(texts):
        found = []
        if not texts:
            return found
        if isinstance(texts, str):
            texts = [texts]
        if isinstance(texts, dict):
            leaves = []
            def gather(d):
                if isinstance(d, str):
                    leaves.append(d)
                elif isinstance(d, dict):
                    for v in d.values():
                        gather(v)
                elif isinstance(d, list):
                    for v in d:
                        gather(v)
            gather(texts)
            texts = leaves
        for t in texts:
            if not isinstance(t, str):
                continue
            for m in re.findall(r"\b(mg|g|mcg|μg|ug|kg|ng|pg|ml|l)\b", t.lower()):
                found.append(m)
        return found

    # 1) formatted_dose
    candidates_from_formatted = extract_units_from_texts(entry.get("formatted_dose"))
    if candidates_from_formatted:
        unit_val = ",".join(candidates_from_formatted)

    # 2) properties.dose
    if not unit_val:
        prop_dose = entry.get("properties", {}).get("dose") if isinstance(entry.get("properties"), dict) else None
        candidates_from_props = extract_units_from_texts(prop_dose)
        if candidates_from_props:
            unit_val = ",".join(candidates_from_props)

    # 3) fallback to standard_unit or other direct unit fields
    if not unit_val:
        su = entry.get("standard_unit")
        if isinstance(su, dict):
            unit_val = su.get("unit") or su.get("units")
        elif isinstance(su, str):
            unit_val = su
        if not unit_val:
            for k in ("unit", "units", "standard_unit_unit"):
                v = entry.get(k)
                if isinstance(v, str) and v.strip():
                    unit_val = v
                    break

    if not unit_val:
        return None

    # split multiple candidates
    parts = re.split(r",|/|\band\b|\||;", unit_val)
    candidates = [p.strip().lower() for p in parts if p and p.strip()]

    # scale factors (larger factor => larger unit)
    scale = {
        "kg": 1e3,
        "g": 1.0,
        "mg": 1e-3,
        "mcg": 1e-6,
        "μg": 1e-6,
        "ug": 1e-6,
        "ng": 1e-9,
        "pg": 1e-12,
    }

    best = None
    best_factor = None
    for c in candidates:
        # try to extract unit token (strip numbers)
        token = re.sub(r"[\d\.\s]+", "", c)
        token = token.replace('\u03bcg', 'mcg')
        token = token.replace('μg', 'mcg')
        token = token.replace('ug', 'mcg')
        token = token.strip()
        if token in scale:
            factor = scale[token]
            if best_factor is None or factor < best_factor:
                best = token
                best_factor = factor
    if best:
        return best

    # fallback: return first candidate as-is
    return candidates[0] if candidates else None


def minimal_template_for(name: str) -> dict:
    return {
        name: {
            "notes": "(add notes)",
            "neuro_buckets": {},
            "half_life_hours": None,
            "active_threshold": None,
            "standard_unit": {"value": None, "unit": ""},
            "potency_multiplier": 1.0,
            "duration_multiplier": 1.0,
            "tolerance_gain_rate": 1.0,
            "tolerance_decay_days": None,
        }
    }


def main() -> None:
    p = argparse.ArgumentParser(description="Find substances missing from inspo.json")
    p.add_argument("--drugs", type=Path, default=Path(__file__).parent / "drugs.json")
    p.add_argument(
        "--inspo",
        type=Path,
        default=Path(__file__).parent / "drug_tolerance_model" / "inspo.json",
    )
    p.add_argument("--count", type=int, default=10, help="maximum number of missing substances to show")
    args = p.parse_args()

    if not args.drugs.exists():
        raise SystemExit(f"drugs file not found: {args.drugs}")
    if not args.inspo.exists():
        raise SystemExit(f"inspo file not found: {args.inspo}")

    missing = find_missing(args.drugs, args.inspo)
    if not missing:
        return

    sample_count = min(args.count, len(missing))
    sampled = random.sample(missing, k=sample_count)

    drugs_data = load_json(args.drugs)
    def extract_text_leaves(x):
        leaves = []
        def gather(v):
            if isinstance(v, str):
                leaves.append(v)
            elif isinstance(v, dict):
                for vv in v.values():
                    gather(vv)
            elif isinstance(v, list):
                for vv in v:
                    gather(vv)
        gather(x)
        return leaves

    def get_dose_for_substance(drugs_dict: dict, name: str) -> Optional[str]:
        entry = None
        if isinstance(drugs_dict, dict) and "substances" in drugs_dict:
            entry = drugs_dict["substances"].get(name)
        else:
            entry = drugs_dict.get(name) if isinstance(drugs_dict, dict) else None
        if not entry or not isinstance(entry, dict):
            return None

        # 1) Try formatted_dose: prefer Oral -> Common/Light/Strong
        fd = entry.get("formatted_dose")
        if fd:
            if isinstance(fd, dict):
                # prefer Oral
                if "Oral" in fd and isinstance(fd["Oral"], dict):
                    oral = fd["Oral"]
                    for key in ("Common", "common", "Light", "light", "Strong", "strong"):
                        if key in oral:
                            return f"Oral: {oral[key]}"
                    # fallback to first leaf in Oral
                    leaves = extract_text_leaves(oral)
                    if leaves:
                        return f"Oral: {leaves[0]}"
                # otherwise take first leaf from formatted_dose
                leaves = extract_text_leaves(fd)
                if leaves:
                    return leaves[0]
            elif isinstance(fd, str):
                return fd

        # 2) Try properties.dose
        props = entry.get("properties") or {}
        pd = props.get("dose") if isinstance(props, dict) else None
        if pd:
            if isinstance(pd, str):
                return pd
            leaves = extract_text_leaves(pd)
            if leaves:
                return leaves[0]

        # 3) Try standard_unit
        su = entry.get("standard_unit")
        if isinstance(su, dict):
            val = su.get("value")
            unit = su.get("unit")
            if val is not None and unit:
                return f"{val}{unit}"
        elif isinstance(su, str) and su.strip():
            return su

        return None

    for i, name in enumerate(sampled, start=1):
        unit = get_unit_for_substance(drugs_data, name)
        dose = get_dose_for_substance(drugs_data, name)
        parts = []
        if unit:
            parts.append(f"({unit})")
        if dose:
            parts.append(f"dose: {dose}")
        suffix = " " + " — ".join(parts) if parts else ""
        print(f"{i}. {name}{suffix}")


if __name__ == "__main__":
    main()

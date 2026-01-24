"""Check dosing coverage in `drugs.json`.

Reports total substances, count with dosing info, percent, and lists missing items.

Run with the workspace venv Python:
  .venv\Scripts\python backend\ML\check_dosing_coverage.py
"""
from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Dict, List


def load_json(path: Path) -> Dict:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


UNIT_RE = re.compile(r"\b(mg|g|mcg|μg|ug|kg|ng|pg|ml|l)\b", re.IGNORECASE)


def has_dose_info(entry: Dict) -> bool:
    # 1) formatted_dose
    fd = entry.get("formatted_dose")
    if fd:
        # search text leaves for unit tokens or numbers
        if find_units_in_leaf(fd):
            return True

    # 2) properties.dose
    props = entry.get("properties") or {}
    pd = props.get("dose") if isinstance(props, dict) else None
    if pd:
        if find_units_in_leaf(pd):
            return True

    # 3) standard_unit
    su = entry.get("standard_unit")
    if isinstance(su, dict):
        if su.get("unit") or su.get("value"):
            return True
    elif isinstance(su, str) and su.strip():
        return True

    return False


def find_units_in_leaf(data) -> bool:
    # collect string leaves and search for unit tokens or numeric dose patterns
    leaves: List[str] = []

    def gather(x):
        if isinstance(x, str):
            leaves.append(x)
        elif isinstance(x, dict):
            for v in x.values():
                gather(v)
        elif isinstance(x, list):
            for v in x:
                gather(v)

    gather(data)
    for s in leaves:
        if not s:
            continue
        if UNIT_RE.search(s):
            return True
        # also accept obvious numeric dose patterns like '10-20', '10mg' handled above
        if re.search(r"\d+\s*(?:-|to)\s*\d+", s):
            return True
        if re.search(r"\d+\s*(?:mg|g|mcg|μg|ug|ml|l)\b", s.lower()):
            return True
    return False


def main() -> None:
    base = Path(__file__).parent
    drugs_path = base / "drugs.json"

    drugs = load_json(drugs_path)
    if isinstance(drugs, dict) and "substances" in drugs:
        subs = drugs["substances"]
    else:
        subs = drugs

    total = 0
    with_dose = 0
    missing: List[str] = []

    for name, entry in subs.items():
        total += 1
        try:
            if has_dose_info(entry if isinstance(entry, dict) else {}):
                with_dose += 1
            else:
                missing.append(name)
        except Exception:
            missing.append(name)

    pct = (with_dose / total * 100) if total else 0.0

    print(f"Total substances: {total}")
    print(f"With dosing info: {with_dose} ({pct:.1f}%)")
    print(f"Missing dosing entries: {len(missing)}")
    if missing:
        limit = 100
        print("Sample missing entries (up to {0}):".format(limit))
        for n in missing[:limit]:
            print(n)


if __name__ == "__main__":
    main()

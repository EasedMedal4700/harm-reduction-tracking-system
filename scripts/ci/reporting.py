"""scripts/ci/reporting.py

Deterministic CI report writer.

Requirement:
- All CI steps/checkers write JSON to scripts/ci/reports/
- Each report contains: summary, details, total
- Output is deterministic (no timestamps / randomness)
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass
from typing import Any, Dict, List, Optional


def reports_dir(ci_dir: Optional[str] = None) -> str:
    base_dir = ci_dir or os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(base_dir, "reports")
    os.makedirs(path, exist_ok=True)
    return path


def write_report(*, name: str, success: bool, summary: Dict[str, Any], details: List[Dict[str, Any]]) -> str:
    """Write a deterministic report file and return its path."""

    # Deterministic sorting: callers should already provide stable ordering, but we
    # defensively sort by common keys if present.
    def _sort_key(item: Dict[str, Any]):
        return (
            str(item.get("file", "")),
            int(item.get("line", 0) or 0),
            str(item.get("rule", item.get("message", ""))),
        )

    details_sorted = sorted(details, key=_sort_key)

    report = {
        "name": name,
        "success": bool(success),
        "summary": dict(summary),
        "details": details_sorted,
        "total": int(summary.get("total", len(details_sorted))),
    }

    out_path = os.path.join(reports_dir(), f"{name}_report.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
        f.write("\n")

    return out_path

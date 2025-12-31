"""List the most uncovered files from coverage/lcov.info.

Usage:
  .\.venv\Scripts\python.exe scripts\tools\lcov_top_uncovered.py [N]

Prints files sorted by uncovered line count (LF-LH).
"""

from __future__ import annotations

import sys
from collections import defaultdict


def main() -> int:
    n = 30
    if len(sys.argv) > 1:
        try:
            n = int(sys.argv[1])
        except Exception:
            n = 30

    path = "coverage/lcov.info"

    totals: dict[str, list[int]] = defaultdict(lambda: [0, 0])  # SF -> [LF, LH]
    sf: str | None = None
    lf = 0
    lh = 0

    with open(path, "r", encoding="utf-8") as f:
        for raw in f:
            line = (raw or "").strip()
            if not line:
                continue

            if line.startswith("SF:"):
                sf = line[3:].strip().replace("\\", "/")
                lf = 0
                lh = 0
                continue

            if line.startswith("LF:"):
                try:
                    lf = int(line.split(":", 1)[1])
                except Exception:
                    lf = 0
                continue

            if line.startswith("LH:"):
                try:
                    lh = int(line.split(":", 1)[1])
                except Exception:
                    lh = 0
                continue

            if line == "end_of_record":
                if sf:
                    totals[sf][0] += lf
                    totals[sf][1] += lh
                sf = None
                lf = 0
                lh = 0

    items: list[tuple[int, int, int, str]] = []
    for k, (t, c) in totals.items():
        if t <= 0:
            continue
        items.append((t - c, t, c, k))

    items.sort(reverse=True)

    print("top uncovered by lines")
    for u, t, c, k in items[:n]:
        pct = (c / t * 100.0) if t else 0.0
        print(f"{u:6d} uncovered / {t:6d} total ({pct:5.1f}%)  {k}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

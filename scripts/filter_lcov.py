from pathlib import Path

INPUT = Path("coverage/lcov.info")
OUTPUT = Path("coverage/lcov_filtered.info")

EXCLUDE_PATTERNS = [
    ".g.dart",
    ".freezed.dart",
    ".mocks.dart",
    ".config.dart",
    ".riverpod.dart",
    ".provider.dart",
    "/lib/common/",
    "/lib/constants/",
]

def should_exclude(source_file: str) -> bool:
    source_file = source_file.replace("\\", "/")
    return any(p in source_file for p in EXCLUDE_PATTERNS)

def filter_lcov():
    if not INPUT.exists():
        raise FileNotFoundError(f"{INPUT} not found")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)

    with INPUT.open("r", encoding="utf-8") as f:
        blocks = f.read().split("end_of_record\n")

    kept = []

    for block in blocks:
        if not block.strip():
            continue

        sf_line = next(
            (line for line in block.splitlines() if line.startswith("SF:")),
            None,
        )

        if sf_line is None:
            continue

        source_file = sf_line[3:]

        if should_exclude(source_file):
            continue

        kept.append(block + "end_of_record\n")

    OUTPUT.write_text("".join(kept), encoding="utf-8")

    print(f"Filtered LCOV written to {OUTPUT}")
    print(f"Kept {len(kept)} coverage records")

if __name__ == "__main__":
    filter_lcov()

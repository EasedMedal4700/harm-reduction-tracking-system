import os
import re
import json
from pathlib import Path

# ----------------------------
# Paths
# ----------------------------
BASE_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = (BASE_DIR / ".." / ".." / "..").resolve()
FEATURES_DIR = PROJECT_ROOT / "lib" / "features"

OUTPUT_FILE = BASE_DIR / "reports" / "design_system_report.json"

# ----------------------------
# Allowlists (do NOT scan)
# ----------------------------
IGNORE_PATH_KEYWORDS = [
    "/theme/",
    "/constants/theme/",
    "/common/",
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
]

# ----------------------------
# Rule definitions
# ----------------------------
# severity: BLOCKING | WARNING
RULES = [
    # ---- BLOCKING: raw colors ----
    (r"Color\(0x[0-9a-fA-F]+\)", "Hardcoded Color literal", "BLOCKING"),
    (r"\bColors\.[a-zA-Z]+", "Hardcoded Flutter color", "BLOCKING"),

    # ---- BLOCKING: theme bypass ----
    (r"\bBrightness\.(light|dark)\b", "Hardcoded Brightness", "BLOCKING"),
    (r"\bThemeData\(", "ThemeData used inside feature", "BLOCKING"),

    # ---- WARNING: magic numbers ----
    (r"SizedBox\([^)]*\b\d+\.?\d*\b", "SizedBox with hardcoded value", "WARNING"),
    (r"\b(height|width|size|fontSize|iconSize)\s*:\s*\d+\.?\d*", "Hardcoded size value", "WARNING"),
    (r"\b(elevation|blurRadius|spreadRadius|strokeWidth)\s*:\s*\d+\.?\d*", "Hardcoded visual constant", "WARNING"),
    (r"\b(Duration|curveSmoothness|barWidth|stepHours)\b.*\d+", "Hardcoded timing/animation value", "WARNING"),
]

# ----------------------------
# Helpers
# ----------------------------
def should_ignore_file(path: Path) -> bool:
    path_str = str(path).replace("\\", "/")

    for keyword in IGNORE_PATH_KEYWORDS:
        if keyword in path_str:
            return True

    for pattern in IGNORE_FILE_PATTERNS:
        if re.match(pattern, path.name):
            return True

    return False


def scan_file(file_path: Path):
    issues = []

    try:
        lines = file_path.read_text(encoding="utf-8").splitlines()
    except Exception as e:
        return [{
            "severity": "ERROR",
            "message": str(e),
            "line": None,
            "snippet": None,
        }]

    for line_number, line in enumerate(lines, start=1):
        for pattern, description, severity in RULES:
            if re.search(pattern, line):
                issues.append({
                    "severity": severity,
                    "message": description,
                    "line": line_number,
                    "snippet": line.strip(),
                })

    # Deduplicate identical findings
    unique = {
        (i["severity"], i["message"], i["line"], i["snippet"]): i
        for i in issues
    }

    return list(unique.values())


# ----------------------------
# Main scan
# ----------------------------
def scan_features():
    report = {
        "summary": {
            "files_scanned": 0,
            "blocking_issues": 0,
            "warning_issues": 0,
        },
        "files": {},
    }

    for root, _, files in os.walk(FEATURES_DIR):
        for filename in files:
            if not filename.endswith(".dart"):
                continue

            file_path = Path(root) / filename

            if should_ignore_file(file_path):
                continue

            issues = scan_file(file_path)

            if issues:
                report["files"][str(file_path.relative_to(PROJECT_ROOT))] = issues

                for issue in issues:
                    if issue["severity"] == "BLOCKING":
                        report["summary"]["blocking_issues"] += 1
                    elif issue["severity"] == "WARNING":
                        report["summary"]["warning_issues"] += 1

            report["summary"]["files_scanned"] += 1

    return report


# ----------------------------
# Entry point
# ----------------------------
def main():
    report = scan_features()
    OUTPUT_FILE.write_text(json.dumps(report, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()

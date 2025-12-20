import os
import re
import json
from pathlib import Path

# ----------------------------
# Paths
# ----------------------------
BASE_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = (BASE_DIR / ".." / ".." / ".." / "..").resolve()
FEATURES_DIR = PROJECT_ROOT / "lib" / "features"

OUTPUT_FILE = BASE_DIR.parent / "reports" / "summaries" / "layout.json"

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
RULES = [
    # WARNING: magic numbers for layout
    (r"SizedBox\([^)]*\b\d+\.?\d*\b", "SizedBox with hardcoded value", "WARNING"),
    (r"\b(height|width|size|fontSize|iconSize)\s*:\s*\d+\.?\d*", "Hardcoded size value", "WARNING"),
    (r"\b(elevation|blurRadius|spreadRadius|strokeWidth)\s*:\s*\d+\.?\d*", "Hardcoded visual constant", "WARNING"),
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
    blocking_issues = 0
    warning_issues = 0
    files_affected = 0
    all_issues = []

    for root, _, files in os.walk(FEATURES_DIR):
        for filename in files:
            if not filename.endswith(".dart"):
                continue

            file_path = Path(root) / filename

            if should_ignore_file(file_path):
                continue

            issues = scan_file(file_path)

            if issues:
                files_affected += 1
                file_issues = []
                for issue in issues:
                    if issue["severity"] == "BLOCKING":
                        blocking_issues += 1
                    elif issue["severity"] == "WARNING":
                        warning_issues += 1
                    
                    # Add file path to issue
                    issue_with_file = issue.copy()
                    issue_with_file["file"] = str(file_path.relative_to(PROJECT_ROOT))
                    file_issues.append(issue_with_file)
                
                all_issues.extend(file_issues)

    status = "FAIL" if blocking_issues > 0 else "PASS"

    summary = {
        "check": "layout_constants",
        "status": status,
        "blocking_issues": blocking_issues,
        "warning_issues": warning_issues,
        "files_affected": files_affected
    }

    return summary, all_issues


# ----------------------------
# Entry point
# ----------------------------
def main():
    summary, all_issues = scan_features()

    # Ensure output directory exists
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    # Write summary
    OUTPUT_FILE.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    
    # Write detailed issues
    deep_file = OUTPUT_FILE.parent.parent / "details" / "layout_deep.json"
    deep_report = {
        "check": "layout_constants",
        "total_issues": len(all_issues),
        "issues": all_issues
    }
    deep_file.write_text(json.dumps(deep_report, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
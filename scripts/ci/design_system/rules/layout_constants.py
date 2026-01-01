"""
Layout Constants Rule - Design System Checker v1.1

Detects hardcoded layout, sizing, and visual constants that should come
from the design system (spacing, sizes, radii, elevations).
Severity is HYGIENE to avoid blocking CI while enforcing consistency.
"""

import re
from pathlib import Path
from typing import List
from models import Issue, RuleClass


# -----------------------------------------------------------------------------
# Allowlists (trusted sources)
# -----------------------------------------------------------------------------
IGNORE_PATH_KEYWORDS = [
    "/theme/",
    "/constants/theme/",
    "/common/",  # Common components are trusted
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
]


# -----------------------------------------------------------------------------
# Rules
# -----------------------------------------------------------------------------
RULES = [
    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded typography sizes
    # -------------------------------------------------------------------------
    (
        r"\b(fontSize|iconSize)\s*:\s*\d+\.?\d*",
        "Hardcoded size value - use design system size tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Visual constants that should be tokenized
    # -------------------------------------------------------------------------
    (
        r"\b(elevation|blurRadius|spreadRadius|strokeWidth)\s*:\s*\d+\.?\d*",
        "Hardcoded visual constant - use design system tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Border radius magic numbers
    # -------------------------------------------------------------------------
    (
        r"\bBorderRadius\.(circular|all)\s*\(\s*\d+\.?\d*\s*\)",
        "Hardcoded border radius - use design system radius tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: EdgeInsets magic numbers
    # (Excludes EdgeInsets.zero to avoid noise)
    # -------------------------------------------------------------------------
    (
        r"EdgeInsets\.(all|only|symmetric)\s*\([^)]*\d+\.?\d*",
        "Hardcoded padding/margin - use spacing tokens",
        RuleClass.HYGIENE,
    ),
]


# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
def should_ignore_file(path: Path) -> bool:
    """Check if file should be ignored based on path or filename patterns."""
    path_str = str(path).replace("\\", "/")

    for keyword in IGNORE_PATH_KEYWORDS:
        if keyword in path_str:
            return True

    for pattern in IGNORE_FILE_PATTERNS:
        if re.match(pattern, path.name):
            return True

    return False


# -----------------------------------------------------------------------------
# Rule runner
# -----------------------------------------------------------------------------
def run(files: List[Path]) -> List[Issue]:
    """
    Run layout constants checks on the given Dart files.

    Args:
        files: List of Dart files to check

    Returns:
        List of Issue objects for violations found
    """
    issues: List[Issue] = []

    for file_path in files:
        if should_ignore_file(file_path):
            continue

        try:
            lines = file_path.read_text(encoding="utf-8").splitlines()
        except Exception as e:
            issues.append(
                Issue(
                    rule="layout_constants",
                    rule_class=RuleClass.CORRECTNESS,
                    file=file_path,
                    line=0,
                    message=f"Could not read file: {str(e)}",
                    snippet="",
                    ignored=False,
                )
            )
            continue

        for line_number, line in enumerate(lines, start=1):
            for pattern, description, rule_class in RULES:
                if re.search(pattern, line):
                    issues.append(
                        Issue(
                            rule="layout_constants",
                            rule_class=rule_class,
                            file=file_path,
                            line=line_number,
                            message=description,
                            snippet=line.strip(),
                            ignored=False,
                        )
                    )

    # -------------------------------------------------------------------------
    # Deduplicate identical findings
    # -------------------------------------------------------------------------
    unique_issues: List[Issue] = []
    seen = set()

    for issue in issues:
        key = (
            issue.rule,
            issue.rule_class,
            issue.file,
            issue.line,
            issue.message,
            issue.snippet,
        )
        if key not in seen:
            seen.add(key)
            unique_issues.append(issue)

    return unique_issues

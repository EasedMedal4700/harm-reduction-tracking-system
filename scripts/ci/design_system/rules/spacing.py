"""
Spacing Rule - Design System Checker v1.1

Detects hardcoded spacing values (padding, margin, gaps, and spacing widgets)
that should come from the design system spacing tokens.
Severity: HYGIENE (non-blocking).
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
    "/common/",  # Common spacing widgets are trusted
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
    r".*spacing.*\.dart$",
    r".*dimensions.*\.dart$",
]


# -----------------------------------------------------------------------------
# Rules
# -----------------------------------------------------------------------------
RULES = [
    # -------------------------------------------------------------------------
    # HYGIENE: EdgeInsets with numeric values
    # -------------------------------------------------------------------------
    (
        r"EdgeInsets(\.all|\.only|\.symmetric)?\s*\([^)]*\d+\.?\d*",
        "Hardcoded EdgeInsets value - use spacing tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: EdgeInsetsDirectional with numeric values
    # -------------------------------------------------------------------------
    (
        r"EdgeInsetsDirectional(\.all|\.only|\.symmetric)?\s*\([^)]*\d+\.?\d*",
        "Hardcoded EdgeInsetsDirectional value - use spacing tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: SizedBox used purely for spacing
    # (width/height with numeric values)
    # -------------------------------------------------------------------------
    (
        r"SizedBox\s*\([^)]*(width|height)\s*:\s*\d+\.?\d*",
        "SizedBox used for spacing - use spacing tokens or spacer widgets",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Gap / spacing widgets with numeric literals
    # -------------------------------------------------------------------------
    (
        r"\b(gap|spacing)\s*:\s*\d+\.?\d*",
        "Hardcoded gap/spacing value - use spacing tokens",
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
    Run spacing checks on the given Dart files.

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
                    rule="spacing",
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
                            rule="spacing",
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

"""
Color and Theme Rule - Design System Checker v1.1

Detects hardcoded colors and improper theme usage.
Enforces use of the design system color tokens instead of raw values.
"""

import re
from pathlib import Path
from typing import List
from models import Issue, RuleClass


# -----------------------------------------------------------------------------
# Allowlists (do NOT scan)
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
    # DESIGN_SYSTEM: Hardcoded Color literals (ARGB / RGB)
    # -------------------------------------------------------------------------
    (
        r"Color\s*\(\s*0x[0-9a-fA-F]{6,8}\s*\)",
        "Hardcoded color literal - use design system colors",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Flutter built-in Colors.*
    # -------------------------------------------------------------------------
    (
        r"\bColors\.[a-zA-Z]+\b",
        "Hardcoded Flutter color - use design system colors",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Opacity applied directly to colors
    # Encourages semantic opacity tokens instead of magic values
    # -------------------------------------------------------------------------
    (
        r"\.withOpacity\s*\(\s*0?\.\d+\s*\)",
        "Hardcoded color opacity - use semantic opacity tokens",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Color.fromARGB / fromRGBO usage
    # -------------------------------------------------------------------------
    (
        r"Color\.from(A)?RGB(O)?\s*\(",
        "Hardcoded color construction - use design system colors",
        RuleClass.DESIGN_SYSTEM,
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
    Run color and theme checks on the given Dart files.

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
                    rule="color_and_theme",
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
                            rule="color_and_theme",
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

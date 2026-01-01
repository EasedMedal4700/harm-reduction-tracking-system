"""
Typography Rule - Design System Checker v1.1

Detects hardcoded typography values that should be sourced from the
design system (text styles, font tokens, and semantic typography).
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
    "/common/",  # Common text widgets/styles are trusted
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
    r".*typography.*\.dart$",
    r".*fonts.*\.dart$",
]


# -----------------------------------------------------------------------------
# Rules
# -----------------------------------------------------------------------------
RULES = [
    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded font family
    # -------------------------------------------------------------------------
    (
        r"\bfontFamily\s*:\s*['\"][^'\"]+['\"]",
        "Hardcoded font family - use design system typography tokens",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded font weight (numeric or enum)
    # -------------------------------------------------------------------------
    (
        r"\bFontWeight\.w\d+\b",
        "Hardcoded font weight - use semantic text styles",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded font size
    # -------------------------------------------------------------------------
    (
        r"\bfontSize\s*:\s*\d+\.?\d*",
        "Hardcoded font size - use semantic text styles",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded line height / height multiplier
    # -------------------------------------------------------------------------
    (
        r"\b(height|lineHeight)\s*:\s*\d+\.?\d*",
        "Hardcoded line height - use semantic text styles",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Hardcoded letter spacing
    # -------------------------------------------------------------------------
    (
        r"\bletterSpacing\s*:\s*-?\d+\.?\d*",
        "Hardcoded letter spacing - use semantic text styles",
        RuleClass.HYGIENE,
    ),

    # -------------------------------------------------------------------------
    # HYGIENE: Inline TextStyle usage (encourage theme usage)
    # -------------------------------------------------------------------------
    (
        r"\bTextStyle\s*\(",
        "Inline TextStyle detected - prefer theme or common text styles",
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
    Run typography checks on the given Dart files.

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
                    rule="typography",
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
                            rule="typography",
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

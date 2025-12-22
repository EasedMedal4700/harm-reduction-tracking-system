"""
Accessibility Rule - Design System Checker v1.1

Enforces explicit accessibility semantics for interactive UI elements.

Focus areas:
- Images without semantic labels
- Buttons with non-text children (spinner / icon)
- Buttons with conditional children
- Conditionally disabled buttons
- Interactive elements without semantics
- Hardcoded colors (contrast risk)
- Focus management awareness
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
    "/common/",  # Common components are trusted to handle accessibility
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
    r".*accessibility.*\.dart$",
]


# -----------------------------------------------------------------------------
# Accessibility rules
# Order matters: most specific rules first to avoid noisy duplicates
# -----------------------------------------------------------------------------
RULES = [
    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Images without semantic labels
    # -------------------------------------------------------------------------
    (
        r"\bImage\s*\([^)]*\)",
        "Image without semanticLabel for accessibility",
        RuleClass.DESIGN_SYSTEM,
    ),
    (
        r"\bImage\.[a-zA-Z]+\s*\([^)]*\)",
        "Image without semanticLabel for accessibility",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Buttons with NON-TEXT children (spinner / icon)
    # These lose meaning without explicit semantics
    # -------------------------------------------------------------------------
    (
        r"(ElevatedButton|TextButton|OutlinedButton)\s*\([^)]*(CircularProgressIndicator|Icon)\s*\(",
        "Button has non-text child and must define semanticLabel",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Buttons with CONDITIONAL children
    # Example: child: isLoading ? Spinner() : Text('Save')
    # -------------------------------------------------------------------------
    (
        r"(ElevatedButton|TextButton|OutlinedButton)\s*\([^)]*child\s*:\s*.*\?.*:",
        "Button has conditional child and must define semanticLabel",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Conditionally disabled buttons
    # Example: onPressed: isLoading ? null : ...
    # -------------------------------------------------------------------------
    (
        r"onPressed\s*:\s*.*\?\s*null\s*:",
        "Conditionally disabled button must expose semantic state",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Generic buttons without semantic labels (fallback rule)
    # -------------------------------------------------------------------------
    (
        r"(ElevatedButton|TextButton|OutlinedButton|IconButton)\s*\([^)]*child\s*:",
        "Button without semanticLabel",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Interactive containers without semantic labels
    # -------------------------------------------------------------------------
    (
        r"(GestureDetector|InkWell)\s*\([^)]*child\s*:",
        "Interactive element without semanticLabel",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Hardcoded colors (contrast risk)
    # -------------------------------------------------------------------------
    (
        r"Color\(0x[0-9a-fA-F]{8}\)",
        "Hardcoded color - verify contrast ratio",
        RuleClass.DESIGN_SYSTEM,
    ),

    # -------------------------------------------------------------------------
    # DESIGN_SYSTEM: Focus management awareness
    # -------------------------------------------------------------------------
    (
        r"FocusNode\s*\(\)",
        "FocusNode created - ensure proper focus management",
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
    Run accessibility checks on the given Dart files.

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
                    rule="accessibility",
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
                            rule="accessibility",
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

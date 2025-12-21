"""
Accessibility Rule - Design System Checker v1.0

Detects accessibility violations and missing accessibility features.
"""

import re
from pathlib import Path
from typing import List
from models import Issue, RuleClass


# Allowlists (do NOT scan)
IGNORE_PATH_KEYWORDS = [
    "/theme/",
    "/constants/theme/",
    "/common/",
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
    r".*accessibility.*\.dart$",
]

RULES = [
    # DESIGN_SYSTEM: Images without semantic labels
    (r"\bImage\s*\([^)]*\)", "Image without semanticLabel for accessibility", RuleClass.DESIGN_SYSTEM),
    (r"\bImage\.[a-zA-Z]+\s*\([^)]*\)", "Image without semanticLabel for accessibility", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: Buttons without semantic labels
    (r"(ElevatedButton|TextButton|OutlinedButton|IconButton)\s*\([^)]*child\s*:", "Button without semanticLabel", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: Missing accessibility labels on interactive elements
    (r"(GestureDetector|InkWell)\s*\([^)]*child\s*:", "Interactive element without semanticLabel", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: Hardcoded colors that might not meet contrast requirements
    (r"Color\(0x[0-9a-fA-F]{8}\)", "Hardcoded color - verify contrast ratio", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: Small touch targets - DISABLED due to high false positive rate (flags spacing/borders)
    # (r"\b(width|height)\s*:\s*([1-9]|[1-3][0-9]|4[0-3])(\.0*)?(?!\.?\d)", "Potentially small touch target (<44px)", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: Missing focus management
    (r"FocusNode\s*\(\)", "FocusNode created - ensure proper focus management", RuleClass.DESIGN_SYSTEM),
]


def should_ignore_file(path: Path) -> bool:
    """Check if file should be ignored based on path or name patterns"""
    path_str = str(path).replace("\\", "/")
    for keyword in IGNORE_PATH_KEYWORDS:
        if keyword in path_str:
            return True
    for pattern in IGNORE_FILE_PATTERNS:
        if re.match(pattern, path.name):
            return True
    return False


def run(files: List[Path]) -> List[Issue]:
    """
    Run accessibility checks on the given files.

    Args:
        files: List of Dart files to check

    Returns:
        List of Issue objects for violations found
    """
    issues = []

    for file_path in files:
        if should_ignore_file(file_path):
            continue

        try:
            lines = file_path.read_text(encoding="utf-8").splitlines()
        except Exception as e:
            # Create an error issue for unreadable files
            issues.append(Issue(
                rule="accessibility",
                rule_class=RuleClass.CORRECTNESS,
                file=file_path,
                line=0,
                message=f"Could not read file: {str(e)}",
                snippet="",
                ignored=False
            ))
            continue

        for line_number, line in enumerate(lines, start=1):
            for pattern, description, rule_class in RULES:
                if re.search(pattern, line):
                    issues.append(Issue(
                        rule="accessibility",
                        rule_class=rule_class,
                        file=file_path,
                        line=line_number,
                        message=description,
                        snippet=line.strip(),
                        ignored=False
                    ))

    # Deduplicate identical findings
    unique_issues = []
    seen = set()
    for issue in issues:
        key = (issue.rule, issue.rule_class, issue.file, issue.line, issue.message, issue.snippet)
        if key not in seen:
            seen.add(key)
            unique_issues.append(issue)

    return unique_issues
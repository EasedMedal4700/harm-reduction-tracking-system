"""
Spacing Rule - Design System Checker v1.0

Detects hardcoded spacing values (padding, margin, etc.).
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
    r".*spacing.*\.dart$",
    r".*dimensions.*\.dart$",
]

RULES = [
    # DESIGN_SYSTEM: hardcoded padding values
    (r"padding\s*:\s*(EdgeInsets|EdgeInsetsDirectional)\([^)]*\d+\.?\d*", "Hardcoded padding value", RuleClass.DESIGN_SYSTEM),
    (r"\bpadding(All|Symmetric|Only)\s*\(\s*\d+\.?\d*", "Hardcoded padding value", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: hardcoded margin values
    (r"margin\s*:\s*(EdgeInsets|EdgeInsetsDirectional)\([^)]*\d+\.?\d*", "Hardcoded margin value", RuleClass.DESIGN_SYSTEM),
    (r"\bmargin(All|Symmetric|Only)\s*\(\s*\d+\.?\d*", "Hardcoded margin value", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: hardcoded SizedBox for spacing
    (r"SizedBox\([^)]*\b\d+\.?\d*\b[^)]*\)", "SizedBox used for spacing (use theme spacing)", RuleClass.DESIGN_SYSTEM),

    # DESIGN_SYSTEM: hardcoded gap values in flex layouts
    (r"(mainAxisAlignment|crossAxisAlignment)\s*:\s*MainAxisAlignment\.", "Hardcoded alignment (consider theme)", RuleClass.DESIGN_SYSTEM),
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
    Run spacing checks on the given files.

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
                rule="spacing",
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
                        rule="spacing",
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
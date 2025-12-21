"""
Component Usage Rule - Design System Checker v1.0

Detects improper component usage patterns and design system violations.
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
    r".*components.*\.dart$",
    r".*widgets.*\.dart$",
]

RULES = [
    # DESIGN_SYSTEM: Using Container when SizedBox would be more appropriate
    (r"Container\s*\(\s*width\s*:\s*\d+\.?\d*\s*,\s*height\s*:\s*\d+\.?\d*\s*\)", "Use SizedBox for fixed dimensions", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Nested Material widgets
    (r"Material\s*\([^)]*child\s*:\s*Material\s*\(", "Nested Material widgets", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Using Column/Row without MainAxisAlignment
    (r"(Column|Row)\s*\(\s*children\s*:\s*\[", "Column/Row without alignment specified", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Hardcoded flex values
    (r"(flex|Flex)\s*:\s*\d+", "Hardcoded flex value", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Using Expanded without consideration
    (r"Expanded\s*\(\s*child\s*:\s*(Container|SizedBox)\s*\(\s*\)", "Expanded with empty container", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Icon without semantic label
    (r"Icon\s*\([^)]*Icons\.[a-zA-Z_]+[^)]*\)", "Icon without semanticLabel", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Card without proper elevation
    (r"Card\s*\(\s*child\s*:", "Card without explicit elevation", RuleClass.HYGIENE),

    # DESIGN_SYSTEM: Using Scaffold in nested widgets
    (r"Scaffold\s*\([^)]*body\s*:\s*(Column|Row|Container)", "Scaffold with simple layout - consider removing", RuleClass.DESIGN_SYSTEM),
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
    Run component usage checks on the given files.

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
                rule="component_usage",
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
                        rule="component_usage",
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
        key = (issue.rule, issue.severity, issue.file, issue.line, issue.message, issue.snippet)
        if key not in seen:
            seen.add(key)
            unique_issues.append(issue)

    return unique_issues
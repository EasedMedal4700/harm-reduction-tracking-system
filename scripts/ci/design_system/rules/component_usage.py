"""
Component Usage Rule - Design System Checker v1.0

Detects improper component usage patterns and design system violations.
"""

import re
from pathlib import Path
from typing import List
from models import Issue, Severity


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
    # WARNING: Using Container when SizedBox would be more appropriate
    (r"Container\s*\(\s*width\s*:\s*\d+\.?\d*\s*,\s*height\s*:\s*\d+\.?\d*\s*\)", "Use SizedBox for fixed dimensions", Severity.WARNING),

    # WARNING: Nested Material widgets
    (r"Material\s*\([^)]*child\s*:\s*Material\s*\(", "Nested Material widgets", Severity.WARNING),

    # WARNING: Using Column/Row without MainAxisAlignment
    (r"(Column|Row)\s*\(\s*children\s*:\s*\[", "Column/Row without alignment specified", Severity.WARNING),

    # WARNING: Hardcoded flex values
    (r"(flex|Flex)\s*:\s*\d+", "Hardcoded flex value", Severity.WARNING),

    # WARNING: Using Expanded without consideration
    (r"Expanded\s*\(\s*child\s*:\s*(Container|SizedBox)\s*\(\s*\)", "Expanded with empty container", Severity.WARNING),

    # WARNING: Icon without semantic label
    (r"Icon\s*\([^)]*Icons\.[a-zA-Z_]+[^)]*\)", "Icon without semanticLabel", Severity.WARNING),

    # WARNING: Card without proper elevation
    (r"Card\s*\(\s*child\s*:", "Card without explicit elevation", Severity.WARNING),

    # WARNING: Using Scaffold in nested widgets
    (r"Scaffold\s*\([^)]*body\s*:\s*(Column|Row|Container)", "Scaffold with simple layout - consider removing", Severity.WARNING),
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
                severity=Severity.BLOCKING,
                file=file_path,
                line=0,
                message=f"Could not read file: {str(e)}",
                snippet="",
                ignored=False
            ))
            continue

        for line_number, line in enumerate(lines, start=1):
            for pattern, description, severity in RULES:
                if re.search(pattern, line):
                    issues.append(Issue(
                        rule="component_usage",
                        severity=severity,
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
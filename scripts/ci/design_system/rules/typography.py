"""
Typography Rule - Design System Checker v1.0

Detects hardcoded typography values and font violations.
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
    r".*typography.*\.dart$",
    r".*fonts.*\.dart$",
]

RULES = [
    # BLOCKING: hardcoded font families
    (r"fontFamily\s*:\s*['\"][^'\"]*['\"]", "Hardcoded font family", Severity.BLOCKING),
    (r"FontWeight\.w\d+", "Hardcoded font weight", Severity.BLOCKING),

    # WARNING: hardcoded font sizes (should use theme)
    (r"fontSize\s*:\s*\d+\.?\d*", "Hardcoded font size", Severity.WARNING),
    (r"TextStyle\s*\([^)]*fontSize\s*:\s*\d+\.?\d*", "TextStyle with hardcoded font size", Severity.WARNING),

    # WARNING: hardcoded line heights
    (r"(height|lineHeight)\s*:\s*\d+\.?\d*", "Hardcoded line height", Severity.WARNING),
    (r"TextStyle\s*\([^)]*height\s*:\s*\d+\.?\d*", "TextStyle with hardcoded height", Severity.WARNING),

    # WARNING: hardcoded letter spacing
    (r"letterSpacing\s*:\s*[-]?\d+\.?\d*", "Hardcoded letter spacing", Severity.WARNING),
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
    Run typography checks on the given files.

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
                rule="typography",
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
                        rule="typography",
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
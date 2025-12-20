"""
Accessibility Rule - Design System Checker v1.0

Detects accessibility violations and missing accessibility features.
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
    r".*accessibility.*\.dart$",
]

RULES = [
    # BLOCKING: Images without semantic labels
    (r"Image\s*\([^)]*\)", "Image without semanticLabel for accessibility", Severity.BLOCKING),
    (r"Image\.[a-zA-Z]+\s*\([^)]*\)", "Image without semanticLabel for accessibility", Severity.BLOCKING),

    # WARNING: Buttons without semantic labels
    (r"(ElevatedButton|TextButton|OutlinedButton|IconButton)\s*\([^)]*child\s*:", "Button without semanticLabel", Severity.WARNING),

    # WARNING: Missing accessibility labels on interactive elements
    (r"(GestureDetector|InkWell)\s*\([^)]*child\s*:", "Interactive element without semanticLabel", Severity.WARNING),

    # WARNING: Hardcoded colors that might not meet contrast requirements
    (r"Color\(0x[0-9a-fA-F]{8}\)", "Hardcoded color - verify contrast ratio", Severity.WARNING),

    # WARNING: Small touch targets
    (r"(width|height)\s*:\s*([1-9]|[1-3][0-9]|4[0-3])(\.0*)?", "Potentially small touch target (<44px)", Severity.WARNING),

    # WARNING: Missing focus management
    (r"FocusNode\s*\(\)", "FocusNode created - ensure proper focus management", Severity.WARNING),
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
                    # Special handling for touch target size check
                    if "touch target" in description and re.search(r"(width|height)\s*:\s*([1-9]|[1-3][0-9]|4[0-3])(\.0*)?", line):
                        match = re.search(r"(width|height)\s*:\s*([1-9]|[1-3][0-9]|4[0-3])(\.0*)?", line)
                        if match:
                            value = float(match.group(2))
                            if value < 44:  # 44px is the minimum recommended touch target size
                                issues.append(Issue(
                                    rule="accessibility",
                                    severity=severity,
                                    file=file_path,
                                    line=line_number,
                                    message=f"{description} - found {value}px",
                                    snippet=line.strip(),
                                    ignored=False
                                ))
                    else:
                        issues.append(Issue(
                            rule="accessibility",
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
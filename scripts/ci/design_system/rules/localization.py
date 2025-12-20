"""
Localization Rule - Design System Checker v1.0

Detects hardcoded strings that should be localized.
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
    "/l10n/",  # Localization files
    "/localization/",
]

IGNORE_FILE_PATTERNS = [
    r".*config\.dart$",
    r".*theme.*\.dart$",
    r".*colors.*\.dart$",
    r".*localization.*\.dart$",
    r".*l10n.*\.dart$",
    r".*strings.*\.dart$",
    r".*translations.*\.dart$",
]

RULES = [
    # WARNING: hardcoded user-facing strings in Text widgets
    (r"Text\s*\(\s*['\"]([^'\"]{3,})['\"]", "Hardcoded string in Text widget", Severity.WARNING),

    # WARNING: hardcoded strings in button labels
    (r"(ElevatedButton|TextButton|OutlinedButton)\s*\([^)]*['\"]([^'\"]{3,})['\"]", "Hardcoded button text", Severity.WARNING),

    # WARNING: hardcoded strings in app bar titles
    (r"AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*['\"]([^'\"]{3,})['\"]", "Hardcoded app bar title", Severity.WARNING),

    # WARNING: hardcoded placeholder text
    (r"(hintText|labelText|helperText)\s*:\s*['\"]([^'\"]{3,})['\"]", "Hardcoded form field text", Severity.WARNING),

    # WARNING: hardcoded error messages
    (r"(errorText|errorMessage)\s*:\s*['\"]([^'\"]{3,})['\"]", "Hardcoded error message", Severity.WARNING),

    # WARNING: hardcoded snackbar messages
    (r"ScaffoldMessenger.*showSnackBar\s*\([^)]*['\"]([^'\"]{5,})['\"]", "Hardcoded snackbar message", Severity.WARNING),

    # WARNING: hardcoded dialog content
    (r"(AlertDialog|SimpleDialog)\s*\([^)]*(title|content)\s*:\s*Text\s*\(\s*['\"]([^'\"]{3,})['\"]", "Hardcoded dialog text", Severity.WARNING),
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


def _is_likely_code_or_config(text: str) -> bool:
    """Check if text is likely code/configuration rather than user-facing text"""
    # Skip very short strings (likely constants, keys, etc.)
    if len(text) < 3:
        return True

    # Skip strings that look like code (contain common programming patterns)
    code_patterns = [
        r'^[A-Z_]+$',  # ALL_CAPS constants
        r'^[a-z_]+$',  # snake_case variables
        r'^[a-zA-Z]+\.[a-zA-Z]+$',  # Class.property
        r'^\d+$',  # Numbers
        r'^#[0-9a-fA-F]+$',  # Hex colors
        r'^https?://',  # URLs
        r'^[a-zA-Z]{1,3}$',  # Very short abbreviations
    ]

    for pattern in code_patterns:
        if re.match(pattern, text):
            return True

    return False


def run(files: List[Path]) -> List[Issue]:
    """
    Run localization checks on the given files.

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
                rule="localization",
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
                matches = re.finditer(pattern, line)
                for match in matches:
                    # Extract the actual string content
                    if len(match.groups()) > 1:
                        text_content = match.group(2) if len(match.groups()) > 1 else match.group(1)
                    else:
                        text_content = match.group(1)

                    # Skip if it looks like code/configuration
                    if _is_likely_code_or_config(text_content):
                        continue

                    issues.append(Issue(
                        rule="localization",
                        severity=severity,
                        file=file_path,
                        line=line_number,
                        message=f"{description}: '{text_content}'",
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
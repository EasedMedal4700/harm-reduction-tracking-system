"""
Localization Rule - Design System Checker v1.1

Detects hardcoded user-facing strings that should be localized.
Focuses on UI text while avoiding configuration, keys, and constants.
"""

import re
from pathlib import Path
from typing import List
from models import Issue, RuleClass


# -----------------------------------------------------------------------------
# Allowlists (trusted / non-UI sources)
# -----------------------------------------------------------------------------
IGNORE_PATH_KEYWORDS = [
    "/theme/",
    "/constants/theme/",
    "/common/",
    "/l10n/",
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


# -----------------------------------------------------------------------------
# Rules
# -----------------------------------------------------------------------------
RULES = [
    # Text widgets
    (
        r"Text\s*\(\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded string in Text widget",
        RuleClass.HYGIENE,
    ),

    # Button labels
    (
        r"(ElevatedButton|TextButton|OutlinedButton)\s*\([^)]*Text\s*\(\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded button text",
        RuleClass.HYGIENE,
    ),

    # AppBar titles
    (
        r"AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded AppBar title",
        RuleClass.HYGIENE,
    ),

    # Form field text
    (
        r"\b(hintText|labelText|helperText)\s*:\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded form field text",
        RuleClass.HYGIENE,
    ),

    # Error messages
    (
        r"\b(errorText|errorMessage)\s*:\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded error message",
        RuleClass.HYGIENE,
    ),

    # Snackbars / toasts
    (
        r"showSnackBar\s*\([^)]*Text\s*\(\s*['\"]([^'\"]{5,})['\"]",
        "Hardcoded snackbar message",
        RuleClass.HYGIENE,
    ),

    # Dialog content (more user-visible → stricter)
    (
        r"(AlertDialog|SimpleDialog)\s*\([^)]*(title|content)\s*:\s*Text\s*\(\s*['\"]([^'\"]{3,})['\"]",
        "Hardcoded dialog text",
        RuleClass.DESIGN_SYSTEM,
    ),
]


# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
def should_ignore_file(path: Path) -> bool:
    path_str = str(path).replace("\\", "/")

    for keyword in IGNORE_PATH_KEYWORDS:
        if keyword in path_str:
            return True

    for pattern in IGNORE_FILE_PATTERNS:
        if re.match(pattern, path.name):
            return True

    return False


def _is_likely_non_user_text(text: str) -> bool:
    """Filter out constants, keys, and non-user-facing strings."""
    if len(text.strip()) < 3:
        return True

    non_user_patterns = [
        r'^[A-Z0-9_]+$',           # CONSTANT_KEYS
        r'^[a-z0-9_]+$',           # snake_case keys
        r'^[a-zA-Z]+\.[a-zA-Z]+$', # object.property
        r'^\d+$',                  # numbers
        r'^#[0-9a-fA-F]+$',        # hex
        r'^https?://',             # URLs
    ]

    for pattern in non_user_patterns:
        if re.match(pattern, text):
            return True

    return False


# -----------------------------------------------------------------------------
# Rule runner
# -----------------------------------------------------------------------------
def run(files: List[Path]) -> List[Issue]:
    issues: List[Issue] = []

    for file_path in files:
        if should_ignore_file(file_path):
            continue

        try:
            lines = file_path.read_text(encoding="utf-8").splitlines()
        except Exception as e:
            issues.append(
                Issue(
                    rule="localization",
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
                for match in re.finditer(pattern, line):
                    text_value = match.groups()[-1]

                    if _is_likely_non_user_text(text_value):
                        continue

                    issues.append(
                        Issue(
                            rule="localization",
                            rule_class=rule_class,
                            file=file_path,
                            line=line_number,
                            message=f"{description}: '{text_value}'",
                            snippet=line.strip(),
                            ignored=False,
                        )
                    )

    # Deduplicate
    unique_issues = []
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

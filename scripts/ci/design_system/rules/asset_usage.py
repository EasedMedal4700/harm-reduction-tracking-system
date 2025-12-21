"""
Asset Usage Rule - Design System Checker v1.0

Detects improper asset usage and hardcoded asset paths.
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
    r".*assets.*\.dart$",
    r".*asset_constants.*\.dart$",
]

RULES = [
    # ARCHITECTURE: hardcoded asset paths
    (r"['\"](assets/images/|assets/icons/|images/|icons/)", "Hardcoded asset path", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: missing asset loading checks
    (r"Image\.asset\s*\(\s*['\"]", "Image.asset without error handling", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: large images without proper sizing
    (r"Image\.(asset|network)\s*\([^)]*width\s*:\s*\d{4,}", "Very large image width specified", RuleClass.ARCHITECTURE),
    (r"Image\.(asset|network)\s*\([^)]*height\s*:\s*\d{4,}", "Very large image height specified", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: SVG without proper package usage
    (r"SvgPicture\.(asset|network)\s*\(\s*['\"]", "SVG usage - ensure flutter_svg package", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: font assets without proper declaration
    (r"fontFamily\s*:\s*['\"]([^'\"]*)\.ttf", "Font asset reference - ensure declared in pubspec.yaml", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: missing asset variants
    (r"Image\.asset\s*\([^)]*\.png", "PNG asset - consider WebP for better compression", RuleClass.ARCHITECTURE),
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
    Run asset usage checks on the given files.

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
                rule="asset_usage",
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
                        rule="asset_usage",
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
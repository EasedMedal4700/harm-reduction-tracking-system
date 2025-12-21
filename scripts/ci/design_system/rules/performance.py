"""
Performance Rule - Design System Checker v1.0

Detects performance anti-patterns and optimization opportunities.
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
    r".*performance.*\.dart$",
]

RULES = [
    # ARCHITECTURE: setState in build method
    (r"setState\s*\(\s*\(\)\s*=>\s*\{", "setState called in build method", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: ListView without proper optimization
    (r"ListView\s*\(\s*children\s*:\s*\[", "ListView with static children - consider ListView.builder", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: unnecessary rebuilds
    (r"StatefulWidget.*build.*setState", "Potential unnecessary rebuilds", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: large widget trees without keys
    (r"(Column|Row|Stack|Flex)\s*\(\s*children\s*:\s*[^)]*key\s*:", "Large layout without keys for performance", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: synchronous network calls
    (r"await\s+http\.(get|post|put|delete)", "Synchronous network call in async context", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: heavy computations in build
    (r"build.*\{[^}]*\b(for|while)\b", "Heavy computation in build method", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: missing const constructors
    (r"(Padding|Container|SizedBox|EdgeInsets)\s*\(\s*[^c]", "Missing const constructor", RuleClass.ARCHITECTURE),

    # ARCHITECTURE: large images without caching
    (r"Image\.network\s*\([^)]*cache", "Network image without caching strategy", RuleClass.ARCHITECTURE),
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
    Run performance checks on the given files.

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
                rule="performance",
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
                        rule="performance",
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
"""
Spacing Rule - Design System Checker v1.1

Detects hardcoded spacing values (padding, margin, gaps, and spacing widgets)
that should come from the design system spacing tokens.
Severity: HYGIENE (non-blocking).
"""

from pathlib import Path
from typing import List
from models import Issue, RuleClass
import re

# v1.2: Be precise.
# The previous regex flagged *any* EdgeInsets/SizedBox usage (even tokenized),
# causing massive false-positive noise. We now only flag explicit numeric
# literals used for spacing.

# EdgeInsets with direct numeric literals.
EDGEINSETS_ALL_NUMERIC = re.compile(
    r"EdgeInsets\.all\s*\(\s*(\d+\.?\d*)\s*\)",
    re.MULTILINE,
)
EDGEINSETS_SYMM_NUMERIC = re.compile(
    r"EdgeInsets\.symmetric\s*\([^)]*\b(horizontal|vertical)\s*:\s*(\d+\.?\d*)\b",
    re.MULTILINE,
)
EDGEINSETS_ONLY_NUMERIC = re.compile(
    r"EdgeInsets\.only\s*\([^)]*\b(left|top|right|bottom)\s*:\s*(\d+\.?\d*)\b",
    re.MULTILINE,
)

# SizedBox with direct numeric width/height.
SIZEDBOX_NUMERIC = re.compile(
    r"SizedBox\s*\([^)]*\b(width|height)\s*:\s*(\d+\.?\d*)\b",
    re.MULTILINE,
)

# Gap-like parameters with direct numeric literal (e.g., Wrap(spacing: 8)).
GAP_LITERAL = re.compile(r"\b(gap|spacing|runSpacing)\s*:\s*(\d+\.?\d*)\b")


IGNORE_PATH_KEYWORDS = [".g.dart", "build/", "generated/", "*.freezed.dart"]
IGNORE_FILE_PATTERNS: List[str] = [r"test_.*\.dart"]


def should_ignore_file(path: Path) -> bool:
    path_str = str(path).replace("\\", "/")
    for keyword in IGNORE_PATH_KEYWORDS:
        if keyword in path_str:
            return True
    for pattern in IGNORE_FILE_PATTERNS:
        if re.match(pattern, path.name):
            return True
    return False


def _report_match(issues: List[Issue], file_path: Path, text: str, m: re.Match, rule: str, msg: str):
    line_no = text[: m.start()].count("\n") + 1
    snippet = text.splitlines()[line_no - 1].strip() if line_no - 1 < len(text.splitlines()) else ""
    issues.append(
        Issue(
            rule=rule,
            rule_class=RuleClass.HYGIENE,
            file=file_path,
            line=line_no,
            message=msg,
            snippet=snippet,
            ignored=False,
        )
    )


def run(files: List[Path]) -> List[Issue]:
    issues: List[Issue] = []

    for file_path in files:
        if should_ignore_file(file_path):
            continue

        try:
            text = file_path.read_text(encoding="utf-8")
        except Exception:
            continue

        # Hardcoded spacing numeric literals.
        for m in EDGEINSETS_ALL_NUMERIC.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_literals",
                "Hardcoded spacing detected. Use design-system spacing tokens (e.g., prelude `sp` or `context.spacing`) instead of numeric literals.",
            )

        for m in EDGEINSETS_SYMM_NUMERIC.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_literals",
                "Hardcoded spacing detected. Use design-system spacing tokens (e.g., prelude `sp` or `context.spacing`) instead of numeric literals.",
            )

        for m in EDGEINSETS_ONLY_NUMERIC.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_literals",
                "Hardcoded spacing detected. Use design-system spacing tokens (e.g., prelude `sp` or `context.spacing`) instead of numeric literals.",
            )

        for m in SIZEDBOX_NUMERIC.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_literals",
                "Hardcoded spacing detected. Use design-system spacing tokens (e.g., prelude `sp` or `context.spacing`) instead of numeric literals.",
            )

        # Gap / spacing literal
        for m in GAP_LITERAL.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_literals",
                "Found direct gap/spacing numeric literal. Prefer using `sp` prelude token or `context.spacing` from the canonical prelude.",
            )

    # deduplicate
    unique: List[Issue] = []
    seen = set()
    for issue in issues:
        key = (issue.rule, issue.file, issue.line, issue.message, issue.snippet)
        if key not in seen:
            seen.add(key)
            unique.append(issue)

    return unique

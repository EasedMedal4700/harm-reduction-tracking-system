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
EDGEINSETS_PATTERN = re.compile(r"EdgeInsets\.(all|symmetric|only)\(|EdgeInsets\(|SizedBox\(|height:\s*\d+\.?\d*|width:\s*\d+\.?\d*")
GAP_LITERAL = re.compile(r"\b(gap|spacing)\s*:\s*\d+\.?\d*")

# Patterns for various forbidden spacing usages that should be migrated to the
# canonical `sp` prelude or `context.spacing` when using the canonical prelude.
PAT_T_DOT_SPACING = re.compile(r"\b\w+\.spacing\.\w+")
PAT_CONTEXT_THEME_SPACING = re.compile(r"\bcontext\.theme\.spacing\.\w+")
PAT_BARE_SPACING = re.compile(r"\bspacing\.\w+")
FORBIDDEN_SPACING_IDENT = re.compile(r"\b(final|var)\s+spacing\s*=")


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

        # Hardcoded EdgeInsets / SizedBox / numeric height/width
        for m in EDGEINSETS_PATTERN.finditer(text):
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
                "gap_literal",
                "Found direct gap/spacing numeric literal. Prefer using `sp` prelude token or `context.spacing` from the canonical prelude.",
            )

        # t.spacing.x or someVar.spacing.x (legacy token access)
        for m in PAT_T_DOT_SPACING.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "legacy_spacing_access",
                "Found legacy spacing access like `t.spacing.x`. Migrate to the canonical prelude `sp.x` or use `context.spacing` via the prelude.",
            )

        # context.theme.spacing.x usage
        for m in PAT_CONTEXT_THEME_SPACING.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "context_theme_spacing",
                "Found `context.theme.spacing.*` usage. Prefer `sp.*` or declare the canonical prelude and use `context.spacing`.",
            )

        # bare spacing.* usages
        for m in PAT_BARE_SPACING.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_identifier_usage",
                "Usage of `spacing.*` detected. Use the canonical shorthand `sp.*` per theme rules.",
            )

        # Declarations that name the spacing identifier `spacing` — recommend `sp`.
        for m in FORBIDDEN_SPACING_IDENT.finditer(text):
            _report_match(
                issues,
                file_path,
                text,
                m,
                "spacing_identifier_declaration",
                "Avoid declaring `spacing` as prelude identifier. Use `sp` as the canonical spacing shorthand.",
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

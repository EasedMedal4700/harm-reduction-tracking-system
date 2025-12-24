"""
Theme Wiring Rule - Design System Checker v1.1

Enforces the canonical theme prelude and approved identifiers from
`lib/constants/theme/theme_rules.md`.

Rules implemented:
- If a file uses >= 3 occurrences of `context.` it SHOULD declare the
  canonical prelude once at the top of `build()` (e.g. `final c = context.colors`).
- Disallow non-approved spacing identifier names such as `spacing`; prefer `sp`.
"""

from pathlib import Path
from typing import List
import re

from models import Issue, RuleClass


CANONICAL_PRELUDE = {"th", "c", "ac", "tx", "sp", "sh"}
RE_ASSIGN_REGEX = re.compile(r"\b(final|var)\s+(\w+)\s*=\s*context\.")


def run(files: List[Path]) -> List[Issue]:
    issues: List[Issue] = []

    for file_path in files:
        try:
            content = file_path.read_text(encoding="utf-8")
        except Exception as e:
            issues.append(
                Issue(
                    rule="theme_wiring",
                    rule_class=RuleClass.CORRECTNESS,
                    file=file_path,
                    line=0,
                    message=f"Could not read file: {e}",
                    snippet="",
                    ignored=False,
                )
            )
            continue

        # count usage of context.* accesses
        context_accesses = len(re.findall(r"\bcontext\.", content))

        # find assignments like: final c = context.colors
        assigned = set(m.group(2) for m in RE_ASSIGN_REGEX.finditer(content))

        # If many context accesses but no canonical prelude variables assigned,
        # report a hygiene issue encouraging the canonical prelude.
        if context_accesses >= 3 and not (assigned & CANONICAL_PRELUDE):
            # find first occurrence line for snippet
            first_line = 0
            for i, line in enumerate(content.splitlines(), start=1):
                if "context." in line:
                    first_line = i
                    snippet = line.strip()
                    break
            else:
                snippet = ""

            issues.append(
                Issue(
                    rule="theme_prelude",
                    rule_class=RuleClass.HYGIENE,
                    file=file_path,
                    line=first_line,
                    message=(
                        "Canonical theme prelude missing: for 3+ context accesses, "
                        "declare `final th = context.theme; final c = context.colors; "
                        "final tx = context.text; final sp = context.spacing;`"
                    ),
                    snippet=snippet,
                    ignored=False,
                )
            )

        # Disallow forbidden prelude identifier names (e.g., spacing)
        for m in RE_ASSIGN_REGEX.finditer(content):
            ident = m.group(2)
            if ident == "spacing":
                # determine line number
                line_no = content[: m.start()].count("\n") + 1
                issues.append(
                    Issue(
                        rule="theme_identifiers",
                        rule_class=RuleClass.HYGIENE,
                        file=file_path,
                        line=line_no,
                        message=(
                            "Use `sp` as the spacing shorthand instead of `spacing`. "
                            "Allowed prelude identifiers: th, c, ac, tx, sp, sh."
                        ),
                        snippet=content.splitlines()[line_no - 1].strip(),
                        ignored=False,
                    )
                )

    return issues
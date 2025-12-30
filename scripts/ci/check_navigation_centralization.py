"""scripts/ci/check_navigation_centralization.py

GOROUTER / NAVIGATION CHECKER (hard enforcement)

Purpose:
- Ensure navigation is fully centralized.
- Enforce that widgets do NOT navigate directly.

Hard failures (in lib/features/ and lib/common/):
- Any `Navigator.*` usage (push/pop/of/etc)
- Any GoRouter navigation calls:
  - context.go(...), context.push(...), context.pop(...), context.replace(...)
  - GoRouter.of(context)
- Any import of `package:go_router/go_router.dart`

Allowed:
- GoRouter/router wiring inside lib/core/** (this checker does not scan lib/core)

Ignores (required):
- Generated files: *.g.dart, *.freezed.dart, *.riverpod.dart
- Directories: build/, .dart_tool/, coverage/
- lib/constants/ (ignored)

Output:
- Deterministic, line-numbered violations
- Non-zero exit on failure
"""

from __future__ import annotations

import argparse
import os
import re
from dataclasses import dataclass
from typing import Iterable, List

from arch_scan_utils import find_project_root, iter_dart_files
from reporting import write_report


@dataclass(frozen=True)
class Violation:
    file_path: str
    line: int
    message: str
    snippet: str

    def render(self) -> str:
        snip = self.snippet.strip()
        return f"{self.file_path}:{self.line}: NAVIGATION: {self.message} | {snip}"


BANNED_LINE_PATTERNS = [
    (re.compile(r"\bNavigator\s*\.\s*(push|pushNamed|pushReplacement|pushAndRemoveUntil|pop|popUntil|maybePop)\b"), "Direct Navigator navigation is forbidden"),
    (re.compile(r"\bNavigator\s*\.\s*of\s*\("), "Navigator.of(context) is forbidden"),
    (re.compile(r"\bcontext\s*\.\s*(go|push|pop|replace|pushReplacement)\s*\("), "Direct GoRouter context navigation is forbidden"),
    (re.compile(r"\bGoRouter\s*\.\s*of\s*\("), "GoRouter.of(context) is forbidden in widgets"),
]

BANNED_IMPORT = re.compile(r"^\s*import\s+['\"]package:go_router/go_router\.dart['\"]\s*;\s*$")


def _is_enforced_path(abs_path: str) -> bool:
    norm = abs_path.replace("\\", "/")
    lower = norm.lower()

    # Enforce ONLY in lib/features and lib/common.
    return "/lib/features/" in lower or "/lib/common/" in lower


def _check_file(path: str) -> List[Violation]:
    with open(path, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()

    violations: List[Violation] = []

    for i, line in enumerate(lines, start=1):
        if BANNED_IMPORT.match(line):
            violations.append(Violation(path, i, "Importing go_router in features/common is forbidden (navigation must be centralized in lib/core)", line))

        for pattern, msg in BANNED_LINE_PATTERNS:
            if pattern.search(line):
                violations.append(Violation(path, i, msg, line))

    return violations


def main() -> int:
    parser = argparse.ArgumentParser(description="Hard enforcement of centralized navigation.")
    parser.add_argument("--root", default=None, help="Project root (defaults to auto-detected Flutter root)")
    args = parser.parse_args()

    project_root = args.root or find_project_root()
    lib_root = os.path.join(project_root, "lib")

    all_violations: List[Violation] = []

    for dart_file in iter_dart_files(lib_root):
        if not _is_enforced_path(dart_file.abs_path):
            continue
        all_violations.extend(_check_file(dart_file.abs_path))

    all_violations.sort(key=lambda v: (v.file_path.replace("\\", "/"), v.line, v.message))

    if all_violations:
        print("NAVIGATION CHECK FAILED")
        for v in all_violations:
            print(v.render())
        print(f"Total violations: {len(all_violations)}")

        write_report(
            name="navigation",
            success=False,
            summary={
                "total": int(len(all_violations)),
            },
            details=[
                {
                    "file": v.file_path.replace("\\", "/"),
                    "line": int(v.line),
                    "message": v.message,
                    "snippet": v.snippet.strip(),
                }
                for v in all_violations
            ],
        )
        return 1

    print("NAVIGATION CHECK PASSED")

    write_report(
        name="navigation",
        success=True,
        summary={
            "total": 0,
        },
        details=[],
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

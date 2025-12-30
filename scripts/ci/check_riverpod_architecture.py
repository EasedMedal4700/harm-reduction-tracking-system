"""scripts/ci/check_riverpod_architecture.py

RIVERPOD CHECKER (hard enforcement)

Purpose:
- Ensure Riverpod is the ONLY state management solution.

Hard failures:
- Anywhere in lib/ (excluding generated + lib/constants):
  - `package:provider/provider.dart` import
  - `Provider.of(` usage
  - Any `ChangeNotifier` usage

Additional hard failures in lib/features/:
- Any `setState(` usage
- Any widget extending `StatelessWidget` or `StatefulWidget`
  (Feature widgets must be ConsumerWidget / ConsumerStatefulWidget / HookConsumerWidget, etc.)

Additional hard failures in lib/features/ and lib/common/:
- Instantiating service-like classes directly (must be provided via providers/services):
  - `*Service(`, `*Repository(`, `*Client(`, `*Api(`, `*DataSource(` / `*Datasource(`

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
from typing import List

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
        return f"{self.file_path}:{self.line}: RIVERPOD: {self.message} | {snip}"


PROVIDER_IMPORT_RE = re.compile(r"^\s*import\s+['\"]package:provider/provider\.dart['\"]\s*;\s*$")
PROVIDER_OF_RE = re.compile(r"\bProvider\s*\.\s*of\s*\(")
CHANGENOTIFIER_RE = re.compile(r"\bChangeNotifier\b")

SETSTATE_RE = re.compile(r"\bsetState\s*\(")

FEATURE_WIDGET_BANNED_EXTENDS = [
    (re.compile(r"\bextends\s+StatelessWidget\b"), "Feature widgets must not extend StatelessWidget (use ConsumerWidget/HookConsumerWidget)"),
    (re.compile(r"\bextends\s+StatefulWidget\b"), "Feature widgets must not extend StatefulWidget (use ConsumerStatefulWidget/HookConsumerStatefulWidget)"),
]

SERVICE_INSTANTIATION_RE = re.compile(
    r"\b[A-Z][A-Za-z0-9_]*(Service|Repository|Client|Api|DataSource|Datasource)\s*\("
)


def _is_features(path: str) -> bool:
    return "/lib/features/" in path.replace("\\", "/").lower()


def _is_common(path: str) -> bool:
    return "/lib/common/" in path.replace("\\", "/").lower()


def _check_file(path: str) -> List[Violation]:
    with open(path, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()

    violations: List[Violation] = []

    for i, line in enumerate(lines, start=1):
        # No legacy provider package
        if PROVIDER_IMPORT_RE.match(line):
            violations.append(Violation(path, i, "Legacy Provider package is forbidden; use Riverpod only", line))
        if PROVIDER_OF_RE.search(line):
            violations.append(Violation(path, i, "Provider.of(context) is forbidden; use ref.watch/ref.read", line))

        # No ChangeNotifier anywhere
        if CHANGENOTIFIER_RE.search(line):
            violations.append(Violation(path, i, "ChangeNotifier is forbidden; use Riverpod Notifier/StateNotifier", line))

        # Feature-only bans
        if _is_features(path):
            if SETSTATE_RE.search(line):
                violations.append(Violation(path, i, "setState() is forbidden in lib/features (use Riverpod state)", line))

            for pattern, msg in FEATURE_WIDGET_BANNED_EXTENDS:
                if pattern.search(line):
                    violations.append(Violation(path, i, msg, line))

        # Service instantiation bans in UI layers
        if _is_features(path) or _is_common(path):
            if SERVICE_INSTANTIATION_RE.search(line):
                violations.append(Violation(path, i, "Service/repository/client instantiation is forbidden in widgets; use providers/services injected via Riverpod", line))

    return violations


def main() -> int:
    parser = argparse.ArgumentParser(description="Hard Riverpod-only enforcement.")
    parser.add_argument("--root", default=None, help="Project root (defaults to auto-detected Flutter root)")
    args = parser.parse_args()

    project_root = args.root or find_project_root()
    lib_root = os.path.join(project_root, "lib")

    all_violations: List[Violation] = []

    for dart_file in iter_dart_files(lib_root):
        all_violations.extend(_check_file(dart_file.abs_path))

    all_violations.sort(key=lambda v: (v.file_path.replace("\\", "/"), v.line, v.message))

    if all_violations:
        print("RIVERPOD CHECK FAILED")
        for v in all_violations:
            print(v.render())
        print(f"Total violations: {len(all_violations)}")

        write_report(
            name="riverpod",
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

    print("RIVERPOD CHECK PASSED")

    write_report(
        name="riverpod",
        success=True,
        summary={
            "total": 0,
        },
        details=[],
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

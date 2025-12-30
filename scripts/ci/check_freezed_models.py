from __future__ import annotations

import argparse
import os
import re
import sys
from dataclasses import dataclass
from typing import List, Optional

from arch_scan_utils import find_project_root, iter_dart_files
from reporting import write_report


# -----------------------------------------------------------------------------
# Data model
# -----------------------------------------------------------------------------

@dataclass(frozen=True)
class Violation:
    file_path: str
    line: int
    message: str

    def render(self) -> str:
        return f"{self.file_path}:{self.line}: FREEZED: {self.message}"


# -----------------------------------------------------------------------------
# File classification
# -----------------------------------------------------------------------------

_MODEL_PATH_SEGMENTS = ("/models/", "/model/")


def _is_model_file(abs_path: str) -> bool:
    norm = abs_path.replace("\\", "/").lower()
    base = os.path.basename(norm)

    if base.endswith("_model.dart"):
        return True

    return any(seg in norm for seg in _MODEL_PATH_SEGMENTS)


# -----------------------------------------------------------------------------
# Parsing helpers
# -----------------------------------------------------------------------------

_PART_RE = re.compile(r"^\s*part\s+['\"]([^'\"]+)['\"]\s*;\s*$")
_CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b")

_JSON_TOKENS = (
    "fromJson(",
    "toJson(",
    "@JsonKey",
    "@JsonSerializable",
    "_$",
)


def _read_lines(path: str) -> List[str]:
    with open(path, "r", encoding="utf-8") as f:
        return f.read().splitlines()


def _find_part_files(lines: List[str]) -> List[str]:
    parts: List[str] = []
    for line in lines:
        m = _PART_RE.match(line)
        if m:
            parts.append(m.group(1))
    return parts


def _find_line_index(lines: List[str], predicate) -> Optional[int]:
    for idx, line in enumerate(lines, start=1):
        if predicate(line):
            return idx
    return None


# -----------------------------------------------------------------------------
# Core checker logic
# -----------------------------------------------------------------------------

def _check_file(path: str) -> List[Violation]:
    violations: List[Violation] = []
    lines = _read_lines(path)
    full_text = "\n".join(lines)

    # ---- Detect usage ----
    has_freezed_annotation = any("@freezed" in line for line in lines)
    parts = _find_part_files(lines)

    has_freezed_part = any(p.endswith(".freezed.dart") for p in parts)
    has_g_part = any(p.endswith(".g.dart") for p in parts)

    uses_json = any(tok in full_text for tok in _JSON_TOKENS)

    # ---- File-level enforcement ----
    if not has_freezed_annotation:
        violations.append(
            Violation(path, 1, "Missing @freezed annotation in model file")
        )

    if not has_freezed_part:
        violations.append(
            Violation(path, 1, "Missing `part '*.freezed.dart';` in model file")
        )

    if uses_json and not has_g_part:
        violations.append(
            Violation(
                path,
                1,
                "Missing `part '*.g.dart';` for JSON-enabled Freezed model",
            )
        )

    # ---- Require at least one Freezed factory ----
    factory_line = _find_line_index(
        lines,
        lambda l: re.search(r"\b(const\s+)?factory\b", l) is not None,
    )
    if factory_line is None:
        violations.append(
            Violation(
                path,
                1,
                "Missing factory constructor (expected Freezed factory constructors)",
            )
        )

    # ---- Every class must be a Freezed class ----
    for idx, line in enumerate(lines, start=1):
        m = _CLASS_RE.match(line)
        if not m:
            continue

        class_name = m.group(1)

        if re.search(rf"\bwith\s+_\${class_name}\b", line) is None:
            violations.append(
                Violation(
                    path,
                    idx,
                    f"Class `{class_name}` is not a Freezed class "
                    f"(missing `with _${class_name}`)",
                )
            )

        # Check @freezed proximity (previous 5 non-empty, non-comment lines)
        window = []
        scan = idx - 1
        while scan >= 1 and len(window) < 5:
            prev = lines[scan - 1].strip()
            scan -= 1
            if not prev or prev.startswith("//"):
                continue
            window.append(prev)

        if not any("@freezed" in l for l in window):
            violations.append(
                Violation(
                    path,
                    idx,
                    f"Class `{class_name}` is not preceded by @freezed",
                )
            )

    # ---- Generated file existence ----
    folder = os.path.dirname(path)
    for part in parts:
        if part.endswith(".freezed.dart") or (uses_json and part.endswith(".g.dart")):
            part_abs = os.path.join(folder, part)
            if not os.path.exists(part_abs):
                violations.append(
                    Violation(
                        path,
                        1,
                        f"Missing generated part file on disk: {part}",
                    )
                )

    return violations


# -----------------------------------------------------------------------------
# Entrypoint
# -----------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Relaxed Freezed enforcement for model files."
    )
    parser.add_argument(
        "--root",
        default=None,
        help="Project root (defaults to auto-detected Flutter root)",
    )
    args = parser.parse_args()

    project_root = args.root or find_project_root()
    lib_root = os.path.join(project_root, "lib")

    all_violations: List[Violation] = []

    for dart_file in iter_dart_files(lib_root):
        if not _is_model_file(dart_file.abs_path):
            continue
        all_violations.extend(_check_file(dart_file.abs_path))

    all_violations.sort(
        key=lambda v: (v.file_path.replace("\\", "/"), v.line, v.message)
    )

    if all_violations:
        print("FREEZED CHECK FAILED")
        for v in all_violations:
            print(v.render())
        print(f"Total violations: {len(all_violations)}")

        write_report(
            name="freezed",
            success=False,
            summary={"total": len(all_violations)},
            details=[{
                "file": v.file_path.replace("\\", "/"),
                "line": v.line,
                "message": v.message,
            } for v in all_violations],
        )
        return 1

    print("FREEZED CHECK PASSED")

    write_report(
        name="freezed",
        success=True,
        summary={"total": 0},
        details=[],
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

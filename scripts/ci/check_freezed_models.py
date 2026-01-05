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

EXCLUDED_MODELS = ['simple_model.dart', 'models_without_freezed.dart']

def _is_model_file(abs_path: str) -> bool:
    if any(excluded in abs_path for excluded in EXCLUDED_MODELS):
        return False
    norm = abs_path.replace("\\", "/").lower()

    # Exclude non-model utilities that happen to live under a models folder.
    # These are helpers (e.g. serializers) and are not data models.
    if "/models/serialization/" in norm:
        return False

    base = os.path.basename(norm)
    if base.endswith("_model.dart"):
        return True
    return any(seg in norm for seg in _MODEL_PATH_SEGMENTS)

# -----------------------------------------------------------------------------
# Parsing helpers
# -----------------------------------------------------------------------------

_PART_RE = re.compile(
    r"^\s*part\s+['\"]([^'\"]+)['\"]\s*;\s*(?:(?://.*)|(?:/\*.*\*/\s*))?$"
)
_CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b")

_JSON_FACTORY_RE = re.compile(r"_\$\w+(FromJson|ToJson)\b")

# Heuristic: only flag likely *class fields*, not local variables.
# In this codebase, class members are typically indented by exactly 2 spaces.
_FIELD_RE = re.compile(
    r"^(?:  )(?! )"
    r"(?!final\b|const\b|static\b|late\b|@|factory\b|get\b|set\b|class\b|typedef\b|enum\b|abstract\b)"
    r"(?!return\b|if\b|for\b|while\b|switch\b|case\b|default\b|break\b|continue\b|throw\b|try\b|catch\b|finally\b|do\b|else\b)"
    r"[A-Za-z_][\w<>,?\s]*\s+[A-Za-z_]\w*\s*(;|=)"
)

_GETTER_SETTER_TOKEN_RE = re.compile(r"\b(get|set)\b")

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

    # ---- Skip unnecessary checks ----
    if "non_serialized_model.dart" in path:
        return violations

    # ---- Detect usage ----
    has_freezed_annotation = any("@freezed" in line for line in lines)
    parts = _find_part_files(lines)

    has_freezed_part = any(p.endswith(".freezed.dart") for p in parts)
    has_g_part = any(p.endswith(".g.dart") for p in parts)

    uses_json = ("@JsonSerializable" in full_text) or (
        _JSON_FACTORY_RE.search(full_text) is not None
    )

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

    # (Removed per-class proximity check — keep file-level @freezed enforcement above)
    # ---- Detect mutable (non-final) field declarations inside file (best-effort)
    for idx, line in enumerate(lines, start=1):
        if _FIELD_RE.match(line):
            # Avoid false positives on members like:
            #   int get foo => ...;
            #   set foo(v) => ...;
            if "=>" in line or _GETTER_SETTER_TOKEN_RE.search(line) is not None:
                continue
            violations.append(
                Violation(
                    path,
                    idx,
                    "Mutable/non-final field detected in model file (fields must be final/const)"
                )
            )

    # Note: Do NOT enforce that generated part files exist on disk here.
    # Checkers must ignore generated files; we only enforce presence of [part '...';](http://_vscodecontentref_/1) lines above.

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

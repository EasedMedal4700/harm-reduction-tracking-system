"""scripts/ci/arch_scan_utils.py

Shared, deterministic scanning utilities for architecture CI checkers.

These helpers are intentionally small and explicit:
- No heuristics, no randomness
- Stable ordering
- Common ignore rules across all architecture checkers

NOTE: This module is shared by multiple *separate* checkers. Each checker remains
single-responsibility; this file only handles walking files safely.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Iterable, Iterator, List, Optional


IGNORED_DIR_NAMES = {
    "build",
    ".dart_tool",
    "coverage",
}

IGNORED_FILE_SUFFIXES = (
    ".g.dart",
    ".freezed.dart",
    ".riverpod.dart",
)


@dataclass(frozen=True)
class DartFile:
    """A Dart source file with normalized path info."""

    abs_path: str

    @property
    def norm_path(self) -> str:
        # Use forward slashes for stable output across Windows/Linux.
        return self.abs_path.replace("\\", "/")

    @property
    def rel_to(self) -> Optional[str]:
        return None


def find_project_root(start_dir: Optional[str] = None) -> str:
    """Find Flutter project root by locating pubspec.yaml."""

    current = os.path.abspath(start_dir or os.getcwd())
    while True:
        if os.path.exists(os.path.join(current, "pubspec.yaml")):
            return current

        parent = os.path.dirname(current)
        if parent == current:
            # Reached filesystem root.
            break
        current = parent

    raise RuntimeError(f"Could not find pubspec.yaml from start_dir={start_dir or os.getcwd()}")


def is_ignored_dart_file(path: str) -> bool:
    lower = path.lower()
    return lower.endswith(IGNORED_FILE_SUFFIXES)


def iter_dart_files(lib_root: str) -> Iterator[DartFile]:
    """Yield Dart files under lib_root, applying required ignore rules.

    - Skips generated files: *.g.dart, *.freezed.dart, *.riverpod.dart
    - Skips build/, .dart_tool/, coverage/
    - Skips lib/constants/ entirely (per project requirements)

    Yields in deterministic sorted order (by normalized path).
    """

    lib_root = os.path.abspath(lib_root)

    collected: List[str] = []

    constants_root = os.path.join(lib_root, "constants")

    for root, dirs, files in os.walk(lib_root):
        # Deterministic traversal:
        dirs.sort()
        files.sort()

        # Skip ignored directories (in-place so os.walk doesn't descend).
        dirs[:] = [
            d
            for d in dirs
            if d not in IGNORED_DIR_NAMES
        ]

        # Skip lib/constants entirely (explicit, path-based).
        root_norm = os.path.abspath(root).lower()
        const_norm = os.path.abspath(constants_root).lower()
        if root_norm == const_norm or root_norm.startswith(const_norm + os.sep):
            dirs[:] = []
            continue

        for name in files:
            if not name.endswith(".dart"):
                continue
            abs_path = os.path.join(root, name)
            if is_ignored_dart_file(abs_path):
                continue
            collected.append(abs_path)

    for abs_path in sorted(collected, key=lambda p: p.replace("\\", "/")):
        yield DartFile(abs_path=os.path.abspath(abs_path))

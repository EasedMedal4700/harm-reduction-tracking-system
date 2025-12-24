#!/usr/bin/env python3
"""Codemod: standardize theme prelude identifiers.

Goal:
- Enforce canonical prelude identifiers used throughout the codebase:
  th, c, ac, tx, sp, sh (+ optional an, sz, op, bd, sf)

This script does conservative, text-based refactors:
- Renames `final/var <ident> = context.<prop>;` to the canonical identifier for `<prop>`.
- Rewrites `<old>.` member accesses to `<new>.` when the declaration was renamed.
- Rewrites `context.<prop>.` to `<canonical>.` when the canonical declaration exists in the file.

It intentionally does NOT attempt to restructure widget trees or change theme APIs.

Usage:
  python scripts/ci/tools/standardize_theme_prelude.py --root lib
  python scripts/ci/tools/standardize_theme_prelude.py --root lib --check
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
import re


CANONICAL_BY_PROP = {
    "theme": "th",
    "colors": "c",
    "accent": "ac",
    "text": "tx",
    "spacing": "sp",
    "shapes": "sh",
    "animations": "an",
    "sizes": "sz",
    "opacities": "op",
    "borders": "bd",
    "surfaces": "sf",
}

# Common legacy local names mapped to canonical names (only used when we see a matching
# `context.<prop>` declaration in-file).
LEGACY_IDENT_OVERRIDES = {
    "color": "c",
    "colors": "c",
    "spacing": "sp",
    "typography": "tx",
    "text": "tx",
    "te": "tx",
    "radii": "sh",
    "shapes": "sh",
    "theme": "th",
    "accent": "ac",
    "a": "ac",
}

RE_CONTEXT_DECL = re.compile(
    r"^(?P<indent>\s*)(?P<kw>final|var)\s+(?P<ident>[A-Za-z_]\w*)\s*=\s*context\.(?P<prop>[A-Za-z_]\w*)\s*;\s*$"
)

RE_BUILD_SIG = re.compile(
    r"(?m)^(?P<indent>\s*)Widget\s+build\s*\(\s*BuildContext\s+(?P<ctx>[A-Za-z_]\w*)\s*\)\s*(?P<body>\{|=>)"
)

# Generic method/function signature with a typed BuildContext parameter.
# Example: `Widget _buildHeader(BuildContext context) {`
RE_FUNC_WITH_CTX = re.compile(
    r"(?m)^(?P<indent>\s*)(?:[A-Za-z_]\w*|Future<[^>]+>|Stream<[^>]+>|List<[^>]+>|Map<[^>]+>|Set<[^>]+>|void|dynamic|Widget)"
    r"(?:\s*<[^>]*>)?\s+"
    r"(?P<name>[A-Za-z_]\w*)\s*\((?P<params>[^)]*\bBuildContext\s+(?P<ctx>[A-Za-z_]\w*)[^)]*)\)\s*(?P<body>\{|=>)"
)


@dataclass
class Edit:
    path: Path
    original: str
    updated: str


def rewrite_file(text: str) -> tuple[str, bool]:
    lines = text.splitlines(keepends=False)

    renamed: dict[str, str] = {}

    # Track which canonical locals already exist so we don't create duplicate
    # `final tx = context.text;` declarations.
    declared_canonicals: set[str] = set()

    # Pass 1: rename declarations (and drop duplicates)
    for i, line in enumerate(lines):
        m = RE_CONTEXT_DECL.match(line)
        if not m:
            continue

        ident = m.group("ident")
        prop = m.group("prop")
        kw = m.group("kw")
        indent = m.group("indent")

        canonical = CANONICAL_BY_PROP.get(prop)
        if not canonical:
            continue

        # If we've already declared the canonical local in this scope, drop this
        # declaration to prevent duplicate local errors.
        if canonical in declared_canonicals:
            if ident != canonical:
                renamed[ident] = canonical
            lines[i] = ""
            continue

        declared_canonicals.add(canonical)

        if ident != canonical:
            renamed[ident] = canonical
            lines[i] = f"{indent}{kw} {canonical} = context.{prop};"

    # Clean up any empty lines introduced by dropping duplicates.
    cleaned_lines = [ln for ln in lines if ln != ""]
    updated = "\n".join(cleaned_lines) + ("\n" if text.endswith("\n") else "")

    # Repair regressions from a previous buggy pass where `context.text.*` became
    # `context.tx.*` (and similarly for other theme buckets).
    for prop, canonical in CANONICAL_BY_PROP.items():
        updated = re.sub(rf"\bcontext\.{re.escape(canonical)}\.", f"context.{prop}.", updated)

    # Pass 2: replace old identifier member access to new identifier member access.
    # Important: avoid matching property names like `_controller.text`.
    for old, new in renamed.items():
        updated = re.sub(rf"(?<!\.)\b{re.escape(old)}\.", f"{new}.", updated)

    # Repair another regression: `TextEditingController.text` accidentally became
    # `TextEditingController.tx` due to the `text -> tx` rename.
    updated = re.sub(r"\b([A-Za-z_]\w*Controller)\.tx\b", r"\1.text", updated)

    # Pass 3: replace context.<prop>. with canonical when canonical declaration exists
    for prop, canonical in CANONICAL_BY_PROP.items():
        if re.search(rf"\b(final|var)\s+{re.escape(canonical)}\s*=\s*context\.{re.escape(prop)}\s*;", updated):
            updated = re.sub(rf"\bcontext\.{re.escape(prop)}\.", f"{canonical}.", updated)

    # Pass 4: ensure `build()` methods declare canonicals they use.
    updated = _ensure_build_prelude(updated)

    changed = updated != text
    return updated, changed


def _ensure_build_prelude(text: str) -> str:
    """Insert missing canonical locals in bodies that accept a BuildContext.

    Covers `build()` plus common helper methods like `_buildHeader(BuildContext context)`.
    """

    edits: list[tuple[int, int, str]] = []

    for m in list(RE_FUNC_WITH_CTX.finditer(text)):
        indent = m.group("indent")
        ctx_name = m.group("ctx")
        body_kind = m.group("body")

        if body_kind == "=>":
            # Arrow-bodied build: convert to block so we can add locals.
            sig_end = m.end()
            stmt_end = _find_statement_end(text, sig_end)
            expr = text[sig_end:stmt_end].strip()
            if not re.search(r"\b(th|c|ac|tx|sp|sh|an|sz|op|bd|sf)\.", expr):
                continue
            body_indent = indent + "  "
            prelude = _build_prelude_lines(body_indent, ctx_name, expr)
            replacement = "{\n" + (prelude + "\n" if prelude else "") + f"{body_indent}return {expr};\n{indent}}}"
            # Replace from the `=>` through the terminating `;`.
            edits.append((m.end() - 2, stmt_end + 1, replacement))
            continue

        # Block-bodied build.
        brace_open = text.find("{", m.end() - 1)
        if brace_open == -1:
            continue
        brace_close = _find_matching_brace(text, brace_open)
        if brace_close == -1:
            continue

        body = text[brace_open + 1 : brace_close]
        used = _used_canonicals(body)
        if not used:
            continue

        missing: list[str] = []
        for canonical in used:
            if re.search(rf"\b(final|var)\s+{re.escape(canonical)}\b", body):
                continue
            missing.append(canonical)

        if not missing:
            continue

        body_indent = indent + "  "
        insertion = "\n" + "\n".join(_canonical_decl_line(body_indent, ctx_name, c) for c in missing) + "\n"
        edits.append((brace_open + 1, brace_open + 1, insertion))

    if not edits:
        return text

    for start, end, repl in sorted(edits, key=lambda t: t[0], reverse=True):
        text = text[:start] + repl + text[end:]
    return text


def _used_canonicals(body: str) -> list[str]:
    order = ["th", "c", "ac", "tx", "sp", "sh", "an", "sz", "op", "bd", "sf"]
    used = {m.group(1) for m in re.finditer(r"\b(th|c|ac|tx|sp|sh|an|sz|op|bd|sf)\.", body)}
    return [c for c in order if c in used]


def _canonical_decl_line(indent: str, ctx_name: str, canonical: str) -> str:
    prop_by_canonical = {v: k for k, v in CANONICAL_BY_PROP.items()}
    prop = prop_by_canonical.get(canonical)
    if not prop:
        return f"{indent}final {canonical} = {ctx_name}.{canonical};"
    return f"{indent}final {canonical} = {ctx_name}.{prop};"


def _build_prelude_lines(indent: str, ctx_name: str, expr: str) -> str:
    used = _used_canonicals(expr)
    return "\n".join(_canonical_decl_line(indent, ctx_name, c) for c in used)


def _find_statement_end(text: str, start: int) -> int:
    i = start
    while i < len(text):
        if text[i] == ";":
            return i
        i += 1
    return len(text)


def _find_matching_brace(text: str, open_index: int) -> int:
    """Find the matching '}' for the '{' at open_index, skipping strings/comments."""

    i = open_index
    depth = 0
    in_line_comment = False
    in_block_comment = False
    in_string: str | None = None  # one of: ', ", ''' , """

    def starts_with(pos: int, s: str) -> bool:
        return text.startswith(s, pos)

    while i < len(text):
        ch = text[i]

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
            i += 1
            continue

        if in_block_comment:
            if starts_with(i, "*/"):
                in_block_comment = False
                i += 2
                continue
            i += 1
            continue

        if in_string:
            if in_string in ("'''", '"""'):
                if starts_with(i, in_string):
                    in_string = None
                    i += 3
                    continue
                i += 1
                continue

            if ch == "\\":
                i += 2
                continue
            if (in_string == "'" and ch == "'") or (in_string == '"' and ch == '"'):
                in_string = None
            i += 1
            continue

        if starts_with(i, "//"):
            in_line_comment = True
            i += 2
            continue
        if starts_with(i, "/*"):
            in_block_comment = True
            i += 2
            continue

        if starts_with(i, "'''"):
            in_string = "'''"
            i += 3
            continue
        if starts_with(i, '"""'):
            in_string = '"""'
            i += 3
            continue
        if ch == "'":
            in_string = "'"
            i += 1
            continue
        if ch == '"':
            in_string = '"'
            i += 1
            continue

        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return i

        i += 1

    return -1


def iter_dart_files(root: Path) -> list[Path]:
    return [p for p in root.rglob("*.dart") if p.is_file()]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", type=Path, default=Path("lib"), help="Root folder to scan (default: lib)")
    ap.add_argument("--check", action="store_true", help="Do not write; exit nonzero if changes needed")
    args = ap.parse_args()

    root = args.root
    if not root.exists():
        raise SystemExit(f"Root does not exist: {root}")

    edits: list[Edit] = []
    for path in iter_dart_files(root):
        original = path.read_text(encoding="utf-8")
        updated, changed = rewrite_file(original)
        if changed:
            edits.append(Edit(path=path, original=original, updated=updated))

    if args.check:
        if edits:
            print(f"{len(edits)} files would be updated")
            return 1
        print("No changes needed")
        return 0

    for edit in edits:
        edit.path.write_text(edit.updated, encoding="utf-8")

    print(f"Updated {len(edits)} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

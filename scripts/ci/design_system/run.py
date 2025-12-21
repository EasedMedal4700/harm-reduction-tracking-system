#!/usr/bin/env python3
"""
Design System Checker v1.0 - Main Entrypoint

Unified design system checking tool for Flutter projects.
"""

import sys
import argparse
from pathlib import Path

# Add current directory to path for imports
current_dir = Path(__file__).parent
sys.path.insert(0, str(current_dir))

from checker import DesignSystemChecker
from report_writer import ReportWriter


def find_project_root() -> Path:
    """Find project root by looking for pubspec.yaml"""
    current = Path.cwd()
    while current.parent != current:
        if (current / "pubspec.yaml").exists():
            return current
        current = current.parent
    return Path.cwd()  # fallback to current directory


def main():
    parser = argparse.ArgumentParser(
        description="Design System Checker v1.0 - Unified design system validation"
    )
    parser.add_argument(
        "--project-root",
        type=Path,
        default=None,
        help="Path to Flutter project root (default: auto-detect)"
    )
    parser.add_argument(
        "--reports-dir",
        type=Path,
        default=None,
        help="Directory to write reports (default: project_root/scripts/ci/design_system/reports)"
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Suppress all output except JSON reports"
    )

    args = parser.parse_args()

    # Determine project root
    project_root = args.project_root or find_project_root()
    if not project_root.exists():
        print(f"Error: Project root not found: {project_root}", file=sys.stderr)
        sys.exit(1)

    # Determine reports directory
    if args.reports_dir:
        reports_dir = args.reports_dir
    else:
        reports_dir = project_root / "scripts" / "ci" / "design_system" / "reports"

    if not args.quiet:
        print(f"Project root: {project_root}")
        print(f"Reports directory: {reports_dir}")

    # Run the checker
    try:
        checker = DesignSystemChecker(project_root)
        report = checker.check()

        # Write reports
        writer = ReportWriter(reports_dir)
        written_files = writer.write_all_reports(report)

        if not args.quiet:
            print(f"\nReports written:")
            for report_type, file_path in written_files.items():
                print(f"  {report_type}: {file_path}")

            print(f"\nSummary:")
            print(f"  Files scanned: {report.summary['files_scanned']}")
            print(f"  BLOCK issues: {report.summary['block']}")
            print(f"  MUST_FIX issues: {report.summary['must_fix']}")
            print(f"  SHOULD_FIX issues: {report.summary['should_fix']}")
            print(f"  LOGONLY issues: {report.summary['logonly']}")
            print(f"  Blocking issues: {report.summary['blocking']}")  # Backward compatibility
            print(f"  Warning issues: {report.summary['warnings']}")  # Backward compatibility

        # Exit with appropriate code
        exit_code = 1 if report.summary['blocking'] > 0 else 0
        sys.exit(exit_code)

    except Exception as e:
        if not args.quiet:
            print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
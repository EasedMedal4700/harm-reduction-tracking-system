import subprocess
import sys
import json
import os
import argparse
from pathlib import Path

def find_project_root():
    """Find project root by looking for pubspec.yaml"""
    current = Path(__file__).resolve().parent
    while current.parent != current:
        if (current / "pubspec.yaml").exists():
            return current
        current = current.parent
    return Path(__file__).resolve().parent.parent.parent.parent  # fallback

def main():
    parser = argparse.ArgumentParser(description='Run design system checks')
    parser.add_argument('--project-root', type=str, 
                       default=os.environ.get('PROJECT_ROOT'),
                       help='Path to project root (default: auto-detect)')
    parser.add_argument('--reports-dir', type=str,
                       default=os.environ.get('REPORTS_DIR'),
                       help='Path to reports directory (default: auto-detect)')
    
    args = parser.parse_args()
    
    # Determine paths
    project_root = Path(args.project_root) if args.project_root else find_project_root()
    design_system_dir = project_root / "scripts" / "ci" / "design_system"
    reports_dir = Path(args.reports_dir) if args.reports_dir else design_system_dir / "reports"
    summaries_dir = reports_dir / "summaries"
    details_dir = reports_dir / "details"
    
    summaries_dir.mkdir(parents=True, exist_ok=True)
    details_dir.mkdir(parents=True, exist_ok=True)

    CHECKS = [
        ("colors_and_theme", "check_colors_and_theme.py", "colors.json"),
        ("layout_constants", "check_layout_constants.py", "layout.json"),
        ("animation_constants", "check_animation_constants.py", "animations.json"),
    ]

    results = {}
    for name, script, output_file in CHECKS:
        print(f"Running {name}...")
        try:
            subprocess.run([sys.executable, script], cwd=design_system_dir / "checks", check=True)
            with open(summaries_dir / output_file) as f:
                results[name] = json.load(f)
            print(f"  {name}: {results[name]['status']}")
        except Exception as e:
            print(f"  ERROR: {e}")
            results[name] = {"status": "ERROR", "blocking_issues": 0, "warning_issues": 0, "files_affected": 0}

    # Aggregate
    status = "PASS" if all(r["status"] == "PASS" for r in results.values()) else "FAIL"
    summary = {
        "domain": "design_system",
        "status": status,
        "checks": {name: r["status"] for name, r in results.items()},
        "summary": {
            "blocking_issues": sum(r["blocking_issues"] for r in results.values()),
            "warning_issues": sum(r["warning_issues"] for r in results.values()),
            "files_scanned": sum(r["files_affected"] for r in results.values())
        }
    }

    with open(reports_dir / "summary.json", "w") as f:
        json.dump(summary, f, indent=2)

    print(f"Summary: {status}")
    sys.exit(0 if status == "PASS" else 1)

if __name__ == "__main__":
    main()
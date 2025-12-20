import subprocess
import sys
import json
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
CHECKS_DIR = BASE_DIR / "checks"
REPORTS_DIR = BASE_DIR / "reports"

def run_check(script_name):
    """Run a single check script and return its exit code."""
    script_path = CHECKS_DIR / script_name
    try:
        result = subprocess.run([sys.executable, str(script_path)], 
                              capture_output=True, text=True, cwd=CHECKS_DIR)
        return result.returncode
    except Exception as e:
        print(f"Error running {script_name}: {e}")
        return 1

def aggregate_results():
    """Aggregate results from all check JSON files."""
    summary = {
        "domain": "design_system",
        "overall_status": "PASS",
        "total_blocking_issues": 0,
        "total_warning_issues": 0,
        "total_files_affected": 0,
        "checks": []
    }

    checks_dir = REPORTS_DIR / "checks"
    if not checks_dir.exists():
        return summary

    for json_file in checks_dir.glob("*.json"):
        try:
            with open(json_file, 'r') as f:
                check_result = json.load(f)
                summary["checks"].append(check_result)
                
                summary["total_blocking_issues"] += check_result.get("blocking_issues", 0)
                summary["total_warning_issues"] += check_result.get("warning_issues", 0)
                summary["total_files_affected"] += check_result.get("files_affected", 0)
                
                if check_result.get("status") == "FAIL":
                    summary["overall_status"] = "FAIL"
        except Exception as e:
            print(f"Error reading {json_file}: {e}")

    return summary

def main():
    # Ensure reports directory exists
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    
    # Run all checks
    checks = [
        "check_colors_and_theme.py",
        "check_layout_constants.py", 
        "check_animation_constants.py"
    ]
    
    exit_codes = []
    for check in checks:
        print(f"Running {check}...")
        exit_code = run_check(check)
        exit_codes.append(exit_code)
        print(f"  Exit code: {exit_code}")
    
    # Aggregate results
    summary = aggregate_results()
    
    # Write summary
    summary_file = REPORTS_DIR / "summary.json"
    with open(summary_file, 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"\nSummary written to {summary_file}")
    print(f"Overall status: {summary['overall_status']}")
    
    # Return overall exit code (0 if all pass, 1 if any fail)
    overall_exit = 0 if all(code == 0 for code in exit_codes) else 1
    sys.exit(overall_exit)

if __name__ == "__main__":
    main()
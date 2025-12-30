"""scripts/ci/check_coverage.py

Coverage Threshold Checker

Enforces a minimum line coverage percentage based on CI config.

Important:
- This script intentionally does NOT enforce coverage regression rules.
- If you want regression tracking, implement it separately as an advisory step.
"""

import os
import sys
import json
import re
try:
    from config import CIConfig
except ImportError:
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from config import CIConfig

try:
    from reporting import write_report
except ImportError:
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from reporting import write_report

def get_coverage_percentage(lcov_path):
    if not os.path.exists(lcov_path):
        return 0.0
    
    total_lines = 0
    covered_lines = 0
    
    try:
        with open(lcov_path, 'r') as f:
            for line in f:
                if line.startswith('LF:'):
                    total_lines += int(line.strip().split(':')[1])
                elif line.startswith('LH:'):
                    covered_lines += int(line.strip().split(':')[1])
    except Exception as e:
        print(f"Error reading lcov.info: {e}")
        return 0.0

    if total_lines == 0:
        return 0.0
        
    return (covered_lines / total_lines) * 100

def main():
    config = CIConfig()
    min_coverage = config.get_step_config('coverage').get('min_coverage', 0.0)

    project_root = os.getcwd()
    lcov_path = os.path.join(project_root, 'coverage', 'lcov.info')
    current_coverage = get_coverage_percentage(lcov_path)
    print(f"Current Coverage: {current_coverage:.2f}%")
    print(f"Minimum Coverage: {min_coverage:.2f}%")

    passed = current_coverage >= min_coverage

    # Write deterministic report
    write_report(
        name="coverage",
        success=passed,
        summary={
            "current": float(f"{current_coverage:.2f}"),
            "minimum": float(f"{min_coverage:.2f}"),
            "total": 0 if passed else 1,
        },
        details=(
            []
            if passed
            else [
                {
                    "message": f"{current_coverage:.2f}% below minimum {min_coverage:.2f}%",
                }
            ]
        ),
    )

    # Check minimum coverage
    if current_coverage < min_coverage:
        print(f"Coverage {current_coverage:.2f}% is below minimum {min_coverage:.2f}%")
        sys.exit(1)
    
    print("Coverage check passed.")
    sys.exit(0)

if __name__ == "__main__":
    main()

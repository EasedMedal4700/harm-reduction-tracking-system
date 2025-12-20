import os
import re
import sys
import json
from datetime import datetime

def check_migration_header(root_dir):
    features_dir = os.path.join(root_dir, 'lib', 'features')
    if not os.path.exists(features_dir):
        return False, [f"Directory {features_dir} does not exist."]

    expected_patterns = [
        r"// MIGRATION:",
        r"// Theme: (COMPLETE|TODO)",
        r"// Common: (COMPLETE|TODO)",
        r"// Riverpod: (COMPLETE|TODO)"
    ]

    violations = []
    for dirpath, dirnames, filenames in os.walk(features_dir):
        for filename in filenames:
            if filename.endswith('.dart'):
                filepath = os.path.join(dirpath, filename)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                except Exception as e:
                    relative_path = os.path.relpath(filepath, root_dir)
                    violations.append(f"Error reading {relative_path}: {e}")
                    continue

                if len(lines) < len(expected_patterns):
                    relative_path = os.path.relpath(filepath, root_dir)
                    violations.append(f"File {relative_path} is too short or missing header.")
                    continue

                # Check if headers are at the top
                header_at_top = True
                for i, pattern in enumerate(expected_patterns):
                    if not re.match(pattern, lines[i].strip()):
                        header_at_top = False
                        break

                if header_at_top:
                    continue  # Headers are correct at the top

                # Check if headers exist anywhere else in the file
                headers_found_elsewhere = False
                for line in lines:
                    if re.match(expected_patterns[0], line.strip()):
                        headers_found_elsewhere = True
                        break

                relative_path = os.path.relpath(filepath, root_dir)
                if headers_found_elsewhere:
                    violations.append(f"File {relative_path} has migration headers in the wrong place (not at the top).")
                else:
                    violations.append(f"File {relative_path} does not have the correct migration header.")

    all_good = len(violations) == 0
    return all_good, violations

if __name__ == "__main__":
    # Assume run from scripts/ci/migration, go up to project root
    root_dir = os.path.join(os.path.dirname(__file__), '..', '..', '..')
    reports_dir = os.path.join(os.path.dirname(__file__), 'reports')
    os.makedirs(reports_dir, exist_ok=True)
    report_file = os.path.join(reports_dir, 'migration_header_report.json')

    all_good, violations = check_migration_header(root_dir)

    report_data = {
        "timestamp": datetime.now().isoformat(),
        "all_good": all_good,
        "violations": violations
    }

    with open(report_file, 'w', encoding='utf-8') as f:
        json.dump(report_data, f, indent=2)

    if all_good:
        print("All files have the migration header.")
        sys.exit(0)
    else:
        print(f"Some files are missing or have incorrect migration headers. See {report_file} for details.")
        sys.exit(1)
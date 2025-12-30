"""
Import Checker Script

Scans Dart files for import counts and enforces limits.
Guidelines:
0-5: Excellent
6-10: Normal
11-15: Warning
16+: Architectural smell (Refactor)
"""

import os
import json
import sys
import fnmatch
from typing import Any, Dict
try:
    from config import CIConfig
except ImportError:
    # Fallback if run from wrong directory or config missing
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from config import CIConfig

try:
    from reporting import write_report
except ImportError:
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from reporting import write_report

def find_dart_files(root_dir, excludes=None):
    if excludes is None:
        excludes = []
    dart_files = []
    for root, dirs, files in os.walk(root_dir):
        if '.dart_tool' in root or 'build' in root or '.venv' in root:
            continue
        for file in files:
            if file.endswith('.dart') and not file.endswith('.freezed.dart') and not file.endswith('.g.dart'):
                full_path = os.path.join(root, file)
                
                # Check exclusions
                is_excluded = False
                # Normalize path for matching
                try:
                    rel_path = os.path.relpath(full_path, os.getcwd()).replace('\\', '/')
                    for pattern in excludes:
                        if fnmatch.fnmatch(rel_path, pattern):
                            is_excluded = True
                            break
                except ValueError:
                    # Handle case where paths are on different drives
                    pass
                
                if not is_excluded:
                    dart_files.append(full_path)
    return dart_files

def count_imports(file_path):
    count = 0
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                if line.strip().startswith('import '):
                    count += 1
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return 0
    return count

def main():
    project_root = os.getcwd()
    lib_dir = os.path.join(project_root, 'lib')
    
    if not os.path.exists(lib_dir):
        print("Error: lib directory not found.")
        sys.exit(1)

    config = CIConfig()
    max_imports = config.get_step_config('imports').get('max_imports', 15)
    excludes = config.get_step_config('imports').get('exclude', [])

    files = find_dart_files(lib_dir, excludes)
    results = []
    violations = 0
    warnings = 0

    print("Checking imports...")
    
    for file_path in files:
        count = count_imports(file_path)
        rel_path = os.path.relpath(file_path, project_root)
        
        status = "OK"
        if count > max_imports:
            status = "SMELL"
            violations += 1
        elif count > 10:
            status = "WARNING"
            warnings += 1
            
        if status != "OK":
            results.append({
                "file": rel_path,
                "count": count,
                "status": status
            })

    # Sort by count descending
    results.sort(key=lambda x: x['count'], reverse=True)

    # Generate report
    details = [
        {
            "file": r.get("file"),
            "count": int(r.get("count", 0)),
            "status": r.get("status"),
        }
        for r in results
    ]

    # Deterministic order: primarily by count desc, then file.
    details.sort(key=lambda d: (-int(d.get("count", 0)), str(d.get("file", ""))))

    summary: Dict[str, Any] = {
        "total_files": int(len(files)),
        "violations": int(violations),
        "warnings": int(warnings),
        "max_imports": int(max_imports),
        "total": int(violations),
    }

    # Write to scripts/ci/reports/imports_report.json
    write_report(
        name="imports",
        success=(violations == 0),
        summary=summary,
        details=details,
    )

    # Print summary
    print(f"Checked {len(files)} files.")
    print(f"Found {violations} violations (> {max_imports} imports) and {warnings} warnings (11-{max_imports} imports).")
    
    if violations > 0:
        print("\nTop offenders:")
        for issue in results[:5]:
            print(f"{issue['count']} imports: {issue['file']}")
        sys.exit(1)
    
    sys.exit(0)

if __name__ == "__main__":
    main()

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
try:
    from config import CIConfig
except ImportError:
    # Fallback if run from wrong directory or config missing
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from config import CIConfig

def find_dart_files(root_dir):
    dart_files = []
    for root, dirs, files in os.walk(root_dir):
        if '.dart_tool' in root or 'build' in root or '.venv' in root:
            continue
        for file in files:
            if file.endswith('.dart') and not file.endswith('.freezed.dart') and not file.endswith('.g.dart'):
                dart_files.append(os.path.join(root, file))
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

    files = find_dart_files(lib_dir)
    results = []
    violations = 0
    warnings = 0

    config = CIConfig()
    max_imports = config.get_step_config('imports').get('max_imports', 15)

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
    import time
    report = {
        "summary": {
            "total_files": len(files),
            "violations": violations,
            "warnings": warnings,
            "timestamp": str(time.time())
        },
        "issues": results
    }

    # Save report
    script_dir = os.path.dirname(os.path.abspath(__file__))
    report_path = os.path.join(script_dir, 'import_report.json')
    with open(report_path, 'w') as f:
        json.dump(report, f, indent=2)

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

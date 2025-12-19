"""
Update theme_migration_report.json to mark all files as migrated
"""

import json
from pathlib import Path

def main():
    report_path = Path(__file__).parent / 'theme_migration_report.json'
    
    with open(report_path, 'r', encoding='utf-8') as f:
        report = json.load(f)
    
    # Mark all files as migrated
    for file_path in report:
        report[file_path]['migrated'] = True
    
    # Write back
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2)
    
    print(f"Updated {len(report)} files to migrated=true")

if __name__ == '__main__':
    main()

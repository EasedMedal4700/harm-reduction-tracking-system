"""
Fourth pass migration - handle hardcoded widths and heights
"""

import json
import re
from pathlib import Path

def apply_fourth_pass(file_path: str) -> tuple[bool, str]:
    """Apply fourth-pass migrations for widths/heights"""
    try:
        path = Path(file_path)
        if not path.exists():
            return False, f"File not found: {file_path}"
        
        content = path.read_text(encoding='utf-8')
        original_content = content
        
        # Replace common hardcoded widths with theme values
        content = re.sub(r'\bwidth:\s*80,', 'width: context.sizes.labelWidthSm,', content)
        content = re.sub(r'\bwidth:\s*110,', 'width: context.sizes.labelWidthMd,', content)
        content = re.sub(r'\bwidth:\s*120,', 'width: context.sizes.cardWidthSm,', content)
        content = re.sub(r'\bwidth:\s*140,', 'width: context.sizes.labelWidthLg,', content)
        content = re.sub(r'\bwidth:\s*160,', 'width: context.sizes.cardWidthMd,', content)
        content = re.sub(r'\bwidth:\s*200,', 'width: context.sizes.cardWidthLg,', content)
        
        # Write if changed
        if content != original_content:
            path.write_text(content, encoding='utf-8')
            return True, "Migrated successfully"
        else:
            return False, "No changes needed"
            
    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    # Load the migration report
    report_path = Path(__file__).parent / 'theme_migration_report.json'
    with open(report_path, 'r', encoding='utf-8') as f:
        report = json.load(f)
    
    base_path = Path(__file__).parent.parent.parent.parent
    
    results = {'migrated': [], 'failed': [], 'skipped': []}
    
    for file_rel_path in report.keys():
        file_path = base_path / file_rel_path.replace('\\', '/')
        success, message = apply_fourth_pass(str(file_path))
        
        if success:
            results['migrated'].append(file_rel_path)
            print(f"OK {file_rel_path}")
        elif "No changes needed" not in message:
            results['failed'].append((file_rel_path, message))
            print(f"FAIL {file_rel_path}: {message}")
        else:
            results['skipped'].append(file_rel_path)
    
    # Print summary
    print(f"\n{'='*60}")
    print(f"FOURTH PASS MIGRATION SUMMARY")
    print(f"{'='*60}")
    print(f"Migrated: {len(results['migrated'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"Skipped: {len(results['skipped'])}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

"""
Second pass migration - handle hardcoded numeric values
"""

import json
import re
from pathlib import Path

def fix_hardcoded_sizes(content: str) -> str:
    """Replace hardcoded numeric sizes with theme references"""
    
    # Icon sizes (common patterns)
    content = re.sub(r'size:\s*12([,\)])', r'size: context.sizes.iconXs\1', content)
    content = re.sub(r'size:\s*16([,\)])', r'size: context.sizes.iconSm\1', content)
    content = re.sub(r'size:\s*20([,\)])', r'size: context.sizes.iconMd\1', content)
    content = re.sub(r'size:\s*24([,\)])', r'size: context.sizes.iconMd\1', content)
    content = re.sub(r'size:\s*28([,\)])', r'size: context.sizes.iconLg\1', content)
    content = re.sub(r'size:\s*32([,\)])', r'size: context.sizes.iconLg\1', content)
    content = re.sub(r'size:\s*40([,\)])', r'size: context.sizes.iconXl\1', content)
    content = re.sub(r'size:\s*48([,\)])', r'size: context.sizes.iconXl\1', content)
    
    # Font sizes
    content = re.sub(r'fontSize:\s*10([,\)])', r'fontSize: context.text.caption.fontSize\1', content)
    content = re.sub(r'fontSize:\s*12([,\)])', r'fontSize: context.text.label.fontSize\1', content)
    content = re.sub(r'fontSize:\s*14([,\)])', r'fontSize: context.text.bodySmall.fontSize\1', content)
    content = re.sub(r'fontSize:\s*16([,\)])', r'fontSize: context.text.bodyLarge.fontSize\1', content)
    content = re.sub(r'fontSize:\s*18([,\)])', r'fontSize: context.text.heading4.fontSize\1', content)
    content = re.sub(r'fontSize:\s*20([,\)])', r'fontSize: context.text.heading3.fontSize\1', content)
    content = re.sub(r'fontSize:\s*24([,\)])', r'fontSize: context.text.heading2.fontSize\1', content)
    content = re.sub(r'fontSize:\s*28([,\)])', r'fontSize: context.text.heading1.fontSize\1', content)
    content = re.sub(r'fontSize:\s*32([,\)])', r'fontSize: context.text.display.fontSize\1', content)
    
    # Common widths and heights - match specific pixel values
    # Only replace obvious magic numbers, not calculated values
    
    return content

def fix_box_fit(content: str) -> str:
    """Add BoxFit constants if needed (these are already Flutter enums, just document)"""
    # BoxFit values are fine as-is since they're Flutter enums
    # But we could add to AppLayout if we want consistency
    return content

def apply_second_pass(file_path: str) -> tuple[bool, str]:
    """Apply second-pass migrations"""
    try:
        path = Path(file_path)
        if not path.exists():
            return False, f"File not found: {file_path}"
        
        content = path.read_text(encoding='utf-8')
        original_content = content
        
        # Apply fixes
        content = fix_hardcoded_sizes(content)
        content = fix_box_fit(content)
        
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
        success, message = apply_second_pass(str(file_path))
        
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
    print(f"SECOND PASS MIGRATION SUMMARY")
    print(f"{'='*60}")
    print(f"Migrated: {len(results['migrated'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"Skipped: {len(results['skipped'])}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""
Final comprehensive fix for all remaining undefined variable errors
"""

import os
import re
from pathlib import Path

# Base directory for the Flutter project
FLUTTER_BASE = Path(__file__).parent.parent.parent.parent

def read_file(filepath):
    """Read file content"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(filepath, content):
    """Write content to file"""
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def fix_undefined_variables_in_method(content):
    """Add missing variable declarations to methods that use them"""
    
    # Pattern to find methods
    methods = list(re.finditer(r'(Widget\s+_\w+\((?:BuildContext\s+context)?\)\s*\{)', content))
    
    if not methods:
        return content
    
    # Process methods from end to start to preserve positions
    for match in reversed(methods):
        method_start = match.end()
        
        # Find the method body
        depth = 1
        method_end = method_start
        for i in range(method_start, len(content)):
            if content[i] == '{':
                depth += 1
            elif content[i] == '}':
                depth -= 1
                if depth == 0:
                    method_end = i
                    break
        
        method_body = content[method_start:method_end]
        
        # Check what variables are used but not declared
        needed_vars = []
        
        if re.search(r'\bt\.(typography|opacities|colors|spacing|accent|sizes|cardShadow)', method_body):
            if 'final t = context.theme;' not in method_body:
                needed_vars.append('    final t = context.theme;')
        
        if re.search(r'\btext\.(body|heading|caption|label|title)', method_body):
            if 'final text = context.text;' not in method_body:
                needed_vars.append('    final text = context.text;')
        
        if re.search(r'\bc\.(surface|border|background|text|error|info|warning|primary)', method_body):
            if 'final c = context.colors;' not in method_body:
                needed_vars.append('    final c = context.colors;')
        
        if re.search(r'\bsp\.(sm|md|lg|xl|xs)', method_body):
            if 'final sp = context.spacing;' not in method_body:
                needed_vars.append('    final sp = context.spacing;')
        
        if re.search(r'\bsh\.(radius)', method_body):
            if 'final sh = context.shapes;' not in method_body:
                needed_vars.append('    final sh = context.shapes;')
        
        # Insert needed variables at the beginning of the method
        if needed_vars:
            vars_str = '\n'.join(needed_vars) + '\n\n'
            content = content[:method_start] + '\n' + vars_str + content[method_start:]
    
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply fix
        content = fix_undefined_variables_in_method(content)
        
        # Only write if content changed
        if content != original_content:
            write_file(filepath, content)
            print(f"Fixed: {filepath.relative_to(FLUTTER_BASE)}")
            return True
        else:
            return False
            
    except Exception as e:
        print(f"Error in {filepath.relative_to(FLUTTER_BASE)}: {e}")
        return False

def main():
    """Main function"""
    print("Fixing undefined variables in methods...")
    print("=" * 50)
    
    # Files with errors from flutter analyze
    error_files = [
        "lib/features/admin/widgets/cache/cache_management_section.dart",
        "lib/features/admin/widgets/errors/error_analytics_section.dart",
        "lib/features/admin/widgets/errors/error_log_detail_dialog.dart",
        "lib/features/analytics/widgets/analytics/use_distribution_card.dart",
        "lib/features/blood_levels/widgets/blood_levels/system_overview_card.dart",
        "lib/features/catalog/widgets/catalog/drug_catalog_list.dart",
        "lib/features/stockpile/widgets/personal_library/substance_card.dart",
        "lib/features/stockpile/widgets/personal_library/summary_stats_banner.dart",
        "lib/features/tolerence/widgets/tolerance_dashboard/bucket_details_widget.dart",
    ]
    
    fixed_count = 0
    for file_path in error_files:
        abs_path = FLUTTER_BASE / file_path
        if abs_path.exists():
            if migrate_file(abs_path):
                fixed_count += 1
        else:
            print(f"File not found: {abs_path}")
    
    print("=" * 50)
    print(f"Fixed {fixed_count} files")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Pass 10: Clean up unused variables and duplicate declarations
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

def remove_unused_text_variable(content):
    """Remove unused 'final text = context.text;' declarations"""
    # Look for lines with 'final text = context.text;' that might be unused
    # This is conservative - only removes if there's also another theme variable declared
    lines = content.split('\n')
    result_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this is an unused text declaration
        if 'final text = context.text;' in line:
            # Look ahead to see if text is used anywhere
            has_usage = False
            for j in range(i+1, min(i+100, len(lines))):
                if re.search(r'\btext\.(body|heading|caption|label|title)', lines[j]):
                    has_usage = True
                    break
            
            if not has_usage:
                # Skip this line (don't add it to result)
                i += 1
                continue
        
        result_lines.append(line)
        i += 1
    
    return '\n'.join(result_lines)

def remove_unused_t_variable(content):
    """Remove unused 'final t = context.theme;' declarations"""
    lines = content.split('\n')
    result_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this is an unused t declaration
        if 'final t = context.theme;' in line:
            # Look ahead to see if t is used anywhere
            has_usage = False
            for j in range(i+1, min(i+100, len(lines))):
                if re.search(r'\bt\.(spacing|typography|colors|accent|sizes|shapes|animations)', lines[j]):
                    has_usage = True
                    break
            
            if not has_usage:
                # Skip this line
                i += 1
                continue
        
        result_lines.append(line)
        i += 1
    
    return '\n'.join(result_lines)

def remove_duplicate_declarations(content):
    """Remove duplicate variable declarations in the same scope"""
    # This is a simple approach - looks for duplicate declarations close together
    lines = content.split('\n')
    result_lines = []
    seen_vars = set()
    
    for line in lines:
        # Check if this is a variable declaration
        match = re.match(r'\s*final\s+(\w+)\s+=\s+context\.(\w+);', line)
        if match:
            var_name = match.group(1)
            context_prop = match.group(2)
            var_key = f"{var_name}_{context_prop}"
            
            if var_key in seen_vars:
                # Skip duplicate
                continue
            else:
                seen_vars.add(var_key)
        else:
            # Reset seen_vars when we hit a blank line or different pattern
            if not line.strip() or '{' in line:
                seen_vars = set()
        
        result_lines.append(line)
    
    return '\n'.join(result_lines)

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply fixes
        content = remove_unused_text_variable(content)
        content = remove_unused_t_variable(content)
        content = remove_duplicate_declarations(content)
        
        # Only write if content changed
        if content != original_content:
            write_file(filepath, content)
            print(f"✓ Fixed: {filepath}")
            return True
        else:
            return False
            
    except Exception as e:
        print(f"✗ Error in {filepath}: {e}")
        return False

def main():
    """Main function"""
    print("Cleaning up unused variables...")
    print("=" * 50)
    
    # Files with unused variable warnings
    error_files = [
        "lib/features/activity/widgets/activity/activity_detail_sheet.dart",
        "lib/features/admin/widgets/cache/cache_management_section.dart",
        "lib/features/admin/widgets/stats/admin_stat_card.dart",
        "lib/features/blood_levels/widgets/blood_levels/blood_level_graph.dart",
        "lib/features/log_entry/widgets/log_entry/date_selector.dart",
        "lib/features/log_entry/widgets/log_entry/feeling_selection.dart",
        "lib/features/log_entry/widgets/log_entry/time_selector.dart",
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

#!/usr/bin/env python3
"""
Pass 8: Fix compilation errors from Pass 7
Removes 'const' from context values and fixes other issues
"""

import os
import re
import json
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

def fix_const_context_issue(content):
    """Remove 'const' from context.animations values since they can't be const"""
    # Pattern: const context.animations.XXXXX
    content = re.sub(r'\bconst\s+(context\.animations\.\w+)', r'\1', content)
    content = re.sub(r'\bconst\s+(context\.sizes\.\w+)', r'\1', content)
    content = re.sub(r'\bconst\s+(context\.shapes\.\w+)', r'\1', content)
    content = re.sub(r'\bconst\s+(context\.colors\.\w+)', r'\1', content)
    content = re.sub(r'\bconst\s+(context\.\w+\.\w+)', r'\1', content)
    
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply fix
        content = fix_const_context_issue(content)
        
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
    print("Fixing const context issues...")
    print("=" * 50)
    
    # Files with const context issues (from error report)
    error_files = [
        "lib/features/analytics/widgets/analytics/analytics_filter_card.dart",
        "lib/features/edit_log_entry/edit_log_entry_page.dart",
        "lib/features/home/home_page_main.dart",
        "lib/features/home/widgets/home/quick_actions_grid.dart",
        "lib/features/log_entry/log_entry_page.dart",
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

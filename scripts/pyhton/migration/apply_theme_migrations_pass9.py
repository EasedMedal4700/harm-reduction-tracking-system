#!/usr/bin/env python3
"""
Pass 9: Fix incorrect theme property access
Fix t.heading4 -> t.typography.heading4, etc.
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

def fix_theme_properties(content):
    """Fix incorrect theme property access patterns"""
    
    # Fix t.heading* -> t.typography.heading*
    content = re.sub(r'\bt\.heading(\d)\b', r't.typography.heading\1', content)
    
    # Fix t.bodySmall -> t.typography.bodySmall
    content = re.sub(r'\bt\.bodySmall\b', r't.typography.bodySmall', content)
    content = re.sub(r'\bt\.bodyLarge\b', r't.typography.bodyLarge', content)
    content = re.sub(r'\bt\.bodyRegular\b', r't.typography.bodyRegular', content)
    
    # Fix t.button -> t.typography.button or t.text.button
    content = re.sub(r'\bt\.button\b', r't.typography.button', content)
    
    # Fix t.caption -> t.typography.caption
    content = re.sub(r'\bt\.caption\b', r't.typography.caption', content)
    content = re.sub(r'\bt\.captionBold\b', r't.typography.captionBold', content)
    
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply fix
        content = fix_theme_properties(content)
        
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
    print("Fixing theme property access...")
    print("=" * 50)
    
    # Files with wrong theme property access
    error_files = [
        "lib/features/home/home_redesign/daily_checkin_card.dart",
        "lib/features/home/home_redesign/header_card.dart",
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

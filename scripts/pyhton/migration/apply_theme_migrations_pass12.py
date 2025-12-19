#!/usr/bin/env python3
"""
Pass 12: Final comprehensive fixes for all remaining errors
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

def add_missing_variables_to_methods(content):
    """Add missing context variables to helper methods that use them"""
    
    # Find all helper method definitions that take BuildContext
    pattern = r'(Widget _\w+\(BuildContext context\) \{)\s*\n'
    
    def add_variables(match):
        method_start = match.group(1)
        # Check what variables are used in this method
        # Look ahead to find the method body (until next Widget method or closing brace at start of line)
        start_pos = match.end()
        method_body = ""
        depth = 1
        for i, line in enumerate(content[start_pos:].split('\n')):
            if '{' in line:
                depth += line.count('{')
            if '}' in line:
                depth -= line.count('}')
            if depth == 0:
                break
            method_body += line + '\n'
        
        variables = []
        
        # Check what's used
        if re.search(r'\bt\.(cardShadow|opacities|colors|spacing|accent|typography)', method_body):
            variables.append("final t = context.theme;")
        if re.search(r'\btext\.(body|heading|caption|label|title)', method_body):
            variables.append("final text = context.text;")
        if re.search(r'\bc\.(surface|border|background|text|error|info|warning)', method_body):
            variables.append("final c = context.colors;")
        if re.search(r'\bsp\.(sm|md|lg|xl)', method_body):
            variables.append("final sp = context.spacing;")
        if re.search(r'\bsh\.(radius)', method_body):
            variables.append("final sh = context.shapes;")
        
        if variables:
            return method_start + '\n    ' + '\n    '.join(variables) + '\n'
        return method_start + '\n'
    
    content = re.sub(pattern, add_variables, content)
    return content

def fix_common_spacer_import(content):
    """Fix CommonSpacer import"""
    if 'CommonSpacer' in content and 'common/layout/common_spacer.dart' not in content:
        # Add import if not present
        if "import 'package:flutter/material.dart';" in content:
            content = content.replace(
                "import 'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';\nimport '../../../../common/layout/common_spacer.dart';"
            )
    return content

def fix_apptheme_reference(content):
    """Fix AppTheme type reference"""
    # Change method signatures that use AppTheme to use proper typing
    content = re.sub(
        r'(\w+\([^)]+,\s+)AppTheme\s+(\w+)\)',
        r'\1BuildContext context)',
        content
    )
    # If AppTheme is used as a parameter, get it from context
    return content

def remove_unused_t_variable(content):
    """Remove unused 't' variables"""
    lines = content.split('\n')
    result = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if 'final t = context.theme;' in line:
            # Check if t is used in the next 50 lines
            used = False
            for j in range(i+1, min(i+50, len(lines))):
                if re.search(r'\bt\.(cardShadow|opacities|colors|spacing|accent|typography|sizes)', lines[j]):
                    used = True
                    break
            if used:
                result.append(line)
            # else skip it
        else:
            result.append(line)
        i += 1
    return '\n'.join(result)

def fix_context_theme_access(content):
    """Fix context.theme to context.colors or appropriate property"""
    # Replace context.theme in specific cases
    content = re.sub(r'context\.theme\.opacities', 'context.opacities', content)
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply all fixes
        content = add_missing_variables_to_methods(content)
        content = fix_common_spacer_import(content)
        content = fix_apptheme_reference(content)
        content = fix_context_theme_access(content)
        content = remove_unused_t_variable(content)
        
        # Only write if content changed
        if content != original_content:
            write_file(filepath, content)
            print(f"Fixed: {filepath.relative_to(FLUTTER_BASE)}")
            return True
        else:
            return False
            
    except Exception as e:
        print(f"Error in {filepath.relative_to(FLUTTER_BASE)}: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main function"""
    print("Applying final comprehensive fixes...")
    print("=" * 50)
    
    # Get all Dart files in lib/features
    features_dir = FLUTTER_BASE / "lib" / "features"
    dart_files = list(features_dir.rglob("*.dart"))
    
    fixed_count = 0
    for filepath in dart_files:
        if migrate_file(filepath):
            fixed_count += 1
    
    print("=" * 50)
    print(f"Fixed {fixed_count} files")

if __name__ == "__main__":
    main()

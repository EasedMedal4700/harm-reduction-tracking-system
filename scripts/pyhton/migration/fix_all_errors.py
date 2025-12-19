#!/usr/bin/env python3
"""
Final fix: Remove duplicate declarations and add missing text declarations
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

def fix_duplicate_declarations(content):
    """Remove duplicate variable declarations in methods"""
    lines = content.split('\n')
    result = []
    current_scope_vars = set()
    scope_depth = 0
    
    for i, line in enumerate(lines):
        # Track scope depth
        scope_depth += line.count('{')
        scope_depth -= line.count('}')
        
        # Reset tracking at method boundaries
        if re.match(r'\s*(Widget|void|Future)', line) and '{' in line:
            current_scope_vars = set()
        
        # Check for variable declaration
        match = re.match(r'\s*final\s+(\w+)\s+=\s+context\.(\w+);', line)
        if match:
            var_name = match.group(1)
            
            if var_name in current_scope_vars:
                # Skip duplicate
                continue
            else:
                current_scope_vars.add(var_name)
        
        # Reset at closing brace of method
        if scope_depth == 0:
            current_scope_vars = set()
        
        result.append(line)
    
    return '\n'.join(result)

def add_missing_text_to_build_method(content):
    """Add missing text variable to build methods"""
    # Check if text is used
    if re.search(r'\btext\.(body|heading|caption|label|title)', content):
        # Check if text is declared in build method
        if not re.search(r'Widget build\(BuildContext context\) \{[^}]*final text = context\.text;', content, re.DOTALL):
            # Add text declaration after build method start
            content = re.sub(
                r'(Widget build\(BuildContext context\) \{\s*\n)(\s*(?!final text))',
                r'\1    final text = context.text;\n\2',
                content,
                count=1
            )
    return content

def add_missing_t_variable(content):
    """Add missing t variable where used"""
    # Check if t is used but not declared
    if re.search(r'\bt\.(typography|opacities|colors|spacing|accent)', content):
        # Check if in a method that doesn't have t
        lines = content.split('\n')
        in_method = False
        method_start = -1
        
        for i, line in enumerate(lines):
            if 'Widget build(BuildContext context)' in line or 'Widget _' in line and '(BuildContext context)' in line:
                in_method = True
                method_start = i
            elif in_method and 'final t = context.theme;' in line:
                in_method = False
        
        # If we found a method without t, add it
        if in_method and method_start >= 0:
            # Add after build method opening brace
            for i in range(method_start, len(lines)):
                if '{' in lines[i]:
                    lines.insert(i + 1, '    final t = context.theme;')
                    break
            content = '\n'.join(lines)
    
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply all fixes
        content = fix_duplicate_declarations(content)
        content = add_missing_text_to_build_method(content)
        content = add_missing_t_variable(content)
        
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
    print("Fixing all errors...")
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

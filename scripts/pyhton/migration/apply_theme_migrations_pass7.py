#!/usr/bin/env python3
"""
Pass 7: Comprehensive theme migration
Handles: heights, durations, colors, elevations, borders, shapes, alignments, etc.
"""

import os
import re
import json
from pathlib import Path

# Base directory for the Flutter project
FLUTTER_BASE = Path(__file__).parent.parent.parent.parent
JSON_FILE = Path(__file__).parent / "theme_migration_report.json"

def load_json_report():
    """Load the theme migration report JSON"""
    with open(JSON_FILE, 'r', encoding='utf-8') as f:
        return json.load(f)

def read_file(filepath):
    """Read file content"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(filepath, content):
    """Write content to file"""
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def migrate_heights(content):
    """Migrate hardcoded heights to theme constants"""
    replacements = {
        r'height:\s*350(?:\.0)?\s*,': 'height: context.sizes.heightXl,',
        r'height:\s*330(?:\.0)?\s*,': 'height: context.sizes.heightXl,',
        r'height:\s*300(?:\.0)?\s*,': 'height: context.sizes.heightLg,',
        r'height:\s*220(?:\.0)?\s*,': 'height: context.sizes.heightMd,',
        r'height:\s*200(?:\.0)?\s*,': 'height: context.sizes.heightMd,',
        r'height:\s*100(?:\.0)?\s*,': 'height: context.sizes.heightSm,',
        r'height:\s*48(?:\.0)?\s*,': 'height: context.sizes.heightXs,',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_durations(content):
    """Migrate hardcoded durations to theme constants"""
    replacements = {
        r'Duration\(milliseconds:\s*220\)': 'context.animations.medium',
        r'Duration\(milliseconds:\s*150\)': 'context.animations.fast',
        r'Duration\(milliseconds:\s*300\)': 'context.animations.normal',
        r'Duration\(milliseconds:\s*500\)': 'context.animations.slow',
        r'Duration\(milliseconds:\s*100\)': 'context.animations.extraFast',
        r'Duration\(seconds:\s*3\)': 'context.animations.toast',
        r'Duration\(seconds:\s*2\)': 'context.animations.snackbar',
        r'Duration\(seconds:\s*4\)': 'context.animations.longSnackbar',
        r'const\s+Duration\(milliseconds:\s*220\)': 'context.animations.medium',
        r'const\s+Duration\(milliseconds:\s*150\)': 'context.animations.fast',
        r'const\s+Duration\(milliseconds:\s*300\)': 'context.animations.normal',
        r'const\s+Duration\(milliseconds:\s*500\)': 'context.animations.slow',
        r'const\s+Duration\(milliseconds:\s*100\)': 'context.animations.extraFast',
        r'const\s+Duration\(seconds:\s*3\)': 'context.animations.toast',
        r'const\s+Duration\(seconds:\s*2\)': 'context.animations.snackbar',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_colors(content):
    """Migrate hardcoded colors to theme colors"""
    # Replace Colors.transparent
    content = re.sub(r'\bColors\.transparent\b', 'context.colors.transparent', content)
    
    # Common color patterns - these need to be context-specific
    # We'll flag these for manual review
    
    return content

def migrate_elevations(content):
    """Migrate hardcoded elevations to theme constants"""
    replacements = {
        r'elevation:\s*0(?:\.0)?\s*,': 'elevation: context.sizes.elevationNone,',
        r'elevation:\s*2(?:\.0)?\s*,': 'elevation: context.sizes.elevationSm,',
        r'elevation:\s*4(?:\.0)?\s*,': 'elevation: context.sizes.cardElevation,',
        r'elevation:\s*8(?:\.0)?\s*,': 'elevation: context.sizes.cardElevationHovered,',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_alignments(content):
    """Migrate hardcoded alignments to theme constants"""
    replacements = {
        r'\bAlignment\.center\b': 'context.shapes.alignmentCenter',
        r'\bAlignment\.topLeft\b': 'context.shapes.alignmentTopLeft',
        r'\bAlignment\.topCenter\b': 'context.shapes.alignmentTopCenter',
        r'\bAlignment\.topRight\b': 'context.shapes.alignmentTopRight',
        r'\bAlignment\.centerLeft\b': 'context.shapes.alignmentCenterLeft',
        r'\bAlignment\.centerRight\b': 'context.shapes.alignmentCenterRight',
        r'\bAlignment\.bottomLeft\b': 'context.shapes.alignmentBottomLeft',
        r'\bAlignment\.bottomCenter\b': 'context.shapes.alignmentBottomCenter',
        r'\bAlignment\.bottomRight\b': 'context.shapes.alignmentBottomRight',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_box_shapes(content):
    """Migrate hardcoded BoxShape to theme constants"""
    replacements = {
        r'\bBoxShape\.circle\b': 'context.shapes.boxShapeCircle',
        r'\bBoxShape\.rectangle\b': 'context.shapes.boxShapeRectangle',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_border_widths(content):
    """Migrate hardcoded border widths to theme constants"""
    replacements = {
        r'width:\s*1(?:\.0)?\s*,': 'width: context.sizes.borderThin,',
        r'width:\s*2(?:\.0)?\s*,': 'width: context.sizes.borderRegular,',
        r'width:\s*3(?:\.0)?\s*,': 'width: context.sizes.borderThick,',
        r'borderWidth:\s*1(?:\.0)?\s*,': 'borderWidth: context.sizes.borderThin,',
        r'borderWidth:\s*2(?:\.0)?\s*,': 'borderWidth: context.sizes.borderRegular,',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_letter_spacing(content):
    """Migrate hardcoded letter spacing to theme constants"""
    replacements = {
        r'letterSpacing:\s*0\.5\s*,': 'letterSpacing: context.sizes.letterSpacingSm,',
        r'letterSpacing:\s*1\.0\s*,': 'letterSpacing: context.sizes.letterSpacingMd,',
        r'letterSpacing:\s*1\.2\s*,': 'letterSpacing: context.sizes.letterSpacingMd,',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def migrate_blur_spread_radius(content):
    """Migrate blur and spread radius to theme constants"""
    replacements = {
        r'blurRadius:\s*4(?:\.0)?\s*,': 'blurRadius: context.sizes.blurRadiusSm,',
        r'blurRadius:\s*8(?:\.0)?\s*,': 'blurRadius: context.sizes.blurRadiusMd,',
        r'spreadRadius:\s*1(?:\.0)?\s*,': 'spreadRadius: context.sizes.spreadRadiusSm,',
        r'spreadRadius:\s*2(?:\.0)?\s*,': 'spreadRadius: context.sizes.spreadRadiusMd,',
    }
    
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def ensure_imports(content):
    """Ensure theme extension import is present"""
    if 'app_theme_extension.dart' not in content:
        # Add import after last existing import
        import_match = re.search(r"(import\s+['\"].*?['\"];?\s*\n)+", content)
        if import_match:
            last_import_end = import_match.end()
            import_line = "import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';\n"
            content = content[:last_import_end] + import_line + content[last_import_end:]
    
    return content

def migrate_file(filepath):
    """Apply all migrations to a single file"""
    try:
        print(f"Migrating: {filepath}")
        content = read_file(filepath)
        original_content = content
        
        # Apply all migration functions
        content = migrate_heights(content)
        content = migrate_durations(content)
        content = migrate_colors(content)
        content = migrate_elevations(content)
        content = migrate_alignments(content)
        content = migrate_box_shapes(content)
        content = migrate_border_widths(content)
        content = migrate_letter_spacing(content)
        content = migrate_blur_spread_radius(content)
        content = ensure_imports(content)
        
        # Only write if content changed
        if content != original_content:
            write_file(filepath, content)
            print(f"  ✓ Updated")
            return True
        else:
            print(f"  - No changes needed")
            return False
            
    except Exception as e:
        print(f"  ✗ Error: {e}")
        return False

def main():
    """Main migration function"""
    print("Starting Pass 7 migration...")
    print("=" * 50)
    
    # Load JSON report
    report = load_json_report()
    
    # Counter for statistics
    migrated_count = 0
    error_count = 0
    
    # Process each file in the report
    for file_path, info in report.items():
        if not info.get('migrated', False):
            # Convert to absolute path
            abs_path = FLUTTER_BASE / file_path.replace('\\', '/')
            
            if abs_path.exists():
                if migrate_file(abs_path):
                    migrated_count += 1
            else:
                print(f"File not found: {abs_path}")
                error_count += 1
    
    print("=" * 50)
    print(f"Migration complete!")
    print(f"Files migrated: {migrated_count}")
    print(f"Errors: {error_count}")

if __name__ == "__main__":
    main()

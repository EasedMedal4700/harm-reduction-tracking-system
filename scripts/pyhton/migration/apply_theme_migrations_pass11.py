#!/usr/bin/env python3
"""
Pass 11: Add missing 'final text = context.text;' declarations and fix other issues
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

def add_missing_text_variable(content):
    """Add 'final text = context.text;' if text is used but not declared"""
    # Check if text is used
    if re.search(r'\btext\.(body|heading|caption|label|title)', content):
        # Check if it's already declared in Widget build method
        if 'final text = context.text;' not in content:
            # Find the build method and add text declaration
            content = re.sub(
                r'(Widget build\(BuildContext context\) \{)\s*(\n\s+final \w+ = context\.\w+;)',
                r'\1\n    final text = context.text;\2',
                content
            )
            # If no other context variables, add after build
            if 'final text = context.text;' not in content:
                content = re.sub(
                    r'(Widget build\(BuildContext context\) \{)\s*\n',
                    r'\1\n    final text = context.text;\n',
                    content
                )
    return content

def fix_const_context(content):
    """Remove const from context values"""
    content = re.sub(r'\bconst\s+(context\.\w+\.\w+)', r'\1', content)
    return content

def fix_common_spacer_import(content):
    """Fix CommonSpacer import path"""
    content = content.replace(
        "import '../../../../common/widgets/common_spacer.dart';",
        "import '../../../../common/layout/common_spacer.dart';"
    )
    content = content.replace(
        "import '../../../common/widgets/common_spacer.dart';",
        "import '../../../common/layout/common_spacer.dart';"
    )
    return content

def fix_bodyRegular(content):
    """Replace text.bodyRegular with text.body"""
    content = re.sub(r'\btext\.bodyRegular\b', 'text.body', content)
    return content

def fix_bodyMedium(content):
    """Replace text.bodyMedium with text.body"""
    content = re.sub(r'\btext\.bodyMedium\b', 'text.body', content)
    return content

def fix_undefined_t(content):
    """Fix undefined 't' by adding context.theme declaration or using correct variable"""
    # Look for undefined t usage
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if 'final t = context.theme;' in line:
            # Already has t declaration
            return content
    
    # Check if t is used
    if re.search(r'\bt\.(cardShadow|opacities|colors|spacing)', content):
        # Add t declaration after build
        content = re.sub(
            r'(Widget build\(BuildContext context\) \{)\s*\n',
            r'\1\n    final t = context.theme;\n',
            content,
            count=1
        )
    
    return content

def fix_invalid_const(content):
    """Remove const from values that can't be const"""
    # Remove const from context.sizes in const Icon
    content = re.sub(
        r'const Icon\(([\w\.]+),\s+size:\s+context\.sizes\.(\w+)',
        r'Icon(\1, size: context.sizes.\2',
        content
    )
    return content

def migrate_file(filepath):
    """Apply fixes to a single file"""
    try:
        content = read_file(filepath)
        original_content = content
        
        # Apply all fixes
        content = add_missing_text_variable(content)
        content = fix_const_context(content)
        content = fix_common_spacer_import(content)
        content = fix_bodyRegular(content)
        content = fix_bodyMedium(content)
        content = fix_undefined_t(content)
        content = fix_invalid_const(content)
        
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
    print("Applying comprehensive fixes...")
    print("=" * 50)
    
    # Files with errors
    error_files = [
        "lib/features/activity/widgets/activity/activity_detail_sheet.dart",
        "lib/features/blood_levels/widgets/blood_levels/system_overview_card.dart",
        "lib/features/reflection/widgets/reflection/edit_reflection_form.dart",
        "lib/features/reflection/widgets/reflection/reflection_form.dart",
        "lib/features/reflection/widgets/reflection/reflection_selection.dart",
        "lib/features/stockpile/widgets/personal_library/day_usage_sheet.dart",
        "lib/features/stockpile/widgets/personal_library/substance_card.dart",
        "lib/features/stockpile/widgets/personal_library/summary_stats_banner.dart",
        "lib/features/stockpile/widgets/personal_library/weekly_usage_display.dart",
        "lib/features/tolerence/widgets/tolerance/unified_bucket_tolerance_widget.dart",
        "lib/features/wearOS/wearos_page.dart",
        "lib/features/daily_chekin/widgets/checkin_history/checkin_card.dart",
        "lib/features/daily_chekin/widgets/daily_checkin/mood_selector.dart",
        "lib/features/daily_chekin/widgets/daily_checkin/time_of_day_indicator.dart",
        "lib/features/catalog/widgets/catalog/drug_catalog_list.dart",
        "lib/features/settings/widgets/settings/account_confirmation_dialogs.dart",
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

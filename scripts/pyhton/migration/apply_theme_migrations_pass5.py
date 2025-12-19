"""
Fifth pass migration - Fix compilation errors
"""

import json
import re
from pathlib import Path

def fix_undefined_variables(content: str) -> str:
    """Fix undefined variable references"""
    
    # Pattern 1: Methods that use `text` without declaring it
    # Add `final text = context.text;` after other context declarations
    lines = content.split('\n')
    new_lines = []
    
    for i, line in enumerate(lines):
        new_lines.append(line)
        
        # If we see context.colors, context.spacing, etc but not context.text
        # and later we use `text.`, add the declaration
        if 'final c = context.colors;' in line or 'final sp = context.spacing;' in line:
            # Check if text is used later but not declared
            rest_of_file = '\n'.join(lines[i:])
            if 'text.body' in rest_of_file or 'text.heading' in rest_of_file or 'text.caption' in rest_of_file:
                # Check if not already declared
                if 'final text = context.text;' not in rest_of_file[:500]:
                    # Find where to insert (after color/spacing declarations)
                    indent = len(line) - len(line.lstrip())
                    new_lines.append(' ' * indent + 'final text = context.text;')
        
        # Similar for `t` variable
        if 'final c = context.colors;' in line:
            rest_of_file = '\n'.join(lines[i:])
            if 't.sizes' in rest_of_file or 't.opacities' in rest_of_file:
                if 'final t = context.theme;' not in rest_of_file[:500]:
                    indent = len(line) - len(line.lstrip())
                    new_lines.append(' ' * indent + 'final t = context.theme;')
    
    return '\n'.join(new_lines)

def fix_bodyregular_references(content: str) -> str:
    """Replace text.bodyRegular with text.body"""
    content = re.sub(r'text\.bodyRegular', 'text.body', content)
    return content

def fix_elevation_references(content: str) -> str:
    """Replace elevationSm with cardElevation"""
    content = re.sub(r'context\.sizes\.elevationSm', 'context.sizes.cardElevation', content)
    return content

def fix_commonspacer_import(content: str) -> str:
    """Fix CommonSpacer import path"""
    content = re.sub(
        r"import\s+['\"]\.\.\/\.\.\/\.\.\/\.\.\/common\/widgets\/common_spacer\.dart['\"];",
        "import '../../../../common/layout/common_spacer.dart';",
        content
    )
    return content

def fix_invalid_const(content: str) -> str:
    """Remove const from non-const contexts"""
    # fontSize: context.text.caption.fontSize can't be const in some contexts
    # This is usually in default parameter values - need to check context
    return content

def apply_fifth_pass(file_path: str) -> tuple[bool, str]:
    """Apply fifth-pass migrations"""
    try:
        path = Path(file_path)
        if not path.exists():
            return False, f"File not found: {file_path}"
        
        content = path.read_text(encoding='utf-8')
        original_content = content
        
        # Apply fixes
        content = fix_undefined_variables(content)
        content = fix_bodyregular_references(content)
        content = fix_elevation_references(content)
        content = fix_commonspacer_import(content)
        content = fix_invalid_const(content)
        
        # Write if changed
        if content != original_content:
            path.write_text(content, encoding='utf-8')
            return True, "Fixed errors"
        else:
            return False, "No changes needed"
            
    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    # Get files with errors from the list
    error_files = [
        "lib\\features\\activity\\widgets\\activity\\activity_detail_sheet.dart",
        "lib\\features\\analytics\\widgets\\analytics\\category_pie_chart.dart",
        "lib\\features\\analytics\\widgets\\analytics\\usage_trend_chart.dart",
        "lib\\features\\analytics\\widgets\\analytics\\use_distribution_card.dart",
        "lib\\features\\blood_levels\\widgets\\blood_levels\\blood_level_graph.dart",
        "lib\\features\\blood_levels\\widgets\\blood_levels\\substance_list_card.dart",
        "lib\\features\\blood_levels\\widgets\\blood_levels\\system_overview_card.dart",
        "lib\\features\\craving\\widgets\\cravings\\body_mind_signals_section.dart",
        "lib\\features\\craving\\widgets\\cravings\\craving_details_section.dart",
        "lib\\features\\craving\\widgets\\cravings\\emotional_state_section.dart",
        "lib\\features\\craving\\widgets\\cravings\\outcome_section.dart",
        "lib\\features\\home\\home_redesign\\daily_checkin_card.dart",
        "lib\\features\\home\\home_redesign\\header_card.dart",
        "lib\\features\\log_entry\\widgets\\log_entry\\date_selector.dart",
        "lib\\features\\log_entry\\widgets\\log_entry\\feeling_selection.dart",
        "lib\\features\\log_entry\\widgets\\log_entry\\route_selection.dart",
        "lib\\features\\log_entry\\widgets\\log_entry\\time_selector.dart",
        "lib\\features\\log_entry\\widgets\\log_entry_cards\\intention_craving_card.dart",
        "lib\\features\\reflection\\widgets\\reflection\\edit_reflection_form.dart",
        "lib\\features\\admin\\widgets\\cache\\cache_management_section.dart",
        "lib\\features\\admin\\widgets\\stats\\admin_stat_card.dart",
    ]
    
    base_path = Path(__file__).parent.parent.parent.parent
    
    results = {'fixed': [], 'failed': [], 'skipped': []}
    
    for file_rel_path in error_files:
        file_path = base_path / file_rel_path.replace('\\', '/')
        success, message = apply_fifth_pass(str(file_path))
        
        if success:
            results['fixed'].append(file_rel_path)
            print(f"FIXED {file_rel_path}")
        elif "No changes needed" not in message:
            results['failed'].append((file_rel_path, message))
            print(f"FAIL {file_rel_path}: {message}")
        else:
            results['skipped'].append(file_rel_path)
    
    # Print summary
    print(f"\n{'='*60}")
    print(f"FIFTH PASS ERROR FIX SUMMARY")
    print(f"{'='*60}")
    print(f"Fixed: {len(results['fixed'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"Skipped: {len(results['skipped'])}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

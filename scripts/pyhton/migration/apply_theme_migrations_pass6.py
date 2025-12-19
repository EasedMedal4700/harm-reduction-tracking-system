"""
Sixth pass - Remove duplicate variable declarations
"""

import re
from pathlib import Path

def remove_duplicate_declarations(content: str) -> str:
    """Remove duplicate `final t = context.theme;` and `final text = context.text;` declarations"""
    lines = content.split('\n')
    new_lines = []
    seen_in_scope = set()
    
    for i, line in enumerate(lines):
        # Reset scope tracking on method boundaries
        if re.match(r'^\s*(Widget|void|Future|List|Map|String|int|double|bool)\s+\w+\s*\(', line):
            seen_in_scope = set()
        
        # Check for duplicate declarations
        if 'final t = context.theme;' in line:
            if 't' in seen_in_scope:
                continue  # Skip this duplicate
            seen_in_scope.add('t')
        elif 'final text = context.text;' in line:
            if 'text' in seen_in_scope:
                continue  # Skip this duplicate
            seen_in_scope.add('text')
        elif 'final t = context.text;' in line:
            # This is wrong anyway - should be theme not text
            if 't' in seen_in_scope:
                continue
            seen_in_scope.add('t')
        
        new_lines.append(line)
    
    return '\n'.join(new_lines)

def remove_unused_variables(content: str) -> str:
    """Remove unused t and text variable declarations if they're truly unused"""
    # This is complex - for now just return as is, compiler warnings are acceptable
    return content

def fix_wrong_t_assignments(content: str) -> str:
    """Fix lines like `final t = context.text;` which should be `final t = context.theme;`"""
    content = re.sub(
        r'final t = context\.text;',
        'final t = context.theme;',
        content
    )
    return content

def main():
    error_files = [
        "lib\\features\\activity\\widgets\\activity\\activity_detail_sheet.dart",
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
        "lib\\features\\log_entry\\widgets\\log_entry_cards\\intention_craving_card.dart",
    ]
    
    base_path = Path(__file__).parent.parent.parent.parent
    
    results = {'fixed': [], 'failed': []}
    
    for file_rel_path in error_files:
        try:
            file_path = base_path / file_rel_path.replace('\\', '/')
            content = file_path.read_text(encoding='utf-8')
            original = content
            
            content = fix_wrong_t_assignments(content)
            content = remove_duplicate_declarations(content)
            
            if content != original:
                file_path.write_text(content, encoding='utf-8')
                results['fixed'].append(file_rel_path)
                print(f"FIXED {file_rel_path}")
            else:
                print(f"SKIP {file_rel_path}")
                
        except Exception as e:
            results['failed'].append((file_rel_path, str(e)))
            print(f"FAIL {file_rel_path}: {e}")
    
    print(f"\n{'='*60}")
    print(f"SIXTH PASS CLEANUP SUMMARY")
    print(f"{'='*60}")
    print(f"Fixed: {len(results['fixed'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

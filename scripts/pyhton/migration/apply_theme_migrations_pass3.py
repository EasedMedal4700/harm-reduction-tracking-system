"""
Third pass migration - handle BoxFit and remaining enum patterns
"""

import json
import re
from pathlib import Path

BOXFIT_REPLACEMENTS = {
    r'fit:\s*BoxFit\.fill': 'fit: AppLayout.boxFitFill',
    r'fit:\s*BoxFit\.contain': 'fit: AppLayout.boxFitContain',
    r'fit:\s*BoxFit\.cover': 'fit: AppLayout.boxFitCover',
    r'fit:\s*BoxFit\.fitWidth': 'fit: AppLayout.boxFitFitWidth',
    r'fit:\s*BoxFit\.fitHeight': 'fit: AppLayout.boxFitFitHeight',
    r'fit:\s*BoxFit\.none': 'fit: AppLayout.boxFitNone',
    r'fit:\s*BoxFit\.scaleDown': 'fit: AppLayout.boxFitScaleDown',
}

CLIP_REPLACEMENTS = {
    r'clipBehavior:\s*Clip\.none': 'clipBehavior: AppLayout.clipNone',
    r'clipBehavior:\s*Clip\.hardEdge': 'clipBehavior: AppLayout.clipHardEdge',
    r'clipBehavior:\s*Clip\.antiAlias': 'clipBehavior: AppLayout.clipAntiAlias',
    r'clipBehavior:\s*Clip\.antiAliasWithSaveLayer': 'clipBehavior: AppLayout.clipAntiAliasWithSaveLayer',
}

STACKFIT_REPLACEMENTS = {
    r'fit:\s*StackFit\.expand': 'fit: AppLayout.stackFitExpand',
    r'fit:\s*StackFit\.loose': 'fit: AppLayout.stackFitLoose',
    r'fit:\s*StackFit\.passthrough': 'fit: AppLayout.stackFitPassthrough',
}

def ensure_import(content: str, file_path: str) -> str:
    """Ensure AppLayout import if AppLayout is used"""
    has_app_layout = "'../../../../constants/theme/app_layout.dart'" in content or \
                     "\"../../../../constants/theme/app_layout.dart\"" in content or \
                     "'../../constants/theme/app_layout.dart'" in content or \
                     "\"../../constants/theme/app_layout.dart\"" in content or \
                     "'package:mobile_drug_use_app/constants/theme/app_layout.dart'" in content
    
    if not has_app_layout and 'AppLayout.' in content:
        # Determine the correct import path
        if 'lib/features' in file_path or 'lib\\features' in file_path:
            import_line = "import '../../../../constants/theme/app_layout.dart';\n"
        else:
            import_line = "import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';\n"
        
        # Add after the first import
        import_match = re.search(r"(import\s+['\"].*?['\"];?\n)", content)
        if import_match:
            insert_pos = import_match.end()
            content = content[:insert_pos] + import_line + content[insert_pos:]
    
    return content

def apply_third_pass(file_path: str) -> tuple[bool, str]:
    """Apply third-pass migrations"""
    try:
        path = Path(file_path)
        if not path.exists():
            return False, f"File not found: {file_path}"
        
        content = path.read_text(encoding='utf-8')
        original_content = content
        
        # Apply replacements
        for pattern, replacement in BOXFIT_REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)
        
        for pattern, replacement in CLIP_REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)
        
        for pattern, replacement in STACKFIT_REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)
        
        # Ensure import if changed
        if content != original_content:
            content = ensure_import(content, file_path)
            path.write_text(content, encoding='utf-8')
            return True, "Migrated successfully"
        else:
            return False, "No changes needed"
            
    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    # Load the migration report
    report_path = Path(__file__).parent / 'theme_migration_report.json'
    with open(report_path, 'r', encoding='utf-8') as f:
        report = json.load(f)
    
    base_path = Path(__file__).parent.parent.parent.parent
    
    results = {'migrated': [], 'failed': [], 'skipped': []}
    
    for file_rel_path in report.keys():
        file_path = base_path / file_rel_path.replace('\\', '/')
        success, message = apply_third_pass(str(file_path))
        
        if success:
            results['migrated'].append(file_rel_path)
            print(f"OK {file_rel_path}")
        elif "No changes needed" not in message:
            results['failed'].append((file_rel_path, message))
            print(f"FAIL {file_rel_path}: {message}")
        else:
            results['skipped'].append(file_rel_path)
    
    # Print summary
    print(f"\n{'='*60}")
    print(f"THIRD PASS MIGRATION SUMMARY")
    print(f"{'='*60}")
    print(f"Migrated: {len(results['migrated'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"Skipped: {len(results['skipped'])}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()

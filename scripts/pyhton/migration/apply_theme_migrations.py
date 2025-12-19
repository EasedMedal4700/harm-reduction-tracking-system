"""
Automated theme migration script
Applies layout constant replacements to all files in the theme_migration_report.json
"""

import json
import re
from pathlib import Path

# Define the mappings
REPLACEMENTS = {
    # MainAxisAlignment
    r'mainAxisAlignment:\s*MainAxisAlignment\.start': 'mainAxisAlignment: AppLayout.mainAxisAlignmentStart',
    r'mainAxisAlignment:\s*MainAxisAlignment\.end': 'mainAxisAlignment: AppLayout.mainAxisAlignmentEnd',
    r'mainAxisAlignment:\s*MainAxisAlignment\.center': 'mainAxisAlignment: AppLayout.mainAxisAlignmentCenter',
    r'mainAxisAlignment:\s*MainAxisAlignment\.spaceBetween': 'mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween',
    r'mainAxisAlignment:\s*MainAxisAlignment\.spaceAround': 'mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceAround',
    r'mainAxisAlignment:\s*MainAxisAlignment\.spaceEvenly': 'mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceEvenly',
    
    # MainAxisSize
    r'mainAxisSize:\s*MainAxisSize\.min': 'mainAxisSize: AppLayout.mainAxisSizeMin',
    r'mainAxisSize:\s*MainAxisSize\.max': 'mainAxisSize: AppLayout.mainAxisSizeMax',
    
    # CrossAxisAlignment
    r'crossAxisAlignment:\s*CrossAxisAlignment\.start': 'crossAxisAlignment: AppLayout.crossAxisAlignmentStart',
    r'crossAxisAlignment:\s*CrossAxisAlignment\.end': 'crossAxisAlignment: AppLayout.crossAxisAlignmentEnd',
    r'crossAxisAlignment:\s*CrossAxisAlignment\.center': 'crossAxisAlignment: AppLayout.crossAxisAlignmentCenter',
    r'crossAxisAlignment:\s*CrossAxisAlignment\.stretch': 'crossAxisAlignment: AppLayout.crossAxisAlignmentStretch',
    r'crossAxisAlignment:\s*CrossAxisAlignment\.baseline': 'crossAxisAlignment: AppLayout.crossAxisAlignmentBaseline',
    
    # TextAlign
    r'textAlign:\s*TextAlign\.left': 'textAlign: AppLayout.textAlignLeft',
    r'textAlign:\s*TextAlign\.right': 'textAlign: AppLayout.textAlignRight',
    r'textAlign:\s*TextAlign\.center': 'textAlign: AppLayout.textAlignCenter',
    r'textAlign:\s*TextAlign\.justify': 'textAlign: AppLayout.textAlignJustify',
    r'textAlign:\s*TextAlign\.start': 'textAlign: AppLayout.textAlignStart',
    r'textAlign:\s*TextAlign\.end': 'textAlign: AppLayout.textAlignEnd',
    
    # TextOverflow
    r'overflow:\s*TextOverflow\.clip': 'overflow: AppLayout.textOverflowClip',
    r'overflow:\s*TextOverflow\.ellipsis': 'overflow: AppLayout.textOverflowEllipsis',
    r'overflow:\s*TextOverflow\.fade': 'overflow: AppLayout.textOverflowFade',
    r'overflow:\s*TextOverflow\.visible': 'overflow: AppLayout.textOverflowVisible',
    
    # Flex values
    r'flex:\s*1,': 'flex: AppLayout.flex1,',
    r'flex:\s*2,': 'flex: AppLayout.flex2,',
    r'flex:\s*3,': 'flex: AppLayout.flex3,',
    r'flex:\s*4,': 'flex: AppLayout.flex4,',
}

# FontWeight replacements
FONTWEIGHT_REPLACEMENTS = {
    r'FontWeight\.w100': 'text.bodyThin.fontWeight',
    r'FontWeight\.w200': 'text.bodyExtraLight.fontWeight',
    r'FontWeight\.w300': 'text.bodyLight.fontWeight',
    r'FontWeight\.w400': 'text.bodyRegular.fontWeight',
    r'FontWeight\.w500': 'text.bodyMedium.fontWeight',
    r'FontWeight\.w600': 'text.bodyBold.fontWeight',
    r'FontWeight\.w700': 'text.bodyBold.fontWeight',
    r'FontWeight\.w800': 'text.bodyExtraBold.fontWeight',
    r'FontWeight\.w900': 'text.bodyBlack.fontWeight',
    r'FontWeight\.normal': 'text.bodyRegular.fontWeight',
    r'FontWeight\.bold': 'text.bodyBold.fontWeight',
}

def ensure_imports(content: str, file_path: str) -> str:
    """Ensure necessary imports are present"""
    has_app_layout = "'../../../../constants/theme/app_layout.dart'" in content or \
                     "\"../../../../constants/theme/app_layout.dart\"" in content or \
                     "'../../constants/theme/app_layout.dart'" in content or \
                     "\"../../constants/theme/app_layout.dart\"" in content
    
    if not has_app_layout and 'AppLayout.' in content:
        # Determine the correct import path based on file location
        depth = file_path.count('lib') + file_path.count('features') + file_path.count('widgets')
        if 'lib/features' in file_path:
            import_line = "import '../../../../constants/theme/app_layout.dart';\n"
        else:
            import_line = "import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';\n"
        
        # Add after the first import or at the beginning
        import_match = re.search(r"(import\s+['\"].*?['\"];?\n)", content)
        if import_match:
            insert_pos = import_match.end()
            content = content[:insert_pos] + import_line + content[insert_pos:]
    
    return content

def apply_migrations(file_path: str) -> tuple[bool, str]:
    """Apply migrations to a single file"""
    try:
        path = Path(file_path)
        if not path.exists():
            return False, f"File not found: {file_path}"
        
        content = path.read_text(encoding='utf-8')
        original_content = content
        
        # Apply layout replacements
        for pattern, replacement in REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)
        
        # Apply font weight replacements (only if 'text.' is in context)
        for pattern, replacement in FONTWEIGHT_REPLACEMENTS.items():
            content = re.sub(pattern, replacement, content)
        
        # Ensure imports
        if content != original_content:
            content = ensure_imports(content, file_path)
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
    
    results = {
        'migrated': [],
        'failed': [],
        'skipped': []
    }
    
    for file_rel_path, file_info in report.items():
        if file_info.get('migrated', False):
            results['skipped'].append(file_rel_path)
            continue
        
        file_path = base_path / file_rel_path.replace('\\', '/')
        success, message = apply_migrations(str(file_path))
        
        if success:
            results['migrated'].append(file_rel_path)
            print(f"✓ {file_rel_path}")
        else:
            results['failed'].append((file_rel_path, message))
            print(f"✗ {file_rel_path}: {message}")
    
    # Print summary
    print(f"\n{'='*60}")
    print(f"MIGRATION SUMMARY")
    print(f"{'='*60}")
    print(f"Migrated: {len(results['migrated'])}")
    print(f"Failed: {len(results['failed'])}")
    print(f"Skipped: {len(results['skipped'])}")
    print(f"{'='*60}")
    
    if results['failed']:
        print("\nFailed files:")
        for file_path, msg in results['failed']:
            print(f"  - {file_path}: {msg}")

if __name__ == '__main__':
    main()

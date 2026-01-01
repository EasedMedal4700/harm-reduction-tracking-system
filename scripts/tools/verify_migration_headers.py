import os
import re

def verify_headers(root_dir):
    required_fields = [
        "// MIGRATION:",
        "// State:",
        "// Navigation:",
        "// Models:",
        "// Theme:",
        "// Common:",
        "// Notes:"
    ]
    
    errors = []
    
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".dart") and not (file.endswith(".g.dart") or file.endswith(".freezed.dart")):
                # Check all dart files, excluding generated ones
                
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                    lines = content.split('\n')
                    # Check first few lines
                    header_lines = lines[:10] # Should be enough
                    
                    missing = []
                    for field in required_fields:
                        found = False
                        for line in header_lines:
                            if line.strip().startswith(field):
                                found = True
                                break
                        if not found:
                            missing.append(field)
                    
                    if missing:
                        errors.append(f"{file_path}: Missing {', '.join(missing)}")
                        
                except Exception as e:
                    errors.append(f"{file_path}: Error reading file - {str(e)}")

    if errors:
        print("Migration Header Verification Failed:")
        for error in errors:
            print(error)
        exit(1)
    else:
        print("All page/screen files have valid migration headers.")
        exit(0)

if __name__ == "__main__":
    # Assuming script is run from root or we can find lib
    target_dir = os.path.join(os.getcwd(), "lib")
    if not os.path.exists(target_dir):
        # Try relative to script location if run from scripts/tools
        target_dir = os.path.join(os.getcwd(), "..", "..", "lib")
        
    if not os.path.exists(target_dir):
        print(f"Could not find lib directory. CWD: {os.getcwd()}")
        exit(1)
        
    verify_headers(target_dir)

"""
Coverage Regression Checker

Checks if code coverage has decreased compared to the previous run.
Uses lcov.info and a cache file.
"""

import os
import sys
import json
import re
try:
    from config import CIConfig
except ImportError:
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    from config import CIConfig

def get_coverage_percentage(lcov_path):
    if not os.path.exists(lcov_path):
        return 0.0
    
    total_lines = 0
    covered_lines = 0
    
    try:
        with open(lcov_path, 'r') as f:
            for line in f:
                if line.startswith('LF:'):
                    total_lines += int(line.strip().split(':')[1])
                elif line.startswith('LH:'):
                    covered_lines += int(line.strip().split(':')[1])
    except Exception as e:
        print(f"Error reading lcov.info: {e}")
        return 0.0

    if total_lines == 0:
        return 0.0
        
    return (covered_lines / total_lines) * 100

def main():
    config = CIConfig()
    min_coverage = config.get_step_config('coverage').get('min_coverage', 0.0)

    project_root = os.getcwd()
    lcov_path = os.path.join(project_root, 'coverage', 'lcov.info')
    script_dir = os.path.dirname(os.path.abspath(__file__))
    cache_path = os.path.join(script_dir, 'coverage_cache.json')

    current_coverage = get_coverage_percentage(lcov_path)
    print(f"Current Coverage: {current_coverage:.2f}%")

    previous_coverage = 0.0
    if os.path.exists(cache_path):
        try:
            with open(cache_path, 'r') as f:
                data = json.load(f)
                previous_coverage = data.get('coverage', 0.0)
        except:
            pass
    
    print(f"Previous Coverage: {previous_coverage:.2f}%")

    # Save current coverage
    with open(cache_path, 'w') as f:
        json.dump({'coverage': current_coverage}, f)

    # Check minimum coverage
    if current_coverage < min_coverage:
        print(f"❌ Coverage {current_coverage:.2f}% is below minimum {min_coverage:.2f}%")
        sys.exit(1)

    # Allow small fluctuation (e.g. 0.1%) or strict? User said "doesnt allow regression".
    # Let's be strict but handle float precision.
    if current_coverage < previous_coverage - 0.01:
        print(f"❌ Coverage regression detected! Dropped from {previous_coverage:.2f}% to {current_coverage:.2f}%")
        sys.exit(1)
    
    print("✅ Coverage check passed.")
    sys.exit(0)

if __name__ == "__main__":
    main()

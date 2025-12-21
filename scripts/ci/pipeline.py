"""
CI Pipeline Execution Module

Contains all execution logic for CI pipeline steps.
Separated from UI for better maintainability and reusability.
"""

import json
import os
import subprocess
from datetime import datetime
from dataclasses import dataclass
from typing import Dict, Any, Optional, Tuple
from datetime import datetime


@dataclass
class PipelineStep:
    """Represents a single CI pipeline step"""
    name: str
    command: str
    cwd: Optional[str] = None

    def execute(self) -> Tuple[bool, str]:
        """Execute the step and return (success, output)"""
        try:
            result = subprocess.run(
                self.command,
                shell=True,
                cwd=self.cwd or find_project_root(),
                capture_output=True,
                text=True,
                encoding='utf-8',
                timeout=300  # 5 minute timeout
            )
            return result.returncode == 0, result.stdout + result.stderr
        except subprocess.TimeoutExpired:
            return False, "Command timed out"
        except Exception as e:
            return False, f"Command failed: {str(e)}"


def find_project_root() -> str:
    """Find the Flutter project root by looking for pubspec.yaml."""
    current = os.getcwd()
    while current != os.path.dirname(current):
        if os.path.exists(os.path.join(current, "pubspec.yaml")):
            return current
        current = os.path.dirname(current)
    return None


def load_unified_report() -> Optional[Dict[str, Any]]:
    """Load the unified design system report"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    report_path = os.path.join(base_dir, "design_system", "reports", "unified_report.json")
    if os.path.exists(report_path):
        with open(report_path, 'r') as f:
            return json.load(f)
    return None


def run_design_system_checks() -> Tuple[bool, str, str]:
    """Run design system checks and return status"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    run_py = os.path.join(base_dir, "design_system", "run.py")
    
    # Use virtual environment Python
    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")
    step = PipelineStep("Design System Checks", f'"{venv_python}" {run_py} --quiet')
    success, output = step.execute()

    # Parse the report to get summary
    report = load_unified_report()
    if report and "summary" in report:
        summary = report["summary"]
        blocking = summary.get("blocking", 0)
        warnings = summary.get("warnings", 0)
        status_msg = f"Design system checks completed\nBlocking: {blocking}\nWarnings: {warnings}"
    else:
        status_msg = "Design system checks completed\nUnable to read results"

    return success, status_msg, output


def run_dart_format() -> Tuple[bool, str, str]:
    """Run dart format and return status"""
    step = PipelineStep("Dart Format", "dart format --set-exit-if-changed .")
    success, output = step.execute()

    if success:
        status_msg = "✅ OK"
    else:
        status_msg = "❌ Needs formatting"

    return success, status_msg, output


def run_tests() -> Tuple[bool, str, str]:
    """Run flutter tests and return status"""
    step = PipelineStep("Tests", "flutter test --machine")
    success, output = step.execute()

    # Parse machine-readable output for detailed results
    failed_tests = []
    test_names = {}  # testID -> name
    total_tests = 0
    passed_tests = 0

    lines = output.strip().split('\n')
    for line in lines:
        if not line.strip():
            continue
        try:
            event = json.loads(line)
            # Skip if it's a list (some events come as arrays)
            if not isinstance(event, dict):
                continue
                
            event_type = event.get('type')
            
            if event_type == 'testStart':
                test_id = event.get('test', {}).get('id')
                test_name = event.get('test', {}).get('name')
                if test_id and test_name:
                    test_names[test_id] = test_name
            
            elif event_type == 'testDone':
                total_tests += 1
                test_id = event.get('testID')
                result = event.get('result')
                skipped = event.get('skipped', False)
                hidden = event.get('hidden', False)
                
                if not skipped and not hidden:
                    if result == 'success':
                        passed_tests += 1
                    else:
                        # This is a failed test
                        test_name = test_names.get(test_id, f'Test {test_id}')
                        failed_tests.append({
                            'id': test_id,
                            'name': test_name,
                            'result': result,
                            'time': event.get('time', 0)
                        })
                        
        except json.JSONDecodeError:
            # Skip non-JSON lines
            continue

    # Save failed tests to JSON file
    if failed_tests:
        report_path = os.path.join(os.path.dirname(__file__), 'test_report.json')
        with open(report_path, 'w') as f:
            json.dump({
                'summary': {
                    'total_tests': total_tests,
                    'passed_tests': passed_tests,
                    'failed_tests': len(failed_tests),
                    'timestamp': str(datetime.now())
                },
                'failed_tests': failed_tests
            }, f, indent=2)

    # Create status message
    if failed_tests:
        status_msg = f"❌ {len(failed_tests)} test(s) failed"
    else:
        status_msg = f"✅ All {total_tests} tests passed"

    return success, status_msg, output


def run_all_pipeline() -> Dict[str, Tuple[bool, str, str]]:
    """Run all CI steps and return results"""
    results = {}

    print("Running ALL checks...")
    print()

    # 1. Dart Format
    print("1. Running Dart Format...")
    results['format'] = run_dart_format()
    print(f"   {results['format'][1]}")
    print()

    # 2. Tests
    print("2. Running Tests...")
    results['tests'] = run_tests()
    print(f"   {results['tests'][1]}")
    print()

    # 3. Design System Checks
    print("3. Running Design System Checks...")
    results['design'] = run_design_system_checks()
    print(f"   {results['design'][1]}")
    print()

    return results
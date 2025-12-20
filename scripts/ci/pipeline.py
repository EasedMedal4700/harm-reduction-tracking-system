"""
CI Pipeline Execution Module

Contains all execution logic for CI pipeline steps.
Separated from UI for better maintainability and reusability.
"""

import json
import os
import subprocess
from dataclasses import dataclass
from typing import Dict, Any, Optional, Tuple


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


def run_design_system_checks() -> Tuple[bool, str]:
    """Run design system checks and return status"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    run_py = os.path.join(base_dir, "design_system", "run.py")

    step = PipelineStep("Design System Checks", f"python {run_py} --quiet")
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

    return success, status_msg


def run_dart_format() -> Tuple[bool, str]:
    """Run dart format and return status"""
    step = PipelineStep("Dart Format", "dart format --output=none --set-exit-if-changed .")
    success, output = step.execute()

    if success:
        return True, "✅ OK"
    else:
        return False, "❌ Needs formatting"


def run_tests() -> Tuple[bool, str]:
    """Run flutter tests and return status"""
    step = PipelineStep("Tests", "flutter test")
    success, output = step.execute()

    # Try to extract test results from output
    lines = output.split('\n')
    for line in reversed(lines):
        if 'tests passed' in line.lower() or 'tests failed' in line.lower():
            if 'failed' in line.lower():
                return False, f"❌ {line.strip()}"
            else:
                return True, f"✅ {line.strip()}"

    # Fallback
    return success, "✅ Tests passed" if success else "❌ Tests failed"


def run_all_pipeline() -> Dict[str, Tuple[bool, str]]:
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
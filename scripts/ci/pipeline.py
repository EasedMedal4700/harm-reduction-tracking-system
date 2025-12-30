"""
CI Pipeline Execution Module

Contains all execution logic for CI pipeline steps.
Separated from UI for better maintainability and reusability.
"""

import json
import os
import subprocess
import glob
from datetime import datetime
from dataclasses import dataclass
from typing import Dict, Any, Optional, Tuple, List
from datetime import datetime
import time
from config import CIConfig, Colors
from reporting import write_report

def create_progress_bar(percentage, width=20):
    """Create a text-based progress bar"""
    filled = int(width * percentage / 100)
    bar = '█' * filled + '░' * (width - filled)
    return bar


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
    config = CIConfig()
    if not config.is_step_enabled('design_system'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

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
        
        allow_warnings = config.get_step_config('design_system').get('allow_warnings', True)
        
        if blocking > 0:
             status_msg = Colors.colorize(f"Design system checks failed\nBlocking: {blocking}", 'failure')
             success = False
        elif warnings > 0:
             if allow_warnings:
                 status_msg = Colors.colorize(f"Design system checks passed with warnings\nWarnings: {warnings}", 'warning')
             else:
                 status_msg = Colors.colorize(f"Design system checks failed (Warnings not allowed)\nWarnings: {warnings}", 'failure')
                 success = False
        else:
             status_msg = Colors.colorize("Design system checks completed\n✅ OK", 'success')
    else:
        status_msg = Colors.colorize("Design system checks completed\nUnable to read results", 'warning')

    # Mirror the latest design system report into scripts/ci/reports/
    try:
        report_for_ci = load_unified_report() or {}
        summary = report_for_ci.get("summary", {}) or {}
        issues = report_for_ci.get("issues", []) or []

        write_report(
            name="design_system",
            success=success,
            summary={
                "blocking": int(summary.get("blocking", 0) or 0),
                "warnings": int(summary.get("warnings", 0) or 0),
                "total": int(summary.get("blocking", 0) or 0),
            },
            details=[
                {
                    "file": (i.get("file", "") or "").replace('\\\\', '/'),
                    "line": int(i.get("line", 0) or 0),
                    "rule": i.get("rule"),
                    "severity": i.get("severity"),
                    "message": i.get("message"),
                }
                for i in issues
            ],
        )
    except Exception:
        # Reporting should never fail the pipeline
        pass

    return success, status_msg, output


def run_dart_format() -> Tuple[bool, str, str]:
    """Run dart format and return status"""
    config = CIConfig()
    if not config.is_step_enabled('format'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    # Run dart format to auto-format
    step = PipelineStep("Dart Format", "dart format .")
    success, output = step.execute()

    if not success:
        return False, Colors.colorize("❌ Dart format failed to run", 'failure'), output

    # Check output to see if files were changed
    formatted_files = []
    for line in output.splitlines():
        if line.startswith("Formatted") and "files (" not in line:
            formatted_files.append(line)
    
    if formatted_files:
        count = len(formatted_files)
        status_msg = Colors.colorize(f"✅ Auto-formatted {count} file(s)", 'success')
    else:
        status_msg = Colors.colorize("✅ Already formatted", 'success')

    # Deterministic report (no timestamps)
    write_report(
        name="format",
        success=True,
        summary={
            "formatted_files": int(len(formatted_files)),
            "total": 0,
        },
        details=[{"message": l} for l in formatted_files],
    )

    return True, status_msg, output


def run_tests() -> Tuple[bool, str, str]:
    """Run flutter tests and return status with progress display"""
    config = CIConfig()
    if not config.is_step_enabled('tests'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Flutter tests...")
    print("Progress will be shown below. This may take a few minutes.")
    print()

    start_time = time.time()

    # Check for cached test count
    cache_file = os.path.join(os.path.dirname(__file__), 'test_count_cache.txt')
    cached_total = None
    if os.path.exists(cache_file):
        try:
            with open(cache_file, 'r') as f:
                cached_total = int(f.read().strip())
        except:
            cached_total = None

    if cached_total:
        fixed_total = cached_total
        total_known = True
        print(f"Using cached test count: {cached_total}")
    else:
        fixed_total = 0
        total_known = False

    # Initial progress display
    percentage = 0.0 if total_known else 0.0
    progress_bar = create_progress_bar(percentage)

    try:
        # Construct command
        cmd = "flutter test --machine --coverage"
        exclude_tags = config.get_step_config('tests').get('exclude_tags', [])
        if exclude_tags:
            cmd += f" --exclude-tags={','.join(exclude_tags)}"

        # Run flutter test with machine-readable output and coverage
        process = subprocess.Popen(
            cmd,
            shell=True,
            cwd=find_project_root(),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            encoding='utf-8'
        )

        # Parse output in real-time
        failed_tests = []
        test_names = {}  # testID -> name
        total_tests = 0
        passed_tests = 0
        completed = 0
        current_test = None
        output_lines = []

        while True:
            line = process.stdout.readline()
            if not line and process.poll() is not None:
                break

            output_lines.append(line)
            line = line.strip()

            if not line:
                continue

            try:
                event = json.loads(line)
                if not isinstance(event, dict):
                    continue

                event_type = event.get('type')

                if event_type == 'testStart':
                    test_id = event.get('test', {}).get('id')
                    test_name = event.get('test', {}).get('name')
                    if test_id and test_name:
                        # The runner emits a hidden "loading <path>" test per suite.
                        # Exclude these so totals/progress match `flutter test` summary.
                        if not str(test_name).startswith('loading '):
                            test_names[test_id] = test_name
                            current_test = test_name

                elif event_type == 'testDone':
                    test_id = event.get('testID')
                    result = event.get('result')
                    skipped = event.get('skipped', False)
                    hidden = event.get('hidden', False)

                    # Ignore hidden tests (not counted in `flutter test` summary)
                    if hidden:
                        continue

                    # Count non-hidden tests as completed (including skipped) for progress
                    completed += 1

                    # Lock total on first testDone if not cached
                    if not total_known:
                        total_known = True
                        fixed_total = len(test_names)

                    # Match console summary: exclude skipped tests from passed/failed totals
                    if not skipped:
                        total_tests += 1
                        if result == 'success':
                            passed_tests += 1
                        else:
                            test_name = test_names.get(test_id, f'Test {test_id}')
                            failed_tests.append({
                                'id': test_id,
                                'name': test_name,
                                'result': result,
                                'time': event.get('time', 0)
                            })

                    # Update progress on every testDone if total known
                    if total_known and config.should_show_progress():
                        percentage = (completed / fixed_total) * 100
                        elapsed = time.time() - start_time
                        progress_bar = create_progress_bar(percentage)
                        print(f"\rProgress: [{progress_bar}] {percentage:.1f}% | ⏱️  Elapsed: {elapsed:.1f}s", end='', flush=True)

                elif event_type == 'done':
                    break

            except json.JSONDecodeError:
                continue

        # Wait for process to complete
        process.wait()
        success = process.returncode == 0

        elapsed = time.time() - start_time
        print()  # New line after progress
        print(f"⏱️  Total time: {elapsed:.1f}s")
        print()

        # Recalculate authoritative total from captured machine output
        try:
            authoritative_total = 0
            def handle_event(ev):
                nonlocal authoritative_total
                if not isinstance(ev, dict):
                    return
                t = ev.get('type') or ev.get('event')
                if t == 'testDone':
                    if ev.get('hidden', False):
                        return
                    if ev.get('skipped', False):
                        return
                    authoritative_total += 1

            for raw_line in output_lines:
                line = (raw_line or '').strip()
                if not line:
                    continue
                try:
                    ev = json.loads(line)
                except json.JSONDecodeError:
                    # Try to clean trailing commas
                    try:
                        ev = json.loads(line.rstrip(','))
                    except Exception:
                        continue

                if isinstance(ev, list):
                    for item in ev:
                        handle_event(item)
                else:
                    handle_event(ev)

            # Use authoritative total if we found any events
            if authoritative_total > 0:
                total_tests = authoritative_total

        except Exception:
            # If re-parse fails, fall back to live count
            pass

        # Cache the test count for future runs
        with open(cache_file, 'w') as f:
            f.write(str(total_tests))

    except Exception as e:
        return False, Colors.colorize(f"❌ Test execution failed: {str(e)}", 'failure'), str(e)

    # Deterministic report (no timestamps)
    # Note: allow_failure is applied later to the step success, but total still
    # reflects real failures.
    write_report(
        name="tests",
        success=(len(failed_tests) == 0),
        summary={
            "total_tests": int(total_tests),
            "passed_tests": int(passed_tests),
            "failed_tests": int(len(failed_tests)),
            "total": int(len(failed_tests)),
        },
        details=[
            {
                "id": t.get('id'),
                "name": t.get('name'),
                "result": t.get('result'),
                "time": t.get('time', 0),
            }
            for t in failed_tests
        ],
    )

    # Create status message
    allow_failure = config.get_step_config('tests').get('allow_failure', False)
    
    if failed_tests:
        msg = f"❌ {len(failed_tests)} test(s) failed"
        if allow_failure:
            status_msg = Colors.colorize(msg + " (Allowed Failure)", 'warning')
            success = True
        else:
            status_msg = Colors.colorize(msg, 'failure')
            success = False
    else:
        status_msg = Colors.colorize(f"✅ All {total_tests} tests passed", 'success')

    output = ''.join(output_lines)
    return success, status_msg, output


def run_dart_analyze() -> Tuple[bool, str, str]:
    """Run dart analyze and return status"""
    config = CIConfig()
    if not config.is_step_enabled('analyze'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Dart Analyze...")
    # Run with --format=json to get machine readable output
    step = PipelineStep("Dart Analyze", "dart analyze --format=json")
    success, json_output = step.execute()
    
    # Filter exclusions from JSON output
    filtered_issues = []
    try:
        data = json.loads(json_output)
        diagnostics = data.get('diagnostics', [])
        
        excludes = config.get_step_config('analyze').get('exclude', [])
        fatal_infos = config.get_step_config('analyze').get('fatal_infos', False)
        
        for issue in diagnostics:
            file_path = issue.get('location', {}).get('file', '')
            # Check exclusions
            is_excluded = False
            for pattern in excludes:
                # Simple containment check for now, can be improved with glob
                clean_pattern = pattern.replace('**', '').replace('*', '')
                if clean_pattern and clean_pattern in file_path.replace('\\', '/'):
                     is_excluded = True
                     break
            
            if not is_excluded:
                filtered_issues.append(issue)
                
        # Re-evaluate success based on filtered issues
        error_count = 0
        for issue in filtered_issues:
            severity = issue.get('severity', 'INFO')
            if severity == 'ERROR' or severity == 'WARNING' or (fatal_infos and severity == 'INFO'):
                 error_count += 1
        
        success = error_count == 0
        
        # Deterministic report (no timestamps)
        details = []
        for issue in filtered_issues:
            loc = issue.get('location', {}) or {}
            rng = loc.get('range', {}) or {}
            start = rng.get('start', {}) or {}

            details.append({
                "file": (loc.get('file', '') or '').replace('\\\\', '/'),
                "line": int(start.get('line', 0) or 0) + 1,
                "severity": issue.get('severity', 'INFO'),
                "code": issue.get('code'),
                "message": issue.get('message'),
            })

        details.sort(key=lambda d: (str(d.get('file', '')), int(d.get('line', 0)), str(d.get('code', ''))))

        write_report(
            name="analyze",
            success=success,
            summary={
                "issues": int(len(filtered_issues)),
                "total": int(len(filtered_issues)),
            },
            details=details,
        )
            
    except json.JSONDecodeError:
        pass

    if success:
        status_msg = Colors.colorize("✅ No issues found", 'success')
    else:
        status_msg = Colors.colorize(f"❌ {len(filtered_issues)} issues found", 'failure')

    return success, status_msg, json_output


def run_import_check() -> Tuple[bool, str, str]:
    """Run import checker script"""
    config = CIConfig()
    if not config.is_step_enabled('imports'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Import Check...")
    base_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(base_dir, "check_imports.py")
    
    # Use virtual environment Python
    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")
    
    step = PipelineStep("Import Check", f'"{venv_python}" "{script_path}"')
    success, output = step.execute()
    
    if success:
        status_msg = Colors.colorize("✅ Imports OK", 'success')
    else:
        status_msg = Colors.colorize("❌ Import violations found", 'failure')
        
    return success, status_msg, output


def run_freezed_check() -> Tuple[bool, str, str]:
    """Run Freezed model enforcement checker"""
    config = CIConfig()
    if not config.is_step_enabled('freezed'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Freezed Checker...")
    base_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(base_dir, "check_freezed_models.py")

    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")

    step = PipelineStep("Freezed Checker", f'"{venv_python}" "{script_path}"')
    success, output = step.execute()

    if success:
        status_msg = Colors.colorize("Freezed OK", 'success')
    else:
        status_msg = Colors.colorize("Freezed violations found", 'failure')

    return success, status_msg, output


def run_navigation_check() -> Tuple[bool, str, str]:
    """Run centralized navigation enforcement checker"""
    config = CIConfig()
    if not config.is_step_enabled('navigation'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Navigation Checker...")
    base_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(base_dir, "check_navigation_centralization.py")

    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")

    step = PipelineStep("Navigation Checker", f'"{venv_python}" "{script_path}"')
    success, output = step.execute()

    if success:
        status_msg = Colors.colorize("Navigation OK", 'success')
    else:
        status_msg = Colors.colorize("Navigation violations found", 'failure')

    return success, status_msg, output


def run_riverpod_check() -> Tuple[bool, str, str]:
    """Run Riverpod-only architecture enforcement checker"""
    config = CIConfig()
    if not config.is_step_enabled('riverpod'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Riverpod Checker...")
    base_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(base_dir, "check_riverpod_architecture.py")

    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")

    step = PipelineStep("Riverpod Checker", f'"{venv_python}" "{script_path}"')
    success, output = step.execute()

    if success:
        status_msg = Colors.colorize("Riverpod OK", 'success')
    else:
        status_msg = Colors.colorize("Riverpod violations found", 'failure')

    return success, status_msg, output


def run_coverage_check() -> Tuple[bool, str, str]:
    """Run coverage threshold check"""
    config = CIConfig()
    if not config.is_step_enabled('coverage'):
        return True, Colors.colorize("Skipped (Disabled in config)", 'neutral'), ""

    print("Running Coverage Check...")
    base_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(base_dir, "check_coverage.py")
    
    # Use virtual environment Python
    project_root = find_project_root()
    venv_python = os.path.join(project_root, ".venv", "Scripts", "python.exe")
    
    step = PipelineStep("Coverage Check", f'"{venv_python}" "{script_path}"')
    success, output = step.execute()

    # Parse numeric coverage values from script output if present
    import re
    current = None
    minimum = None
    m_curr = re.search(r"Current Coverage:\s*([0-9]+(?:\.[0-9]+)?)%", output)
    if m_curr:
        try:
            current = float(m_curr.group(1))
        except Exception:
            current = None

    m_min = re.search(r"Minimum Coverage:\s*([0-9]+(?:\.[0-9]+)?)%", output)
    if m_min:
        try:
            minimum = float(m_min.group(1))
        except Exception:
            minimum = None

    if success:
        if current is not None and minimum is not None:
            status_msg = Colors.colorize(f"✅ Coverage OK: {current:.2f}% (min {minimum:.2f}%)", 'success')
        else:
            status_msg = Colors.colorize("✅ Coverage OK", 'success')
    else:
        if current is not None and minimum is not None:
            status_msg = Colors.colorize(f"{current:.2f}% should be {minimum:.2f}% — ❌ Coverage below threshold", 'failure')
        else:
            status_msg = Colors.colorize("❌ Coverage below threshold", 'failure')

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

    # 2. Dart Analyze
    print("2. Running Dart Analyze...")
    results['analyze'] = run_dart_analyze()
    print(f"   {results['analyze'][1]}")
    print()

    # 3. Tests (includes coverage generation)
    print("3. Running Tests...")
    results['tests'] = run_tests()
    print(f"   {results['tests'][1]}")
    print()

    # 4. Coverage Check
    print("4. Checking Coverage Threshold...")
    results['coverage'] = run_coverage_check()
    print(f"   {results['coverage'][1]}")
    print()

    # 5. Import Check
    print("5. Checking Imports...")
    results['imports'] = run_import_check()
    print(f"   {results['imports'][1]}")
    print()

    # 6. Freezed Checker
    print("6. Checking Freezed Models...")
    results['freezed'] = run_freezed_check()
    print(f"   {results['freezed'][1]}")
    print()

    # 7. Navigation Checker
    print("7. Checking Navigation Centralization...")
    results['navigation'] = run_navigation_check()
    print(f"   {results['navigation'][1]}")
    print()

    # 8. Riverpod Checker
    print("8. Checking Riverpod Architecture...")
    results['riverpod'] = run_riverpod_check()
    print(f"   {results['riverpod'][1]}")
    print()

    # 9. Design System Checks
    print("9. Running Design System Checks...")
    results['design'] = run_design_system_checks()
    print(f"   {results['design'][1]}")
    print()

    return results
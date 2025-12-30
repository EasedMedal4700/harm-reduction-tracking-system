import json
import os
import sys
from typing import Dict, Any, List, Optional, Tuple
from config import Colors

from pipeline import (
    load_unified_report,
    run_design_system_checks,
    run_dart_format,
    run_dart_analyze,
    run_tests,
    run_import_check,
    run_coverage_check,
    run_freezed_check,
    run_navigation_check,
    run_riverpod_check,
    run_all_pipeline
)

def render_main_menu() -> None:
    """Render the main CI dashboard menu"""
    print("LOCAL CI DASHBOARD")
    print("────────────────────────────────")
    print("[1] Run Design System Checks")
    print("[2] View Design System Results")
    print("[3] Run Dart Format")
    print("[4] Run Dart Analyze")
    print("[5] Run Tests")
    print("[6] Run Import Check")
    print("[7] Run Coverage Check")
    print("[8] Run Freezed Checker")
    print("[9] Run Navigation Checker")
    print("[10] Run Riverpod Checker")
    print("[11] Run ALL (Format + Analyze + Tests + Checks)")
    print()
    print("[q] Quit")

def show_all_summary(results: Dict[str, Tuple[bool, str, str]]) -> Dict[str, str]:
    """Show unified summary for Run ALL and return outputs map"""
    print("LOCAL CI SUMMARY")
    print("────────────────────────────────")
    print()

    # Format results
    format_success, format_msg, format_output = results['format']
    analyze_success, analyze_msg, analyze_output = results['analyze']
    tests_success, tests_msg, tests_output = results['tests']
    imports_success, imports_msg, imports_output = results['imports']
    coverage_success, coverage_msg, coverage_output = results['coverage']
    freezed_success, freezed_msg, freezed_output = results.get('freezed', (True, '', ''))
    navigation_success, navigation_msg, navigation_output = results.get('navigation', (True, '', ''))
    riverpod_success, riverpod_msg, riverpod_output = results.get('riverpod', (True, '', ''))
    design_success, design_msg, design_output = results['design']

    print(f"Dart Format:        {format_msg}")
    print(f"Dart Analyze:       {analyze_msg}")
    print(f"Tests:              {tests_msg}")
    print(f"Import Check:       {imports_msg}")
    print(f"Coverage Check:     {coverage_msg}")
    print(f"Freezed Checker:    {freezed_msg}")
    print(f"Navigation Check:   {navigation_msg}")
    print(f"Riverpod Check:     {riverpod_msg}")
    print(f"Design System:      {design_msg}")
    print()

    # Overall status
    # Note: design_success might be False if warnings exist but are allowed, 
    # so we should rely on the success flag returned by the pipeline step which handles allow_warnings
    all_passed = (
        format_success and analyze_success and tests_success and
        imports_success and coverage_success and
        freezed_success and navigation_success and riverpod_success and
        design_success
    )
    
    overall = Colors.colorize("✅ PASS", 'success') if all_passed else Colors.colorize("❌ FAIL", 'failure')
    print(f"Overall Status: {overall}")
    print()

    print("[f] View format output")
    print("[a] View analyze output")
    print("[t] View test output")
    print("[i] View import check output")
    print("[c] View coverage check output")
    print("[m] View freezed checker output")
    print("[n] View navigation checker output")
    print("[r] View riverpod checker output")
    print("[d] View design system results")
    print("[q] Back to menu")

    return {
        'f': format_output,
        'a': analyze_output,
        't': tests_output,
        'i': imports_output,
        'c': coverage_output,
        'm': freezed_output,
        'n': navigation_output,
        'r': riverpod_output,
        'd': design_output
    }

def view_design_system_results() -> None:
    """File-first view of design system results"""
    report = load_unified_report()
    if not report:
        print("No design system results available.")
        return

    issues = report.get("issues", [])
    if not issues:
        print("No issues found!")
        return

    # Group issues by file
    files = {}
    for issue in issues:
        file_path = issue.get("file", "unknown")
        if file_path not in files:
            files[file_path] = []
        files[file_path].append(issue)

    # Show files with issue counts
    print("Files with issues:")
    print()
    file_list = list(files.keys())
    for i, file_path in enumerate(file_list, 1):
        issue_count = len(files[file_path])
        file_name = os.path.basename(file_path)
        print(f"[{i}] {file_name} ({issue_count} issues)")

    print()
    print("[b] Back to menu")

    while True:
        choice = safe_input("Select file or [b] back: ").strip().lower()
        if choice == 'b':
            break

        try:
            index = int(choice) - 1
            if 0 <= index < len(file_list):
                selected_file = file_list[index]
                show_file_issues(selected_file, files[selected_file])
            else:
                print("Invalid choice.")
        except ValueError:
            print("Invalid input.")

def show_file_issues(file_path: str, issues: List[Dict[str, Any]]) -> None:
    """Show issues for a specific file"""
    print(f"\nIssues in {os.path.basename(file_path)}:")
    print()

    for i, issue in enumerate(issues, 1):
        rule = issue.get("rule", "unknown")
        severity = issue.get("severity", "unknown")
        line = issue.get("line", 0)
        message = issue.get("message", "unknown")
        snippet = issue.get("snippet", "").strip()

        print(f"{i}. [{severity}] {rule}")
        print(f"   Line {line}: {message}")
        if snippet:
            print(f"   Code: {snippet}")
        print()

    safe_input("Press Enter to go back...")

def safe_input(prompt: str) -> str:
    """Safe input that handles EOF gracefully."""
    try:
        return input(prompt)
    except EOFError:
        print("\nInput ended (EOF). Exiting...")
        sys.exit(0)

def main():
    while True:
        render_main_menu()
        choice = safe_input("\nSelect option: ").strip().lower()

        if choice == 'q':
            break
        elif choice == '1':
            print("\n[1] Run Design System Checks")
            success, message, output = run_design_system_checks()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '2':
            print("\n[2] View Design System Results")
            view_design_system_results()
        elif choice == '3':
            print("\n[3] Run Dart Format")
            success, message, output = run_dart_format()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '4':
            print("\n[4] Run Dart Analyze")
            success, message, output = run_dart_analyze()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '5':
            print("\n[5] Run Tests")
            success, message, output = run_tests()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '6':
            print("\n[6] Run Import Check")
            success, message, output = run_import_check()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '7':
            print("\n[7] Run Coverage Check")
            success, message, output = run_coverage_check()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '8':
            print("\n[8] Run Freezed Checker")
            success, message, output = run_freezed_check()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '9':
            print("\n[9] Run Navigation Checker")
            success, message, output = run_navigation_check()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '10':
            print("\n[10] Run Riverpod Checker")
            success, message, output = run_riverpod_check()
            print(message)
            if output.strip():
                print("\nOutput:")
                print(output)
            safe_input("\nPress Enter to continue...")
        elif choice == '11':
            print("\n[11] Run ALL")
            print("Running all checks...")
            results = run_all_pipeline()
            outputs = show_all_summary(results)

            # Handle sub-menu for viewing individual outputs
            while True:
                sub_choice = safe_input("Select option: ").strip().lower()
                if sub_choice == 'q':
                    break
                elif sub_choice == 'd':
                    view_design_system_results()
                elif sub_choice in outputs:
                    print(f"\nOutput:\n{outputs[sub_choice]}")
                    safe_input("\nPress Enter to continue...")
                else:
                    print("Invalid choice.")
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()

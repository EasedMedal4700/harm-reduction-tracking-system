import json
import os
import sys
from typing import Dict, Any, List, Optional

from pipeline import (
    load_unified_report,
    run_design_system_checks,
    run_dart_format,
    run_tests,
    run_all_pipeline
)

def render_main_menu() -> None:
    """Render the main CI dashboard menu"""
    print("LOCAL CI DASHBOARD")
    print("────────────────────────────────")
    print()
    print("[1] Run Design System Checks")
    print("[2] View Design System Results")
    print()
    print("[3] Run Dart Format")
    print("[4] Run Tests")
    print()
    print("[5] Run ALL (Format + Tests + Checks)")
    print()
    print("[q] Quit")

def show_all_summary(results: Dict[str, Tuple[bool, str]]) -> None:
    """Show unified summary for Run ALL"""
    print("LOCAL CI SUMMARY")
    print("────────────────────────────────")
    print()

    # Format results
    format_success, format_msg = results['format']
    tests_success, tests_msg = results['tests']
    design_success, design_msg = results['design']

    print(f"Dart Format:        {format_msg}")
    print(f"Tests:              {tests_msg}")

    # Parse design system results
    report = load_unified_report()
    if report and "summary" in report:
        summary = report["summary"]
        blocking = summary.get("blocking", 0)
        warnings = summary.get("warnings", 0)
        if blocking > 0:
            design_status = f"❌ BLOCKING ({blocking})"
        elif warnings > 0:
            design_status = f"⚠ WARNINGS ({warnings})"
        else:
            design_status = "✅ OK"
    else:
        design_status = "❓ UNKNOWN"

    print(f"Design System:      {design_status}")
    print()

    # Overall status
    all_passed = format_success and tests_success and (blocking == 0)
    overall = "✅ PASS" if all_passed else "❌ FAIL"
    print(f"Overall Status: {overall}")
    print()

    print("[f] View format output")
    print("[t] View test output")
    print("[d] View design system results")
    print("[q] Back to menu")

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
            success, message = run_design_system_checks()
            print(message)
            safe_input("\nPress Enter to continue...")
        elif choice == '2':
            print("\n[2] View Design System Results")
            view_design_system_results()
        elif choice == '3':
            print("\n[3] Run Dart Format")
            success, message = run_dart_format()
            print(message)
            safe_input("\nPress Enter to continue...")
        elif choice == '4':
            print("\n[4] Run Tests")
            success, message = run_tests()
            print(message)
            safe_input("\nPress Enter to continue...")
        elif choice == '5':
            print("\n[5] Run ALL")
            results = run_all_pipeline()
            show_all_summary(results)

            # Handle sub-menu for viewing individual outputs
            while True:
                sub_choice = safe_input("Select option: ").strip().lower()
                if sub_choice == 'q':
                    break
                elif sub_choice == 'f':
                    print(f"\nFormat Output:\n{results['format'][1]}")
                    safe_input("\nPress Enter to continue...")
                elif sub_choice == 't':
                    print(f"\nTest Output:\n{results['tests'][1]}")
                    safe_input("\nPress Enter to continue...")
                elif sub_choice == 'd':
                    view_design_system_results()
                else:
                    print("Invalid choice.")
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()

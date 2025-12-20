import json
import os
import sys
from dataclasses import dataclass
from typing import Dict, Any, List

@dataclass
class DataSource:
    name: str
    path: str
    data: Dict[str, Any] = None

    def load(self) -> None:
        """Load JSON data from the path."""
        if os.path.exists(self.path):
            with open(self.path, 'r') as f:
                self.data = json.load(f)
        else:
            self.data = {}

def load_data_sources() -> List[DataSource]:
    """Register and return available data sources."""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    design_system_dir = os.path.join(base_dir, "design_system")
    reports_dir = os.path.join(design_system_dir, "reports")

    data_sources = [
        DataSource("Design System Report", os.path.join(reports_dir, "unified_report.json")),
    ]

    # Add summary data sources
    summaries_dir = os.path.join(reports_dir, "summaries")
    if os.path.exists(summaries_dir):
        for filename in os.listdir(summaries_dir):
            if filename.endswith('.json'):
                rule_name = filename.replace('.json', '')
                data_sources.append(DataSource(
                    f"{rule_name.title()} Summary",
                    os.path.join(summaries_dir, filename)
                ))

    # Add detail data sources
    details_dir = os.path.join(reports_dir, "details")
    if os.path.exists(details_dir):
        for filename in os.listdir(details_dir):
            if filename.endswith('_deep.json'):
                rule_name = filename.replace('_deep.json', '')
                data_sources.append(DataSource(
                    f"{rule_name.title()} Details",
                    os.path.join(details_dir, filename)
                ))

    return data_sources

def render_menu(data_sources: List[DataSource]) -> None:
    """Render the menu to select a data source."""
    print("Select a dataset to view:")
    print("[1] Design System Report (Overview)")

    # Group data sources by type
    summaries = []
    details = []

    for ds in data_sources[1:]:  # Skip the first one (unified report)
        if "Summary" in ds.name:
            summaries.append(ds)
        elif "Details" in ds.name:
            details.append(ds)

    if summaries:
        print("\nSummaries:")
        for i, ds in enumerate(summaries, 2):
            rule_name = ds.name.replace(" Summary", "")
            print(f"[{i}] {rule_name} Summary")

    if details:
        print("\nDetails:")
        for i, ds in enumerate(details, len(summaries) + 2):
            rule_name = ds.name.replace(" Details", "")
            print(f"[{i}] {rule_name} Details")

    print("\n[q] Quit")

def render_summary(data_source: DataSource) -> None:
    """Render a summary of the active data source."""
    if data_source.data is None:
        print(f"No data loaded for {data_source.name}.")
        return

    print(f"\n--- {data_source.name} ---")

    if "Design System Report" in data_source.name:
        # Unified report
        summary = data_source.data.get("summary", {})
        files_scanned = summary.get("files_scanned", 0)
        blocking_issues = summary.get("blocking", 0)
        warning_issues = summary.get("warnings", 0)
        rules_executed = summary.get("rules_executed", 0)
        print(f"Files scanned: {files_scanned}")
        print(f"Rules executed: {rules_executed}")
        print(f"Blocking issues: {blocking_issues}")
        print(f"Warning issues: {warning_issues}")

        # Show top issues by rule
        issues = data_source.data.get("issues", [])
        if issues:
            print(f"\nTop issues by rule:")
            rule_counts = {}
            for issue in issues:
                rule = issue.get("rule", "unknown")
                severity = issue.get("severity", "unknown")
                if rule not in rule_counts:
                    rule_counts[rule] = {"blocking": 0, "warning": 0}
                if severity == "BLOCKING":
                    rule_counts[rule]["blocking"] += 1
                elif severity == "WARNING":
                    rule_counts[rule]["warning"] += 1

            for rule, counts in rule_counts.items():
                print(f"  {rule}: {counts['blocking']} blocking, {counts['warning']} warnings")

    elif "Summary" in data_source.name:
        # Individual rule summary
        check = data_source.data.get("check", "unknown")
        status = data_source.data.get("status", "unknown")
        blocking = data_source.data.get("blocking_issues", 0)
        warnings = data_source.data.get("warning_issues", 0)
        files_affected = data_source.data.get("files_affected", 0)

        print(f"Check: {check}")
        print(f"Status: {status}")
        print(f"Blocking issues: {blocking}")
        print(f"Warning issues: {warnings}")
        print(f"Files affected: {files_affected}")

    elif "Details" in data_source.name:
        # Individual rule details
        check = data_source.data.get("check", "unknown")
        total_issues = data_source.data.get("total_issues", 0)
        issues = data_source.data.get("issues", [])

        print(f"Check: {check}")
        print(f"Total issues: {total_issues}")

        if issues:
            print(f"\nIssues:")
            for i, issue in enumerate(issues[:10], 1):  # Show first 10 issues
                severity = issue.get("severity", "unknown")
                message = issue.get("message", "unknown")
                file_path = issue.get("file", "unknown")
                line = issue.get("line", "unknown")
                snippet = issue.get("snippet", "").strip()

                print(f"{i}. [{severity}] {message}")
                print(f"   File: {os.path.basename(file_path)}:{line}")
                if snippet:
                    print(f"   Code: {snippet}")
                print()

            if len(issues) > 10:
                print(f"... and {len(issues) - 10} more issues")
        else:
            print("No issues found.")

    else:
        print("Unknown data source type.")

def safe_input(prompt: str) -> str:
    """Safe input that handles EOF gracefully."""
    try:
        return input(prompt)
    except EOFError:
        print("\nInput ended (EOF). Exiting...")
        sys.exit(0)

def main():
    data_sources = load_data_sources()
    active_source = None

    while True:
        if active_source is None:
            render_menu(data_sources)
            choice = safe_input("Enter choice: ").strip().lower()
            if choice == 'q':
                break
            try:
                index = int(choice) - 1
                if 0 <= index < len(data_sources):
                    active_source = data_sources[index]
                    active_source.load()
                else:
                    print("Invalid choice.")
            except ValueError:
                print("Invalid input.")
        else:
            render_summary(active_source)
            safe_input("\nPress Enter to return to menu...")
            active_source = None

if __name__ == "__main__":
    main()

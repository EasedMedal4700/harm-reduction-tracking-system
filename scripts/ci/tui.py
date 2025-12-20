import json
import os
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
    return [
        DataSource("Design System Report", os.path.join(base_dir, "design_system", "reports", "design_system_report.json")),
    ]

def render_menu(data_sources: List[DataSource]) -> None:
    """Render the menu to select a data source."""
    print("Select a dataset to view:")
    for i, ds in enumerate(data_sources, 1):
        print(f"[{i}] {ds.name}")
    print("[q] Quit")

def render_summary(data_source: DataSource) -> None:
    """Render a summary of the active data source."""
    if data_source.data is None:
        print(f"No data loaded for {data_source.name}.")
        return

    print(f"\n--- {data_source.name} Summary ---")
    if data_source.name == "Design System Report":
        summary = data_source.data.get("summary", {})
        files_scanned = summary.get("files_scanned", 0)
        blocking_issues = summary.get("blocking_issues", 0)
        warning_issues = summary.get("warning_issues", 0)
        print(f"Files scanned: {files_scanned}")
        print(f"Blocking issues: {blocking_issues}")
        print(f"Warning issues: {warning_issues}")
    else:
        print("Unknown data source type.")

def main():
    data_sources = load_data_sources()
    active_source = None

    while True:
        if active_source is None:
            render_menu(data_sources)
            choice = input("Enter choice: ").strip().lower()
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
            input("\nPress Enter to return to menu...")
            active_source = None

if __name__ == "__main__":
    main()

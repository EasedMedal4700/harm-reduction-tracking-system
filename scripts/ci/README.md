# CI Tools for Flutter Projects

This directory contains various CI and development tools for Flutter projects.

## Design System Checker v1.0

Unified design system validation tool for Flutter projects.

### Architecture

```
scripts/ci/design_system/
├── models.py              # Data models (Issue, Severity, etc.)
├── checker.py             # Core checker orchestrates all rules
├── report_writer.py       # JSON report generation
├── run.py                 # Main entrypoint (use this!)
├── rules/                 # Modular rule plugins
│   ├── color_and_theme.py
│   ├── layout_constants.py
│   ├── animation_constants.py
│   └── theme_wiring.py
├── reports/               # Generated reports
│   ├── unified_report.json    # New unified format
│   ├── summaries/             # Backward compatible summaries
│   └── details/               # Backward compatible details
└── ../TUI.py              # Terminal UI (reads unified reports)
```

### Usage

```bash
# Run all checks (from scripts/ci/design_system/)
cd scripts/ci/design_system
python run.py

# Specify custom paths
python run.py --project-root /path/to/project --reports-dir /path/to/reports

# Quiet mode (JSON only, no stdout) - perfect for CI
python run.py --quiet
```

### Key Features

- **Modular Rules**: Each rule is a plugin that returns structured Issue objects
- **Unified Report**: Single JSON with all violations and summary statistics
- **Zero Stdout**: Only writes JSON reports, no console output
- **Backward Compatible**: Still generates old-format reports for existing tools
- **TUI Support**: Updated terminal interface reads unified reports

## Terminal User Interface (TUI)

The TUI provides an interactive way to view design system reports without needing to read raw JSON.

### How to Run the TUI

```bash
# From scripts/ci directory
cd scripts/ci
python TUI.py
```

### TUI Workflow

1. **Launch**: Run `python TUI.py`
2. **Select Dataset**: Choose `[1] Design System Report`
3. **View Summary**: See comprehensive statistics:
   - Files scanned
   - Rules executed
   - Blocking issues (must fix)
   - Warning issues (should fix)
   - Breakdown by rule type
4. **Navigate**: Press `Enter` to return to menu
5. **Quit**: Type `q` to exit

### Example TUI Output

```
Select a dataset to view:
[1] Design System Report
[q] Quit
Enter choice: 1

--- Design System Report Summary ---
Files scanned: 219
Rules executed: 4
Blocking issues: 23
Warning issues: 130

Top issues by rule:
  color_and_theme: 23 blocking, 0 warnings
  layout_constants: 0 blocking, 95 warnings
  animation_constants: 0 blocking, 35 warnings

Press Enter to return to menu...
```

### TUI Tips

- **Always run checks first**: Use `python design_system/run.py` before viewing reports
- **Check regularly**: Run during development to catch issues early
- **Focus on blocking issues**: These prevent CI from passing
- **Address warnings**: Improve code quality by fixing warnings over time

## Rule Development

Rules are simple functions that take a list of files and return Issues:

```python
def run(files: List[Path]) -> List[Issue]:
    issues = []
    for file_path in files:
        # Check file and create Issue objects
        issues.append(Issue(...))
    return issues
```

## Migration Notes

- Old `run_all.py` is deprecated - use `run.py`
- Old `design_system_report.json` replaced by `unified_report.json`
- All existing report formats still generated for compatibility
"""
Design System Checker v1.0 - Core Checker

Orchestrates all design system rules and produces unified reports.
"""

import time
import importlib
import os
from pathlib import Path
from typing import List, Dict, Any
from models import Issue, RuleResult, UnifiedReport, Severity


class DesignSystemChecker:
    """Main checker that runs all design system rules"""

    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.features_dir = project_root / "lib" / "features"
        self.rules_dir = Path(__file__).parent / "rules"

    def discover_dart_files(self) -> List[Path]:
        """Find all Dart files in lib/features/**"""
        dart_files = []
        if not self.features_dir.exists():
            return dart_files

        for root, _, files in os.walk(self.features_dir):
            for filename in files:
                if filename.endswith(".dart"):
                    dart_files.append(Path(root) / filename)

        return dart_files

    def load_rules(self) -> Dict[str, callable]:
        """Dynamically load all rule modules"""
        rules = {}

        # Auto-discover all rule files in the rules directory
        if not self.rules_dir.exists():
            return rules

        for rule_file in self.rules_dir.glob("*.py"):
            if rule_file.name == "__init__.py":
                continue

            rule_name = rule_file.stem  # Remove .py extension
            try:
                # Import from rules package
                module = importlib.import_module(f"rules.{rule_name}")
                if hasattr(module, "run"):
                    rules[rule_name] = module.run
            except ImportError as e:
                # Skip rules that can't be loaded
                print(f"Warning: Could not load rule {rule_name}: {e}")
                continue

        return rules

    def run_all_rules(self, files: List[Path]) -> List[RuleResult]:
        """Run all available rules on the given files"""
        rules = self.load_rules()
        results = []

        for rule_name, rule_func in rules.items():
            start_time = time.time()

            try:
                issues = rule_func(files)
                execution_time = time.time() - start_time

                result = RuleResult(
                    rule_name=rule_name,
                    issues=issues,
                    files_scanned=len(files),
                    execution_time=execution_time
                )
                results.append(result)

            except Exception as e:
                # Create a result with error information
                error_issue = Issue(
                    rule=rule_name,
                    severity=Severity.BLOCKING,
                    file=Path("unknown"),
                    line=0,
                    message=f"Rule execution failed: {str(e)}",
                    snippet="",
                    ignored=False
                )
                result = RuleResult(
                    rule_name=rule_name,
                    issues=[error_issue],
                    files_scanned=len(files),
                    execution_time=time.time() - start_time
                )
                results.append(result)

        return results

    def create_unified_report(self, rule_results: List[RuleResult]) -> UnifiedReport:
        """Merge all rule results into a single unified report"""
        all_issues = []
        total_blocking = 0
        total_warnings = 0
        total_files = 0

        for result in rule_results:
            all_issues.extend(result.issues)
            total_files = max(total_files, result.files_scanned)

            for issue in result.issues:
                if issue.severity == Severity.BLOCKING:
                    total_blocking += 1
                elif issue.severity == Severity.WARNING:
                    total_warnings += 1

        summary = {
            "files_scanned": total_files,
            "blocking": total_blocking,
            "warnings": total_warnings,
            "rules_executed": len(rule_results)
        }

        return UnifiedReport(
            summary=summary,
            issues=all_issues
        )

    def check(self) -> UnifiedReport:
        """Run the complete design system check"""
        # Discover files
        files = self.discover_dart_files()

        # Run all rules
        rule_results = self.run_all_rules(files)

        # Create unified report
        report = self.create_unified_report(rule_results)

        return report
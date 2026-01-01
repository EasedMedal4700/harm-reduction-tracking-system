"""
Design System Checker v1.0 - Core Checker

Orchestrates all design system rules and produces unified reports.
"""

import time
import importlib
import os
import subprocess
from pathlib import Path
from typing import List, Dict, Any, Set
from models import Issue, RuleResult, UnifiedReport, Severity, RuleClass


class DesignSystemChecker:
    """Main checker that runs all design system rules"""

    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.features_dir = project_root / "lib" / "features"
        self.rules_dir = Path(__file__).parent / "rules"
        self.modified_files = self.get_modified_files()

    def get_modified_files(self) -> Set[Path]:
        """Get set of files that are modified or staged in git"""
        modified = set()
        try:
            # Get staged files
            result = subprocess.run(
                ["git", "diff", "--cached", "--name-only"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0:
                for line in result.stdout.strip().split('\n'):
                    if line.strip():
                        modified.add(self.project_root / line.strip())

            # Get unstaged modified files
            result = subprocess.run(
                ["git", "diff", "--name-only"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0:
                for line in result.stdout.strip().split('\n'):
                    if line.strip():
                        modified.add(self.project_root / line.strip())

            # Get untracked files
            result = subprocess.run(
                ["git", "ls-files", "--others", "--exclude-standard"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0:
                for line in result.stdout.strip().split('\n'):
                    if line.strip():
                        modified.add(self.project_root / line.strip())

        except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
            # If git fails, assume no files are modified
            pass

        return modified

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

                # Set severity for each issue based on file modification status
                for issue in issues:
                    is_modified = issue.file in self.modified_files
                    issue.severity = issue.get_severity(is_modified)

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
                    rule_class=RuleClass.CORRECTNESS,  # Errors are correctness issues
                    severity=Severity.BLOCK,
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
        total_block = 0
        total_must_fix = 0
        total_should_fix = 0
        total_logonly = 0
        total_files = 0

        for result in rule_results:
            all_issues.extend(result.issues)
            total_files = max(total_files, result.files_scanned)

            for issue in result.issues:
                if issue.severity == Severity.BLOCK:
                    total_block += 1
                elif issue.severity == Severity.MUST_FIX:
                    total_must_fix += 1
                elif issue.severity == Severity.SHOULD_FIX:
                    total_should_fix += 1
                elif issue.severity == Severity.LOGONLY:
                    total_logonly += 1

        summary = {
            "files_scanned": total_files,
            "block": total_block,
            "must_fix": total_must_fix,
            "should_fix": total_should_fix,
            "logonly": total_logonly,
            "blocking": total_block + total_must_fix,  # Backward compatibility
            "warnings": total_should_fix + total_logonly,  # Backward compatibility
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
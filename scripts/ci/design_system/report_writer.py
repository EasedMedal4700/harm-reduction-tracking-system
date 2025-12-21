"""
Design System Checker v1.0 - Report Writer

Handles JSON report generation with backward compatibility.
"""

import json
from pathlib import Path
from typing import Dict, Any
from models import UnifiedReport, Issue, Severity


class ReportWriter:
    """Handles writing unified reports and maintaining backward compatibility"""

    def __init__(self, reports_dir: Path):
        self.reports_dir = reports_dir
        self.summaries_dir = reports_dir / "summaries"
        self.details_dir = reports_dir / "details"

        # Ensure directories exist
        self.summaries_dir.mkdir(parents=True, exist_ok=True)
        self.details_dir.mkdir(parents=True, exist_ok=True)

    def write_unified_report(self, report: UnifiedReport, filename: str = "unified_report.json") -> Path:
        """Write the unified JSON report"""
        output_file = self.reports_dir / filename
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(report.to_dict(), f, indent=2)
        return output_file

    def write_backward_compatible_reports(self, report: UnifiedReport) -> Dict[str, Path]:
        """Write reports in the old format for backward compatibility"""
        written_files = {}

        # Group issues by rule
        issues_by_rule = {}
        for issue in report.issues:
            if issue.rule not in issues_by_rule:
                issues_by_rule[issue.rule] = []
            issues_by_rule[issue.rule].append(issue)

        # Write summary files for all rules
        rule_mappings = {
            "color_and_theme": "colors",
            "layout_constants": "layout",
            "animation_constants": "animations",
            "typography": "typography",
            "spacing": "spacing",
            "accessibility": "accessibility",
            "localization": "localization",
            "component_usage": "component_usage",
            "asset_usage": "asset_usage",
            "performance": "performance",
            "theme_wiring": "theme_wiring"
        }

        for rule_name, short_name in rule_mappings.items():
            issues = issues_by_rule.get(rule_name, [])
            blocking_count = sum(1 for i in issues if i.severity in [Severity.BLOCK, Severity.MUST_FIX])
            warning_count = sum(1 for i in issues if i.severity in [Severity.SHOULD_FIX, Severity.LOGONLY])
            affected_files = len(set(str(i.file) for i in issues))

            summary_data = {
                "check": f"{short_name}_check",
                "status": "FAIL" if blocking_count > 0 else "PASS",
                "blocking_issues": blocking_count,
                "warning_issues": warning_count,
                "files_affected": affected_files
            }

            summary_file = self.summaries_dir / f"{short_name}.json"
            with open(summary_file, "w", encoding="utf-8") as f:
                json.dump(summary_data, f, indent=2)
            written_files[f"{short_name}_summary"] = summary_file

        # Write detailed files for all rules
        for rule_name, short_name in rule_mappings.items():
            issues = issues_by_rule.get(rule_name, [])

            # Convert issues to detailed format
            detailed_issues = []
            for issue in issues:
                detailed_issues.append({
                    "severity": issue.severity.value,
                    "message": issue.message,
                    "line": issue.line,
                    "snippet": issue.snippet,
                    "file": str(issue.file)
                })

            detail_data = {
                "check": f"{short_name}_check",
                "total_issues": len(detailed_issues),
                "issues": detailed_issues
            }

            detail_file = self.details_dir / f"{short_name}_deep.json"
            with open(detail_file, "w", encoding="utf-8") as f:
                json.dump(detail_data, f, indent=2)
            written_files[f"{short_name}_details"] = detail_file

        return written_files

    def write_all_reports(self, report: UnifiedReport) -> Dict[str, Path]:
        """Write all reports: unified + backward compatible"""
        written_files = {}

        # Write unified report
        unified_file = self.write_unified_report(report)
        written_files["unified"] = unified_file

        # Write backward compatible reports
        backward_files = self.write_backward_compatible_reports(report)
        written_files.update(backward_files)

        return written_files
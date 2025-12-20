"""
Design System Checker v1.0 - Data Models

Unified data structures for the design system checker.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import List, Dict, Any
from enum import Enum


class Severity(Enum):
    """Issue severity levels"""
    BLOCKING = "BLOCKING"
    WARNING = "WARNING"


@dataclass
class Issue:
    """Represents a single design system violation"""
    rule: str
    severity: Severity
    file: Path
    line: int
    message: str
    snippet: str
    ignored: bool = False

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization"""
        return {
            "rule": self.rule,
            "severity": self.severity.value,
            "file": str(self.file),
            "line": self.line,
            "message": self.message,
            "snippet": self.snippet,
            "ignored": self.ignored
        }


@dataclass
class RuleResult:
    """Result from running a single rule"""
    rule_name: str
    issues: List[Issue]
    files_scanned: int
    execution_time: float = 0.0


@dataclass
class UnifiedReport:
    """Complete report from all rules"""
    summary: Dict[str, Any]
    issues: List[Issue]

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization"""
        return {
            "summary": self.summary,
            "issues": [issue.to_dict() for issue in self.issues]
        }
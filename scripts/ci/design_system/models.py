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
    BLOCK = "BLOCK"
    MUST_FIX = "MUST_FIX"
    SHOULD_FIX = "SHOULD_FIX"
    LOGONLY = "LOGONLY"


class RuleClass(Enum):
    """Rule classification"""
    CORRECTNESS = "Correctness"
    ARCHITECTURE = "Architecture"
    DESIGN_SYSTEM = "DesignSystem"
    HYGIENE = "Hygiene"


class EnforcementMode(Enum):
    """Enforcement modes"""
    LOG_ONLY = "LogOnly"
    WARN = "Warn"
    ENFORCE_NEW_CODE = "EnforceNewCode"
    HARD_BLOCK = "HardBlock"


@dataclass
class Issue:
    """Represents a single design system violation"""
    rule: str
    rule_class: RuleClass
    file: Path
    line: int
    message: str
    snippet: str
    severity: Severity = None
    ignored: bool = False

    def __post_init__(self):
        """Set severity based on rule class if not explicitly set"""
        if self.severity is None:
            self.severity = self.get_severity()

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization"""
        return {
            "rule": self.rule,
            "rule_class": self.rule_class.value,
            "severity": self.severity.value,
            "file": str(self.file),
            "line": self.line,
            "message": self.message,
            "snippet": self.snippet,
            "ignored": self.ignored
        }

    def get_severity(self, is_new_code: bool = False) -> Severity:
        """Determine severity based on rule class - all code treated equally"""
        if self.rule_class == RuleClass.CORRECTNESS:
            return Severity.BLOCK
        elif self.rule_class in [RuleClass.ARCHITECTURE, RuleClass.DESIGN_SYSTEM]:
            return Severity.MUST_FIX  # Important design/architecture issues
        elif self.rule_class == RuleClass.HYGIENE:
            return Severity.SHOULD_FIX  # Minor issues
        return Severity.SHOULD_FIX


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
    

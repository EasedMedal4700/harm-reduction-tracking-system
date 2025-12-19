#!/usr/bin/env python3
"""
Copilot Helper — Structured TUI for Controlled Iteration

Purpose:
- Review Copilot output
- Request small, scoped changes
- Generate continuation prompts
- Avoid open-ended chat failures

No AI simulation. No APIs. No background runners.
This tool structures YOUR intent for Copilot.
"""

import datetime
import json
import sys

STATE = {
    "last_batch_files": [],
    "review_notes": [],
    "issues": [],
    "pending_change": None,
}

RULES = [
    "Only allowed theme import:",
    "import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';",
    "No hardcoded spacing, colors, or font sizes",
    "Use common widgets wherever possible",
    "Work in controlled batches",
    "Run flutter analyze after each batch",
    "Stop immediately on any new error",
]

def now():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def pause():
    input("\nPress Enter to continue...")

def header(title):
    print("\n" + "=" * 60)
    print(title)
    print("=" * 60)

def main_menu():
    header("Copilot Control Panel")
    print("1. Set / update last batch files")
    print("2. Review last batch")
    print("3. Request small change")
    print("4. Generate continuation prompt")
    print("5. Show migration rules")
    print("6. Exit")
    return input("\nSelect option: ").strip()

# ─────────────────────────────────────────────

def set_last_batch():
    header("Set Last Batch Files")
    files = input("Enter file names (comma separated): ").strip()
    STATE["last_batch_files"] = [f.strip() for f in files.split(",") if f.strip()]
    print("Saved batch files:")
    for f in STATE["last_batch_files"]:
        print(f"- {f}")
    pause()

def review_batch():
    header("Review Last Batch")
    if not STATE["last_batch_files"]:
        print("No batch files set.")
        pause()
        return

    print("Files reviewed:")
    for f in STATE["last_batch_files"]:
        print(f"- {f}")

    status = input("\nOverall status (ok / minor / major): ").strip().lower()
    notes = input("Review notes (optional): ").strip()

    STATE["review_notes"].append({
        "time": now(),
        "status": status,
        "notes": notes,
    })

    if status != "ok":
        issue = input("Describe the issue found: ").strip()
        STATE["issues"].append(issue)

    print("Review recorded.")
    pause()

def request_small_change():
    header("Request Small Change")

    print("Change types:")
    print("1. Fix spacing")
    print("2. Replace deprecated widget")
    print("3. Rename variable / method")
    print("4. Update import")
    print("5. Revert specific change")

    choice = input("Select change type: ").strip()

    change_map = {
        "1": "Fix spacing",
        "2": "Replace deprecated widget",
        "3": "Rename variable / method",
        "4": "Update import",
        "5": "Revert specific change",
    }

    change_type = change_map.get(choice)
    if not change_type:
        print("Invalid choice.")
        pause()
        return

    target_file = input("Target file: ").strip()
    details = input("Exact change details: ").strip()

    STATE["pending_change"] = {
        "type": change_type,
        "file": target_file,
        "details": details,
    }

    print("Pending change recorded.")
    pause()

def generate_prompt():
    header("Generated Copilot Continuation Prompt")

    print("📌 CONTINUATION TASK — CONTROLLED CHANGE\n")

    if STATE["last_batch_files"]:
        print("LAST BATCH FILES:")
        for f in STATE["last_batch_files"]:
            print(f"- {f}")
        print()

    if STATE["review_notes"]:
        print("REVIEW SUMMARY:")
        for r in STATE["review_notes"][-1:]:
            print(f"- Status: {r['status']}")
            if r["notes"]:
                print(f"  Notes: {r['notes']}")
        print()

    if STATE["issues"]:
        print("ISSUES FOUND:")
        for i in STATE["issues"]:
            print(f"- {i}")
        print()

    if STATE["pending_change"]:
        pc = STATE["pending_change"]
        print("REQUESTED CHANGE (SCOPE IS STRICT):")
        print(f"- Type: {pc['type']}")
        print(f"- File: {pc['file']}")
        print(f"- Details: {pc['details']}")
        print()

    print("RULES (NON-NEGOTIABLE):")
    for r in RULES:
        print(f"- {r}")

    print("\nINSTRUCTIONS:")
    print("- Apply ONLY the requested change")
    print("- Do NOT refactor unrelated code")
    print("- Re-run flutter analyze")
    print("- Stop and report results")

    print("\nBEGIN WORK NOW.")
    pause()

def show_rules():
    header("Migration Rules")
    for r in RULES:
        print(f"- {r}")
    pause()

# ─────────────────────────────────────────────

def main():
    while True:
        choice = main_menu()

        if choice == "1":
            set_last_batch()
        elif choice == "2":
            review_batch()
        elif choice == "3":
            request_small_change()
        elif choice == "4":
            generate_prompt()
        elif choice == "5":
            show_rules()
        elif choice == "6":
            print("Exiting Copilot Helper.")
            sys.exit(0)
        else:
            print("Invalid option.")
            pause()

if __name__ == "__main__":
    main()

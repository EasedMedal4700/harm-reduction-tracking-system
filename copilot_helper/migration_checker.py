#!/usr/bin/env python3
"""
Migration Checker TUI
Processes a list of files in batches of 36 and prompts the reviewer after each
batch whether the changes are correct and whether to continue.

Usage:
  - Run `python copilot_helper/migration_checker.py` and follow prompts.
  - You can paste a comma-separated list of file paths, or point to a file
    containing one path per line.
"""

import json
import math
import os
import sys
from typing import List

BATCH_SIZE = 36
STATE_FILE = "migration_state.json"


def read_file_list_from_input() -> List[str]:
    inp = input("Enter file paths (comma-separated) or path to a file listing files: ").strip()
    if not inp:
        return []
    if os.path.exists(inp) and os.path.isfile(inp):
        with open(inp, 'r', encoding='utf-8') as f:
            lines = [l.strip() for l in f.readlines() if l.strip()]
        return lines
    # else treat as comma-separated
    return [p.strip() for p in inp.split(',') if p.strip()]


def save_state(state: dict):
    with open(STATE_FILE, 'w', encoding='utf-8') as f:
        json.dump(state, f, indent=2)


def load_state():
    if not os.path.exists(STATE_FILE):
        return None
    try:
        with open(STATE_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception:
        return None


def prompt_yes_no(question: str, default: bool = True) -> bool:
    yes = 'Y' if default else 'y'
    no = 'n' if default else 'N'
    while True:
        ans = input(f"{question} [{yes}/{no}]: ").strip().lower()
        if not ans:
            return default
        if ans in ('y', 'yes'):
            return True
        if ans in ('n', 'no'):
            return False
        print("Please answer 'y' or 'n'.")


def process_batches(files: List[str]):
    total = len(files)
    if total == 0:
        print("No files provided. Exiting.")
        return

    total_batches = math.ceil(total / BATCH_SIZE)
    state = {'files': files, 'index': 0, 'approved_batches': [], 'issues': []}

    # If there's an existing state, offer to resume
    existing = load_state()
    if existing and existing.get('files') == files:
        if prompt_yes_no('Found existing migration state for these files. Resume?'):
            state = existing
            print(f"Resuming at file index {state['index']}.")

    while state['index'] < total:
        start = state['index']
        end = min(total, start + BATCH_SIZE)
        batch = files[start:end]
        batch_no = (start // BATCH_SIZE) + 1

        print('\n' + '=' * 60)
        print(f"Batch {batch_no}/{total_batches} — files {start + 1}..{end} of {total}")
        for f in batch:
            print(f" - {f}")

        # Simulate that Copilot has applied changes; reviewer inspects and answers
        correct = prompt_yes_no('Are the changes for this batch correct?', default=True)
        if not correct:
            issue = input('Describe the issue found (brief): ').strip()
            state['issues'].append({'batch': batch_no, 'issue': issue})
            print('Pausing migration. State saved to', STATE_FILE)
            save_state(state)
            return

        # mark approved
        state['approved_batches'].append(batch_no)
        state['index'] = end
        save_state(state)

        if state['index'] >= total:
            print('\nAll files processed and approved.')
            if os.path.exists(STATE_FILE):
                os.remove(STATE_FILE)
            return

        cont = prompt_yes_no('Apply next 36 files now?', default=True)
        if not cont:
            print('Migration paused by reviewer. State saved to', STATE_FILE)
            save_state(state)
            return

    print('Done.')


def main():
    print('Migration Checker — batch review helper')
    print('Batch size:', BATCH_SIZE)

    files = read_file_list_from_input()
    if not files:
        print('No files provided.')
        return

    process_batches(files)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nInterrupted by user.')
        sys.exit(1)

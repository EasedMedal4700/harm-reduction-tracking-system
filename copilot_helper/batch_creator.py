#!/usr/bin/env python3
"""
Batch Creator Script
Creates batches of 36 files from a given folder, recursively scanning for files.
Outputs batch_1.txt, batch_2.txt, etc., with relative paths.

Usage:
  python batch_creator.py <folder_path>
  or
  python batch_creator.py  # prompts for folder path
"""

import os
import sys
from typing import List

BATCH_SIZE = 36

def get_all_files(folder_path: str) -> List[str]:
    """Recursively get all files in the folder, relative to the current working directory."""
    files = []
    for root, dirs, filenames in os.walk(folder_path):
        for filename in filenames:
            full_path = os.path.join(root, filename)
            # Make relative to current directory
            rel_path = os.path.relpath(full_path, os.getcwd())
            files.append(rel_path)
    return sorted(files)  # Sort for consistency

def create_batches(files: List[str], output_prefix: str = "batch"):
    """Create batch files with 36 files each."""
    # Create batch folder if it doesn't exist
    batch_dir = "copilot_helper/batch"
    os.makedirs(batch_dir, exist_ok=True)
    
    total_files = len(files)
    num_batches = (total_files + BATCH_SIZE - 1) // BATCH_SIZE  # Ceiling division

    for i in range(num_batches):
        batch_num = i + 1
        start_idx = i * BATCH_SIZE
        end_idx = min((i + 1) * BATCH_SIZE, total_files)
        batch_files = files[start_idx:end_idx]

        batch_filename = f"{output_prefix}_{batch_num}.txt"
        batch_path = os.path.join(batch_dir, batch_filename)
        with open(batch_path, 'w', encoding='utf-8') as f:
            for file_path in batch_files:
                f.write(file_path + '\n')

        print(f"Created {batch_path} with {len(batch_files)} files.")

def main():
    if len(sys.argv) > 1:
        folder_path = sys.argv[1]
    else:
        folder_path = input("Enter the folder path to scan: ").strip()

    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        sys.exit(1)

    if not os.path.isdir(folder_path):
        print(f"Error: '{folder_path}' is not a directory.")
        sys.exit(1)

    print(f"Scanning folder: {folder_path}")
    files = get_all_files(folder_path)
    print(f"Found {len(files)} files.")

    if not files:
        print("No files found. Exiting.")
        sys.exit(0)

    create_batches(files)
    print("Batch creation complete.")

if __name__ == "__main__":
    main()

import os
import re
from collections import Counter

def extract_status_from_header(header, key):
    match = re.search(rf'{key}\s*:\s*(COMPLETE|PARTIAL|TODO)', header, re.IGNORECASE)
    if match:
        return match.group(1).upper()
    return None

def scan_widget_files(widget_dir):
    files_info = []
    theme_counts = Counter()
    common_counts = Counter()
    riverpod_counts = Counter()
    total = 0
    for root, _, files in os.walk(widget_dir):
        for fname in files:
            if fname.endswith('.dart'):
                fpath = os.path.join(root, fname)
                try:
                    with open(fpath, 'r', encoding='utf-8') as f:
                        content = f.read(300)
                    theme_status = extract_status_from_header(content, 'Theme')
                    common_status = extract_status_from_header(content, 'Common')
                    riverpod_status = extract_status_from_header(content, 'Riverpod')
                    files_info.append({
                        'path': fpath,
                        'Theme': theme_status,
                        'Common': common_status,
                        'Riverpod': riverpod_status
                    })
                    if theme_status:
                        theme_counts[theme_status] += 1
                    if common_status:
                        common_counts[common_status] += 1
                    if riverpod_status:
                        riverpod_counts[riverpod_status] += 1
                    total += 1
                except Exception as e:
                    print(f"Error reading {fpath}: {e}")
    return files_info, theme_counts, common_counts, riverpod_counts, total

def print_percentages(counts, total, label):
    print(f"{label} Migration Status:")
    for k in ["COMPLETE", "PARTIAL", "TODO"]:
        v = counts.get(k, 0)
        percent = (v / total * 100) if total else 0
        print(f"  {k}: {v} files ({percent:.1f}%)")
    print()


def tui():
    widget_dir = os.path.join(os.path.dirname(__file__), '../lib/widgets')
    files_info, theme_counts, common_counts, riverpod_counts, total = scan_widget_files(widget_dir)
    print(f"Total widget files scanned: {total}\n")
    print_percentages(theme_counts, total, "Theme")
    print_percentages(common_counts, total, "Common")
    print_percentages(riverpod_counts, total, "Riverpod")
    overall_complete = theme_counts.get("COMPLETE", 0)
    print(f"Overall THEME completion: {overall_complete / total * 100:.1f}%\n")

    categories = ['Theme', 'Common', 'Riverpod']
    print("Select migration header to deep dive:")
    for i, cat in enumerate(categories, 1):
        print(f"  {i}. {cat}")
    cat_choice = input("Enter number (1-3): ").strip()
    try:
        cat_idx = int(cat_choice) - 1
        if cat_idx not in range(3):
            raise ValueError
    except ValueError:
        print("Invalid selection.")
        return
    category = categories[cat_idx]

    statuses = ['COMPLETE', 'PARTIAL', 'TODO']
    print(f"Select status for {category}:")
    for i, stat in enumerate(statuses, 1):
        print(f"  {i}. {stat}")
    stat_choice = input("Enter number (1-3): ").strip()
    try:
        stat_idx = int(stat_choice) - 1
        if stat_idx not in range(3):
            raise ValueError
    except ValueError:
        print("Invalid selection.")
        return
    status = statuses[stat_idx]

    print(f"\nFiles with {category}: {status}")
    found = False
    for info in files_info:
        if info.get(category) == status:
            print(f"- {os.path.relpath(info['path'], widget_dir)}")
            found = True
    if not found:
        print("(None found)")

if __name__ == "__main__":
    tui()

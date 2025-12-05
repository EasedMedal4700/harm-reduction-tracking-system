import argparse
import subprocess
import sys

def run_scrapers():
    print("🔵 Running scrapers...")
    subprocess.run([sys.executable, "-m", "backend.scrapers.run_scrapers"])

def run_normalizer():
    print("🟢 Normalizing scraped data...")
    subprocess.run([sys.executable, "-m", "backend.processors.normalize_data"])

def run_diff():
    print("🟡 Generating DB diff...")
    subprocess.run([sys.executable, "-m", "backend.processors.generate_diff"])

def main():
    parser = argparse.ArgumentParser(description="Data Pipeline Runner")
    parser.add_argument("steps", nargs="+", help="Steps to run: scrape normalize diff all")

    args = parser.parse_args()
    steps = args.steps

    if "all" in steps:
        run_scrapers()
        run_normalizer()
        run_diff()
        return

    if "scrape" in steps:
        run_scrapers()

    if "normalize" in steps:
        run_normalizer()

    if "diff" in steps:
        run_diff()


if __name__ == "__main__":
    main()

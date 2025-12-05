import os
from datetime import datetime

DATA_DIR = "data"
SCRAPED_DIR = os.path.join(DATA_DIR, "scraped")
CLEANED_DIR = os.path.join(DATA_DIR, "cleaned")
DIFF_DIR = os.path.join(DATA_DIR, "diff")
LOG_DIR = os.path.join(DATA_DIR, "logs")

# timestamp used in filenames
def timestamp():
    return datetime.now().strftime("%Y%m%d")

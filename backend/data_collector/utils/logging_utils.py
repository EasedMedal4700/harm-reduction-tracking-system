import logging
import os
from .config import LOG_DIR

os.makedirs(LOG_DIR, exist_ok=True)

logging.basicConfig(
    filename=os.path.join(LOG_DIR, "pipeline.log"),
    level=logging.INFO,
    format="%(asctime)s — %(levelname)s — %(message)s",
)

log = logging.getLogger()

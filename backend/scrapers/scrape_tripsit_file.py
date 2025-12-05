import requests
from backend.utils.logging_utils import log

TRIPSIT_FILE = "https://raw.githubusercontent.com/TripSit/drugs/master/drugs.json"

def scrape_tripsit_file():
    try:
        log.info("[TripSit JSON] Fetching full dataset...")

        res = requests.get(TRIPSIT_FILE, timeout=10)

        if res.status_code != 200:
            return {
                "drug": "ALL",
                "source": "tripsit_json",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": {}
            }

        return {
            "drug": "ALL",
            "source": "tripsit_json",
            "ok": True,
            "error": None,
            "raw": res.json(),
        }

    except Exception as e:
        log.error(f"[TripSit JSON] Error: {e}")
        return {
            "drug": "ALL",
            "source": "tripsit_json",
            "ok": False,
            "error": str(e),
            "raw": {}
        }

if __name__ == "__main__":
    data = scrape_tripsit_file()
    print(data)
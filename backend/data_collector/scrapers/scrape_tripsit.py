import requests
from backend.utils.logging_utils import log

TRIPSIT_URL = "https://tripbot.tripsit.me/api/tripsit/getDrug?name={}"

def scrape_tripsit(drug_name: str) -> dict:
    try:
        url = TRIPSIT_URL.format(drug_name)
        log.info(f"[TripSit] Scraping {drug_name}")

        res = requests.get(url, timeout=10)

        if res.status_code != 200:
            return {
                "drug": drug_name,
                "source": "tripsit",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": {}
            }

        data = res.json()

        if "data" not in data or not data["data"]:
            return {
                "drug": drug_name,
                "source": "tripsit",
                "ok": False,
                "error": "TripSit returned no drug data",
                "raw": {}
            }

        return {
            "drug": drug_name,
            "source": "tripsit",
            "ok": True,
            "error": None,
            "raw": data,
        }

    except Exception as e:
        log.error(f"[TripSit] Error scraping {drug_name}: {e}")
        return {
            "drug": drug_name,
            "source": "tripsit",
            "ok": False,
            "error": str(e),
            "raw": {}
        }

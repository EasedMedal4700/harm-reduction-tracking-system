import requests
from backend.utils.logging_utils import log

WIKI_API = "https://en.wikipedia.org/w/api.php"

def scrape_wikipedia(drug_name: str) -> dict:
    try:
        log.info(f"[Wikipedia] Scraping {drug_name}")

        params = {
            "action": "query",
            "prop": "extracts",
            "exintro": True,
            "titles": drug_name,
            "format": "json",
        }

        res = requests.get(WIKI_API, params=params, timeout=10)

        if res.status_code != 200:
            return {
                "drug": drug_name,
                "source": "wikipedia",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": {}
            }

        data = res.json()

        pages = data.get("query", {}).get("pages", {})

        # Missing page indicator
        if "-1" in pages:
            return {
                "drug": drug_name,
                "source": "wikipedia",
                "ok": False,
                "error": "Page not found",
                "raw": {}
            }

        return {
            "drug": drug_name,
            "source": "wikipedia",
            "ok": True,
            "error": None,
            "raw": data,
        }

    except Exception as e:
        log.error(f"[Wikipedia] Error scraping {drug_name}: {e}")
        return {
            "drug": drug_name,
            "source": "wikipedia",
            "ok": False,
            "error": str(e),
            "raw": {}
        }

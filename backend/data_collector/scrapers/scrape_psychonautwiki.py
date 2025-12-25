import requests
from backend.utils.logging_utils import log

PW_API = "https://psychonautwiki.org/w/api.php"

def scrape_psychonautwiki(drug_name: str) -> dict:
    try:
        params = {
            "action": "parse",
            "page": drug_name,
            "prop": "text",
            "format": "json",
        }

        log.info(f"[PW] Scraping {drug_name}")

        res = requests.get(PW_API, params=params, timeout=10)

        if res.status_code != 200:
            return {
                "drug": drug_name,
                "source": "psychonautwiki",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": {}
            }

        data = res.json()

        if "error" in data:
            return {
                "drug": drug_name,
                "source": "psychonautwiki",
                "ok": False,
                "error": data["error"].get("info", "Page missing"),
                "raw": {}
            }

        if "parse" not in data:
            return {
                "drug": drug_name,
                "source": "psychonautwiki",
                "ok": False,
                "error": "No 'parse' section in response",
                "raw": {}
            }

        return {
            "drug": drug_name,
            "source": "psychonautwiki",
            "ok": True,
            "error": None,
            "raw": data,
        }

    except Exception as e:
        log.error(f"[PW] Error scraping {drug_name}: {e}")
        return {
            "drug": drug_name,
            "source": "psychonautwiki",
            "ok": False,
            "error": str(e),
            "raw": {}
        }

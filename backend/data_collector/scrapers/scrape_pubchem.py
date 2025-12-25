import requests
from backend.utils.logging_utils import log

PUBCHEM_URL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/{}/JSON"

def scrape_pubchem(drug_name: str) -> dict:
    try:
        url = PUBCHEM_URL.format(drug_name)
        log.info(f"[PubChem] Scraping {drug_name} from {url}")

        res = requests.get(url, timeout=10)

        if res.status_code != 200:
            return {
                "drug": drug_name,
                "source": "pubchem",
                "ok": False,
                "error": f"HTTP {res.status_code} — Not found",
                "raw": {}
            }

        data = res.json()

        if "PC_Compounds" not in data:
            return {
                "drug": drug_name,
                "source": "pubchem",
                "ok": False,
                "error": "Invalid or empty PubChem response",
                "raw": {}
            }

        return {
            "drug": drug_name,
            "source": "pubchem",
            "ok": True,
            "error": None,
            "raw": data,
        }

    except Exception as e:
        log.error(f"[PubChem] Error for {drug_name}: {e}")
        return {
            "drug": drug_name,
            "source": "pubchem",
            "ok": False,
            "error": str(e),
            "raw": {}
        }

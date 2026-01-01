"""
PsychonautWiki Index Scraper

Scrapes the full substance index from PsychonautWiki and extracts:
- Substance names
- Article URLs
- Detailed page content for follow-up scraping

Matches the drug_profiles DB schema for later insertion.
"""

import requests
from bs4 import BeautifulSoup
from backend.utils.logging_utils import log
import re
import json

# Constants
PW_INDEX_URL = "https://psychonautwiki.org/wiki/Psychoactive_substance_index"
PW_BASE_URL = "https://psychonautwiki.org"
REQUEST_TIMEOUT = 10


def scrape_psychonautwiki_index():
    """
    Scrape the PsychonautWiki substance index page.
    
    Returns:
        dict: {
            "drug": "PW_INDEX",
            "source": "psychonautwiki_index",
            "ok": True/False,
            "error": "message or None",
            "raw": [ { "name": str, "url": str }, ... ]
        }
    """
    log.info("[PW Index] Starting scrape of master substance index...")
    log.debug(f"[PW Index] Target URL: {PW_INDEX_URL}")
    
    try:
        # Request the index page
        log.info("[PW Index] Requesting index page...")
        res = requests.get(PW_INDEX_URL, timeout=REQUEST_TIMEOUT)
        
        if res.status_code != 200:
            log.error(f"[PW Index] HTTP error: {res.status_code}")
            return {
                "drug": "PW_INDEX",
                "source": "psychonautwiki_index",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": []
            }
        
        log.info(f"[PW Index] Received response: {len(res.text)} bytes")
        
        # Parse HTML
        log.debug("[PW Index] Parsing HTML with BeautifulSoup (lxml)...")
        soup = BeautifulSoup(res.text, "lxml")
        
        # Find the main content block
        content = soup.find("div", {"id": "mw-content-text"})
        if not content:
            log.error("[PW Index] Could not find main content block (div#mw-content-text)")
            return {
                "drug": "PW_INDEX",
                "source": "psychonautwiki_index",
                "ok": False,
                "error": "Missing main content block",
                "raw": []
            }
        
        log.debug("[PW Index] Found main content block")
        
        # Extract all substance links
        substances = []
        seen_urls = set()  # Avoid duplicates
        
        for a in content.find_all("a", href=True):
            href = a["href"]
            
            # Only process /wiki/ links
            if not href.startswith("/wiki/"):
                continue
            
            # Skip special pages (contain ":")
            if ":" in href:
                log.debug(f"[PW Index] Skipping special page: {href}")
                continue
            
            # Skip anchors and fragments
            if "#" in href:
                href = href.split("#")[0]
            
            # Skip if already seen
            if href in seen_urls:
                continue
            
            # Get the substance name
            name = a.get_text().strip()
            
            # Skip empty or too short names
            if len(name) < 2:
                log.debug(f"[PW Index] Skipping short/empty name: '{name}'")
                continue
            
            # Skip common navigation/meta links
            skip_patterns = [
                "index", "main page", "edit", "history", "talk",
                "psychonautwiki", "wiki", "category", "help",
                "special", "file", "template", "mediawiki"
            ]
            if name.lower() in skip_patterns:
                log.debug(f"[PW Index] Skipping navigation link: {name}")
                continue
            
            # Build full URL
            full_url = f"{PW_BASE_URL}{href}"
            
            # Add to results
            seen_urls.add(href)
            substances.append({
                "name": name,
                "url": full_url
            })
            log.debug(f"[PW Index] Added substance: {name} -> {full_url}")
        
        # Check if we found any substances
        if not substances:
            log.warning("[PW Index] No substance links found in content")
            return {
                "drug": "PW_INDEX",
                "source": "psychonautwiki_index",
                "ok": False,
                "error": "No substance links found",
                "raw": []
            }
        
        # Sort by name for consistency
        substances = sorted(substances, key=lambda x: x["name"].lower())
        
        log.info(f"[PW Index] Successfully extracted {len(substances)} substances")
        
        return {
            "drug": "PW_INDEX",
            "source": "psychonautwiki_index",
            "ok": True,
            "error": None,
            "raw": substances
        }
        
    except requests.exceptions.Timeout:
        log.error(f"[PW Index] Request timed out after {REQUEST_TIMEOUT}s")
        return {
            "drug": "PW_INDEX",
            "source": "psychonautwiki_index",
            "ok": False,
            "error": f"Request timeout ({REQUEST_TIMEOUT}s)",
            "raw": []
        }
    except requests.exceptions.ConnectionError as e:
        log.error(f"[PW Index] Connection error: {e}")
        return {
            "drug": "PW_INDEX",
            "source": "psychonautwiki_index",
            "ok": False,
            "error": f"Connection error: {str(e)}",
            "raw": []
        }
    except Exception as e:
        log.error(f"[PW Index] Unexpected error: {e}")
        return {
            "drug": "PW_INDEX",
            "source": "psychonautwiki_index",
            "ok": False,
            "error": str(e),
            "raw": []
        }


def scrape_psychonautwiki_page(url: str, name: str):
    """
    Scrape a specific PsychonautWiki substance page.
    
    Args:
        url: Full URL to the substance page
        name: Name of the substance (for logging)
    
    Returns:
        dict: {
            "drug": str (substance name),
            "source": "psychonautwiki_page",
            "ok": True/False,
            "error": "message or None",
            "raw": {
                "html": str (raw HTML content),
                "url": str,
                "name": str
            }
        }
    """
    log.info(f"[PW Page] Scraping page for: {name}")
    log.debug(f"[PW Page] URL: {url}")
    
    try:
        # Request the page
        res = requests.get(url, timeout=REQUEST_TIMEOUT)
        
        if res.status_code == 404:
            log.warning(f"[PW Page] Page not found (404): {name}")
            return {
                "drug": name,
                "source": "psychonautwiki_page",
                "ok": False,
                "error": "Page not found (404)",
                "raw": None
            }
        
        if res.status_code != 200:
            log.error(f"[PW Page] HTTP error {res.status_code} for: {name}")
            return {
                "drug": name,
                "source": "psychonautwiki_page",
                "ok": False,
                "error": f"HTTP {res.status_code}",
                "raw": None
            }
        
        log.debug(f"[PW Page] Received {len(res.text)} bytes for: {name}")
        
        # Parse HTML
        soup = BeautifulSoup(res.text, "lxml")
        
        # Find main content
        content = soup.find("div", {"id": "mw-content-text"})
        if not content:
            log.warning(f"[PW Page] Missing content block for: {name}")
            return {
                "drug": name,
                "source": "psychonautwiki_page",
                "ok": False,
                "error": "Missing content block",
                "raw": None
            }
        
        # Extract the content HTML
        content_html = str(content)
        
        log.info(f"[PW Page] Successfully scraped: {name} ({len(content_html)} bytes)")
        
        return {
            "drug": name,
            "source": "psychonautwiki_page",
            "ok": True,
            "error": None,
            "raw": {
                "html": content_html,
                "url": url,
                "name": name
            }
        }
        
    except requests.exceptions.Timeout:
        log.error(f"[PW Page] Timeout for: {name}")
        return {
            "drug": name,
            "source": "psychonautwiki_page",
            "ok": False,
            "error": f"Request timeout ({REQUEST_TIMEOUT}s)",
            "raw": None
        }
    except requests.exceptions.ConnectionError as e:
        log.error(f"[PW Page] Connection error for {name}: {e}")
        return {
            "drug": name,
            "source": "psychonautwiki_page",
            "ok": False,
            "error": f"Connection error: {str(e)}",
            "raw": None
        }
    except Exception as e:
        log.error(f"[PW Page] Unexpected error for {name}: {e}")
        return {
            "drug": name,
            "source": "psychonautwiki_page",
            "ok": False,
            "error": str(e),
            "raw": None
        }


def parse_substance_page(html: str, name: str):
    """
    Parse a PsychonautWiki substance page HTML and extract structured data.
    
    This extracts data matching the drug_profiles DB schema:
    - name, pretty_name, slug
    - categories, aliases
    - dose, duration, onset, aftereffects
    - effects, pweffects
    - properties, sources
    
    Args:
        html: Raw HTML content of the page
        name: Substance name
    
    Returns:
        dict: Parsed substance data matching DB schema
    """
    log.debug(f"[PW Parse] Parsing page content for: {name}")
    
    soup = BeautifulSoup(html, "lxml")
    
    data = {
        "name": name.lower().replace(" ", "-").replace("_", "-"),
        "slug": name.lower().replace(" ", "-").replace("_", "-"),
        "pretty_name": name,
        "categories": [],
        "aliases": [],
        "formatted_dose": {},
        "formatted_duration": {},
        "formatted_onset": {},
        "formatted_aftereffects": {},
        "formatted_effects": [],
        "properties": {},
        "pweffects": {},
        "sources": {},
        "dose_note": None
    }
    
    try:
        # Extract summary/description
        summary_div = soup.find("div", class_="mw-parser-output")
        if summary_div:
            first_p = summary_div.find("p")
            if first_p:
                data["properties"]["summary"] = first_p.get_text().strip()
                log.debug(f"[PW Parse] Found summary for: {name}")
        
        # Extract effect links (pweffects)
        effect_links = soup.find_all("a", href=re.compile(r"/wiki/.*_(effect|Effect)"))
        for link in effect_links:
            effect_name = link.get_text().strip()
            effect_url = f"{PW_BASE_URL}{link['href']}"
            if effect_name and len(effect_name) > 2:
                data["pweffects"][effect_name] = effect_url
        
        if data["pweffects"]:
            log.debug(f"[PW Parse] Found {len(data['pweffects'])} effect links for: {name}")
        
        # Extract categories from the page
        cat_div = soup.find("div", {"id": "catlinks"})
        if cat_div:
            for cat_link in cat_div.find_all("a"):
                cat_text = cat_link.get_text().strip()
                if cat_text and cat_text.lower() not in ["categories", "category"]:
                    data["categories"].append(cat_text)
            log.debug(f"[PW Parse] Found {len(data['categories'])} categories for: {name}")
        
        # Look for dosage tables
        dose_tables = soup.find_all("table", class_="wikitable")
        for table in dose_tables:
            header = table.find("th")
            if header and "dose" in header.get_text().lower():
                log.debug(f"[PW Parse] Found dosage table for: {name}")
                # Parse dosage rows
                for row in table.find_all("tr")[1:]:  # Skip header
                    cells = row.find_all(["td", "th"])
                    if len(cells) >= 2:
                        route = cells[0].get_text().strip()
                        dose = cells[1].get_text().strip()
                        if route and dose:
                            data["formatted_dose"][route] = dose
        
        # Look for duration info
        duration_patterns = ["duration", "total duration"]
        for pattern in duration_patterns:
            duration_elem = soup.find(string=re.compile(pattern, re.I))
            if duration_elem:
                parent = duration_elem.find_parent()
                if parent:
                    sibling = parent.find_next_sibling()
                    if sibling:
                        data["formatted_duration"]["value"] = sibling.get_text().strip()
                        log.debug(f"[PW Parse] Found duration for: {name}")
                        break
        
        # Extract effects list
        effects_section = soup.find("span", {"id": re.compile(r".*[Ee]ffects.*")})
        if effects_section:
            effects_list = effects_section.find_parent().find_next("ul")
            if effects_list:
                for li in effects_list.find_all("li"):
                    effect_text = li.get_text().strip()
                    if effect_text:
                        data["formatted_effects"].append(effect_text)
                log.debug(f"[PW Parse] Found {len(data['formatted_effects'])} effects for: {name}")
        
        log.info(f"[PW Parse] Completed parsing for: {name}")
        
    except Exception as e:
        log.error(f"[PW Parse] Error parsing {name}: {e}")
    
    return data


def scrape_all_substances(limit: int = None, delay: float = 1.0):
    """
    Scrape the index and then scrape each individual substance page.
    
    Args:
        limit: Maximum number of substances to scrape (None for all)
        delay: Delay between requests in seconds
    
    Returns:
        dict: {
            "ok": True/False,
            "error": "message or None",
            "substances": [ parsed substance data, ... ],
            "failed": [ { "name": str, "error": str }, ... ]
        }
    """
    import time
    
    log.info("[PW All] Starting full substance scrape...")
    
    # First, get the index
    index_result = scrape_psychonautwiki_index()
    
    if not index_result["ok"]:
        return {
            "ok": False,
            "error": f"Index scrape failed: {index_result['error']}",
            "substances": [],
            "failed": []
        }
    
    substances_to_scrape = index_result["raw"]
    
    if limit:
        substances_to_scrape = substances_to_scrape[:limit]
        log.info(f"[PW All] Limited to {limit} substances")
    
    log.info(f"[PW All] Scraping {len(substances_to_scrape)} substance pages...")
    
    parsed_substances = []
    failed = []
    
    for i, substance in enumerate(substances_to_scrape):
        name = substance["name"]
        url = substance["url"]
        
        log.info(f"[PW All] ({i+1}/{len(substances_to_scrape)}) Scraping: {name}")
        
        # Scrape the page
        page_result = scrape_psychonautwiki_page(url, name)
        
        if page_result["ok"]:
            # Parse the HTML
            parsed = parse_substance_page(page_result["raw"]["html"], name)
            parsed["url"] = url
            parsed_substances.append(parsed)
        else:
            failed.append({
                "name": name,
                "url": url,
                "error": page_result["error"]
            })
        
        # Rate limiting
        if delay > 0 and i < len(substances_to_scrape) - 1:
            time.sleep(delay)
    
    log.info(f"[PW All] Completed: {len(parsed_substances)} success, {len(failed)} failed")
    
    return {
        "ok": True,
        "error": None,
        "substances": parsed_substances,
        "failed": failed
    }


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Scrape PsychonautWiki substance index")
    parser.add_argument("--full", action="store_true", help="Scrape all substance pages (not just index)")
    parser.add_argument("--limit", type=int, default=5, help="Limit number of substances to scrape (default: 5)")
    parser.add_argument("--delay", type=float, default=1.0, help="Delay between requests in seconds")
    parser.add_argument("--output", type=str, help="Output JSON file path")
    args = parser.parse_args()
    
    print("=" * 60)
    print("PsychonautWiki Index Scraper")
    print("=" * 60)
    
    if args.full:
        print(f"\nScraping substance pages (limit: {args.limit}, delay: {args.delay}s)...")
        result = scrape_all_substances(limit=args.limit, delay=args.delay)
    else:
        print("\nScraping index only...")
        result = scrape_psychonautwiki_index()
    
    print("\n" + "-" * 60)
    print(f"Status: {'SUCCESS' if result['ok'] else 'FAILED'}")
    
    if result.get("error"):
        print(f"Error: {result['error']}")
    
    if "raw" in result:
        print(f"Substances found: {len(result['raw'])}")
        if result["raw"]:
            print("\nFirst 10 substances:")
            for sub in result["raw"][:10]:
                if isinstance(sub, dict):
                    print(f"  - {sub['name']}: {sub['url']}")
                else:
                    print(f"  - {sub}")
    
    if "substances" in result:
        print(f"Substances parsed: {len(result['substances'])}")
        print(f"Failed: {len(result.get('failed', []))}")
    
    # Save to file if requested
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
        print(f"\nResults saved to: {args.output}")
    
    print("=" * 60)

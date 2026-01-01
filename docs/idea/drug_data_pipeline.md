Drug Data Pipeline - Orchestrator
Overview

The Drug Data Pipeline is an automated system for scraping, processing, and reporting drug data from various online sources. It ensures that drug profiles are continuously updated by gathering raw data from multiple repositories, normalizing it, and merging it into a unified format for analysis. This pipeline is designed to scale with increasing data sources and offers flexibility for further expansion.

Purpose

This pipeline serves as the backend data ingestion mechanism for the drug catalog system. It fetches data from the following sources:

TripSit

PsychonautWiki

Wikipedia

PubChem

Once the raw data is scraped, the pipeline normalizes, merges, validates, and generates a final dataset ready for use in drug profiles. This system is extensible and designed for future integration of additional data sources and processing stages.

Features

Scraping: Collects data from multiple sources, including TripSit, PsychonautWiki, Wikipedia, and PubChem.

Normalization: Cleans and structures raw data into a consistent format for further analysis.

Merging: Combines data from various sources, ensuring that records are grouped and deduplicated.

Validation: Checks data integrity and consistency before finalizing the dataset.

Reporting: Generates detailed reports on data quality, source coverage, and missing substances.

Pipeline Workflow

Stage A: Raw Scraping

Collects data from TripSit, PsychonautWiki, Wikipedia, and PubChem.

Stores raw HTML from each source for later processing.

Stage B: Processing

Normalizes the raw data to a standard format.

Merges records from different sources into unified drug profiles.

Validates the data for consistency and completeness.

Stage C: Final Merge & Reporting

Merges all normalized data into a final dataset.

Generates a quality report, including source coverage, missing substances, and potential issues.

Usage

To run the entire pipeline:

python -m backend.pipeline --run-all

Options:

--run-all: Executes the full pipeline (scraping, processing, and reporting).

--skip-scraping: Skips the scraping stage and uses existing raw data.

--delay: Specifies the delay (in seconds) between requests to prevent overloading sources.

--max-pw: Limits the number of PsychonautWiki pages to scrape.

--skip-wikipedia: Skips Wikipedia scraping.

--skip-pubchem: Skips PubChem scraping.

--skip-pw: Skips PsychonautWiki scraping.

--debug: Enables verbose logging for debugging.

Example:

Run the entire pipeline with a 1-second delay between requests and a maximum of 50 PsychonautWiki pages:

python -m backend.pipeline --run-all --delay 1.0 --max-pw 50

File Structure
drug_data_pipeline/
├── backend/
│   ├── scrapers/         # Scraping scripts for TripSit, PsychonautWiki, Wikipedia, PubChem
│   ├── processors/       # Data normalization, merging, and validation
│   ├── utils/            # Logging, configuration, and utility functions
│   └── pipeline.py       # Orchestrator for the entire drug data pipeline
├── data/
│   ├── raw/              # Raw scraped data
│   ├── cleaned/          # Normalized data
│   ├── processed/        # Final processed and merged data
│   └── reports/          # Generated reports (e.g., quality, missing substances)
└── README.md             # Documentation for the pipeline

Expansion & Future Directions

As part of ongoing development, the pipeline can be expanded to support:

New Data Sources: Additional scraping scripts can be added to support other drug-related databases or websites.

Advanced Data Processing: Implement additional processing steps such as clustering similar drugs or advanced analytics.

Machine Learning Integration: Use machine learning to enhance data classification and prediction models.

Conclusion

The Drug Data Pipeline provides an efficient, automated solution for gathering and processing drug-related data from multiple sources. It ensures that your drug profiles remain up-to-date and consistent, empowering users to access accurate, comprehensive information.
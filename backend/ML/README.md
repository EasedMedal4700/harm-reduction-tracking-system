# Mobile Drug Use App - Backend ML Services

## Overview

Machine learning inference services for:
1. **Drug Interaction Risk Assessment** - Conservative risk classification for drug combinations
2. **Tolerance Parameter Estimation** - Guideline-level tolerance models for under-documented substances

## Architecture

```
backend/
├── ML/
│   ├── drug_interaction_model/    # Interaction risk inference
│   │   ├── exploration.ipynb      # Development notebook
│   │   ├── model.py               # Production model class
│   │   ├── data_preprocessing.py  # Feature extraction
│   │   ├── train.py               # Training script
│   │   └── models/                # Saved model artifacts
│   │
│   └── drug_tolerance_model/      # Tolerance estimation
│       ├── exploration.ipynb      # Development notebook
│       ├── model.py               # Production model class
│       ├── data_preprocessing.py  # Feature extraction
│       ├── train.py               # Training script
│       └── models/                # Saved model artifacts
│
├── services/
│   ├── interaction_service.py     # REST API for interactions
│   └── tolerance_service.py       # REST API for tolerance
│
├── controllers/
│   └── drug_controller.py         # Main API gateway
│
├── utils/
│   └── data_preprocessing.py      # Shared utilities
│
├── database/
│   └── db_connection.py           # Database client
│
└── tests/
    ├── test_interaction_model.py
    └── test_tolerance_model.py
```

## Research Philosophy

Both models follow conservative, harm-reduction principles:

- **Never Authoritative**: All outputs labeled as estimates, not medical advice
- **Explainable**: Provides reasoning and derivation metadata
- **Conservative Defaults**: Errs on the side of caution
- **Privacy-Preserving**: No user data training
- **Never Reduces Warnings**: Cannot override manual safety classifications

See `/docs/ml_interaction_inference.md` and `/docs/ml_tolerance_inference.md` for detailed research proposals.

## Installation

```bash
# Create virtual environment
python -m venv .venv
.venv\Scripts\activate  # Windows
# source .venv/bin/activate  # Unix

# Install dependencies
pip install -r requirements.txt
```

## Development

### 1. Explore Models (Jupyter)

```bash
# Start Jupyter Lab
jupyter lab

# Open notebooks:
# - ML/drug_interaction_model/exploration.ipynb
# - ML/drug_tolerance_model/exploration.ipynb
```

### 2. Train Models

```bash
cd ML/drug_interaction_model
python train.py

cd ../drug_tolerance_model
python train.py
```

### 3. Run Services

```bash
# Terminal 1: Interaction service
cd services
python interaction_service.py
# Runs on http://localhost:5001

# Terminal 2: Tolerance service
python tolerance_service.py
# Runs on http://localhost:5002

# Terminal 3: Main gateway
cd ../controllers
python drug_controller.py
# Runs on http://localhost:5000
```

## API Usage

### Check Drug Interaction

```bash
curl -X POST http://localhost:5000/api/drugs/interaction \
  -H "Content-Type: application/json" \
  -d '{
    "drug_a": "MDMA",
    "drug_b": "LSD"
  }'
```

Response:
```json
{
  "drug_a": "MDMA",
  "drug_b": "LSD",
  "risk_level": "Caution",
  "confidence": 0.75,
  "reasoning": "Both substances affect serotonin. Similar to MDMA+Psilocybin.",
  "similar_combinations": [
    {"drugs": ["MDMA", "Psilocybin"], "risk": "Caution"}
  ],
  "model_origin": "ml_inferred",
  "disclaimers": [
    "This is not medical advice.",
    "Always research combinations thoroughly."
  ]
}
```

### Estimate Tolerance

```bash
curl -X POST http://localhost:5000/api/drugs/tolerance \
  -H "Content-Type: application/json" \
  -d '{
    "substance_profile": {
      "neuro_buckets": {
        "serotonin_release": {"weight": 0.9},
        "dopamine_release": {"weight": 0.3}
      },
      "half_life_hours": 8,
      "duration_hours": 6,
      "categories": ["entactogen", "stimulant"]
    }
  }'
```

Response:
```json
{
  "model_origin": "ml_inferred",
  "confidence": "Medium",
  "confidence_score": 0.78,
  "derived_from": ["MDMA", "Amphetamine"],
  "tolerance_gain_rate": 1.05,
  "tolerance_decay_days": 92,
  "notes": "Estimated via pharmacological similarity to MDMA, Amphetamine. Conservative decay applied. This is a guideline-level estimate."
}
```

## Testing

```bash
pytest tests/ -v --cov=ML --cov=services
```

## Integration with Flutter App

The Flutter app should:
1. Call `/api/drugs/interaction` when checking combinations
2. Call `/api/drugs/tolerance` for substances without manual models
3. Display confidence scores and disclaimers prominently
4. Cache responses locally to minimize API calls

## Model Updates

To retrain with new data:

1. Update training data in `data/processed/`
2. Run training scripts: `python train.py`
3. Restart services to load new models
4. Run tests to validate: `pytest tests/`

## Security Notes

- Services run locally by default (localhost)
- No authentication implemented (add JWT if deploying remotely)
- Input validation performed on all endpoints
- Rate limiting recommended for production
- Never log sensitive user data

## Future Work

- [ ] Add more training data as interactions are documented
- [ ] Implement model versioning and A/B testing
- [ ] Add monitoring and logging infrastructure
- [ ] Deploy as containerized microservices
- [ ] Add CI/CD pipeline for automated retraining

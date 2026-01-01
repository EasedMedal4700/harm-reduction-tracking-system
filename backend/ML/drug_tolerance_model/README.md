# Drug Tolerance Model

## Overview

ML-assisted tolerance parameter estimation for under-documented substances using mechanism similarity to well-studied drugs.

## Philosophy

- **Guideline-Level Only**: Never overrides manually curated models
- **Conservative Estimates**: Applies safety margins to predictions
- **Transparent Derivation**: Shows which substances were used for inference
- **Gap-Filling**: Only provides estimates when manual data unavailable

## Model Architecture

- **Algorithm**: K-Nearest Neighbors Regression
- **Features**: Neurotransmitter mechanisms, pharmacokinetics, drug categories
- **Training Data**: Documented tolerance models
- **Output**: Gain rate + decay days + confidence + derivation metadata

## Predicted Parameters

1. **tolerance_gain_rate**: How quickly tolerance develops (0.5-2.0)
   - 0.5 = slow (e.g., cannabis)
   - 1.0 = normal baseline
   - 2.0 = rapid (e.g., LSD, psilocybin)

2. **tolerance_decay_days**: Time for tolerance reset (7-90 days)
   - Varies by mechanism and duration

3. **confidence**: Reliability indicator
   - Low / Medium-Low / Medium (never "High" for ML-inferred)

## Files

- `exploration.ipynb` - Full ML pipeline development notebook
- `model.py` - Production model class
- `data_preprocessing.py` - Feature extraction utilities
- `train.py` - Model training script
- `requirements.txt` - Python dependencies
- `models/` - Saved model artifacts

## Usage

```python
from model import ToleranceModel

model = ToleranceModel()
model.load()

substance_profile = {
    "neuro_buckets": {"serotonin_release": {"weight": 0.9}},
    "half_life_hours": 8,
    "duration_hours": 6,
    "categories": ["entactogen"]
}

result = model.estimate_tolerance(substance_profile)
print(f"Gain rate: {result['tolerance_gain_rate']}")
print(f"Decay days: {result['tolerance_decay_days']}")
print(f"Confidence: {result['confidence']}")
print(f"Derived from: {result['derived_from']}")
```

## Training

```bash
python train.py
```

This trains on documented tolerance models and saves artifacts to `models/` directory.

## Integration

The model integrates with:
- `tolerance_service.py` - REST API service
- Flutter app - Tolerance calculator
- Database - Stores inferred models with metadata

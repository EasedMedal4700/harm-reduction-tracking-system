# Drug Interaction Model

## Overview

ML-assisted risk inference for drug combinations using mechanism-based similarity to documented interactions.

## Philosophy

- **Conservative by Design**: Never predicts "Low Risk" for undocumented combinations
- **Explainable**: Provides reasoning and similar known combinations
- **Harm Reduction**: Prioritizes user safety over prediction accuracy
- **Non-Authoritative**: All outputs labeled as estimates, not medical advice

## Model Architecture

- **Algorithm**: Random Forest Classifier
- **Features**: Neurotransmitter bucket loads, pharmacokinetics, safety flags, category overlaps
- **Training Data**: Manually curated interaction classifications
- **Output**: Risk level + confidence + reasoning + similar combinations

## Risk Categories

1. **Low Risk**: Only for well-documented safe combinations
2. **Caution**: Default for undocumented pairs, minor concerns
3. **Unsafe**: Significant risks, documented interactions
4. **Dangerous**: Life-threatening combinations

## Files

- `exploration.ipynb` - Full ML pipeline development notebook
- `model.py` - Production model class
- `data_preprocessing.py` - Feature extraction utilities
- `train.py` - Model training script
- `requirements.txt` - Python dependencies
- `models/` - Saved model artifacts

## Usage

```python
from model import InteractionModel

model = InteractionModel()
model.load()

result = model.predict_interaction("MDMA", "LSD")
print(f"Risk: {result['risk_level']}")
print(f"Confidence: {result['confidence']}")
print(f"Reasoning: {result['reasoning']}")
```

## Training

```bash
python train.py
```

This trains on documented interactions and saves models to `models/` directory.

## Integration

The model is designed to integrate with:
- `interaction_service.py` - REST API service
- Flutter app - Client-side interaction checker
- Database - Caches predictions for common combinations

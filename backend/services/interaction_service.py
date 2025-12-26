"""
Drug Interaction Service - REST API layer for ML-assisted interaction inference
"""

import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from flask import Flask, request, jsonify
from ML.drug_interaction_model.model import InteractionModel
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Initialize model
interaction_model = InteractionModel()

@app.before_first_request
def load_model():
    """Load ML model on first request"""
    try:
        interaction_model.load()
        logger.info("✓ Interaction model loaded successfully")
    except Exception as e:
        logger.error(f"Failed to load interaction model: {e}")

@app.route('/api/interaction/predict', methods=['POST'])
def predict_interaction():
    """
    Predict interaction risk for a drug combination.
    
    Request body:
    {
        "drug_a": "MDMA",
        "drug_b": "LSD"
    }
    
    Response:
    {
        "drug_a": "MDMA",
        "drug_b": "LSD",
        "risk_level": "Caution",
        "confidence": 0.75,
        "reasoning": "...",
        "similar_combinations": [...],
        "model_origin": "ml_inferred",
        "disclaimers": [...]
    }
    """
    try:
        data = request.get_json()
        
        # Validate input
        if not data or 'drug_a' not in data or 'drug_b' not in data:
            return jsonify({
                'error': 'Missing required fields: drug_a, drug_b'
            }), 400
        
        drug_a = data['drug_a']
        drug_b = data['drug_b']
        
        # Get prediction
        result = interaction_model.predict_interaction(drug_a, drug_b)
        
        logger.info(f"Predicted interaction: {drug_a} + {drug_b} = {result['risk_level']}")
        
        return jsonify(result), 200
        
    except ValueError as e:
        logger.warning(f"Invalid input: {e}")
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        logger.error(f"Prediction error: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/interaction/batch', methods=['POST'])
def predict_batch():
    """
    Predict interactions for multiple combinations.
    
    Request body:
    {
        "combinations": [
            {"drug_a": "MDMA", "drug_b": "LSD"},
            {"drug_a": "Cocaine", "drug_b": "Alcohol"}
        ]
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'combinations' not in data:
            return jsonify({'error': 'Missing required field: combinations'}), 400
        
        combinations = data['combinations']
        results = []
        
        for combo in combinations:
            if 'drug_a' not in combo or 'drug_b' not in combo:
                results.append({'error': 'Invalid combination format'})
                continue
            
            result = interaction_model.predict_interaction(combo['drug_a'], combo['drug_b'])
            results.append(result)
        
        return jsonify({'results': results}), 200
        
    except Exception as e:
        logger.error(f"Batch prediction error: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/interaction/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': interaction_model.is_loaded(),
        'service': 'interaction_service'
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=False)

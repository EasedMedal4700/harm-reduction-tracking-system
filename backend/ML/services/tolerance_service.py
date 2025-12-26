"""
Drug Tolerance Service - REST API layer for ML-assisted tolerance inference
"""

import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))

from flask import Flask, request, jsonify
from ML.drug_tolerance_model.model import ToleranceModel
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Initialize model
tolerance_model = ToleranceModel()

@app.before_first_request
def load_model():
    """Load ML model on first request"""
    try:
        tolerance_model.load()
        logger.info("✓ Tolerance model loaded successfully")
    except Exception as e:
        logger.error(f"Failed to load tolerance model: {e}")

@app.route('/api/tolerance/estimate', methods=['POST'])
def estimate_tolerance():
    """
    Estimate tolerance parameters for a substance.
    
    Request body:
    {
        "substance_profile": {
            "neuro_buckets": {
                "serotonin_release": {"weight": 0.9},
                "dopamine_release": {"weight": 0.3}
            },
            "half_life_hours": 8,
            "duration_hours": 6,
            "categories": ["entactogen", "stimulant"]
        }
    }
    
    Response:
    {
        "model_origin": "ml_inferred",
        "confidence": "Medium",
        "confidence_score": 0.75,
        "derived_from": ["MDMA", "Amphetamine"],
        "tolerance_gain_rate": 1.0,
        "tolerance_decay_days": 90,
        "notes": "..."
    }
    """
    try:
        data = request.get_json()
        
        # Validate input
        if not data or 'substance_profile' not in data:
            return jsonify({
                'error': 'Missing required field: substance_profile'
            }), 400
        
        substance_profile = data['substance_profile']
        
        # Get estimate
        result = tolerance_model.estimate_tolerance(substance_profile)
        
        logger.info(f"Estimated tolerance: gain={result['tolerance_gain_rate']}, decay={result['tolerance_decay_days']} days")
        
        return jsonify(result), 200
        
    except ValueError as e:
        logger.warning(f"Invalid input: {e}")
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        logger.error(f"Estimation error: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/tolerance/batch', methods=['POST'])
def estimate_batch():
    """
    Estimate tolerance for multiple substances.
    
    Request body:
    {
        "substances": [
            {"name": "Novel MDMA Analog", "profile": {...}},
            {"name": "Novel Psychedelic", "profile": {...}}
        ]
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'substances' not in data:
            return jsonify({'error': 'Missing required field: substances'}), 400
        
        substances = data['substances']
        results = []
        
        for substance in substances:
            if 'profile' not in substance:
                results.append({'error': 'Invalid substance format'})
                continue
            
            result = tolerance_model.estimate_tolerance(substance['profile'])
            result['substance_name'] = substance.get('name', 'Unknown')
            results.append(result)
        
        return jsonify({'results': results}), 200
        
    except Exception as e:
        logger.error(f"Batch estimation error: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/api/tolerance/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': tolerance_model.is_loaded(),
        'service': 'tolerance_service'
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=False)

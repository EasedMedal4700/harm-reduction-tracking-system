"""
Drug Controller - Main API gateway for ML services
"""

from flask import Flask, request, jsonify
import requests
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Service endpoints
INTERACTION_SERVICE_URL = "http://localhost:5001"
TOLERANCE_SERVICE_URL = "http://localhost:5002"

@app.route('/api/drugs/interaction', methods=['POST'])
def check_interaction():
    """
    Forward interaction check to interaction service.
    
    Request body:
    {
        "drug_a": "MDMA",
        "drug_b": "LSD"
    }
    """
    try:
        data = request.get_json()
        response = requests.post(
            f"{INTERACTION_SERVICE_URL}/api/interaction/predict",
            json=data,
            timeout=10
        )
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        logger.error(f"Interaction service error: {e}")
        return jsonify({'error': 'Interaction service unavailable'}), 503

@app.route('/api/drugs/tolerance', methods=['POST'])
def estimate_tolerance():
    """
    Forward tolerance estimation to tolerance service.
    
    Request body:
    {
        "substance_profile": {...}
    }
    """
    try:
        data = request.get_json()
        response = requests.post(
            f"{TOLERANCE_SERVICE_URL}/api/tolerance/estimate",
            json=data,
            timeout=10
        )
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        logger.error(f"Tolerance service error: {e}")
        return jsonify({'error': 'Tolerance service unavailable'}), 503

@app.route('/api/health', methods=['GET'])
def health():
    """Check health of all services"""
    health_status = {
        'gateway': 'healthy',
        'services': {}
    }
    
    # Check interaction service
    try:
        response = requests.get(f"{INTERACTION_SERVICE_URL}/api/interaction/health", timeout=5)
        health_status['services']['interaction'] = response.json()
    except:
        health_status['services']['interaction'] = {'status': 'unhealthy'}
    
    # Check tolerance service
    try:
        response = requests.get(f"{TOLERANCE_SERVICE_URL}/api/tolerance/health", timeout=5)
        health_status['services']['tolerance'] = response.json()
    except:
        health_status['services']['tolerance'] = {'status': 'unhealthy'}
    
    # Determine overall status
    all_healthy = all(
        service.get('status') == 'healthy' 
        for service in health_status['services'].values()
    )
    
    status_code = 200 if all_healthy else 503
    return jsonify(health_status), status_code

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)

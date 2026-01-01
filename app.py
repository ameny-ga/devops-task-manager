"""
Task Manager REST API - DevOps Project
A simple REST API for managing tasks with observability and security features.
Author: DevOps Student
Date: January 2026
"""

from flask import Flask, request, jsonify
from prometheus_flask_exporter import PrometheusMetrics
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, BatchSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
import logging
import json
from datetime import datetime
import uuid

# Configure structured logging
logging.basicConfig(
    level=logging.INFO,
    format='{"timestamp": "%(asctime)s", "level": "%(levelname)s", "message": "%(message)s"}'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)

# Setup Prometheus metrics for observability
metrics = PrometheusMetrics(app)
metrics.info('task_manager_info', 'Task Manager API', version='1.0.0')

# Setup OpenTelemetry tracing
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)
FlaskInstrumentor().instrument_app(app)

# In-memory task storage (simple database)
tasks = {}


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for Kubernetes liveness/readiness probes"""
    logger.info("Health check requested")
    return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()}), 200


@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    """Retrieve all tasks"""
    with tracer.start_as_current_span("get_all_tasks"):
        logger.info(f"Fetching all tasks - Count: {len(tasks)}")
        return jsonify({"tasks": list(tasks.values()), "count": len(tasks)}), 200


@app.route('/api/tasks/<task_id>', methods=['GET'])
def get_task(task_id):
    """Retrieve a specific task by ID"""
    with tracer.start_as_current_span("get_task_by_id"):
        if task_id not in tasks:
            logger.warning(f"Task not found: {task_id}")
            return jsonify({"error": "Task not found"}), 404
        
        logger.info(f"Task retrieved: {task_id}")
        return jsonify(tasks[task_id]), 200


@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Create a new task"""
    with tracer.start_as_current_span("create_task"):
        data = request.get_json()
        
        # Validate input
        if not data or 'title' not in data:
            logger.error("Invalid request - missing title")
            return jsonify({"error": "Title is required"}), 400
        
        # Create new task
        task_id = str(uuid.uuid4())
        task = {
            "id": task_id,
            "title": data['title'],
            "description": data.get('description', ''),
            "status": data.get('status', 'pending'),
            "created_at": datetime.utcnow().isoformat(),
            "updated_at": datetime.utcnow().isoformat()
        }
        
        tasks[task_id] = task
        logger.info(f"Task created: {task_id} - Title: {data['title']}")
        return jsonify(task), 201


@app.route('/api/tasks/<task_id>', methods=['PUT'])
def update_task(task_id):
    """Update an existing task"""
    with tracer.start_as_current_span("update_task"):
        if task_id not in tasks:
            logger.warning(f"Update failed - Task not found: {task_id}")
            return jsonify({"error": "Task not found"}), 404
        
        data = request.get_json()
        task = tasks[task_id]
        
        # Update task fields
        task['title'] = data.get('title', task['title'])
        task['description'] = data.get('description', task['description'])
        task['status'] = data.get('status', task['status'])
        task['updated_at'] = datetime.utcnow().isoformat()
        
        logger.info(f"Task updated: {task_id}")
        return jsonify(task), 200


@app.route('/api/tasks/<task_id>', methods=['DELETE'])
def delete_task(task_id):
    """Delete a task"""
    with tracer.start_as_current_span("delete_task"):
        if task_id not in tasks:
            logger.warning(f"Delete failed - Task not found: {task_id}")
            return jsonify({"error": "Task not found"}), 404
        
        del tasks[task_id]
        logger.info(f"Task deleted: {task_id}")
        return jsonify({"message": "Task deleted successfully"}), 200


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    logger.error(f"404 Error: {request.url}")
    return jsonify({"error": "Endpoint not found"}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    logger.error(f"500 Error: {str(error)}")
    return jsonify({"error": "Internal server error"}), 500


if __name__ == '__main__':
    logger.info("Starting Task Manager API on port 5000")
    app.run(host='0.0.0.0', port=5000, debug=False)

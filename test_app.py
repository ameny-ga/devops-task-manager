"""
Unit tests for Task Manager API
Tests all endpoints and functionality
"""

import pytest
import json
from app import app, tasks


@pytest.fixture
def client():
    """Create test client"""
    app.config['TESTING'] = True
    tasks.clear()  # Clear tasks before each test
    with app.test_client() as client:
        yield client


def test_health_check(client):
    """Test health check endpoint"""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'


def test_get_empty_tasks(client):
    """Test getting tasks when none exist"""
    response = client.get('/api/tasks')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['count'] == 0
    assert len(data['tasks']) == 0


def test_create_task(client):
    """Test creating a new task"""
    task_data = {
        'title': 'Test Task',
        'description': 'This is a test task',
        'status': 'pending'
    }
    response = client.post('/api/tasks', 
                          json=task_data,
                          content_type='application/json')
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['title'] == 'Test Task'
    assert 'id' in data


def test_create_task_without_title(client):
    """Test creating task without required title"""
    task_data = {'description': 'No title'}
    response = client.post('/api/tasks',
                          json=task_data,
                          content_type='application/json')
    assert response.status_code == 400


def test_get_task_by_id(client):
    """Test retrieving a specific task"""
    # Create a task first
    task_data = {'title': 'Specific Task'}
    create_response = client.post('/api/tasks', json=task_data)
    task_id = json.loads(create_response.data)['id']
    
    # Get the task
    response = client.get(f'/api/tasks/{task_id}')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['title'] == 'Specific Task'


def test_get_nonexistent_task(client):
    """Test getting a task that doesn't exist"""
    response = client.get('/api/tasks/nonexistent-id')
    assert response.status_code == 404


def test_update_task(client):
    """Test updating an existing task"""
    # Create a task
    task_data = {'title': 'Original Title'}
    create_response = client.post('/api/tasks', json=task_data)
    task_id = json.loads(create_response.data)['id']
    
    # Update the task
    update_data = {'title': 'Updated Title', 'status': 'completed'}
    response = client.put(f'/api/tasks/{task_id}', json=update_data)
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['title'] == 'Updated Title'
    assert data['status'] == 'completed'


def test_delete_task(client):
    """Test deleting a task"""
    # Create a task
    task_data = {'title': 'Task to Delete'}
    create_response = client.post('/api/tasks', json=task_data)
    task_id = json.loads(create_response.data)['id']
    
    # Delete the task
    response = client.delete(f'/api/tasks/{task_id}')
    assert response.status_code == 200
    
    # Verify it's deleted
    get_response = client.get(f'/api/tasks/{task_id}')
    assert get_response.status_code == 404


def test_metrics_endpoint(client):
    """Test that Prometheus metrics endpoint is available"""
    response = client.get('/metrics')
    assert response.status_code == 200

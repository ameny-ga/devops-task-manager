# Scripts utiles pour le projet

## Script de test de l'API

### test_api.sh
```bash
#!/bin/bash

API_URL="http://localhost:5000"

echo "=== Testing Task Manager API ==="
echo ""

# Test 1: Health Check
echo "1. Health Check"
curl -s $API_URL/health | jq .
echo ""

# Test 2: Create Task
echo "2. Creating a new task..."
TASK_ID=$(curl -s -X POST $API_URL/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"This is a test","status":"pending"}' \
  | jq -r '.id')
echo "Task created with ID: $TASK_ID"
echo ""

# Test 3: Get all tasks
echo "3. Getting all tasks..."
curl -s $API_URL/api/tasks | jq .
echo ""

# Test 4: Get specific task
echo "4. Getting task $TASK_ID..."
curl -s $API_URL/api/tasks/$TASK_ID | jq .
echo ""

# Test 5: Update task
echo "5. Updating task..."
curl -s -X PUT $API_URL/api/tasks/$TASK_ID \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task","status":"completed"}' \
  | jq .
echo ""

# Test 6: Delete task
echo "6. Deleting task..."
curl -s -X DELETE $API_URL/api/tasks/$TASK_ID | jq .
echo ""

# Test 7: Verify deletion
echo "7. Verifying deletion (should return 404)..."
curl -s $API_URL/api/tasks/$TASK_ID
echo ""

# Test 8: Metrics
echo "8. Getting Prometheus metrics..."
curl -s $API_URL/metrics | grep flask_http
echo ""

echo "=== All tests completed ==="
```

### test_api.ps1 (PowerShell pour Windows)
```powershell
# Script PowerShell pour tester l'API

$API_URL = "http://localhost:5000"

Write-Host "=== Testing Task Manager API ===" -ForegroundColor Green
Write-Host ""

# Test 1: Health Check
Write-Host "1. Health Check" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$API_URL/health" -Method Get
$response | ConvertTo-Json
Write-Host ""

# Test 2: Create Task
Write-Host "2. Creating a new task..." -ForegroundColor Yellow
$body = @{
    title = "Test Task"
    description = "This is a test"
    status = "pending"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$API_URL/api/tasks" -Method Post -Body $body -ContentType "application/json"
$taskId = $response.id
Write-Host "Task created with ID: $taskId" -ForegroundColor Green
Write-Host ""

# Test 3: Get all tasks
Write-Host "3. Getting all tasks..." -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$API_URL/api/tasks" -Method Get
$response | ConvertTo-Json
Write-Host ""

# Test 4: Get specific task
Write-Host "4. Getting task $taskId..." -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Get
$response | ConvertTo-Json
Write-Host ""

# Test 5: Update task
Write-Host "5. Updating task..." -ForegroundColor Yellow
$body = @{
    title = "Updated Task"
    status = "completed"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Put -Body $body -ContentType "application/json"
$response | ConvertTo-Json
Write-Host ""

# Test 6: Delete task
Write-Host "6. Deleting task..." -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$API_URL/api/tasks/$taskId" -Method Delete
$response | ConvertTo-Json
Write-Host ""

# Test 7: Metrics
Write-Host "7. Getting Prometheus metrics..." -ForegroundColor Yellow
$metrics = Invoke-WebRequest -Uri "$API_URL/metrics" -Method Get
$metrics.Content | Select-String -Pattern "flask_http" | Select-Object -First 10
Write-Host ""

Write-Host "=== All tests completed ===" -ForegroundColor Green
```

## Script de déploiement Kubernetes

### deploy.sh
```bash
#!/bin/bash

echo "=== Deploying Task Manager API to Kubernetes ==="
echo ""

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl not found. Please install kubectl."
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "Error: Cannot connect to Kubernetes cluster."
    exit 1
fi

echo "Cluster accessible. Proceeding with deployment..."
echo ""

# Apply ConfigMap
echo "1. Applying ConfigMap..."
kubectl apply -f k8s/configmap.yaml

# Apply Deployment
echo "2. Applying Deployment..."
kubectl apply -f k8s/deployment.yaml

# Apply Service
echo "3. Applying Service..."
kubectl apply -f k8s/service.yaml

# Apply HPA
echo "4. Applying HPA..."
kubectl apply -f k8s/hpa.yaml

echo ""
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/task-manager-api

echo ""
echo "=== Deployment completed ==="
echo ""

# Show status
echo "Current status:"
kubectl get all -l app=task-manager

echo ""
echo "To access the service:"
echo "  kubectl port-forward service/task-manager-service 8080:80"
echo "  or"
echo "  minikube service task-manager-service"
```

## Script de build et push Docker

### build-push.sh
```bash
#!/bin/bash

# Configuration
IMAGE_NAME="task-manager-api"
DOCKER_USERNAME="${DOCKER_USERNAME:-yourusername}"
VERSION="${1:-latest}"

echo "=== Building and Pushing Docker Image ==="
echo "Image: $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
echo ""

# Build
echo "1. Building Docker image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$VERSION .

if [ $? -ne 0 ]; then
    echo "Error: Docker build failed"
    exit 1
fi

echo ""
echo "2. Tagging as latest..."
docker tag $DOCKER_USERNAME/$IMAGE_NAME:$VERSION $DOCKER_USERNAME/$IMAGE_NAME:latest

echo ""
echo "3. Pushing to Docker Hub..."
docker push $DOCKER_USERNAME/$IMAGE_NAME:$VERSION
docker push $DOCKER_USERNAME/$IMAGE_NAME:latest

echo ""
echo "=== Build and Push completed ==="
echo "Image available: $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
```

## Script de démarrage complet (local)

### start.sh
```bash
#!/bin/bash

echo "=== Starting Task Manager API (Local Development) ==="
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Run tests
echo ""
echo "Running tests..."
pytest test_app.py -v

if [ $? -ne 0 ]; then
    echo "Tests failed. Please fix errors before starting."
    exit 1
fi

# Start application
echo ""
echo "Starting application..."
python app.py
```

### start.ps1 (PowerShell)
```powershell
Write-Host "=== Starting Task Manager API (Local Development) ===" -ForegroundColor Green
Write-Host ""

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
.\venv\Scripts\Activate.ps1

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

# Run tests
Write-Host ""
Write-Host "Running tests..." -ForegroundColor Yellow
pytest test_app.py -v

if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed. Please fix errors before starting." -ForegroundColor Red
    exit 1
}

# Start application
Write-Host ""
Write-Host "Starting application..." -ForegroundColor Green
python app.py
```

## Script de nettoyage

### cleanup.sh
```bash
#!/bin/bash

echo "=== Cleanup Task Manager Project ==="
echo ""

# Stop Docker containers
echo "1. Stopping Docker containers..."
docker-compose down -v

# Remove Docker images
echo "2. Removing Docker images..."
docker rmi task-manager-api:latest 2>/dev/null || true

# Clean Kubernetes
echo "3. Cleaning Kubernetes resources..."
kubectl delete -f k8s/ 2>/dev/null || true

# Clean Python cache
echo "4. Cleaning Python cache..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
rm -rf .pytest_cache htmlcov .coverage 2>/dev/null || true

# Clean test reports
echo "5. Cleaning test reports..."
rm -f bandit-report.json safety-report.json report_html.html 2>/dev/null || true

echo ""
echo "=== Cleanup completed ==="
```

## Utilisation des scripts

### Rendre les scripts exécutables (Linux/Mac)
```bash
chmod +x test_api.sh deploy.sh build-push.sh start.sh cleanup.sh
```

### Exécuter les scripts
```bash
# Tests
./test_api.sh

# PowerShell sur Windows
.\test_api.ps1

# Déploiement Kubernetes
./deploy.sh

# Build et push Docker
./build-push.sh v1.0.0

# Démarrage local
./start.sh

# Nettoyage
./cleanup.sh
```

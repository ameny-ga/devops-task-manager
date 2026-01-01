# Exemples de Requêtes API - Task Manager

## Exemples avec PowerShell (Windows)

### 1. Health Check
```powershell
Invoke-RestMethod -Uri http://localhost:5000/health
```

**Réponse attendue:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-01T12:00:00.000000"
}
```

### 2. Créer une tâche
```powershell
$body = @{
    title = "Finir le projet DevOps"
    description = "Compléter tous les livrables"
    status = "pending"
} | ConvertTo-Json

$task = Invoke-RestMethod -Uri http://localhost:5000/api/tasks `
    -Method Post `
    -Body $body `
    -ContentType "application/json"

# Afficher la tâche créée
$task | ConvertTo-Json
```

### 3. Lister toutes les tâches
```powershell
$tasks = Invoke-RestMethod -Uri http://localhost:5000/api/tasks
$tasks | ConvertTo-Json -Depth 3
```

### 4. Récupérer une tâche spécifique
```powershell
# Utiliser l'ID de la tâche créée précédemment
$taskId = $task.id
Invoke-RestMethod -Uri "http://localhost:5000/api/tasks/$taskId" | ConvertTo-Json
```

### 5. Mettre à jour une tâche
```powershell
$updateBody = @{
    title = "Finir le projet DevOps"
    description = "Tous les livrables complétés!"
    status = "completed"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/tasks/$taskId" `
    -Method Put `
    -Body $updateBody `
    -ContentType "application/json" | ConvertTo-Json
```

### 6. Supprimer une tâche
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/tasks/$taskId" -Method Delete
```

### 7. Voir les métriques Prometheus
```powershell
Invoke-WebRequest -Uri http://localhost:5000/metrics | Select-Object -ExpandProperty Content
```

---

## Exemples avec curl (Linux/Mac/Git Bash)

### 1. Health Check
```bash
curl http://localhost:5000/health
```

### 2. Créer une tâche
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Finir le projet DevOps",
    "description": "Compléter tous les livrables",
    "status": "pending"
  }'
```

### 3. Lister toutes les tâches
```bash
curl http://localhost:5000/api/tasks
```

### 4. Récupérer une tâche (remplacer TASK_ID)
```bash
curl http://localhost:5000/api/tasks/TASK_ID
```

### 5. Mettre à jour une tâche
```bash
curl -X PUT http://localhost:5000/api/tasks/TASK_ID \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Projet DevOps complété",
    "status": "completed"
  }'
```

### 6. Supprimer une tâche
```bash
curl -X DELETE http://localhost:5000/api/tasks/TASK_ID
```

### 7. Métriques Prometheus
```bash
curl http://localhost:5000/metrics
```

---

## Exemples avec Postman

### Configuration de base
- **Base URL**: `http://localhost:5000`
- **Headers**: `Content-Type: application/json`

### Collection de requêtes

#### 1. Health Check
- **Method**: GET
- **URL**: `{{baseUrl}}/health`

#### 2. Create Task
- **Method**: POST
- **URL**: `{{baseUrl}}/api/tasks`
- **Body** (raw JSON):
```json
{
  "title": "Ma première tâche",
  "description": "Description de la tâche",
  "status": "pending"
}
```

#### 3. Get All Tasks
- **Method**: GET
- **URL**: `{{baseUrl}}/api/tasks`

#### 4. Get Task by ID
- **Method**: GET
- **URL**: `{{baseUrl}}/api/tasks/{{taskId}}`

#### 5. Update Task
- **Method**: PUT
- **URL**: `{{baseUrl}}/api/tasks/{{taskId}}`
- **Body** (raw JSON):
```json
{
  "title": "Tâche mise à jour",
  "description": "Nouvelle description",
  "status": "completed"
}
```

#### 6. Delete Task
- **Method**: DELETE
- **URL**: `{{baseUrl}}/api/tasks/{{taskId}}`

#### 7. Get Metrics
- **Method**: GET
- **URL**: `{{baseUrl}}/metrics`

---

## Scénario de test complet

### Script PowerShell complet
```powershell
$baseUrl = "http://localhost:5000"

Write-Host "=== Scénario de test complet ===" -ForegroundColor Cyan

# 1. Vérifier la santé de l'API
Write-Host "`n1. Health Check" -ForegroundColor Yellow
Invoke-RestMethod "$baseUrl/health"

# 2. Créer plusieurs tâches
Write-Host "`n2. Création de 3 tâches" -ForegroundColor Yellow
$tasks = @(
    @{ title = "Configurer CI/CD"; description = "GitHub Actions"; status = "completed" },
    @{ title = "Implémenter observabilité"; description = "Prometheus + Grafana"; status = "completed" },
    @{ title = "Déployer sur Kubernetes"; description = "Minikube"; status = "in-progress" }
)

$createdTasks = @()
foreach ($taskData in $tasks) {
    $body = $taskData | ConvertTo-Json
    $task = Invoke-RestMethod -Uri "$baseUrl/api/tasks" -Method Post -Body $body -ContentType "application/json"
    $createdTasks += $task
    Write-Host "  ✓ Créé: $($task.title)" -ForegroundColor Green
}

# 3. Lister toutes les tâches
Write-Host "`n3. Liste de toutes les tâches" -ForegroundColor Yellow
$allTasks = Invoke-RestMethod "$baseUrl/api/tasks"
Write-Host "  Total: $($allTasks.count) tâches" -ForegroundColor Green

# 4. Mettre à jour une tâche
Write-Host "`n4. Mise à jour d'une tâche" -ForegroundColor Yellow
$taskToUpdate = $createdTasks[2]
$updateBody = @{
    title = $taskToUpdate.title
    description = $taskToUpdate.description
    status = "completed"
} | ConvertTo-Json
Invoke-RestMethod "$baseUrl/api/tasks/$($taskToUpdate.id)" -Method Put -Body $updateBody -ContentType "application/json"
Write-Host "  ✓ Tâche mise à jour en 'completed'" -ForegroundColor Green

# 5. Récupérer une tâche spécifique
Write-Host "`n5. Récupération d'une tâche" -ForegroundColor Yellow
$task = Invoke-RestMethod "$baseUrl/api/tasks/$($taskToUpdate.id)"
Write-Host "  ✓ Statut: $($task.status)" -ForegroundColor Green

# 6. Supprimer une tâche
Write-Host "`n6. Suppression d'une tâche" -ForegroundColor Yellow
Invoke-RestMethod "$baseUrl/api/tasks/$($createdTasks[0].id)" -Method Delete
Write-Host "  ✓ Tâche supprimée" -ForegroundColor Green

# 7. Vérifier les métriques
Write-Host "`n7. Vérification des métriques" -ForegroundColor Yellow
$metrics = Invoke-WebRequest "$baseUrl/metrics"
$requestCount = ($metrics.Content -split "`n" | Select-String "flask_http_request_total").Count
Write-Host "  ✓ Métriques disponibles (lignes: $requestCount)" -ForegroundColor Green

Write-Host "`n=== Test complet terminé avec succès ===" -ForegroundColor Cyan
```

---

## Tests avec Docker

### Si l'API tourne dans Docker
```powershell
# Lancer le container
docker run -d -p 5000:5000 --name task-api task-manager-api

# Attendre que l'API démarre
Start-Sleep -Seconds 5

# Tester
Invoke-RestMethod http://localhost:5000/health

# Voir les logs
docker logs task-api

# Arrêter et supprimer
docker stop task-api
docker rm task-api
```

---

## Tests avec Docker Compose

```powershell
# Démarrer tous les services
docker-compose up -d

# Attendre que tout soit prêt
Start-Sleep -Seconds 10

# Tester l'API
Invoke-RestMethod http://localhost:5000/health

# Vérifier Prometheus
Invoke-WebRequest http://localhost:9090/-/healthy

# Vérifier Grafana
Invoke-WebRequest http://localhost:3000/api/health

# Voir les logs
docker-compose logs -f api

# Arrêter
docker-compose down
```

---

## Tests avec Kubernetes

```bash
# Déployer
kubectl apply -f k8s/

# Attendre que les pods soient prêts
kubectl wait --for=condition=Ready pod -l app=task-manager --timeout=300s

# Port forward
kubectl port-forward service/task-manager-service 8080:80

# Dans un autre terminal, tester (remplacer 5000 par 8080)
curl http://localhost:8080/health
```

---

## Exemples de réponses attendues

### GET /health
```json
{
  "status": "healthy",
  "timestamp": "2026-01-01T12:34:56.789012"
}
```

### POST /api/tasks (201 Created)
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Ma tâche",
  "description": "Description",
  "status": "pending",
  "created_at": "2026-01-01T12:00:00.000000",
  "updated_at": "2026-01-01T12:00:00.000000"
}
```

### GET /api/tasks
```json
{
  "tasks": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Ma tâche",
      "description": "Description",
      "status": "pending",
      "created_at": "2026-01-01T12:00:00.000000",
      "updated_at": "2026-01-01T12:00:00.000000"
    }
  ],
  "count": 1
}
```

### Erreur 404 - Task not found
```json
{
  "error": "Task not found"
}
```

### Erreur 400 - Validation error
```json
{
  "error": "Title is required"
}
```

---

## Pour la présentation / démo

### Script de démo rapide (30 secondes)
```powershell
# 1. Health check
Write-Host "✓ API is healthy" -ForegroundColor Green
Invoke-RestMethod http://localhost:5000/health | ConvertTo-Json

# 2. Créer une tâche
Write-Host "`n✓ Creating a task..." -ForegroundColor Green
$task = Invoke-RestMethod -Uri http://localhost:5000/api/tasks -Method Post `
    -Body '{"title":"Demo Task","status":"pending"}' -ContentType "application/json"

# 3. Récupérer la tâche
Write-Host "`n✓ Task created with ID: $($task.id)" -ForegroundColor Green
Invoke-RestMethod "http://localhost:5000/api/tasks/$($task.id)" | ConvertTo-Json

# 4. Montrer les métriques
Write-Host "`n✓ Prometheus metrics available" -ForegroundColor Green
(Invoke-WebRequest http://localhost:5000/metrics).Content | Select-String "flask_http_request_total" | Select-Object -First 3
```

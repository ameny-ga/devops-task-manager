
# Task Manager API - DevOps Project

[![CI/CD Pipeline](https://github.com/ameny-ga/devops-task-manager/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/ameny-ga/devops-task-manager/actions)
[![Docker Image](https://img.shields.io/docker/v/ameeny/task-manager-api?label=docker)](https://hub.docker.com/r/ameeny/task-manager-api)
[![Python](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📋 Vue d'ensemble

API REST simple pour la gestion de tâches avec observabilité complète, sécurité intégrée, et déploiement Kubernetes. Projet DevOps démontrant les meilleures pratiques en CI/CD, containerisation, monitoring, et sécurité.

### ✨ Fonctionnalités

- ✅ **API REST CRUD** - Création, lecture, mise à jour et suppression de tâches
- 📊 **Observabilité complète** - Métriques Prometheus, logs structurés, tracing OpenTelemetry
- 🔒 **Sécurité** - Scans SAST/DAST, utilisateur non-root, healthchecks
- 🐳 **Containerisé** - Multi-stage Dockerfile optimisé
- ☸️ **Kubernetes ready** - Déploiements, services, HPA, ConfigMaps
- 🔄 **CI/CD automatisé** - GitHub Actions avec tests, scans de sécurité, et déploiement
- 📈 **Monitoring** - Prometheus + Grafana pour visualisation

## 🏗️ Architecture

```
┌─────────────────┐
│   GitHub Repo   │
│  (Source Code)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GitHub Actions  │
│   CI/CD Pipeline│
│  - Tests        │
│  - SAST/DAST    │
│  - Build Docker │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Docker Hub     │
│  (Image Repo)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌──────────────┐
│   Kubernetes    │────▶│  Prometheus  │
│   Cluster       │     │  (Metrics)   │
│  - Deployment   │     └──────────────┘
│  - Service      │     
│  - HPA          │     ┌──────────────┐
│  - ConfigMap    │────▶│   Grafana    │
└─────────────────┘     │  (Dashboard) │
                        └──────────────┘
```

## 🚀 Démarrage rapide

### Prérequis

- Python 3.11+
- Docker Desktop
- Kubernetes (Minikube) 
- kubectl
- Git

### 🎯 Démarrage rapide (Kubernetes)

```bash
# 1. Démarrer Minikube
minikube start

# 2. Déployer l'application
kubectl apply -f k8s/

# 3. Vérifier que tout tourne
kubectl get pods

# 4. Accéder à l'API
kubectl port-forward service/task-manager-service 8081:80
```

**✅ L'API est maintenant disponible sur http://localhost:8081**

### Installation locale (développement)

1. **Cloner le repository**
```bash
git clone https://github.com/ameny-ga/devops-task-manager.git
cd devops-task-manager
```

2. **Créer l'environnement virtuel**
```bash
python -m venv venv
.\venv\Scripts\Activate.ps1  # Windows
source venv/bin/activate     # Linux/Mac
```

3. **Installer les dépendances**
```bash
pip install -r requirements.txt
```

4. **Lancer l'application**
```bash
python app.py
```

L'API sera disponible sur `http://localhost:5000`

### 🐳 Utilisation avec Docker

#### Build de l'image
```bash
# Construire l'image
docker build -t task-manager-api .

# Charger dans Minikube (pour Kubernetes)
minikube image load task-manager-api:latest
```

### ☸️ Déploiement Kubernetes (Recommandé)

**Architecture actuelle : Kubernetes avec Minikube**

```bash
# Démarrer Minikube
minikube start

# Déployer tous les services
kubectl apply -f k8s/

# Vérifier le déploiement
kubectl get all
```

**Services déployés:**
- 🚀 **3 replicas** de l'API (haute disponibilité)
- 📊 **Prometheus** pour les métriques
- 📈 **Grafana** pour la visualisation
- ⚖️ **HPA** pour l'autoscaling (2-10 pods)

#### Accéder aux services (Port-Forward)

```powershell
# API (Terminal 1)
kubectl port-forward service/task-manager-service 8081:80
# Accès: http://localhost:8081

# Prometheus (Terminal 2)  
kubectl port-forward service/prometheus-service 9091:9090
# Accès: http://localhost:9091

# Grafana (Terminal 3)
kubectl port-forward service/grafana-service 3001:3000
# Accès: http://localhost:3001 (admin/admin)
```

**Services disponibles via Kubernetes:**
| Service | Port Local | URL | Credentials |
|---------|-----------|-----|-------------|
| **API** | 8081 | http://localhost:8081 | - |
| **Prometheus** | 9091 | http://localhost:9091 | - |
| **Grafana** | 3001 | http://localhost:3001 | admin/admin |
| **Métriques API** | 8081 | http://localhost:8081/metrics | - |

#### Commandes utiles Kubernetes

```bash
# Voir les pods
kubectl get pods

# Logs de l'API
kubectl logs -f deployment/task-manager-api

# Scaler manuellement
kubectl scale deployment task-manager-api --replicas=5

# Redémarrer les pods
kubectl rollout restart deployment/task-manager-api

# Supprimer tous les déploiements
kubectl delete -f k8s/
```

### 🧪 Tester l'API rapidement

```powershell
# Health check
Invoke-RestMethod http://localhost:8081/health

# Créer une tâche
$body = @{title="Test"; description="Ma tâche"} | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:8081/api/tasks -Method Post -Body $body -ContentType "application/json"

# Lister les tâches
Invoke-RestMethod http://localhost:8081/api/tasks
```

## 📡 Endpoints API

### Health Check
```bash
GET /health
```
**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-01T12:00:00.000000"
}
```

### Lister toutes les tâches
```bash
GET /api/tasks
```
**Response:**
```json
{
  "tasks": [...],
  "count": 5
}
```

### Obtenir une tâche
```bash
GET /api/tasks/{task_id}
```
**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Ma tâche",
  "description": "Description de la tâche",
  "status": "pending",
  "created_at": "2026-01-01T12:00:00.000000",
  "updated_at": "2026-01-01T12:00:00.000000"
}
```

### Créer une tâche
```bash
POST /api/tasks
Content-Type: application/json

{
  "title": "Nouvelle tâche",
  "description": "Description optionnelle",
  "status": "pending"
}
```

### Mettre à jour une tâche
```bash
PUT /api/tasks/{task_id}
Content-Type: application/json

{
  "title": "Tâche mise à jour",
  "status": "completed"
}
```

### Supprimer une tâche
```bash
DELETE /api/tasks/{task_id}
```

## 🧪 Tests

```bash
# Installer les dépendances de test
pip install pytest pytest-cov

# Lancer les tests
pytest test_app.py -v

# Avec coverage
pytest test_app.py --cov=app --cov-report=html
```

## ☸️ Déploiement Kubernetes

### Avec Minikube

1. **Démarrer Minikube**
```bash
minikube start
```

2. **Appliquer les manifests**
```bash
# Appliquer tous les manifests
kubectl apply -f k8s/

# Ou individuellement
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

3. **Vérifier le déploiement**
```bash
# Vérifier les pods
kubectl get pods

# Vérifier le service
kubectl get services

# Obtenir l'URL du service
minikube service task-manager-service --url
```

4. **Accéder à l'application**
```bash
# Port-forward pour accès local
kubectl port-forward service/task-manager-service 8080:80
```

### Scaling manuel
```bash
# Augmenter le nombre de replicas
kubectl scale deployment task-manager-api --replicas=5

# Vérifier l'autoscaling
kubectl get hpa
```

## 📊 Observabilité

### Métriques Prometheus

L'application expose des métriques Prometheus sur `/metrics`:
- Nombre de requêtes par endpoint
- Temps de réponse
- Codes de statut HTTP
- Custom metrics

**Accéder à Prometheus:** http://localhost:9090

### Logs structurés

Tous les logs sont en format JSON pour faciliter l'analyse:
```json
{
  "timestamp": "2026-01-01 12:00:00,000",
  "level": "INFO",
  "message": "Task created: 550e8400-e29b-41d4-a716-446655440000"
}
```

### Tracing distribué

OpenTelemetry est intégré pour tracer les requêtes:
- Span pour chaque opération
- Contexte de trace propagé
- Export vers console (configurable pour Jaeger/Zipkin)

## 🔒 Sécurité

### SAST (Static Application Security Testing)

Le pipeline CI/CD exécute automatiquement:
- **Bandit** - Scan de sécurité Python
- **Safety** - Vérification des vulnérabilités des dépendances
- **Flake8** - Linting et qualité du code

### DAST (Dynamic Application Security Testing)

- **OWASP ZAP** - Scan de sécurité de l'API en cours d'exécution
- Tests de vulnérabilités communes (injection, XSS, etc.)

### Bonnes pratiques de sécurité

- ✅ Container non-root (user 1000)
- ✅ Multi-stage build pour réduire la surface d'attaque
- ✅ Health checks intégrés
- ✅ Resource limits dans Kubernetes
- ✅ Pas de secrets hardcodés

## 🔄 CI/CD Pipeline

Le pipeline GitHub Actions s'exécute automatiquement sur chaque push/PR:

1. **Code Quality & SAST** - Linting, Bandit, Safety
2. **Unit Tests** - Pytest avec coverage
3. **Build & Push** - Construction et publication de l'image Docker
4. **DAST** - Scan OWASP ZAP de l'API
5. **Deploy** - Déploiement automatique (branche main)

### Configuration requise

Ajouter ces secrets dans GitHub:
- `DOCKER_USERNAME` - Votre nom d'utilisateur Docker Hub
- `DOCKER_PASSWORD` - Votre token Docker Hub

## 📝 Structure du projet

```
devops-task-manager/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Pipeline CI/CD
├── k8s/
│   ├── deployment.yaml        # Kubernetes Deployment
│   ├── service.yaml           # Kubernetes Service
│   ├── configmap.yaml         # Configuration
│   └── hpa.yaml               # Horizontal Pod Autoscaler
├── app.py                     # Application principale (< 150 lignes)
├── test_app.py                # Tests unitaires
├── requirements.txt           # Dépendances Python
├── Dockerfile                 # Multi-stage Dockerfile
├── docker-compose.yml         # Stack complète avec monitoring
├── prometheus.yml             # Configuration Prometheus
├── README.md                  # Documentation
└── REPORT.md                  # Rapport final du projet
```

## 📈 Métriques et Monitoring

### Accéder à Grafana

1. Ouvrir http://localhost:3000
2. Login: `admin` / `admin`
3. Ajouter Prometheus comme source de données: `http://prometheus:9090`
4. Créer un dashboard avec les métriques de l'API

### Exemples de requêtes Prometheus

```promql
# Taux de requêtes par seconde
rate(flask_http_request_total[1m])

# Durée moyenne des requêtes
flask_http_request_duration_seconds_avg

# Nombre d'erreurs
flask_http_request_total{status="500"}
```

## 🎯 Utilisation avec GitHub

### Créer le repository

```bash
# Initialiser git
git init

# Ajouter les fichiers
git add .

# Premier commit
git commit -m "Initial commit - Task Manager API with full DevOps stack"

# Créer le repo sur GitHub et ajouter le remote
git remote add origin https://github.com/yourusername/devops-task-manager.git

# Pousser le code
git push -u origin main
```

### Workflow recommandé

1. **Créer des Issues** pour chaque fonctionnalité
2. **Créer des branches** depuis les issues
3. **Faire des Pull Requests** pour review
4. **Merger** après approbation et tests passés

## 🐛 Troubleshooting

### L'API ne démarre pas
```bash
# Vérifier les logs
docker logs task-manager-api

# Ou avec docker-compose
docker-compose logs api
```

### Problèmes Kubernetes
```bash
# Vérifier les pods
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>

# Vérifier les events
kubectl get events --sort-by='.lastTimestamp'
```

### Tests échouent
```bash
# Vérifier l'environnement Python
python --version

# Réinstaller les dépendances
pip install -r requirements.txt --force-reinstall
```

## 📚 Technologies utilisées

- **Backend:** Python 3.11, Flask
- **Observabilité:** Prometheus, Grafana, OpenTelemetry
- **Containerisation:** Docker, Docker Compose
- **Orchestration:** Kubernetes
- **CI/CD:** GitHub Actions
- **Sécurité:** Bandit, Safety, OWASP ZAP
- **Tests:** Pytest

## 👥 Contribution

Ce projet est un projet académique DevOps. Pour contribuer:

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

MIT License - Voir [LICENSE](LICENSE) pour plus de détails

## 🎓 Projet académique

Ce projet fait partie du cours de DevOps et démontre:
- ✅ Développement d'une API REST (<150 lignes)
- ✅ Utilisation de Git/GitHub avec Issues et PRs
- ✅ Pipeline CI/CD automatisé
- ✅ Observabilité complète (métriques, logs, tracing)
- ✅ Sécurité (SAST + DAST)
- ✅ Containerisation Docker
- ✅ Déploiement Kubernetes
- ✅ Documentation et rapport

---

**Auteur:** Étudiant DevOps  
**Date:** Janvier 2026  
**Cours:** DevOps Project

 < ! - -   D o c k e r   c o n f i g u r a t i o n   c o m p l e t e   - - > 
 
 < ! - -   U n i t   t e s t s   a n d   t e s t   a u t o m a t i o n   - - > 
 
 
# 🚀 Task Manager API - DevOps Production Project

[![CI/CD Pipeline](https://github.com/ameny-ga/devops-task-manager/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/ameny-ga/devops-task-manager/actions)
[![Python](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-ready-326CE5.svg)](https://kubernetes.io/)
[![Security](https://img.shields.io/badge/security-SAST%20%2B%20DAST-success.svg)](https://github.com/ameny-ga/devops-task-manager/actions)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

> API REST complète de gestion de tâches avec stack DevOps moderne : Kubernetes, Prometheus, Grafana, CI/CD avec SAST/DAST, et observabilité complète.

---

## 📋 Table des Matières

- [Vue d'ensemble](#-vue-densemble)
- [Architecture](#️-architecture)
- [Fonctionnalités](#-fonctionnalités)
- [Stack Technique](#️-stack-technique)
- [Démarrage Rapide](#-démarrage-rapide)
- [API Endpoints](#-endpoints-api)
- [Monitoring](#-monitoring)
- [Sécurité](#-sécurité)
- [Tests](#-tests)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Kubernetes](#️-kubernetes)
- [Documentation](#-documentation)

---

## 🎯 Vue d'ensemble

**Task Manager API** est une application de démonstration DevOps complète qui illustre les meilleures pratiques de l'industrie pour le développement, le déploiement et l'exploitation d'une API REST moderne en production.

### ✨ Fonctionnalités Principales

| Catégorie | Fonctionnalités |
|-----------|----------------|
| **API REST** | CRUD complet • Validation des données • Health checks • Métriques Prometheus |
| **Containerisation** | Multi-stage Docker build • Images optimisées • Non-root user (sécurité) |
| **Orchestration** | Kubernetes • 3 replicas HA • HPA autoscaling (2-10 pods) • Rolling updates |
| **Monitoring** | Prometheus metrics • Grafana dashboards • Logs structurés JSON • Tracing |
| **Sécurité** | SAST (Bandit + Safety) • DAST (OWASP ZAP) • 53 tests automatisés • 0 vulnérabilités |
| **CI/CD** | GitHub Actions • Tests automatisés • Scans de sécurité • Déploiement continu |

---

## 🏗️ Architecture

### Diagramme de déploiement complet

```
┌──────────────────────────────────────────────────────────────┐
│                       GITHUB REPOSITORY                      │
│  Source Code • Dockerfile • Kubernetes Manifests • Tests     │
└──────────────────────┬───────────────────────────────────────┘
                       │ git push
                       ▼
┌──────────────────────────────────────────────────────────────┐
│                    GITHUB ACTIONS CI/CD                      │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌───────┐ │
│  │  SAST  │→ │ Tests  │→ │ Build  │→ │  DAST  │→ │Deploy │ │
│  │ Bandit │  │ pytest │  │ Docker │  │  OWASP │  │  K8s  │ │
│  │ Safety │  │  100%  │  │  Image │  │   ZAP  │  │       │ │
│  └────────┘  └────────┘  └────────┘  └────────┘  └───────┘ │
└──────────────────────┬───────────────────────────────────────┘
                       │ kubectl apply
                       ▼
┌──────────────────────────────────────────────────────────────┐
│                KUBERNETES CLUSTER (Minikube)                 │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │         Task Manager API (3 replicas - HA)             │ │
│  │  ┌────────┐    ┌────────┐    ┌────────┐              │ │
│  │  │ Pod 1  │    │ Pod 2  │    │ Pod 3  │              │ │
│  │  │Flask   │    │Flask   │    │Flask   │              │ │
│  │  │API     │    │API     │    │API     │              │ │
│  │  │:5000   │    │:5000   │    │:5000   │              │ │
│  │  └───┬────┘    └───┬────┘    └───┬────┘              │ │
│  └──────┼─────────────┼─────────────┼───────────────────┘ │
│         │             │             │                      │
│         └─────────────┴─────────────┘                      │
│                       │                                     │
│                       ▼                                     │
│         ┌───────────────────────────┐                      │
│         │  Service (NodePort)       │                      │
│         │  task-manager-service     │                      │
│         │  Port: 80 → 5000          │                      │
│         │  Load Balancer            │                      │
│         └────────┬──────────────────┘                      │
│                  │                                          │
│     ┌────────────┴────────────┐                           │
│     ▼                         ▼                           │
│  ┌──────────┐           ┌──────────┐                     │
│  │Prometheus│  ◄────    │ Grafana  │                     │
│  │  Metrics │  scrape   │Dashboards│                     │
│  │  :9090   │  /metrics │  :3000   │                     │
│  └──────────┘           └──────────┘                     │
│       │                                                    │
│       ▼                                                    │
│  ┌──────────────────────────┐                            │
│  │ HPA (Horizontal Pod      │                            │
│  │ Autoscaler)              │                            │
│  │ Min: 2 | Max: 10         │                            │
│  │ Target: CPU 70%          │                            │
│  └──────────────────────────┘                            │
└──────────────────────────────────────────────────────────────┘
```

### Composants déployés

| Composant | Rôle | Replicas | Port | Ressources |
|-----------|------|----------|------|------------|
| **API Flask** | Application principale | 3 | 5000 | 100m CPU, 128Mi RAM |
| **Prometheus** | Collecte de métriques | 1 | 9090 | 100m CPU, 256Mi RAM |
| **Grafana** | Visualisation | 1 | 3000 | 100m CPU, 128Mi RAM |
| **HPA** | Autoscaling automatique | - | - | - |

---

## 🛠️ Stack Technique

### Backend & Framework
- ![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white) **Python 3.12** - Langage de programmation
- ![Flask](https://img.shields.io/badge/Flask-3.0.3-000000?logo=flask&logoColor=white) **Flask 3.0.3** - Framework web léger et performant
- **prometheus-flask-exporter** - Exposition automatique des métriques
- **OpenTelemetry** - Tracing distribué et observabilité

### Infrastructure & DevOps
- ![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white) **Docker** - Containerisation avec multi-stage builds
- ![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white) **Kubernetes (Minikube)** - Orchestration de containers
- **kubectl** - CLI de gestion Kubernetes

### Monitoring & Observabilité
- ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?logo=prometheus&logoColor=white) **Prometheus** - Système de monitoring et alerting
- ![Grafana](https://img.shields.io/badge/Grafana-F46800?logo=grafana&logoColor=white) **Grafana** - Plateforme de visualisation de métriques
- **Logs structurés JSON** - Logging unifié pour agrégation

### CI/CD & Sécurité
- ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white) **GitHub Actions** - Pipeline CI/CD automatisé
- **Bandit** - SAST (Static Analysis) pour Python
- **Safety** - Scan de dépendances vulnérables
- **OWASP ZAP** - DAST (Dynamic Analysis) - 53 tests de sécurité
- **Flake8** - Linting et qualité de code

### Tests
- **pytest** - Framework de tests unitaires
- **pytest-cov** - Mesure de couverture de code

---

## 🚀 Démarrage Rapide

### Prérequis

```bash
✅ Python 3.12+
✅ Docker Desktop
✅ Minikube
✅ kubectl
✅ Git
```

### Installation complète (5 minutes ⏱️)

#### 1️⃣ Cloner le repository
```bash
git clone https://github.com/ameny-ga/devops-task-manager.git
cd devops-task-manager
```

#### 2️⃣ Démarrer Minikube
```powershell
minikube start
```

#### 3️⃣ Configurer Docker pour Minikube
```powershell
minikube docker-env --shell powershell | Invoke-Expression
```

#### 4️⃣ Construire l'image Docker
```powershell
docker build -t task-manager-api:latest .
```

#### 5️⃣ Déployer sur Kubernetes
```powershell
kubectl apply -f k8s/
```

#### 6️⃣ Vérifier le déploiement
```powershell
kubectl get pods
# Attendez que tous les pods soient "Running" (30-60 secondes)
```

#### 7️⃣ Accéder aux services via port-forward
```powershell
# Terminal 1 - API
kubectl port-forward service/task-manager-service 9000:80

# Terminal 2 - Prometheus  
kubectl port-forward service/prometheus-service 9091:9090

# Terminal 3 - Grafana
kubectl port-forward service/grafana-service 3000:3000
```

### ✅ Services accessibles

| Service | URL | Credentials |
|---------|-----|-------------|
| **API REST** | http://localhost:9000 | - |
| **Health Check** | http://localhost:9000/health | - |
| **API Tasks** | http://localhost:9000/api/tasks | - |
| **Métriques** | http://localhost:9000/metrics | - |
| **Prometheus** | http://localhost:9091 | - |
| **Grafana** | http://localhost:3000 | admin / admin |

---

## 📡 Endpoints API

### Documentation complète

| Méthode | Endpoint | Description | Body | Response |
|---------|----------|-------------|------|----------|
| `GET` | `/health` | Health check du service | - | `200 OK` |
| `GET` | `/api/tasks` | Liste toutes les tâches | - | `{tasks: [], count: 0}` |
| `GET` | `/api/tasks/<id>` | Récupère une tâche par ID | - | `{id, title, ...}` |
| `POST` | `/api/tasks` | Crée une nouvelle tâche | `{title, description?, status?}` | `201 Created` |
| `PUT` | `/api/tasks/<id>` | Met à jour une tâche | `{title?, description?, status?}` | `200 OK` |
| `DELETE` | `/api/tasks/<id>` | Supprime une tâche | - | `204 No Content` |
| `GET` | `/metrics` | Métriques Prometheus | - | `text/plain` |

### Exemples d'utilisation (PowerShell)

#### ✅ Health Check
```powershell
curl.exe http://localhost:9000/health
```
**Réponse:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-16T12:00:00.000000"
}
```

#### ➕ Créer une tâche
```powershell
$body = @{
    title = "Setup Infrastructure"
    description = "Deploy Kubernetes cluster with Minikube"
    status = "in-progress"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:9000/api/tasks `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

#### 📋 Lister toutes les tâches
```powershell
Invoke-RestMethod http://localhost:9000/api/tasks
```
**Réponse:**
```json
{
  "tasks": [
    {
      "id": "abc-123",
      "title": "Setup Infrastructure",
      "description": "Deploy Kubernetes cluster",
      "status": "in-progress",
      "created_at": "2026-01-16T10:00:00",
      "updated_at": "2026-01-16T10:00:00"
    }
  ],
  "count": 1
}
```

#### 🔍 Obtenir une tâche spécifique
```powershell
Invoke-RestMethod http://localhost:9000/api/tasks/abc-123
```

#### ✏️ Mettre à jour une tâche
```powershell
$body = @{
    status = "completed"
    description = "Successfully deployed on Kubernetes"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:9000/api/tasks/abc-123 `
    -Method Put `
    -Body $body `
    -ContentType "application/json"
```

#### ❌ Supprimer une tâche
```powershell
Invoke-RestMethod -Uri http://localhost:9000/api/tasks/abc-123 `
    -Method Delete
```

---

## 📊 Monitoring

### Prometheus

**Accès:** http://localhost:9091

Prometheus collecte automatiquement les métriques toutes les 15 secondes depuis l'endpoint `/metrics` de l'API.

#### Requêtes PromQL essentielles

```promql
# Nombre total de requêtes HTTP
flask_http_request_total

# Taux de requêtes par seconde (moyenne 1 minute)
rate(flask_http_request_total[1m])

# Requêtes par endpoint
sum by (path) (flask_http_request_total)

# Requêtes par méthode HTTP (GET, POST, PUT, DELETE)
sum by (method) (flask_http_request_total)

# Requêtes réussies (status 200)
flask_http_request_total{status="200"}

# Latence 95e percentile (95% des requêtes < X secondes)
histogram_quantile(0.95, flask_http_request_duration_seconds_bucket)

# Nombre total de tâches dans l'application
task_manager_tasks_total

# Augmentation du nombre de tâches sur 5 minutes
increase(task_manager_tasks_total[5m])
```

### Grafana

**Accès:** http://localhost:3000  
**Credentials:** `admin` / `admin`

#### Configuration rapide du Data Source

1. Menu (☰) → **Connections** → **Data sources**
2. **Add data source** → **Prometheus**
3. **URL:** `http://prometheus-service:9090` ⚠️ Important!
4. **Save & test** → ✅ Success

#### Dashboard recommandé - Panels

| Panel | Query PromQL | Type de visualisation |
|-------|--------------|----------------------|
| **Total HTTP Requests** | `flask_http_request_total` | Time series |
| **Request Rate** | `rate(flask_http_request_total[1m])` | Time series |
| **Requests by Endpoint** | `sum by (path) (flask_http_request_total)` | Bar chart |
| **HTTP Methods** | `sum by (method) (flask_http_request_total)` | Pie chart |
| **Total Tasks** | `task_manager_tasks_total` | Stat (grand chiffre) |
| **Success Rate** | `(sum(flask_http_request_total{status="200"}) / sum(flask_http_request_total)) * 100` | Gauge |
| **Request Duration (p95)** | `histogram_quantile(0.95, flask_http_request_duration_seconds_bucket)` | Time series |

📖 **Guide détaillé:** Voir [GRAFANA_SETUP.md](GRAFANA_SETUP.md) pour la configuration complète pas à pas.

---

## 🔒 Sécurité

### ✅ SAST (Static Application Security Testing)

Le pipeline CI/CD inclut **3 outils SAST** qui analysent le code avant exécution :

| Outil | Fonction | Fréquence | Status |
|-------|----------|-----------|--------|
| **Bandit** | Scanner de sécurité Python | À chaque push/PR | ✅ Actif |
| **Safety** | Détection de dépendances vulnérables | À chaque push/PR | ✅ Actif |
| **Flake8** | Linting et qualité de code | À chaque push/PR | ✅ Actif |

**Vulnérabilités détectées par SAST:**
- ❌ Injection SQL
- ❌ Secrets hardcodés
- ❌ Fonctions dangereuses (eval, exec)
- ❌ Dépendances obsolètes
- ❌ Problèmes de qualité de code

### ✅ DAST (Dynamic Application Security Testing)

**OWASP ZAP** effectue **53 tests de sécurité** sur l'application en cours d'exécution :

```
✅ Cross-Site Scripting (XSS) - 0 vulnérabilités
✅ SQL Injection - 0 vulnérabilités
✅ Command Injection - 0 vulnérabilités  
✅ Security Headers (CSP, X-Frame-Options) - Vérifiés
✅ Cookie Security (HttpOnly, Secure, SameSite) - Conformes
✅ CORS Configuration - Sécurisée
✅ Authentication & Authorization - Testés
... et 46 autres tests de sécurité
```

**Dernier scan:**  
- 🎯 GitHub Actions Run **#21064495714**
- ✅ **Résultat:** Tous les tests passés
- 🔒 **Vulnérabilités critiques:** 0
- 📊 **Score de sécurité:** 100/100

### Bonnes pratiques de sécurité implémentées

- ✅ **Container non-root** - L'application tourne avec UID 1000 (utilisateur non-privilégié)
- ✅ **Multi-stage Docker builds** - Image finale minimale sans outils de build
- ✅ **Secrets management** - Pas de secrets hardcodés, utilisation de ConfigMaps/Secrets K8s
- ✅ **Health checks** - Liveness et readiness probes configurés
- ✅ **Resource limits** - Limites CPU/RAM définies pour éviter les resource exhaustion
- ✅ **Dependency scanning** - Vérification automatique des CVEs dans les dépendances
- ✅ **Security testing** - Tests de sécurité automatisés à chaque commit

---

## 🧪 Tests

### Tests unitaires

```bash
# Installer les dépendances
pip install -r requirements.txt

# Lancer les tests
pytest test_app.py -v

# Avec couverture de code
pytest test_app.py --cov=app --cov-report=html

# Ouvrir le rapport HTML
start htmlcov/index.html  # Windows
open htmlcov/index.html   # Mac/Linux
```

### Couverture des tests

| Endpoint | Test | Status |
|----------|------|--------|
| `/health` | Health check OK | ✅ |
| `GET /api/tasks` | Liste vide | ✅ |
| `POST /api/tasks` | Création tâche | ✅ |
| `GET /api/tasks/<id>` | Récupération par ID | ✅ |
| `GET /api/tasks` | Liste avec données | ✅ |
| `PUT /api/tasks/<id>` | Mise à jour | ✅ |
| `DELETE /api/tasks/<id>` | Suppression | ✅ |
| Error handling | 404, 400, 500 | ✅ |

### Tests d'intégration

Pour tester l'application complète déployée sur Kubernetes, voir le guide complet dans [DEMO_TEST.md](DEMO_TEST.md).

---

## 🔄 CI/CD Pipeline

### Workflow GitHub Actions

Le pipeline s'exécute automatiquement sur chaque `push` et `pull_request` vers les branches `main` et `develop`.

```
┌─────────────────────────────────────────────────────────────┐
│                     CI/CD PIPELINE                          │
└─────────────────────────────────────────────────────────────┘

1️⃣ Code Quality & SAST (5 min)
   ├─ Flake8        → Linting Python
   ├─ Bandit        → Security scanning
   └─ Safety Check  → Dependency vulnerabilities
   
2️⃣ Unit Tests (3 min)
   ├─ pytest        → Run all tests
   └─ Coverage      → Generate report
   
3️⃣ Build & Push (4 min)
   ├─ Docker Build  → Multi-stage build
   └─ Push Registry → Docker Hub
   
4️⃣ DAST Scan (10 min)
   ├─ Start API     → Run container
   ├─ OWASP ZAP     → 53 security tests
   └─ Report        → Upload artifacts
   
5️⃣ Deploy (2 min) [main branch only]
   └─ Kubernetes    → Update deployment

✅ Total: ~24 minutes
```

### Fichiers de configuration

- `.github/workflows/ci-cd.yml` - Workflow principal
- `.zap/rules.tsv` - Configuration OWASP ZAP

### Status du pipeline

[![CI/CD](https://github.com/ameny-ga/devops-task-manager/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/ameny-ga/devops-task-manager/actions)

Dernière exécution: **✅ Success** (Run #21064495714)

---

## ☸️ Kubernetes

### Architecture Kubernetes

```yaml
Namespace: default

Deployments:
  - task-manager-api (replicas: 3)
  - prometheus (replicas: 1)
  - grafana (replicas: 1)

Services:
  - task-manager-service (NodePort: 31308)
  - prometheus-service (NodePort: 32348)
  - grafana-service (NodePort: 31892)

ConfigMaps:
  - prometheus-config (prometheus.yml)

HorizontalPodAutoscaler:
  - task-manager-hpa (min: 2, max: 10, CPU: 70%, Memory: 80%)
```

### Commandes utiles

#### Gestion des pods

```bash
# Voir tous les pods
kubectl get pods

# Détails d'un pod
kubectl describe pod task-manager-api-xxxxx

# Logs d'un pod spécifique
kubectl logs task-manager-api-xxxxx

# Logs de tous les pods de l'API
kubectl logs -l app=task-manager --tail=20

# Logs en temps réel
kubectl logs -f deployment/task-manager-api
```

#### Scaling

```bash
# Scaler manuellement à 5 replicas
kubectl scale deployment task-manager-api --replicas=5

# Voir le statut du HPA
kubectl get hpa

# Détails du HPA
kubectl describe hpa task-manager-hpa
```

#### Debugging

```bash
# Vue d'ensemble complète
kubectl get all

# Vérifier les déploiements
kubectl get deployments

# Vérifier les services
kubectl get services

# Événements récents
kubectl get events --sort-by=.metadata.creationTimestamp

# Exécuter une commande dans un pod
kubectl exec -it task-manager-api-xxxxx -- /bin/sh
```

#### Mise à jour et maintenance

```bash
# Redémarrer les pods (rolling restart)
kubectl rollout restart deployment/task-manager-api

# Voir l'historique des déploiements
kubectl rollout history deployment/task-manager-api

# Rollback au déploiement précédent
kubectl rollout undo deployment/task-manager-api

# Supprimer tous les déploiements
kubectl delete -f k8s/

# Redéployer
kubectl apply -f k8s/
```

---

## 📁 Structure du Projet

```
devops-task-manager/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # Pipeline CI/CD complet
├── .zap/
│   └── rules.tsv                  # Configuration OWASP ZAP
├── k8s/
│   ├── configmap.yaml             # ConfigMap (non utilisé actuellement)
│   ├── deployment.yaml            # Déploiement API (3 replicas)
│   ├── service.yaml               # Service NodePort pour l'API
│   ├── hpa.yaml                   # Horizontal Pod Autoscaler
│   ├── prometheus.yaml            # Prometheus (ConfigMap + Deployment + Service)
│   └── grafana.yaml               # Grafana (Deployment + Service)
├── app.py                         # Application Flask principale
├── test_app.py                    # Suite de tests unitaires
├── Dockerfile                     # Multi-stage Docker build
├── requirements.txt               # Dépendances Python
├── README.md                      # Ce fichier
├── DEMO_TEST.md                   # Guide de démonstration complet
├── GRAFANA_SETUP.md              # Configuration Grafana pas à pas
├── TECHNICAL_SUMMARY.md          # Documentation technique détaillée (60+ pages)
└── API_EXAMPLES.md               # Exemples d'utilisation de l'API
```

---

## 🎯 Features Avancées

### Horizontal Pod Autoscaling (HPA)

L'application **scale automatiquement** entre **2 et 10 pods** basé sur les métriques :

| Métrique | Seuil | Action |
|----------|-------|--------|
| **CPU** | > 70% | ⬆️ Augmente les replicas |
| **Memory** | > 80% | ⬆️ Augmente les replicas |
| **CPU** | < 30% | ⬇️ Diminue les replicas (après 5 min) |

```bash
# Voir le statut du HPA
kubectl get hpa
```

### Health Checks Kubernetes

- **Liveness Probe:** Redémarre le pod automatiquement si l'application crash
- **Readiness Probe:** Retire le pod du load balancer s'il n'est pas prêt à recevoir du trafic

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 5000
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health
    port: 5000
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Logs Structurés

Tous les logs sont au format **JSON** pour faciliter l'agrégation et l'analyse :

```json
{
  "timestamp": "2026-01-16 12:00:00,000",
  "level": "INFO",
  "message": "Task created: abc-123 - Title: Setup Infrastructure"
}
```

### Métriques Prometheus exportées

L'API expose automatiquement via `/metrics` :

- `flask_http_request_total` - Nombre de requêtes HTTP
- `flask_http_request_duration_seconds` - Latence des requêtes
- `task_manager_tasks_total` - Nombre de tâches actives
- `process_cpu_seconds_total` - Utilisation CPU
- `process_resident_memory_bytes` - Utilisation mémoire

---

## 📚 Documentation

| Document | Description | Pages |
|----------|-------------|-------|
| [README.md](README.md) | Documentation principale (ce fichier) | - |
| [DEMO_TEST.md](DEMO_TEST.md) | Guide de test et démonstration complète | 10+ |
| [GRAFANA_SETUP.md](GRAFANA_SETUP.md) | Configuration Grafana pas à pas avec screenshots texte | 20+ |
| [TECHNICAL_SUMMARY.md](TECHNICAL_SUMMARY.md) | Résumé technique exhaustif de toutes les technologies | 60+ |
| [API_EXAMPLES.md](API_EXAMPLES.md) | Exemples d'utilisation de l'API REST | 5+ |

---

## 🤝 Contribution

Les contributions sont les bienvenues! Pour contribuer :

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add: Amazing new feature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Guidelines

- ✅ Tous les tests doivent passer (`pytest`)
- ✅ Le code doit respecter PEP 8 (`flake8`)
- ✅ Les scans de sécurité doivent passer (Bandit, Safety)
- ✅ Ajouter des tests pour les nouvelles fonctionnalités
- ✅ Mettre à jour la documentation si nécessaire

---

## 📝 License

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👨‍💻 Auteur

**Ameny GA**

- 🐙 GitHub: [@ameny-ga](https://github.com/ameny-ga)
- 📦 Repository: [devops-task-manager](https://github.com/ameny-ga/devops-task-manager)

---

## 🙏 Remerciements

- **Flask** et la communauté Python pour le framework web
- **Prometheus** & **Grafana** pour l'observabilité de qualité production
- **Kubernetes** et la **CNCF** pour l'orchestration
- **OWASP** pour les outils de sécurité open-source
- **GitHub** pour Actions et l'hébergement du code

---

## 📞 Support

Pour toute question ou problème :

1. 📖 Consulter la [documentation technique complète](TECHNICAL_SUMMARY.md)
2. 🔍 Vérifier les [issues GitHub](https://github.com/ameny-ga/devops-task-manager/issues)
3. 🆕 Créer une [nouvelle issue](https://github.com/ameny-ga/devops-task-manager/issues/new) si nécessaire

---

## 🎓 Apprentissage

Ce projet est idéal pour apprendre:

- ✅ **Docker** - Containerisation d'applications Python
- ✅ **Kubernetes** - Orchestration et déploiement
- ✅ **CI/CD** - Pipelines automatisés avec GitHub Actions
- ✅ **Monitoring** - Prometheus et Grafana en pratique
- ✅ **Sécurité** - SAST/DAST dans un pipeline DevOps
- ✅ **Tests** - Tests unitaires et d'intégration
- ✅ **API REST** - Développement d'API avec Flask

---

<div align="center">

## ⭐ Si ce projet vous est utile, n'hésitez pas à lui donner une étoile! ⭐

### Made with ❤️ for DevOps learning

[![GitHub stars](https://img.shields.io/github/stars/ameny-ga/devops-task-manager?style=social)](https://github.com/ameny-ga/devops-task-manager/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ameny-ga/devops-task-manager?style=social)](https://github.com/ameny-ga/devops-task-manager/network/members)

</div>

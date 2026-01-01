# Guide de démarrage rapide - Task Manager API

## 🚀 Installation et démarrage en 5 minutes

### Option 1: Démarrage rapide avec le script

```powershell
# Exécuter le script de démarrage
.\start.ps1
```

Ce script va automatiquement:
- ✅ Créer l'environnement virtuel Python
- ✅ Installer les dépendances
- ✅ Exécuter les tests
- ✅ Démarrer l'API sur http://localhost:5000

### Option 2: Installation manuelle

```powershell
# 1. Créer l'environnement virtuel
python -m venv venv

# 2. Activer l'environnement
.\venv\Scripts\Activate.ps1

# 3. Installer les dépendances
pip install -r requirements.txt

# 4. Lancer l'application
python app.py
```

## 🧪 Tester l'API

### Avec le script de test automatique
```powershell
.\test_api.ps1
```

### Manuellement avec curl ou Invoke-RestMethod

```powershell
# Health check
Invoke-RestMethod -Uri http://localhost:5000/health

# Créer une tâche
$body = @{title="Ma tâche"; description="Test"} | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:5000/api/tasks -Method Post -Body $body -ContentType "application/json"

# Lister les tâches
Invoke-RestMethod -Uri http://localhost:5000/api/tasks
```

## 🐳 Utilisation avec Docker

### Build et run
```powershell
# Build l'image
docker build -t task-manager-api .

# Lancer le container
docker run -p 5000:5000 task-manager-api
```

### Avec Docker Compose (recommandé)
```powershell
# Lancer tous les services (API + Prometheus + Grafana)
docker-compose up -d

# Voir les logs
docker-compose logs -f api

# Arrêter
docker-compose down
```

**Services disponibles:**
- API: http://localhost:5000
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)

## ☸️ Déploiement Kubernetes

Voir [KUBERNETES_DEPLOYMENT.md](KUBERNETES_DEPLOYMENT.md) pour le guide complet.

```bash
# Déployer sur Minikube
kubectl apply -f k8s/

# Accéder au service
kubectl port-forward service/task-manager-service 8080:80
```

## 📊 GitHub Repository Setup

### 1. Créer le repository sur GitHub
1. Aller sur https://github.com/new
2. Nom: `devops-task-manager`
3. Créer le repository

### 2. Pousser le code
```bash
git add .
git commit -m "Initial commit: Complete DevOps Task Manager project"
git branch -M main
git remote add origin https://github.com/VOTRE_USERNAME/devops-task-manager.git
git push -u origin main
```

### 3. Configurer les secrets pour CI/CD
Dans GitHub Settings → Secrets → Actions:
- `DOCKER_USERNAME`: Votre username Docker Hub
- `DOCKER_PASSWORD`: Votre token Docker Hub

### 4. Créer les Issues
Voir [GITHUB_WORKFLOW.md](GITHUB_WORKFLOW.md) pour les templates d'issues.

## 📝 Checklist du projet

### Fonctionnalités principales
- ✅ API REST avec CRUD (< 150 lignes)
- ✅ Tests unitaires avec Pytest
- ✅ Observabilité (Prometheus, logs, tracing)
- ✅ Sécurité (SAST, DAST)
- ✅ Dockerfile multi-stage
- ✅ Docker Compose
- ✅ Manifests Kubernetes
- ✅ Pipeline CI/CD (GitHub Actions)
- ✅ Documentation complète
- ✅ Rapport final

### Workflow GitHub
- ⬜ Créer 8 issues (voir GITHUB_WORKFLOW.md)
- ⬜ Créer une branche par issue
- ⬜ Faire des Pull Requests
- ⬜ Peer review avec un collègue
- ⬜ Merger après approbation

### Tests et validation
- ⬜ Tests unitaires passent (pytest)
- ⬜ Scans SAST passent (Bandit, Safety)
- ⬜ Scan DAST passe (OWASP ZAP)
- ⬜ Build Docker réussit
- ⬜ Déploiement Kubernetes fonctionne

### Documentation
- ⬜ README.md complet
- ⬜ REPORT.md avec architecture et leçons
- ⬜ Exemples d'API testés
- ⬜ Screenshots ou démo

### Présentation finale
- ⬜ Préparer présentation 10 minutes
- ⬜ Démo en live de l'API
- ⬜ Montrer dashboard Grafana
- ⬜ Montrer pipeline CI/CD
- ⬜ Expliquer choix techniques

## 🔧 Troubleshooting

### L'API ne démarre pas
```powershell
# Vérifier Python
python --version

# Réinstaller les dépendances
pip install -r requirements.txt --force-reinstall

# Vérifier les logs
python app.py
```

### Docker ne build pas
```powershell
# Vérifier Docker
docker --version

# Nettoyer Docker
docker system prune -a

# Rebuild
docker build -t task-manager-api . --no-cache
```

### Tests échouent
```powershell
# Activer l'environnement virtuel
.\venv\Scripts\Activate.ps1

# Réinstaller pytest
pip install pytest pytest-cov --upgrade

# Lancer les tests avec verbose
pytest test_app.py -v -s
```

## 📚 Ressources

- [README.md](README.md) - Documentation complète
- [REPORT.md](REPORT.md) - Rapport final du projet
- [KUBERNETES_DEPLOYMENT.md](KUBERNETES_DEPLOYMENT.md) - Guide Kubernetes
- [GITHUB_WORKFLOW.md](GITHUB_WORKFLOW.md) - Workflow GitHub
- [SCRIPTS.md](SCRIPTS.md) - Scripts utiles

## 🎯 Critères d'évaluation

| Critère | Points | Status |
|---------|--------|--------|
| Backend functionality | 10% | ✅ |
| GitHub workflow | 10% | ⬜ |
| CI/CD pipeline | 15% | ✅ |
| Containerization | 10% | ✅ |
| Observability | 15% | ✅ |
| Security | 10% | ✅ |
| Kubernetes deployment | 10% | ✅ |
| Final report & presentation | 20% | ✅ |

## 💡 Conseils

1. **Commencez tôt** - Ne pas attendre la dernière minute
2. **Testez régulièrement** - Validez chaque étape
3. **Documentez** - Prenez des screenshots de vos résultats
4. **Demandez des reviews** - Échangez avec vos collègues
5. **Pratiquez la présentation** - Chronométrez-vous

---

**Prêt à commencer? Lancez `.\start.ps1` !** 🚀
